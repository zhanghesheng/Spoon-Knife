//
// Created by enfeng on 12-10-18.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <TBNetwork/Reachability.h>
#import <TBService/TBNetworkApiAdapter.h>
#import "Tao800TableVCL.h"
#import "TBBaseViewCTLAdditions.h"
#import "Tao800LoadMoreCell.h"
#import "Tao800LoadMoreItem.h"
#import "Tao800StyleSheet.h"
#import "Tao800RefreshTableHeaderView.h"
#import "Tao800NetworkNotReachableTipView.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800SearchHomeModel.h"
#import "Tao800TabVCL.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800NotifycationConstant.h"
#import "TBCore/TBCore.h"

@interface Tao800TableVCL ()
@property(nonatomic) int lastPosition;
@end

@implementation Tao800TableVCL {

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.enableShowPageTip = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.enableShowPageTip = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.refreshHeaderView.layer removeAllAnimations];
    [RefreshTableHeaderView cancelPreviousPerformRequestsWithTarget:self.refreshHeaderView];
    self.refreshHeaderView.delegate = nil;
}

- (void)doneLoadingHeaderRefresh {

    self.isLoading = NO;
    if (self.model) {
        self.model.loading = NO;
    }

    NSTimeInterval duration;
    if (!self.netErrorDescription) {
        duration = 1.2f;
        //先等待前面的loading动画
        [self.refreshHeaderView setState:EGOOPullRefreshSuccess];
        Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
        if (dm.networkStatus == NotReachable) {
            self.refreshHeaderView.finishMessage = @"刷新失败!";
            duration = .2f;
        } else {
            self.refreshHeaderView.finishMessage = @"刷新成功!";
            [self.refreshHeaderView setState:EGOOPullRefreshSuccess];//保证刷新成功状态的正常显示
        }
    } else {
        self.refreshHeaderView.finishMessage = @"刷新失败!";
        duration = .2f;
    }

    //隐藏
    SEL sel = @selector(egoRefreshScrollViewDataSourceDidFinishedLoading:);

    [self.refreshHeaderView performSelector:sel withObject:self.tableView afterDelay:duration];
}

- (BOOL)resetLoadMoreItem:(NSObject *)item {
    BOOL ret = NO;
    if ([item isKindOfClass:[Tao800LoadMoreItem class]]) {
        self.model.pageNumber--;
        if (self.model.pageNumber < 1) {
            self.model.pageNumber = 1;
        }

        Tao800LoadMoreItem *loadMoreItem = (Tao800LoadMoreItem *) item;
        loadMoreItem.loading = NO;
        loadMoreItem.waitForLoading = YES;
        loadMoreItem.text = @"加载失败，点击重新加载";
        [self.tableView reloadData];

        ret = YES;
    }
    return ret;
}

- (void)resetLoadMoreState {
    for (NSObject *item in self.model.items) {
        if ([item isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *) item;
            for (NSObject *item2 in arr) {
                BOOL ret = [self resetLoadMoreItem:item2];
                if (ret) {
                    break;
                }
            }
        } else {
            BOOL ret = [self resetLoadMoreItem:item];
            if (ret) {
                break;
            }
        }
    }
}

- (void)dealError:(TBErrorDescription *)error {
    NSString *errorMessage = @"当前网络不稳定，请稍后再试";

    TBNetworkApiAdapter *serviceAdapter = [TBNetworkApiAdapter sharedInstance];
    if (serviceAdapter.networkStatus == NotReachable) { //无网络
        errorMessage = nil;

        //需要显示网络断开的提示

        if (self.model.items.count > 0) {
            Tao800NetworkNotReachableTipView *mView = [[Tao800NetworkNotReachableTipView alloc]
                    initWithTitle:@"当前处于无网络连接，请检查设置"
                         delegate:nil
                            style:TBBMessageViewStyleWarning
                         position:TBBMessageViewPositionBottom
               containRightButton:YES];
            [mView show];
        }
    }
    TBNotify(Tao800NetWorkDidErrorNotification, nil, nil);
    //用于下拉刷新完成状态的判断
    self.netErrorDescription = error;

    [self showPageLoading:NO];
    [self resetLoadState];


    Tao800PageTipType tipType = Tao800PageTipTypeNetworkError;

    if (serviceAdapter.networkStatus == NotReachable) {
        tipType = Tao800PageTipTypeNetworkNotReachable;
    } else if (error.errorCode >= 500) {
        errorMessage = @"工程师们正在抢修，请稍后再试";
        tipType = Tao800PageTipTypeNetworkServer500;
    } else if (error.errorCode == 404) {
        tipType = Tao800PageTipTypeNetworkServer404;
        errorMessage = @"工程师们正在抢修，请稍后再试";
    } else if (error.errorCode == 401) {
        //需要用户登录
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];
        return;
    }
    BOOL showPageError = NO;

    if (self.dataSource) {
        if ([self.dataSource isKindOfClass:[TBTableViewDataSource class]]) {
            TBTableViewDataSource *dc = (TBTableViewDataSource *) self.dataSource;
            if (dc.items.count < 1) {
                showPageError = YES;
            }
        }

        if ([self.dataSource isKindOfClass:[TBSectionedDataSource class]]) {
            TBSectionedDataSource *dc = (TBSectionedDataSource *) self.dataSource;
            if (dc.items.count < 1) {
                showPageError = YES;
            }
        }
    } else {
        showPageError = self.model.items.count<1;
    }

    //应该主要以这个判断为准
    if (self.model.items.count < 1) {
        showPageError = YES;
    }

    //兼容老的写法
    if (self.items.count > 1) {
        showPageError = NO;
    }

    if ([self.model isKindOfClass:[Tao800SearchHomeModel class]]) {
        Tao800SearchHomeModel *model1 = (Tao800SearchHomeModel *) self.model;
        if (model1.controller.requestType == RequsetTypeRecommendDeals) {
            showPageError = NO;
        }

    }

    if (showPageError) {
        if (self.enableShowPageTip) {
            [self showPageTip:nil
                       detail:nil
                      tipType:tipType];
        } else if (errorMessage) {   //刷新
            [self showTextTip:errorMessage];
        }

    } else if (self.model.pageNumber == 1) {

        if (self.needShowLoadMore) {
            [self resetLoadMoreState];
        } else if (errorMessage) {   //刷新
            [self showTextTip:errorMessage];
        }
    } else {
        [self resetLoadMoreState];
    }

    if (error.errorCode > 10000) {//收货地址服务器异常处理,此处交互和显示需要确认
        errorMessage = error.errorMessage;
        [self showFailTip:errorMessage];
    }
}

- (void)startRefreshHeaderLoading {
    self.netErrorDescription = nil;

    [super startRefreshHeaderLoading];
}

- (BOOL) needShowPrdValue{
    return NO;
}

- (void)addHeaderRefreshView {
    // 下拉刷新
    if (self.refreshHeaderView == nil) {
        CGRect rHeaderRect = CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 300, REFRESH_HEADER_HEIGHT);
        Tao800RefreshTableHeaderView *ref = nil;
        if (![self needShowPrdValue]) {
            ref = [[Tao800RefreshTableHeaderView alloc]
                   initWithFrame:rHeaderRect];
        }else{
            ref = [[Tao800RefreshTableHeaderView alloc]
                   initWithFrameAndPrdValue:rHeaderRect];
        }
        self.refreshHeaderView = ref;
        self.refreshHeaderView.delegate = self;

        [self.tableView addSubview:self.refreshHeaderView];
        [self.refreshHeaderView setActivityStyle:UIActivityIndicatorViewStyleGray];
    }
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[Tao800LoadMoreCell class]]) {
        Tao800LoadMoreCell *loadMoreCell = (Tao800LoadMoreCell *) cell;
        Tao800LoadMoreItem *item = (Tao800LoadMoreItem *) loadMoreCell.object;

        //适配自动加载
        if (self.model.loading) {
            item.text = @"努力加载中...";
            item.loading = YES;
        }

        if (item.loading || item.waitForLoading) {

            return;
        }
        if (!self.model.hasNext) {
            return;
        }

        TBDPRINT(@"即将显示加载更多cell");
        item.loading = YES;
        if (self.model.loading) {
            return;
        }
        self.model.loading = YES; //todo
        self.model.pageNumber++;
        [self loadItems];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[Tao800LoadMoreCell class]]) {
        Tao800LoadMoreCell *loadMoreCell = (Tao800LoadMoreCell *) cell;
        Tao800LoadMoreItem *item = (Tao800LoadMoreItem *) loadMoreCell.object;
        item.text = @"努力加载中...";
        [self.tableView reloadData];

        item.waitForLoading = NO;
        if (item.loading) {
            return;
        }
        self.model.loading = YES;
        item.loading = YES;
        self.model.pageNumber++; //todo
        [self loadItems];
    }
}

- (BOOL) needRedrawStatusBar {
    return NeedResetUIStyleLikeIOS7();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR_RED1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self resetStyleForIOS7];
    
    if ([self needRedrawStatusBar]) {
        UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        statusBar.backgroundColor = BACKGROUND_COLOR_RED1;
        statusBar.tag = Tao800RedStatusBar;
        [self.view addSubview:statusBar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self viewWillAppearDeal:animated];
}

- (void)didNetworkError:(NSDictionary *)params {
    [self resetLoadState];
    [self hideLoadingView];
    [super didNetworkError:params];
}

// 用于判断是否加载更多的分页大小，由于服务器端不能保证返回的数据每页都是20条，所以用此参数。
+ (int)loadMorePageSize {
    return 1;
}

- (void)resetLoadState {

    if ([self.topViewController isKindOfClass:[self class]]) {
        BOOL loading = self.model.loading;
        if (loading) {
            BOOL loadingMore = self.model.pageNumber > 1;
            if (!loadingMore && self.tableView.contentInset.top == 60) {
                [self doneLoadingHeaderRefresh];
            }
        }
    } else {
        [self.refreshHeaderView resetToDefaultState:self.tableView];
    }

    self.isLoading = NO;
    self.refreshFooterView.IsLoading = NO;
    self.model.loading = NO;
}

- (UIViewController *)topViewController {
    UIViewController *controller;
    if (self.navigationController) {
        controller = self.navigationController;
        if (self.navigationController.topViewController) {
            NSArray *controllers = self.navigationController.viewControllers;
            if (controllers.count == 1) {
                UIViewController *ctl = controllers[0];
                if ([ctl isKindOfClass:[Tao800TabVCL class]]) {
                    Tao800TabVCL *vcl = (Tao800TabVCL *) ctl;
                    return vcl.selectedVCL;
                }
            }
            return self.navigationController.topViewController;
        }
    } else {
        controller = self;
    }
    UIViewController *ctl = controller.presentedViewController;
    if (ctl == nil) {
        ctl = self.presentedViewController;
    }
    if (ctl) {
        return ctl;
    }

    return controller;
}

/**
* 支持 6.0 之前
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - UIScrollViewDelegate Methods -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.previousContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;

    if (scrollView != self.tableView) {
        return;
    }

    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 5) {
        _lastPosition = currentPostion;
        //NSLog(@"ScrollUp now");
        _directionCurrent = Tao800TableDirectionUp;
    }
    else if (_lastPosition - currentPostion > 5)
    {
        _lastPosition = currentPostion;
        _directionCurrent = Tao800TableDirectionDown;
        //NSLog(@"ScrollDown now");
    }

    CGFloat height = self.view.frame.size.height;
    CGFloat offsetYY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;

    if (contentHeight < height) {
        return;
    }
    [self hideAction:offsetYY with:offsetY];
}

- (void)hideAction:(CGFloat)offsetYY with:(CGFloat)offsetY {
    BOOL show = NO;
    if (offsetYY < (self.previousContentOffset.y)) {
        //向下, 隐藏筛选
        show = YES;
        [self displayNavBar:YES];
    } else if (offsetY > self.previousContentOffset.y + 44) {
        show = NO;
        [self displayNavBar:NO];
    }
}

#pragma mark - displayNavBa 

- (void)displayNavBar:(BOOL)show {
}

@end