//
//  Tao800SearchHomeVCL.m
//  tao800
//
//  Created by worker on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchHomeVCL.h"
#import "Tao800SearchHomeDataSource.h"
#import "Tao800SearchHistoryItem.h"
#import "Tao800StyleSheet.h"
#import "TBCore/TBCore.h"
#import "Tao800SearchHomeModel.h"
#import "Tao800SearchSuggestionItem.h"
#import "Tao800ForwardSegue.h"
#import "Tao800LoadMoreCell.h"
#import "Tao800LoadMoreItem.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800DealListGridItem.h"
#import "Tao800DealListItem.h"
#import "Tao800LoadMoreFinishTipView.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800SearchSuggestionVCL.h"
#import "Tao800SearchSuggestionModel.h"
#import "Tao800AnalysisExposureManage.h"

#define SearchbButtonTag (8743)

@interface Tao800SearchHomeVCL () {
    CGRect _saveRect;
}

@property(nonatomic) BOOL suggestionAppeared; //正在显示搜索提示

@end

@implementation Tao800SearchHomeVCL

- (void)initExposureContent {
}

//每次更新搜索关键字时需要调用
- (void) resetExposureContent:(NSString*)keyword {
    NSString *exposureKeyword = keyword;
    NSUInteger limitLength = 10;
    if (exposureKeyword.length>limitLength) {
        exposureKeyword = [keyword substringToIndex:limitLength];
    }

    if (self.exposureContentVO) {
        [[Tao800AnalysisExposureManage shareInstance] removeExposureBaseInfo:self.exposureContentVO];
    }

    self.exposureContentVO = [self getExposureContentVo];
    [self.exposureContentVO resetExposureIdentifier];
    self.exposureContentVO.exposurePostValue = exposureKeyword;

    Tao800AnalysisExposureManage *manage = [Tao800AnalysisExposureManage shareInstance];
    [manage addExposureBaseInfo:self.exposureContentVO];
}

- (Tao800AnalysisExposureContentVO*)getExposureContentVo {

    Tao800AnalysisExposureContentVO *ret = [super getExposureContentVo];
    ret.exposurePosType = Tao800AnalysisExposurePostTypeSearch;
    return ret;
}


- (void)keyboardWillShow:(NSNotification *)notification {
   self.suggestionAppeared = YES;
    [self switchSearchTableView];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self switchSearchTableView];
}

#pragma mark - 生命周期方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.configManage = [[Tao800ConfigManage alloc] init];
        self.model = [[Tao800SearchHomeModel alloc] init];
        ((Tao800SearchHomeModel *) self.model).controller = self;


        __weak Tao800SearchHomeVCL *instance = self;
        self.suggestionVCL = [Tao800ForwardSegue
                LoadViewControllerFromStoryboard:@"Tao800SearchHomeVCL"
                                 classIdentifier:@"Tao800SearchSuggestionVCL"];
        self.suggestionVCL.goBackBlock = ^(BOOL finish, NSDictionary *params) {
            NSString *searchKeyword = params[@"searchKeyword"];
            instance.searchBar.searchTextField.text = searchKeyword;
            [instance getSearchDeals];
        };

    }
    return self;
}
#pragma mark - 设置SearchBar样式

- (void)resetSearchBarStyle {
    Tao800DataModelSingleton* dm = [Tao800DataModelSingleton sharedInstance];
    self.searchBar.backgroundColor = [UIColor clearColor];

    self.searchBar.horizontalPadding = 10;
    self.searchBar.verticalPadding = 7;

    self.searchBar.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.searchTextField.keyboardType = UIKeyboardTypeDefault;
    if (dm.dealCounts) {
        self.searchBar.searchTextField.placeholder = [NSString stringWithFormat:@"在%@款商品中搜索",dm.dealCounts];
    }else{
        self.searchBar.searchTextField.placeholder = @"寻找商品";
    }
    self.searchBar.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchBar.searchTextField.font = V3_24PX_FONT;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goBackBlock = ^(BOOL finish, NSDictionary *dict) {
        return ;
    };
//    self.tableView.bounces = NO;
    if (self.dealDetailFrom != Tao800DealDetailFromWishList && self.dealDetailFrom!= Tao800DealDetailFromPush) {
        self.dealDetailFrom = Tao800DealDetailFromSearch;
    }
    
    [self addBackButtonToNavigator];

    self.searchBar.needShowCancelButton = NO;
    self.searchBar.delegate = self;
    [self resetSearchBarStyle];

    // Do any additional setup after loading the view.
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Category_Search params:nil];

    self.tableView.backgroundColor = BACKGROUND_COLOR_GRAY1;
    self.view.backgroundColor = [UIColor whiteColor];
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height)];
//    bgView.backgroundColor = [UIColor blueColor];
//    self.tableView.backgroundView = bgView;
//    [self.view insertSubview:bgView belowSubview:self.view];
    [self.tableView setScrollsToTop:YES];

    //   NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"Tao800SearchNoDealHeaderView" owner:self options:nil];
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 192);
    self.noDealHeaderView = [[Tao800SearchNoDealHeaderView alloc] initWithFrame:rect];
    self.noDealHeaderView.delegate = self;
    //self.noDealHeaderView = [nibView objectAtIndex:0];

    _saveRect = self.tableView.frame;

    UIView *sView = [self.view viewWithTag:Tao800RedStatusBar];
    if (sView) {
        [sView removeFromSuperview];
    }

    [self.suggestionVCL view];


    [self addChildViewController:self.suggestionVCL];

    [self.view addSubview:self.suggestionVCL.tableView];
    self.suggestionVCL.tableView.hidden = YES;

    [self.suggestionVCL didMoveToParentViewController:self];
    
    
    if (_paramDict) {
        self.searchBar.searchTextField.text =  _paramDict[@"keyword"];
        self.suggestionVCL.suggestionModel.keyword = self.searchBar.searchTextField.text;
        [self getSearchDeals];
    }
    self.view.backgroundColor = BACKGROUND_COLOR_RED1;
    
}

-(NSString *)getCID{
    
    return self.suggestionVCL.suggestionModel.keyword;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setParameters:(NSDictionary *)parameters {
    [super setParameters:parameters];

    self.suggestionVCL.suggestionModel.keyword =  parameters[@"keyword"];
    self.cId = self.suggestionVCL.suggestionModel.keyword;
    if (parameters[@"pageFrom"]) {
        if ([parameters[@"pageFrom"] intValue] == Tao800DealDetailFromWishList) {
            self.dealDetailFrom = Tao800DealDetailFromWishList;
        }
        if ([parameters[@"pageFrom"] intValue] == Tao800DealDetailFromPush) {
            self.dealDetailFrom = Tao800DealDetailFromPush;
            self.cId = parameters[@"cId"];
        }
        
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
 
}

#pragma mark - --------- 滚动视图相关 -----------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self resetSwitchButtonStatus];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [super scrollViewDidEndDecelerating:scrollView];
    [self resetSwitchButtonStatus];
}

- (void)hideSwitchButton:(BOOL)show {
    self.toTopButton.hidden = self.tableView.contentOffset.y<=Tao800DealListTopButtonDisplayOffset;
    [UIView animateWithDuration:.3
                     animations:^{
                         if (show) {
                             if ((self.requestType == RequsetTypeSearchDeals || self.requestType == RequsetTypeRecommendDeals) && _items.count > 2) {
                                 [self.view bringSubviewToFront:self.switchButton];
                                 self.switchButton.hidden = NO;
                                 [self.view bringSubviewToFront:self.toTopButton];
                                 self.switchButton.alpha = 1.0;
                                 self.toTopButton.alpha = 1.0;
                             }
                         }
                         else {
                             self.switchButton.alpha = 0.0;
                             self.toTopButton.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finish) {
                     }];

}


#pragma mark 重新设置列表宫格按钮显示状态
- (void)resetSwitchButtonStatus {
    switch (self.requestType) {
        case RequsetTypeSearchHistory: {
            self.switchButton.hidden = YES;
        }
            break;
        case RequsetTypeSearchDeals: {
            self.switchButton.hidden = NO;
        }
            break;
        case RequsetTypeSearchSuggestion: {
            self.switchButton.hidden = YES;
        }
            break;
        case RequsetTypeRecommendDeals: {
            self.switchButton.hidden = NO;
        }
            break;
        default:
            break;
    }
   
}

#pragma mark - --------- TBSearchBarDelegate ----------
#pragma mark 开始开始编辑文本框
- (void)tbSearchBarTextDidBeginEditing:(TBSearchBar *)searchBar {
    [self tbSearchBar:searchBar textDidChange:@""];
}

#pragma mark 搜索文字改变
- (void)tbSearchBar:(TBSearchBar *)searchBar textDidChange:(NSString *)searchText {
    TBDPRINT(@"searchText=%@", searchText);
    NSString *keyword = searchBar.searchTextField.text.trim;
    
    Tao800SearchHomeModel *model1 = (Tao800SearchHomeModel*)self.model;
    if (!searchText || searchText.length<1) {
        if (!keyword || keyword.length<1) {
            model1.keyword = nil;
            [self getSearchHistory];
            return;
        }
    }

    if (keyword.length > 0) {
        if (model1.keyword && [model1.keyword isEqualToString:keyword]) {
            //条件和前一次相同，不用刷新
            return;
        }
        
        // 获取搜索建议
        self.model.pageNumber = 1;
        self.suggestionVCL.suggestionModel.keyword = keyword;
        [self getSearchSuggestion];
    } else {
        model1.keyword = nil;
        [self getSearchHistory];
    }
}

#pragma mark 搜索按钮点击事件
- (void)tbSearchBarSearchButtonClicked:(TBSearchBar *)searchBar {
    NSString *keyword = searchBar.searchTextField.text.trim;
    if (keyword.length > 0) {
        //保存搜索记录
        [self.suggestionVCL.suggestionModel saveSearchKeyword:keyword];

        _searchBar.searchTextField.text = keyword;
        
        //搜索商品
        self.model.pageNumber = 1;
        [self getSearchDeals];
    }
}
#pragma mark 取消按钮点击代理

- (void)tbSearchBarCancelButtonClicked:(TBSearchBar *)searchBar {
//    self.searchBar.searchTextField.text = nil;
    //[self layoutTbSearchBar:.2];
    self.suggestionAppeared = NO;
    [self switchSearchTableView];
}

-(void)resetSuggestionOrHistoryTableView{
    CGRect rect = self.view.frame;
    rect.origin.y = self.searchBar.frame.origin.y + self.searchBar.height;
    rect.size.height = rect.size.height - rect.origin.y;
    self.suggestionVCL.tableView.frame = rect;
    [self.view bringSubviewToFront:self.suggestionVCL.tableView];
}

- (void)switchSearchTableView {
    self.suggestionVCL.tableView.hidden = !self.suggestionAppeared;
    if (!self.suggestionVCL.tableView.hidden) {
        [self resetSuggestionOrHistoryTableView];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - ---------- 搜索建议相关 ----------
#pragma mark 获取搜索建议
- (void)getSearchSuggestion {
    self.suggestionAppeared = YES;
    
    //先清除前一次的数据
    [self.suggestionVCL.suggestionModel.items removeAllObjects];
    [self.suggestionVCL loadItems];
    
    [self.suggestionVCL getSearchSuggestion];
    
    [self resetSuggestionOrHistoryTableView];
    self.suggestionVCL.tableView.hidden = NO;
}

- (void)getSearchHistory { 
    self.suggestionAppeared = YES;
    self.suggestionVCL.tableView.hidden = !self.suggestionAppeared;
    self.suggestionVCL.suggestionModel.keyword = nil;
    [self.suggestionVCL getSearchHistory];
    
    [self resetSuggestionOrHistoryTableView];
    self.suggestionVCL.tableView.hidden = NO;
}


#pragma mark - --------- 搜索商品相关 ----------
#pragma mark 搜索商品
- (void)getSearchDeals {
    self.suggestionAppeared = NO;
    [self switchSearchTableView];
    [self.searchBar layoutCancelButton];

    self.requestType = RequsetTypeSearchDeals; // 设置请求类型

    [self.view.superview endEditing:YES];
    [self hidePageTip];
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView = nil;

    if (self.model.pageNumber == 1) {
        [self showPageLoading:YES];
    }
    __weak Tao800SearchHomeVCL *instance = self;
    Tao800SearchHomeModel *homeModel = (Tao800SearchHomeModel *) _model;

    NSString *keyword = _searchBar.searchTextField.text.trim;

    [homeModel getNewSearchDeals:@{@"q" : keyword}
                      completion:^(NSDictionary *dict) {

                          //添加曝光打点内容
                          [instance resetExposureContent: instance.suggestionVCL.suggestionModel.keyword];

                          [instance hidePageTip];
                          [instance showPageLoading:NO];
                          [instance resetLoadState];

                          if ([instance.model.items count] < 1) {
                              //获取推荐商品列表
                              instance.model.pageNumber = 1;
                              [instance getRecommendDeals];
                          }

                          if(instance.model.pageNumber == 1){
                              [self displayNavBar:YES];
                          }
                          [instance reloadTableData];
                      }
                         failure:^(TBErrorDescription *error) {

                             if (instance.model.pageNumber == 1) {
                                 [instance.items removeAllObjects];
                                 [instance reloadTableData];
                             }
                             [instance dealError:error];

                         }];
}

#pragma mark - ---------- 推荐商品相关 ----------
#pragma mark 获取推荐商品列表
- (void)getRecommendDeals {

    self.requestType = RequsetTypeRecommendDeals; // 设置请求类型

    self.tableView.tableHeaderView = _noDealHeaderView;
//    CGRect rect = _saveRect;
//    rect.origin.y = rect.origin.y + _noDealHeaderView.size.height;
//    self.tableView.frame = rect;
    self.tableView.tableFooterView = nil;

    if (self.model.pageNumber == 1) {
        [self showPageLoading:YES];
    }

    Tao800SearchHomeModel *homeModel = (Tao800SearchHomeModel *) _model;
    __weak Tao800SearchHomeVCL *instance = self;
    [homeModel getRecommendDeals:nil
                      completion:^(NSDictionary *dict) {

                          [instance showPageLoading:NO];
                          [instance resetLoadState];

                          [instance reloadTableData];
                      }
                         failure:^(TBErrorDescription *error) {
                             instance.requestType = RequsetTypeRecommendDeals;
//                          [instance.model.items removeAllObjects];
                             [instance dealError:error];
                         }];
}


#pragma mark - ----------- 表格相关 ----------
#pragma mark 刷新表格
- (void)reloadTableData {
    [_items removeAllObjects];
    [_items addObjectsFromArray:self.model.items];
    //[self.view bringSubviewToFront: self.tableView];
    Tao800SearchHomeDataSource *dc = [[Tao800SearchHomeDataSource alloc] initWithItems:_items];
    self.dataSource = dc;
//    [self displayNavBar:YES];

    if (self.model.pageNumber <= 1) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        //[self.tableView scrollsToTop];
    }

    if (self.requestType != RequsetTypeSearchDeals) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)loadItems {
    switch (self.requestType) {
        case RequsetTypeSearchHistory: {
            [self getSearchHistory];
        }
            break;
        case RequsetTypeSearchDeals: {
            [self getSearchDeals];
        }
            break;
        case RequsetTypeSearchSuggestion: {
            [self getSearchSuggestion];
        }
            break;
        case RequsetTypeRecommendDeals: {
            [self getRecommendDeals];
        }
            break;
        default:
            break;
    }

}

#pragma mark 单元格将要显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    [self resetSwitchButtonStatus];
}

#pragma mark 点击表格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *keyword = @"";

    NSObject *selectItem = [_items objectAtIndex:indexPath.row];
    if ([selectItem isKindOfClass:[Tao800LoadMoreItem class]]) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

    if (selectItem == nil) {
        return;
    }
    if ([selectItem isKindOfClass:[Tao800DealListGridItem class]]) {
        return;
    }

    if ([selectItem isKindOfClass:[Tao800SearchHistoryItem class]]) {
        Tao800SearchHistoryItem *item = (Tao800SearchHistoryItem *) selectItem;
        if (item.isHeader) {
            return;
        }
        keyword = item.keyword;
        TBDPRINT(@"%@", item.keyword);
    } else if ([selectItem isKindOfClass:[Tao800SearchSuggestionItem class]]) {
        Tao800SearchSuggestionItem *item = (Tao800SearchSuggestionItem *) selectItem;
        Tao800SearchSuggestionVo *vo = item.vo;
        keyword = vo.word;
        TBDPRINT(@"%@", vo.word);
        //保存搜索记录
        [self.suggestionVCL.suggestionModel saveSearchKeyword:vo.word];
    }

    _searchBar.searchTextField.text = keyword;

    //搜索商品
    self.model.pageNumber = 1;
    [self getSearchDeals];
}

#pragma mark - 子类必须实现此方法，用于实现加载数据时loading框确定位置
- (CGRect)getLoadingRect {
    CGRect rect = self.tableView.frame;
    return rect;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.enableAutoLoadItems = (self.requestType != RequsetTypeSearchSuggestion);
    [super scrollViewDidScroll:scrollView];
    [self.view.superview endEditing:YES];
}
#pragma mark - displayNavBarAndheadView 隐藏和显示头筛选视图和导航条,搜索部分滑动存在特性，注意逻辑处理
- (void)displayNavBar:(BOOL)show {
    Tao800SearchHomeModel *homeModel = (Tao800SearchHomeModel *) _model;
    int number = 11;
    if ([UIScreen mainScreen].bounds.size.height < 500) {
        number = 6;
    }
    if (self.requestType == RequsetTypeSearchHistory && homeModel.items.count < number) {
        return;
    }


    static BOOL hidAnimation = NO;
    if (hidAnimation) {
        return;
    }

    static BOOL tabBarAppeared = YES;

    if (show == tabBarAppeared) {
        return;
    }
    hidAnimation = YES;
    tabBarAppeared = show;

    [self hideSwitchButton:show];

    CGRect tRect = self.tableView.frame;
    if (!show) {
        //隐藏上下栏时，先修改tableView的大小和位置
        CGRect topBarRect = self.searchBar.frame;
        CGFloat offset = topBarRect.origin.y + topBarRect.size.height;
        tRect.size.height = self.view.height - offset;
        self.tableView.frame = tRect;
    }

    [self.view bringSubviewToFront:self.tbNavigatorView];

    [UIView animateWithDuration:.3
                     animations:^{

                         CGRect navRect = self.tbNavigatorView.frame;
                         if (show) {
                             navRect.origin.y = self.view.height - navRect.size.height;
                         } else {
                             navRect.origin.y = navRect.origin.y + navRect.size.height;
                         }

                         self.tbNavigatorView.frame = navRect;

                     }
                     completion:^(BOOL finish) {
                         hidAnimation = NO;

                         if (show) {
                             CGRect tableRect = self.tableView.frame;
                             tableRect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.searchBar.frame) - CGRectGetMinY(self.searchBar.frame) - self.tbNavigatorView.height;
                             self.tableView.frame = tableRect;
                         }


                         //解决切换首行无响应问题，问题原因还在找。
                         [self.view bringSubviewToFront:self.tableView];
                         [self.view bringSubviewToFront:self.tbNavigatorView];
                         [self.view bringSubviewToFront:self.switchButton];
                         [self.view bringSubviewToFront:self.toTopButton];
                     }];
}

- (void)resetLoadState {
    [super resetLoadState];

    if (!self.model.hasNext && [self.model.items count] > 0) {//&& self.model.pageNumber > 1
        //加载已经完成，并且超过一页
        id vo = [self.model.items objectAtIndex:0];
        if (![vo isKindOfClass:[Tao800DealListItem class]] && ![vo isKindOfClass:[Tao800DealListGridItem class]]) {
            self.tableView.tableFooterView = nil;
            return;
        }
        Tao800LoadMoreFinishTipView *loadFinishTipView = [[Tao800LoadMoreFinishTipView alloc]
                initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        self.tableView.tableFooterView = loadFinishTipView;

    } else {
        self.tableView.tableFooterView = nil;
    }
}

#pragma Tao800SearchNoDealHeaderViewDelegate method
- (void)addToWishList {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if(dm.user==nil || dm.user.userId==nil){
        [self doLoginAction];
        return;
    }
    
    //点击许愿 来源：搜索打点
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Wishc params:@{Event_Wishc_S : @"1"}];

    if (self.wishWord != nil && ![self.wishWord isEqualToString:@""]) { //从心愿单界面而来
        [self goBackFromNavigator];
    } else { //从搜索界面来，需要跳到心愿单
        NSString *wishWord = _searchBar.searchTextField.text;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                @"Tao800HeartWish@Tao800HeartWishListVCL", TBBForwardSegueIdentifierKey,
                wishWord, @"wishWord",
                nil];
        [Tao800ForwardSegue ForwardTo:dict sourceController:self];
    }
}

-(NSString*)touchStatusBarChild{
    return NSStringFromClass([self class]);
}

-(void)showStatusMessage{
    if (!NeedResetUIStyleLikeIOS7()) {
        self.customStatusBar.backgroundColor = [UIColor colorWithHex:0x2A3440];
    }else{
        self.customStatusBar.backgroundColor = TEXT_COLOR_RED1;
    }
    [self.customStatusBar showStatusMessage:@"轻触此处回到顶部" autoHide:YES];
}


@end
