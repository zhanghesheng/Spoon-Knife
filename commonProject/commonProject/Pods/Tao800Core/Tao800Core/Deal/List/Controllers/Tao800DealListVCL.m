//
//  Tao800DealListVCL.m
//  tao800
//
//  Created by enfeng on 14-2-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListVCL.h"
#import "TLSwipeForOptionsCell.h"
#import "Tao800ForwardSegue.h"
#import "Tao800DealListModel.h"
#import "Tao800DealListItem.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800DealListGridCell.h"
#import "Tao800DealListGridItemView.h"
#import "Tao800StyleSheet.h"
#import "Tao800TabButton.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
#import "Tao800DealListGridItem.h"
#import "Tao800LoadMoreItem.h"
#import "Tao800AnalysisExposureContentVO.h"
#import "Tao800ConfigTipBVO.h"
#import "Tao800ConfigBVO.h"
#import "Tao800ConfigManage.h"
#import "Tao800AnalysisExposureManage.h"
#import "Tao800AnalysisExposureContentDealVO.h"
#import "TBCore/TBCore.h"

NSString *const DealListFavoriteHelpTip = @"DealListFavoriteHelpTip";
NSString *const DealListCellClickedHelpTip = @"DealListCellClickedHelpTip";

CGFloat const DealListOffsetLoading = 99 * 5; //滚动到倒数第5个加载下一页
CGFloat const DealGridOffsetLoading = 242 * 3;


@interface Tao800DealListVCL ()
@property(nonatomic, strong) TLOverlayView *overlayView;
@property(nonatomic, weak) UITableViewCell *cellDisplayingMenuOptions;
@property(nonatomic, assign) SEL favoriteSelector5;
@property (nonatomic) Tao800DealListPageTag pageTag;

@property (nonatomic) NSUInteger tapCountOnSwithBtn; //纪录switch按钮的点击次数

- (void) addFavorite;
- (void) deleteFavorite;
@end


@implementation Tao800DealListVCL


- (void)hideSafeView:(BOOL)show{}

- (void) resetPagTag {
    self.pageTag = Tao800DealListPageTagDefault;
}

- (void) forwardToAfterLogin {
    SEL sel = nil;
    switch (self.pageTag) {
        case Tao800DealListPageTagDefault:
            break;
        case Tao800DealListPageTagWishList:
            sel = @selector(addToWishList);
            break;
        default:
            break;
    }
    if (!sel) {
        return;
    }
    
    //登录成功后的跳转
    [self performSelector:sel withObject:nil afterDelay:.7];
    [self performSelector:@selector(resetPagTag) withObject:nil afterDelay:.9];
}

-(void)cancelLogin{
    [self resetPagTag];
}

-(void)doLoginAction{
    [self openLoginPage];
    self.pageTag = Tao800DealListPageTagWishList;
}

- (void) setFavoriteSelector5:(SEL) sel {
    _favoriteSelector5 = sel;
}

- (void)saveFavoriteState:(Tao800DealVo*) dealVo {
    self.selectedDeal = dealVo;

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    BOOL contain = [dm.favoriteDealIds containsObject:@(dealVo.dealId)];
    if (contain) {//已经收藏过
        [self deleteFavorite];
    } else {
        [self addFavorite];
    }
}

- (NSString *) getCID {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    return dm.getUserRole;
}

- (void)openDealPage:(Tao800DealVo *)deal sortId:(int)sortId{

//    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    
    NSDictionary *dict = @{
            TBBForwardSegueIdentifierKey : @"Tao800DealDetail@Tao800DealDetailWebVCL",
            @"deal" : deal,
            @"pageFrom" : @(self.dealDetailFrom),
            @"sortId" : [NSString stringWithFormat:@"%d",sortId],
            @"tapCountOnSwithBtn" : @(self.tapCountOnSwithBtn),
            @"displayAsGrid" : @(listModel.displayAsGrid)
    };

    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict];

    NSString *cId = [self getCID];

//    if ([self.model isKindOfClass:[Tao800TagListModel class]]) {
//        cId = ((Tao800TagListModel*)self.model).categoryVo.urlName;
//        [result setObject:((Tao800TagListModel*)self.model).tagList forKey:@"tagList"];//分类列表特殊处理
//    }else if ([self.model isKindOfClass:[Tao800SaunterListModel class]]) {
//        cId = ((Tao800SaunterListModel*)self.model).urlName;
//    }else if([self.model isKindOfClass:[Tao800HomeModel class]]) {
//        cId = dm.getUserRole;
//    }else if([self.model isKindOfClass:[Tao800PromotionListModel class]]) {
//        Tao800PromotionListVCL *vcl = (Tao800PromotionListVCL *)self;
//        cId = [NSString stringWithFormat:@"%d",vcl.sourceFrom];
//    }else if ([self isKindOfClass:[Tao800MuYingBrandDealListVCL class]]){
//        Tao800MuYingBrandDealListVCL * brandList = (Tao800MuYingBrandDealListVCL * )self;
//        cId = brandList.urlName;
//    }else if([self isKindOfClass:[Tao800MuYingSingleDealListVCL class]]){
//        Tao800MuYingSingleDealListVCL * singleBrand = (Tao800MuYingSingleDealListVCL * )self;
//        cId = singleBrand.keyWord;
//    }else if ([self isKindOfClass:[Tao800SearchHomeVCL class]]){
//        Tao800SearchHomeVCL *searchHomeVCL = (Tao800SearchHomeVCL *)self;
//        cId = searchHomeVCL.suggestionVCL.suggestionModel.keyword;
//    }

    switch (self.dealDetailFrom) {
        case Tao800DealDetailFromBanner:
            if (self.bannerVo) {
                cId = [NSString stringWithFormat:@"%d",self.bannerVo.bannerId.intValue];
            }
            break;
        case Tao800DealDetailFromStartInfo:
            if (self.bannerVo) {
                cId = [NSString stringWithFormat:@"%d",self.bannerVo.bannerId.intValue];
            }
            break;
        case Tao800DealDetailFromSaunterChoiceBanner:
            if (self.bannerVo) {
                cId = [NSString stringWithFormat:@"%d",self.bannerVo.bannerId.intValue];
            }
            break;
        case Tao800DealDetailFromSaunterCategoryBanner:
            if (self.bannerVo) {
                cId = [NSString stringWithFormat:@"%d",self.bannerVo.bannerId.intValue];
            }
            break;
        case Tao800DealDetailFromJuBanner:
            if (self.bannerVo) {
                cId = [NSString stringWithFormat:@"%d",self.bannerVo.bannerId.intValue];
            }
            break;
        default:
            break;
    }

    if (cId.length > 0) {
        [result setObject:cId forKey:@"cId"]; //todo 需要传入分类id
    }

    [[Tao800ForwardSingleton sharedInstance] openDealDetailPage:result];
}

#pragma mark 进入我的礼品列表页面
- (void)openDealDetailPage:(NSDictionary *)params {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800DealVo *dealVo = params[@"deal"];
    NSString *dealId = params[@"dealId"];
    NSString *_toTaoBao = params[@"_toTaoBao"];  //本地跳到淘宝页面，强制条件
    
    NSString *identifierKey = nil;
    if (_toTaoBao) {
        identifierKey = @"Tao800DealDetail@Tao800DealDetailTaoBaoWebVCL";
    } else if (dm.configBVO.configTipBVO.isUserDefineUrl) { //全局开关, 如果打开代表跳转到我们自己的url
        if (dealVo && dealVo.detailUrl && dealVo.detailUrl.length > 1) {
            identifierKey = @"Tao800DealDetail@Tao800DealDetailLocalWebVCL";
        } else {
            identifierKey = @"Tao800DealDetail@Tao800DealDetailTaoBaoWebVCL";
        }
    } else if (dealId) {
        //来自运营
        identifierKey = @"Tao800DealDetail@Tao800DealDetailLocalWebVCL";
    } else {
        //来自个人中心我的收藏
        identifierKey = @"Tao800DealDetail@Tao800DealDetailTaoBaoWebVCL";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setValue:identifierKey forKey:TBBForwardSegueIdentifierKey];
    [Tao800ForwardSegue ForwardTo:dict sourceController:self.navigationController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.favoriteSelector5 = NULL;
}

- (void)loginNotify:(NSNotification *)note {
    [self.tableView reloadData]; //同步积分状态
    if (self.favoriteSelector5) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:self.favoriteSelector5];
#pragma clang diagnostic pop
    }
    
    [self forwardToAfterLogin];
}

- (void) logout:(NSNotification *)note {
    [self.tableView reloadData];  //同步积分状态
}

-(void)cancelLoginEvent:(NSNotification *)nt{
    [self cancelLogin];
}

- (void)updateExposureContentVO {
 
    [self initExposureContent];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.enableAutoLoadItems = YES;
        self.lastSlideTime = nil;
        self.beforeLastSlideTime = nil;
        self.isStatusTipAppear = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginNotify:)
                                                     name:Tao800SettingLoginCTLDidCheckLoginNotifyCation
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(logout:)
                                                     name:Tao800SettingsViewCTLLogoutSuccessNotifyCation
                                                   object:nil];
        //关注取消登陆事件
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelLoginEvent:)
                                                     name:Tao800SettingLoginCTLDidCanceledNotifyCation
                                                   object:nil];
        TBAddObserver(Tao800PersonalIdentityDidChangeNotification, self, @selector(updateExposureContentVO), nil);
        TBAddObserver(Tao800PersonalBirthdayVCLDidChangeNotification, self, @selector(updateExposureContentVO), nil);
        TBAddObserver(Tao800SettingLoginCTLDidCheckLoginNotifyCation, self, @selector(updateExposureContentVO), nil);
    }
    return self;
}

- (void)dealloc {
    if (_customStatusBar) {
        [_customStatusBar cancelMethod];
        
        [_customStatusBar removeFromSuperview];
    }
    _customStatusBar = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[Tao800AnalysisExposureManage shareInstance] removeExposureBaseInfo:self.exposureContentVO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_customStatusBar && _customStatusBar.hidden) {
        _customStatusBar.hidden = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_customStatusBar) {
        _customStatusBar.hidden = YES;
    }
}

//要想掉用此方法必须保证该类或其子类的 goBackBlock 不为空
-(void)preBackBlock{
    if (_customStatusBar && !_customStatusBar.hidden) {
        _customStatusBar.hidden = YES;
    }
}

- (void)reloadTableData {
    
}

- (void)reloadTableFrame {
    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    if (listModel.items.count <3&& !listModel.hasNext) {
        if (self.tableView.tag == 0) {
            CGRect rect = self.tableView.frame;
            rect.size.height -= (Tao800DefaultTabbarHeight-1);
            self.tableView.frame = rect;
            self.tableView.tag = 1;
        }
    }else{
        CGRect rectNormal = self.tableView.frame;
        rectNormal.size.height = _tableHeight;
        self.tableView.frame = rectNormal;
        self.tableView.tag = 0;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void) layoutFloatButton {
    UIImage *gridImage = TBIMAGE(@"bundle://common_grid_btn@2x.png");
    UIImage *listImage = TBIMAGE(@"bundle://common_list_btn@2x.png");
    UIImage *topImage = TBIMAGE(@"bundle://common_scrolltotop_btn.png");
    
    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    UIImage *image = nil;
    if (listModel.displayAsGrid) {
        image = listImage;
    } else {
        image = gridImage;
    } 
    
    CGRect rect = self.switchButton.frame;
    rect.size = CGSizeMake(31, 31);
    rect.origin.x = self.view.width - rect.size.width - 15;
    rect.origin.y = self.view.height - 20 - rect.size.height - [self bottomBarHeight];
    self.switchButton.frame = rect;
    [self.switchButton setBackgroundImage:image forState:UIControlStateNormal];
    
    rect = self.switchButton.frame;
    rect.origin.y = rect.origin.y-rect.size.height-9;
    self.toTopButton.frame = rect;
    [self.toTopButton setBackgroundImage:topImage forState:UIControlStateNormal]; //todo test

    //将topButton放在下面
    CGRect topRect = self.toTopButton.frame;
    CGRect switchRect = self.switchButton.frame;

    self.toTopButton.frame = switchRect;
    self.switchButton.frame = topRect;
    
    [self resetSwitchButton:self.tableView];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutFloatButton];
}

- (void)handleGuarantee:(id)sender{
    
#if DEBUG
    //NSString *const h5url = @"http://h5.m.xiongmaoz.com/ms/zhe800h5/app/staticpage/xb.html";
    NSString *const h5url = @"http://s.zhe800.com/ms/zhe800hd/app/xb/xb.html";
#else
    //NSString *const h5url = @"http://h5.m.xiongmaoz.com/ms/zhe800h5/app/staticpage/xb.html";
    NSString *const h5url = @"http://s.zhe800.com/ms/zhe800hd/app/xb/xb.html";
#endif
    NSDictionary *dict = @{
                           TBBForwardSegueIdentifierKey : @"TBBWebViewCTL@Tao800WebVCL",
                           @"url" :h5url
                           };
    [Tao800ForwardSegue ForwardTo:dict sourceController:self];
}

/**
 * 子类需要重写该方法
 */
- (NSIndexPath*) getSwitchTargetIndexPath {
    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    NSIndexPath *indexPath = nil;
    
    NSArray *visibleCells = [self.tableView visibleCells];
    if (visibleCells && visibleCells.count>1) {
        UITableViewCell *cell = visibleCells[0];
        indexPath = [self.tableView indexPathForCell:cell];
        NSInteger row = 0;
    
        if (listModel.displayAsGrid) {
            row = indexPath.row/2;
        } else {
            row = (indexPath.row)*2;
        }
        indexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
    }
    return indexPath;
}

-(void)logReturnTop{
    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    
    switch (self.dealDetailFrom) {
        case Tao800DealDetailFromNewCategory:{
            NSString *urlName = listModel.cId;
            if (!urlName) {
                urlName = @"";
            }
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Returnttp params:@{Event_Returnttp_S:urlName}];
        }
            break;
        case Tao800DealDetailFromToday:{
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Returnttp params:@{Event_Returnttp_S:@"today"}];
        }
            break;
        case Tao800DealDetailFromMobile:{
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Returnttp params:@{Event_Returnttp_S:@"mobile"}];
        }
            break;
        case Tao800DealDetailFromHome:{
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Returnttp params:@{Event_Returnttp_S:@"shouye"}];
        }
            break;
        case Tao800DealDetailFromPromotionHome:{
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Returnttp params:@{Event_Returnttp_S:@"shouye"}];
        }
            break;
        case Tao800DealDetailFromSearch:{
            [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Returnttp params:@{Event_Returnttp_S:@"search"}];
        }
        default:
            break;
    }
}

- (BOOL) enableSwitchAnimation {
    return NO;
}

- (void)handleSwitch:(id)sender {
    if (sender == self.toTopButton) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self logReturnTop];//返回顶部打点 update by minjie
        return;
    }
    
    BOOL canSwitch = NO; //update by enfeng
    if (self.model.items.count>0) {
        canSwitch = YES;
        
        self.tapCountOnSwithBtn++;
    }
    
    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    
    listModel.displayAsGrid = !listModel.displayAsGrid;
    NSIndexPath *indexPath = nil;
    if (canSwitch) {
        indexPath = [self getSwitchTargetIndexPath];
    }
    
    [self.model.items removeAllObjects];

    if (listModel.displayAsGrid) {
        [[Tao800UGCSingleton sharedInstance] paramsLog:Event_DisplayAsGrid params:@{Event_DisplayAsGrid_PARAM_T: @"1"}];
    }else{
        [[Tao800UGCSingleton sharedInstance] paramsLog:Event_DisplayAsGrid params:@{Event_DisplayAsGrid_PARAM_T: @"2"}];
    }
    
    if (canSwitch) {  
        [listModel reloadItems];
    }
    [self viewDidLayoutSubviews];
    
    self.isSwitching = YES;
    [self reloadTableData];
    
    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:[self enableSwitchAnimation]];

    }
    self.isSwitching = NO;
}

- (void) initExposureContent {

    //添加基础打点信息
    self.exposureContentVO = [self getExposureContentVo];
    [self.exposureContentVO resetExposureIdentifier];
    Tao800AnalysisExposureManage *manage = [Tao800AnalysisExposureManage shareInstance];
    [manage addExposureBaseInfo:self.exposureContentVO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tapCountOnSwithBtn = 0;
    
    [self initExposureContent];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton = btn;
    self.switchButton.hidden = YES;
    self.toTopButton = btn2;
    self.toTopButton.hidden = YES;
    [self.view addSubview:btn];
    [self.view addSubview:btn2];
    
 
    
    self.tableView.backgroundColor = BACKGROUND_COLOR_GRAY1;

    [btn addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventTouchUpInside];
    _tableHeight = self.tableView.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //warning
    //该方法不会被调用
    //因为Cell中的ScrollView在顶层会优先响应触摸事件
    
    NSInteger index = indexPath.row;
    if (index >= self.model.items.count) {
        return;
    }

    NSObject *item = [self.model.items objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[Tao800LoadMoreItem class]]) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[Tao800MenuCell class]]) {
        Tao800MenuCell *cell1 = (Tao800MenuCell *) cell;
        cell1.delegate = self;
    } else if ([cell isKindOfClass:[Tao800DealListGridCell class]]) {
        Tao800DealListGridCell *cell1 = (Tao800DealListGridCell *) cell;
        for (Tao800DealListGridItemView *itemView in cell1.itemViews) {
            [itemView.maskButton setTitle:@"" forState:UIControlStateNormal];
            [itemView.maskButton addTarget:self
                                    action:@selector(clickItem:)
                          forControlEvents:UIControlEventTouchUpInside];
            [itemView.favoriteButton addTarget:self
                                        action:@selector(changeFavoriteState:)
                              forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)clickItem:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if ([btn.superview isKindOfClass:[Tao800DealListGridItemView class]]) {
        Tao800DealListGridItemView *itemView = (Tao800DealListGridItemView *) btn.superview;
        // 计算sortId
        NSInteger sortId = (self.model.pageNumber-1)*(self.model.pageSize)+(btn.tag+1);
        [self openDealPage:itemView.userData sortId:(int)sortId];
    }  
    //30天访问详情打点
    [[Tao800UGCSingleton sharedInstance] countEachDayOut];
}

- (void)changeFavoriteState:(id)sender {
    Tao800TabButton *btn = (Tao800TabButton *) sender;
    [self saveFavoriteState:btn.userData];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter]
            postNotificationName:TLSwipeForOptionsCellShouldHideMenuNotification
                          object:scrollView];
    self.previousContentOffset = scrollView.contentOffset;
    if (!self.lastSlideTime) {
        self.lastSlideTime = [NSDate date];
    }else if(!self.beforeLastSlideTime){
        self.beforeLastSlideTime = _lastSlideTime;
        self.lastSlideTime = [NSDate date];
    }else{
        self.beforeLastSlideTime = _lastSlideTime;
        self.lastSlideTime = [NSDate date];
    }
}

#pragma mark - TLOverlayViewDelegate Methods

- (UIView *)overlayView:(TLOverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL shouldInterceptTouches = YES;

    CGPoint location = [self.view convertPoint:point fromView:view];
    CGRect rect = [self.tableView convertRect:self.cellDisplayingMenuOptions.frame toView:self.view];

    shouldInterceptTouches = CGRectContainsPoint(rect, location);
    if (!shouldInterceptTouches)
        [[NSNotificationCenter defaultCenter]
                postNotificationName:TLSwipeForOptionsCellShouldHideMenuNotification object:self.tableView];


    return shouldInterceptTouches ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
}


#pragma mark - Tao800DealListCellDelegate Methods

- (void)cell:(Tao800MenuCell *)cell didShowMenu:(BOOL)isShowingMenu {
    self.cellDisplayingMenuOptions = cell;
    [self.tableView setScrollEnabled:!isShowingMenu];
    if (isShowingMenu) {
        if (!self.overlayView) {
            self.overlayView = [[TLOverlayView alloc] initWithFrame:self.view.bounds];
            [self.overlayView setDelegate:self];
        }

        [self.overlayView setFrame:self.view.bounds];
        [self.view addSubview:self.overlayView];
 
    } else {
        [self.overlayView removeFromSuperview];
//        self.tableView.userInteractionEnabled = YES;
    }
}

- (void)dealFavoriteError:(TBErrorDescription *)error {
    [self showPageLoading:NO];
    [self hideLoadingView];
    if (error.errorCode == 401) {
//        [self showTextTip:@"请登录后操作"];
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];
    }
}

- (void)addFavorite {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.user || !dm.user.userId) {
        //弹出登录
        self.favoriteSelector5 = @selector(addFavorite);
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];
        return;
    }

    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    if (listModel.displayAsGrid) {
        [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Favorite_List params:@{Event_Favorite_List_PARAM_D : [NSString stringWithFormat:@"%d", self.selectedDeal.dealId], Event_Favorite_List_PARAM_T : @"1"}];
    } else {
        [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Favorite_List params:@{Event_Favorite_List_PARAM_D : [NSString stringWithFormat:@"%d", self.selectedDeal.dealId], Event_Favorite_List_PARAM_T : @"0"}];
    }

    __weak Tao800DealListVCL *instance = self;

//    [self showPopupLoadingView:@"收藏中" fullScreen:YES];

    [listModel addFavorite:@{@"deal" : self.selectedDeal}
                completion:^(NSDictionary *pDict) {
                    [instance hideLoadingView];

                    NSNumber *statusNumber = pDict[@"status"];
                    NSString *message = pDict[@"message"];
                    int status = statusNumber.intValue;
                    NSNumber *dealIdNum = pDict[@"dealId"];
                    if (status == 201 || status==409 || dealIdNum) {
//                        [instance showTextTip:@"收藏成功"];


                        [[NSNotificationCenter defaultCenter]
                                postNotificationName:TLSwipeForOptionsCellShouldHideMenuNotification
                                              object:instance.tableView];
                        //收藏成功，发送通知
                        [[NSNotificationCenter defaultCenter]
                                postNotificationName:Tao800FavoriteDealDidChangeNotification
                                              object:instance.tableView
                                            userInfo:@{@"deal" : instance.selectedDeal}];
                    } else {
                        if (!message) {
                            message = @"收藏失败";
                        }
                        [instance showTextTip:message];
                    }
                } failure:^(TBErrorDescription *err) {
        [instance dealFavoriteError:err];
        if (err.errorCode != 401) {
            [instance showTextTip:@"收藏失败"];
        }
    }];
}

- (void)deleteFavorite {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.user || !dm.user.userId) {
        //弹出登录  //应该不需要判断登录状态
        self.favoriteSelector5 = @selector(deleteFavorite);
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];

        return;
    }

    Tao800DealListModel *listModel = (Tao800DealListModel *) self.model;
    __weak Tao800DealListVCL *instance = self;

//    [self showPopupLoadingView:@"取消收藏" fullScreen:YES];

    [listModel deleteFavorite:@{@"deal" : self.selectedDeal}
                   completion:^(NSDictionary *pDict) {
                       [instance hideLoadingView];

                       NSNumber *statusNumber = pDict[@"status"];
                       NSString *message = pDict[@"message"];
                       int status = statusNumber.intValue;

                       if (status == 201) {
//                           [instance showTextTip:@"取消收藏成功"];


                           [[NSNotificationCenter defaultCenter]
                                   postNotificationName:TLSwipeForOptionsCellShouldHideMenuNotification
                                                 object:instance.tableView];
                           //收藏，发送通知
                           [[NSNotificationCenter defaultCenter]
                                   postNotificationName:Tao800FavoriteDealDidChangeNotification
                                                 object:instance.tableView
                                               userInfo:@{@"deal" : instance.selectedDeal}
                           ];
                       } else {
                           if (!message) {
                               message = @"取消收藏失败";
                           }
                           [instance showTextTip:message];
                       }
                   } failure:^(TBErrorDescription *err) {
        [instance dealFavoriteError:err];
        if (err.errorCode != 401) {
            [instance showTextTip:@"取消收藏失败"];
        }
    }];
}

- (void)cellDidSelectFavorite:(Tao800MenuCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    Tao800DealListItem *item = [self.model.items objectAtIndex:row];

    [self saveFavoriteState:item.dealVo];
}

- (NSInteger) getDealIndexWithCell:(UITableViewCell*) cell {
    return [self.tableView indexPathForCell:cell].row+1;
}

- (void)cellDidSelect:(Tao800MenuCell *)cell {
    //30天访问详情打点
    [[Tao800UGCSingleton sharedInstance] countEachDayOut];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tip = [defaults objectForKey:DealListCellClickedHelpTip];
    if (!tip) {
        //记录用户点击了cell，用于蒙层提示
        [defaults setObject:@"" forKey:DealListCellClickedHelpTip];
        [defaults synchronize];
    }

    cell.selected = NO;
    Tao800DealListCell *cell1 = (Tao800DealListCell *) cell;
    Tao800DealListItemView *itemView = cell1.itemView;


    NSInteger sortId = [self getDealIndexWithCell:cell];

    [self openDealPage:itemView.userData sortId:(int)sortId];
}

- (void)resetSwitchButton:(UIScrollView *)scrollView {
    self.toTopButton.hidden = scrollView.contentOffset.y<=Tao800DealListTopButtonDisplayOffset;
}

#pragma mark - UIScrollViewDelegate Methods -

- (void) scrollToLoadItems:(UIScrollView *)scrollView {
    if (!self.enableAutoLoadItems || self.isSwitching) {
        return;
    }
    Tao800DealListModel *model1 = (Tao800DealListModel *) self.model;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetLoad = 0;
    if (model1.displayAsGrid) {
        offsetLoad = DealGridOffsetLoading;
    } else {
        offsetLoad = DealListOffsetLoading;
    }
    offsetLoad = offsetLoad + scrollView.height;

    CGSize contentSize = scrollView.contentSize;
    if (contentSize.height - offsetY <= offsetLoad && !self.model.loading && self.model.hasNext) {
        self.model.loading = YES;
        self.model.pageNumber++;
        [self loadItems];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isSwitching) {
        return;
    }
    [super scrollViewDidScroll:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<=0) {
        [self resetSwitchButton:scrollView];
    }
    
    [self scrollToLoadItems:scrollView];
    
    if (scrollView != self.tableView) {
        return;
    }
    Tao800DataModelSingleton* dm = [Tao800DataModelSingleton sharedInstance];
    if (self.lastDirection == Tao800TableDirectionDown && self.beforeLastDirection == Tao800TableDirectionDown) {
        NSString* classString = [self touchStatusBarChild];
        NSString* name = [dm.statusBarClickCache objectForKey:classString];
        if (_lastSlideTime && _beforeLastSlideTime && !self.isStatusTipAppear && !name) {
            NSTimeInterval time = [_lastSlideTime timeIntervalSinceDate: _beforeLastSlideTime];
            if (time<=.8) {
                [self showStatusMessage];
                self.isStatusTipAppear = YES;
            }
        }
    }
    
    CGFloat height = self.view.frame.size.height;
    CGFloat offsetYY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    
    if (contentHeight < height) {
        return;
    }
    [self hideAction:offsetYY with:offsetY];
}

- (void)hideAction:(CGFloat)offsetYY with:(CGFloat)offsetY
{
    if (self.isSwitching) {
        return;
    }
    
    BOOL show = NO;
    if (offsetYY < self.previousContentOffset.y-44) {
        //向下, 隐藏筛选
        show = YES;
        [self displayNavBar:YES];
//        [self hideSwitchButton:show];
    } else if (offsetY > self.previousContentOffset.y + 44) {
        show = NO;
        [self displayNavBar:NO];
//        [self hideSwitchButton:show];
    }
}

- (void)displayNavBar:(BOOL)show {
    [self hideSwitchButton:show];
 
}

- (void)hideSwitchButton:(BOOL)show
{
    self.toTopButton.hidden = self.tableView.contentOffset.y<=Tao800DealListTopButtonDisplayOffset;
    [UIView animateWithDuration:.3
                     animations:^{
                         if (show&&([self.model.items count]>0)) {
                             self.switchButton.alpha = 1.0;
                             self.toTopButton.alpha = 1.0;
                         }
                         else
                         {
                             self.switchButton.alpha = 0.0;
                             self.toTopButton.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finish) {
                     }];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetSwitchButton:scrollView];

    [self checkExposureItems];
}

- (Tao800AnalysisExposureContentVO*) getExposureContentVo {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    Tao800ConfigManage* configManage = [[Tao800ConfigManage alloc]init];
    NSString *birthday = [configManage getBabyBirthday];
    NSString *babySex = [configManage getBabySex];

    Tao800AnalysisExposureContentVO *contentVO = [[Tao800AnalysisExposureContentVO alloc] init];
    contentVO.exposureUserId = @"";
    if (dm.user.userId) {
        contentVO.exposureUserId = dm.user.userId;
    }
    contentVO.exposureDeviceId = dm.headerVo.deviceId;
    contentVO.exposureFromSource = @"2"; //代表客户端
    contentVO.exposurePlatform = dm.headerVo.platform;
    contentVO.exposureVersion = dm.headerVo.appVersion;
    contentVO.exposureChannel = dm.headerVo.partner;
    contentVO.exposureUserRole = [dm getUserRole];
    contentVO.exposureUserType = [NSString stringWithFormat:@"%@", @(dm.userType)];
    contentVO.exposureSchool =  [NSString stringWithFormat:@"%@", @([dm getUserStudentStatus])];
    if (birthday && babySex) {
        contentVO.exposureChild = [NSString stringWithFormat:@"%@_%@", birthday, babySex];
    }

//    contentVO.exposureListVersion = dm.listVersion; //需要子类重新赋值
    contentVO.exposurePosType = Tao800AnalysisExposurePostTypeHome; //需要子类设置
    contentVO.exposurePostValue = @"";  //需要子类设置
    contentVO.exposureRefer = @""; //需要子类设置
    return contentVO;
}

/**
* 上报曝光打点，检查所有符合条件的商品
*/
- (void)checkExposureItems {
    Tao800AnalysisExposureManage *exposureManage = [Tao800AnalysisExposureManage shareInstance];

    for (id obj in self.model.items) {

        if (![obj isKindOfClass:[Tao800DealBaseItem class]]) {
            continue;
        }
        Tao800DealBaseItem *item = obj;
        if (item.appearTime < 1) {
            continue;
        }
        NSDate *date2 = [NSDate date];
        NSTimeInterval disappearTime = [date2 timeIntervalSince1970];
        NSTimeInterval tt =  disappearTime - item.appearTime;
        if (item.disappearTime>0) {
            tt = item.disappearTime - item.appearTime;
        }

        if (tt > 1 || tt < 0) {
            if ([obj isKindOfClass:[Tao800DealListItem class]]) {
                //普通列表模式
                Tao800DealListItem *item1 = obj;
                Tao800AnalysisExposureContentDealVO *vo = [[Tao800AnalysisExposureContentDealVO alloc] init];
                vo.exposureOrderIndex = @(item.sortId);
                vo.exposureDealId = [NSString stringWithFormat:@"%d", item1.dealVo.dealId];
                long temp = (long) item.appearTime;
                vo.exposureTime = @(temp);
                vo.parentIdentifier = self.exposureContentVO.exposureIdentifier;

                [exposureManage addExposureDeal:vo];


                item1.appearTime = 0;
                item1.disappearTime = 0;
            } else {
                //宫格模式
                Tao800DealListGridItem *item1 = obj;
                int sortId= item.sortId;
                for (Tao800DealVo *dealVo in item1.items) {
                    if (dealVo.dealId<1) {
                        continue;
                    }
                    Tao800AnalysisExposureContentDealVO *vo = [[Tao800AnalysisExposureContentDealVO alloc] init];
                    vo.exposureOrderIndex = @(sortId);
                    vo.exposureDealId = [NSString stringWithFormat:@"%d", dealVo.dealId];
                    long temp = (long) item.appearTime;
                    vo.exposureTime = @(temp);
                    vo.parentIdentifier = self.exposureContentVO.exposureIdentifier;
                    [exposureManage addExposureDeal:vo];

                    sortId++;
                }
                item1.appearTime = 0;
                item1.disappearTime = 0;
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

//    if (!decelerate) {
        [self checkExposureItems];
//    }

    if (_lastDirection == Tao800TableDirectionNone) {
        _lastDirection = self.directionCurrent;
    }else if(_beforeLastDirection == Tao800TableDirectionNone){
        _beforeLastDirection = _lastDirection;
        _lastDirection = self.directionCurrent;
    }else{
        _beforeLastDirection = _lastDirection;
        _lastDirection = self.directionCurrent;
    }
    
}

//可供不同子类实现，解决下拉刷新成功提示不显示问题，默认调用父类方法
- (void)resetLoadStateSupper{
    [super resetLoadState];
}

- (void)resetLoadState {
    [self resetLoadStateSupper];

    if (!self.model.hasNext && [self.model.items count]>0) {//&& self.model.pageNumber > 1

        id voLast = [self.model.items lastObject];
        //如果正在加载，那么不出现心愿单和终止符，此种情况会出现在老接口没有明确hasNext并且预先有若干条信息（首页）的时候，此情况不影响新接口
        if (voLast&&[voLast isKindOfClass:[Tao800LoadMoreItem class]]){
            self.tableView.tableFooterView = nil;
        }else {
            Tao800AddToWishTipView *loadFinishTipView = [[Tao800AddToWishTipView alloc]
                    initWithFrame:CGRectMake(0, 0, self.view.width, 154)];
            self.tableView.tableFooterView = loadFinishTipView;
            loadFinishTipView.delegate = self;
        }
    } else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)openLoginPage {
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.user.userId) {
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];
    }
}

#pragma Tao800AddToWishTipViewDelegate method
-(void)addToWishList{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if(dm.user==nil || dm.user.userId==nil){
        [self doLoginAction];
        return;
    }
    
    //点击许愿 来源：列表底部
    [[Tao800UGCSingleton sharedInstance] paramsLog:Event_Wishc params:@{Event_Wishc_S: @"2"}];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Tao800HeartWish@Tao800HeartWishListVCL", TBBForwardSegueIdentifierKey,
                          nil];
    [Tao800ForwardSegue ForwardTo:dict sourceController:self];
}

-(Tao800CustomStatueBar *)getcustomStatusBar{
    if (!_customStatusBar) {
        _customStatusBar = [[Tao800CustomStatueBar alloc] initWithFrame:CGRectZero];
        _customStatusBar.barDelegate = self;
        [_customStatusBar makeKeyAndVisible];
    }
    return _customStatusBar;
}

-(NSString*)touchStatusBarChild{
    //子类重写该方法，返回子类的类名用来记录点击过
    return nil;
}

-(void)showStatusMessage{
    //子类重写该方法 group2_001 子类显示状态栏上的提示信息
}

-(void)touchStatusBar{
    Tao800DataModelSingleton* dm = [Tao800DataModelSingleton sharedInstance];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.tableView && self.model.items.count>0) {
        NSString* classString = [self touchStatusBarChild];
        if (classString && classString.length>0) {
            [dm.statusBarClickCache setValue:classString forKey:classString];
        }
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (CGFloat) bottomBarHeight {
    return TBDefaultNavigationBarHeight;
}

- (void) hideFloatButton {
    self.switchButton.hidden = YES;
    self.toTopButton.hidden = YES;
}
@end
