//
//  Tao800ForwardSingleton.m
//  tao800
//
//  Created by worker on 13-3-22.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ForwardSingleton.h"
#import "TBCore/TBCoreCommonFunction.h"
#import "Tao800UGCSingleton.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800DataModelSingleton.h"

#import "Tao800ForwardSegue.h"
#import "Tao800FunctionCommon.h"
#import "Tao800Util.h"
#import "Tao800ConfigManage.h"
#import "Tao800StartInfoVo.h"
#import "Tao800ForwardQueueItem.h"
#import "Tao800UpgradeManage.h"
#import "Tao800AutoLoginManager.h"
#import "Tao800CommentManager.h"

static Tao800ForwardSingleton *_instance;

@interface Tao800ForwardSingleton () {

}

@end

@implementation Tao800ForwardSingleton

@synthesize navigationController = _navigationController;

/**
* 每次收到页面退出的通知后都需要检查下是否还有符合条件的启动视图
*/
- (void)runStartQueueNext {
    [self.forwardDelegate runStartQueueNext];
}


/**
* 该方法的调用入口
*
* 1: 全新启动  didFinishLaunchingWithOptions
* 2: 后台切前台 applicationWillEnterForeground
*
* @param isBackToFront YES:后台切前台  NO:全新启动
*/
- (void)initStartQueue:(NSDictionary *)params {
    [self.forwardDelegate initStartQueue:params];
}

- (UIWindow *)window {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *arr = app.windows;
    for (UIWindow *win in arr) {
        NSString *sName = NSStringFromClass([win class]);
        if ([sName isEqualToString:@"UITextEffectsWindow"]) {
            return win;
        }
    }
    return [app.windows objectAtIndex:0];
}


/**
* 打开启动引导页面
*/
- (void)openLaunchPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openLaunchPage:params closeCallback:closeCallback];
}

- (void)openBlurPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openBlurPage:params closeCallback:closeCallback];
}

/**
* 用户身份选择页面
*/
- (void)openUserTypePage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openUserTypePage:params closeCallback:closeCallback];
}

- (UINavigationController *)navigationController {
//    if (_navigationController) {
//        return _navigationController;
//    }

    UIApplication *application = [UIApplication sharedApplication];
    UIViewController *viewCTL = application.keyWindow.rootViewController;
    if (![viewCTL isKindOfClass:[UINavigationController class]]) {
        return _navigationController;
    }

    UIViewController *ctl = nil;

    //先判断是不是弹出的model窗口
    ctl = viewCTL.presentedViewController;

    if (ctl) {
        viewCTL = ctl;
    }
    UIViewController *topViewCTL = viewCTL.topViewController;

    _navigationController = nil;
    if (topViewCTL.navigationController) {
        _navigationController = (Tao800NavigationVCL *) topViewCTL.navigationController;
    }
    if (!_navigationController) {
        _navigationController = (Tao800NavigationVCL *) self.appRootViewController;
    }
    return _navigationController;
}

- (void)resetNavigationController {
    [self navigationController];
    if (!_navigationController) {
        _navigationController = (Tao800NavigationVCL *) self.appRootViewController;
    }
}

- (void)openStartBannerPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openStartBannerPage:params closeCallback:closeCallback];
}

- (void)openWebPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openWebPage:params closeCallback:closeCallback];
}

/**
* 首单返利
*/
- (void)openFirstOrderRewardPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openFirstOrderRewardPage:params closeCallback:closeCallback];
}

- (void)openUpgradePage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {

    [self.forwardDelegate openUpgradePage:params closeCallback:closeCallback];
}

- (void)openAppCommentPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openAppCommentPage:params closeCallback:closeCallback];
}

/**
 * 崩溃提示
 */
- (void)openCrashCommentPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback{
    [self.forwardDelegate openCrashCommentPage:params closeCallback:closeCallback];
}


- (void)openTaobaoMergeTipPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *))closeCallback {
    //第三方登录需要放在最后一步
    //todo 后期第三方登录会重新实现

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [dm.autoLoginManager checkTaobaoLogin];
}

- (void)presentModelViewCTL:(UIViewController *)ctl {
    [self resetNavigationController];
    if ([ctl isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navCTL = (UINavigationController *) ctl;

        NSArray *array = [_navigationController viewControllers];
        NSArray *array2 = [navCTL viewControllers];
        //针对401,弹出登录都处理；避免崩溃
        if (array.count == array2.count && array2.count == 1) {
            UIViewController *ctlItem1 = [array objectAtIndex:0];
            UIViewController *ctlItem2 = [array2 objectAtIndex:0];
            NSString *ctlName1 = NSStringFromClass([ctlItem1 class]);
            NSString *ctlName2 = NSStringFromClass([ctlItem2 class]);
            if ([ctlName1 isEqualToString:ctlName2]) {
                return;
            }
        }
    }
    [_navigationController presentViewController:ctl animated:YES completion:^{
    }];
}

- (void)initData {

//    self.forwardCamera = [[Tao800ForwardCamera alloc] init];

    self.isBackToFront = NO;

    TBAddObserver(UIApplicationWillEnterForegroundNotification, self, @selector(applicationWillEnterForeground:), nil);
}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    self.isBackToFront = YES;
    self.isInstallStart = NO;
}

+ (Tao800ForwardSingleton *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            [_instance initData];
        }
    }
    return _instance;
}

- (uint)queueCount {
    return [self.forwardDelegate queueCount];
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self) {

        if (_instance == nil) {

            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark 账号登录页面

- (void)openLoginPage:(NSDictionary *)params {
    [self.forwardDelegate openLoginPage:params];
}

#pragma mark 注册页面

- (void)openUserRegistPage:(NSDictionary *)params {
    [self.forwardDelegate openUserRegistPage:params];
}

#pragma mark 修改密码页面

- (void)openFetchPasswordPage:(NSDictionary *)params {
    [self.forwardDelegate openFetchPasswordPage:params];
}

#pragma mark 我的礼物竞拍详情页面

- (void)openMyPresentAuctionDetailPage:(NSDictionary *)params {
    [self.forwardDelegate openMyPresentAuctionDetailPage:params];
}

#pragma mark 我的收藏页面

- (void)openMyFavoritePage:(NSDictionary *)params {
    [self.forwardDelegate openMyFavoritePage:params];
}

#pragma mark 分享管理页面

- (void)openShareManagerPage:(NSDictionary *)params {
    [self.forwardDelegate openShareManagerPage:params];
}

#pragma mark 打开新的web页

- (void)openOperationWebPage:(NSDictionary *)params {
    [self.forwardDelegate openOperationWebPage:params];
}

- (void)openSharePage:(NSDictionary *)params {
    [self.forwardDelegate openSharePage:params];
}

#pragma mark 进入我的礼品列表页面

- (void)openDealDetailPage:(NSDictionary *)params {
    [self.forwardDelegate openDealDetailPage:params];
}

#pragma mark 我的奖品新

- (void)openMyRewardPage:(NSDictionary *)params {
    [self.forwardDelegate openMyRewardPage:params];
}

#pragma mark 我的抽奖

- (void)openMyLuckyDrawPage:(NSDictionary *)params {
    [self.forwardDelegate openMyLuckyDrawPage:params];

}

#pragma mark 我的抽奖详情页

- (void)openMyLuckyDrawDetailPage:(NSDictionary *)params {
    [self.forwardDelegate openMyLuckyDrawDetailPage:params];
}

#pragma mark 抽奖详情页进入查看我的抽奖码
- (void)openMyLuckyDrawDetailMyCode:(NSDictionary *)params {
    [self.forwardDelegate openMyLuckyDrawDetailMyCode:params];
}

#pragma mark 抽奖详情页进入晒单页面

- (void)openMyLuckyDrawDetailShowPage:(NSDictionary *)params
{
    [self.forwardDelegate openMyLuckyDrawDetailShowPage:params];
}

#pragma mark 我的积分

- (void)openMyScorePage:(NSDictionary *)params {
    [self.forwardDelegate openMyScorePage:params];
}

#pragma mark 返积分订单

- (void)openScoreFeedbackOrderListPage:(NSDictionary *)params {
    [self.forwardDelegate openScoreFeedbackOrderListPage:params];
}

#pragma mark 我的账户页面

- (void)openPersonalInfoPage:(NSDictionary *)params {
    [self.forwardDelegate openPersonalInfoPage:params];
}

#pragma mark 开卖提醒页面

- (void)openMyRemindPage:(NSDictionary *)params {
    [self.forwardDelegate openMyRemindPage:params];
}


#pragma mark 关注公共账号页面

- (void)openAttentionPublicAccountPage:(NSDictionary *)params {
    [self.forwardDelegate openAttentionPublicAccountPage:params];
}

#pragma mark 编辑地址页面

- (void)openEditAddressPage:(NSDictionary *)params {
    [self.forwardDelegate openEditAddressPage:params];
}


#pragma mark 收货地址页面

- (void)openAddressPage:(NSDictionary *)params {
    [self.forwardDelegate openAddressPage:params];
}

#pragma mark 设置页面

- (void)openSettingPage:(NSDictionary *)params {
    [self.forwardDelegate openSettingPage:params];
}

#pragma mark 关于淘800页面

- (void)openAboutTao800Page:(NSDictionary *)params {
    [self.forwardDelegate openAboutTao800Page:params];
}

#pragma mark 打开意见反馈页面

- (void)openUserFeedbackPage:(NSDictionary *)params {
    [self.forwardDelegate openUserFeedbackPage:params];
}

#pragma mark 我的礼品的详情页面

- (void)openMyPresentDetailPage:(NSDictionary *)params {
    [self.forwardDelegate openMyPresentDetailPage:params];
}

#pragma mark 发布晒单页面

- (void)openPublishPostsPage:(NSDictionary *)params {
    [self.forwardDelegate openPublishPostsPage:params];

}

#pragma mark 激活页面

- (void)openAwakeAcountPage:(NSDictionary *)params {
    [self.forwardDelegate openAwakeAcountPage:params];
}

#pragma mark 用淘宝账号登录

- (void)openLoginWithThirdAcountPage:(NSDictionary *)params {
    [self.forwardDelegate openLoginWithThirdAcountPage:params];
}

#pragma mark 积分回馈商品详情界面

- (void)openScoreRewardDetailPage:(NSDictionary *)params {
    [self.forwardDelegate openScoreRewardDetailPage:params];
}

#pragma mark 积分拍卖详情界面 只有推送时会调用,

- (void)openScoreAuctionDetailPage:(NSDictionary *)params {
    [self.forwardDelegate openScoreAuctionDetailPage:params];
}

#pragma mark 积分兑换界面

- (void)openExchangePage:(NSDictionary *)params {
    [self.forwardDelegate openExchangePage:params];
}

#pragma mark 积分规则

- (void)openPointRulePage:(NSDictionary *)params {
    [self.forwardDelegate openPointRulePage:params];
}

#pragma mark 扫描条形码页面

- (void)openBarcodePage:(NSDictionary *)params {
    [self.forwardDelegate openBarcodePage:params];
}

#pragma mark 校园专区

- (void)openCampusProductsPage:(NSDictionary *)params {
    [self.forwardDelegate openCampusProductsPage:params];
}

#pragma 每日十件

- (void)openTenProductsEverydayPage:(NSString *)pushId {

    [self.forwardDelegate openTenProductsEverydayPage:pushId];
}

#pragma mark - 淘宝账户合并wap页面

- (void)openTaoBaoAccountMergeWebPage:(NSDictionary *)params {
    [self.forwardDelegate openTaoBaoAccountMergeWebPage:params];
}


#pragma mark 大促页面

- (void)openPromotionPage:(NSDictionary *)params {
    [self.forwardDelegate openPromotionPage:params];
}

- (NSURL *)wrapperBannerWapURL:(NSString *)bannerUrl {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSMutableString *urlString = [NSMutableString string];

    [urlString appendString:bannerUrl];

    NSRange range = [urlString rangeOfString:@"?"];
    if (range.length > 0) {
        [urlString appendString:@"&platform=iphone"];
    } else {
        [urlString appendString:@"?platform=iphone"];
    }
    [urlString appendString:@"&source=tao800_app"];
    [urlString appendFormat:@"&version=%@", dm.currentVersion];
    [urlString appendFormat:@"&channelId=%@", dm.partner];
    [urlString appendFormat:@"&deviceId=%@", [dm getHeaderVo].deviceId];
    if (dm.user.userId) {
        [urlString appendFormat:@"&userId=%@", dm.user.userId];
    }

    return [NSURL URLWithString:urlString];
}

// v3.0.0新增
#pragma mark 通过banner跳转页面

- (void)bannerForward:(Tao800BannerVo *)vo openByModel:(BOOL)flag bannerAtIndex:(int)index {
    [self.forwardDelegate bannerForward:vo openByModel:flag bannerAtIndex:index];
}

#pragma mark 通过开卖提醒push跳转页面

- (void)startSellPushForward:(NSDictionary *)userInfo openByModel:(BOOL)flag {
    [self.forwardDelegate startSellPushForward:userInfo openByModel:flag];
}

- (void)forwardToAWebPage:(NSDictionary *)dict {
    [Tao800ForwardSegue ForwardTo:dict sourceController:self.navigationController];
}

/**
* url格式
* zhe800://m.zhe800.com?_windowKey=1s&param2=fff&param3=ff
* @param windowKey
* @params
*   key: value
*/
- (void)forwardToURL:(Tao800ForwardQueueItem *)forwardQueueItem {
    [self.forwardDelegate forwardToURL:forwardQueueItem];
}

- (void)openLoginPage:(NSDictionary *)params completion:(void (^)(NSDictionary *dict))completion {
    [self.forwardDelegate openLoginPage:params completion:completion];
}

- (void)openPage:(NSDictionary *)params completion:(void (^)(NSDictionary *dict))completion {
    [self.forwardDelegate openPage:params completion:completion];
}

- (void)openSharePage:(NSDictionary *)params closeCallBack:(void (^)(NSDictionary *dict))completion {
    [self.forwardDelegate openSharePage:params closeCallBack:completion];
}

- (void)openCategoryPage:(NSDictionary *)params {
    [self.forwardDelegate openCategoryPage:params];
}

- (void)openTodayCategoryPage:(NSDictionary *)params{
    [self.forwardDelegate openTodayCategoryPage:params];
}

- (void)openAddressPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openAddressPage:params closeCallback:closeCallback];
}

- (void)openAddressDetailPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openAddressDetailPage:params closeCallback:closeCallback];
}

- (void)openHomePage:(NSDictionary *)params {
    [self.forwardDelegate openHomePage:params];
}

-(void)openIMTalkPage:(NSDictionary *)params {
    [self.forwardDelegate openIMTalkPage:params];
}

- (void)openSpecialShop:(NSDictionary *)params completion:(void (^)(NSDictionary *dict))completion{
    [self.forwardDelegate openSpecialShop:params completion:completion];
}


/**
* 每日十件
*/
- (void)openDailyTenPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openDailyTenPage:params closeCallback:closeCallback];
}

/**
* 签到页面
*/
- (void)openCheckInPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openCheckInPage:params closeCallback:closeCallback];
}

/**
* 精选预告
*/
- (void)openForenoticePage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback {
    [self.forwardDelegate openForenoticePage:params closeCallback:closeCallback];
}
@end
