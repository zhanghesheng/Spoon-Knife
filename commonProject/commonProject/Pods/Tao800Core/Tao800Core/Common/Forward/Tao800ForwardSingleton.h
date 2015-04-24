//
//  Tao800ForwardSingleton.h
//  tao800
//
//  Created by worker on 13-3-22.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800NavigationVCL.h"
#import "Tao800BannerVo.h"
#import "Tao800ForwardConstant.h"
#import "Tao800ForwardInterface.h"
//#import "Tao800ForwardCamera.h"

@class Tao800ForwardQueueItem;


@interface Tao800ForwardSingleton : NSObject

//每次打开一个新的导航时，将当前的UINavigationController传过来
@property(nonatomic, weak) Tao800NavigationVCL *navigationController;

@property (nonatomic) BOOL enableHomeStartQueue; //是否可以继续首页启动流程
@property (nonatomic) BOOL isBackToFront; //是否是后台切到前台
@property (nonatomic) BOOL isInstallStart; //是否为安装启动，当从后台切到前台时设为NO

@property (nonatomic, weak) UIViewController *appRootViewController;

@property (nonatomic, strong) id<Tao800ForwardDelegate> forwardDelegate;
//@property (nonatomic, strong) Tao800ForwardCamera *forwardCamera;

+ (Tao800ForwardSingleton *)sharedInstance;

- (uint) queueCount;

/**
* 每次收到页面退出的通知后都需要检查下是否还有符合条件的启动视图
*/
- (void)runStartQueueNext;

/**
* 该方法的调用入口
*
* 1: 全新启动  didFinishLaunchingWithOptions
* 2: 后台切前台 applicationWillEnterForeground
*
* @param isBackToFront YES:后台切前台  NO:全新启动
*/
- (void) initStartQueue:(NSDictionary *) params;

- (void)openBlurPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 打开启动引导页面
*/
- (void)openLaunchPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 用户身份选择页面
*/
- (void)openUserTypePage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 开机大图
*/
- (void)openStartBannerPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

- (void)openWebPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 首单返利
*/
- (void)openFirstOrderRewardPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 升级提醒页面
*/
- (void)openUpgradePage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 评价页面
*/
- (void)openAppCommentPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
 * 崩溃提示
 */
- (void)openCrashCommentPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 第三方淘宝登录判断页面
*/
- (void)openTaobaoMergeTipPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

- (void)presentModelViewCTL:(UIViewController *)ctl;

- (void)resetNavigationController;

- (void)openSharePage:(NSDictionary *)params;

#pragma mark 商品详情页面

/**
* 目前的商品详情包括淘宝商品详情和我们自己的商品详情两种，通过此处开关控制跳转
*/
- (void)openDealDetailPage:(NSDictionary *)params;

#pragma mark 进入我的礼品列表页面

- (void)openMyRewardPage:(NSDictionary *)params;

#pragma mark 进入我的抽奖列表页面

- (void)openMyLuckyDrawPage:(NSDictionary *)params;

#pragma mark 进入我的抽奖中奖了页面

- (void)openMyLuckyDrawDetailPage:(NSDictionary *)params;

#pragma mark 抽奖详情页进入查看我的抽奖码

- (void)openMyLuckyDrawDetailMyCode:(NSDictionary *)params;

#pragma mark 抽奖详情页进入晒单页面

- (void)openMyLuckyDrawDetailShowPage:(NSDictionary *)params;

#pragma mark 我的礼物竞拍详情页面

- (void)openMyPresentAuctionDetailPage:(NSDictionary *)params;

#pragma mark 我的礼品里礼品的详情页面

- (void)openMyPresentDetailPage:(NSDictionary *)params;

#pragma mark 激活页面

- (void)openAwakeAcountPage:(NSDictionary *)params;

#pragma mark 注册页面

- (void)openUserRegistPage:(NSDictionary *)params;

#pragma mark 修改密码页面

- (void)openFetchPasswordPage:(NSDictionary *)params;

#pragma mark 登录界面

- (void)openLoginPage:(NSDictionary *)params;

#pragma mark 用第三方账号登录

- (void)openLoginWithThirdAcountPage:(NSDictionary *)params;

#pragma mark 打开意见反馈页面

- (void)openUserFeedbackPage:(NSDictionary *)params;

#pragma mark 关于淘800页面

- (void)openAboutTao800Page:(NSDictionary *)params;

#pragma mark 积分回馈界面

#pragma mark 积分回馈商品详情界面

- (void)openScoreRewardDetailPage:(NSDictionary *)params;

#pragma mark 积分拍卖详情界面

- (void)openScoreAuctionDetailPage:(NSDictionary *)params;

#pragma mark 积分兑换界面

- (void)openExchangePage:(NSDictionary *)params;

#pragma mark 发布晒单页面

- (void)openPublishPostsPage:(NSDictionary *)params;

#pragma mark 设置页面

- (void)openSettingPage:(NSDictionary *)params;

#pragma mark 编辑地址页面

- (void)openEditAddressPage:(NSDictionary *)params;

#pragma mark 收货地址页面

- (void)openAddressPage:(NSDictionary *)params;

#pragma mark 我的积分

- (void)openMyScorePage:(NSDictionary *)params;

#pragma mark 积分规则

- (void)openPointRulePage:(NSDictionary *)params;

#pragma mark 分享管理页面

- (void)openShareManagerPage:(NSDictionary *)params;

#pragma mark 打开新的web页

- (void)openOperationWebPage:(NSDictionary *)params;

#pragma mark 返积分订单

- (void)openScoreFeedbackOrderListPage:(NSDictionary *)params;

#pragma mark 扫描条形码页面

- (void)openBarcodePage:(NSDictionary *)params;

#pragma mark 我的账户页面

- (void)openPersonalInfoPage:(NSDictionary *)params;

#pragma mark 我的收藏页面

- (void)openMyFavoritePage:(NSDictionary *)params;

#pragma mark 开卖提醒页面

- (void)openMyRemindPage:(NSDictionary *)params;

#pragma mark 用于运营或者和本地交互的wap页面
//- (void)openOperationWebPage:(NSDictionary *)params;

// v2.8.0新增
#pragma - mark 淘宝账户合并wap页面

- (void)openTaoBaoAccountMergeWebPage:(NSDictionary *)params;

#pragma mark 关注公共账号页面

- (void)openAttentionPublicAccountPage:(NSDictionary *)params;

// v3.0.0新增
#pragma mark 通过banner跳转页面

- (void)bannerForward:(Tao800BannerVo *)vo openByModel:(BOOL)flag bannerAtIndex:(int)index;

#pragma mark 通过开卖提醒push跳转页面

- (void)startSellPushForward:(NSDictionary *)userInfo openByModel:(BOOL)flag;

#pragma mark 大促页面

- (void)openPromotionPage:(NSDictionary *)params;

#pragma mark 校园专区

- (void)openCampusProductsPage:(NSDictionary *)params;

#pragma 每日十件

- (void)openTenProductsEverydayPage:(NSString *)pushId;

//跳转到一个网页
/*
* 参数url是一个string
*/
- (void)forwardToAWebPage:(NSDictionary *)dict;


/**
* url格式
* 1. zhe800://m.zhe800.com?_windowKey=1s&param2=fff&param3=ff
* 2. http://www.zhe800.com
* @param windowKey
* @params
*   key: value
*/
- (void)forwardToURL:(Tao800ForwardQueueItem *)url;

- (void)openLoginPage:(NSDictionary *)params completion:(void (^)(NSDictionary *dict))completion;

- (void)openPage:(NSDictionary *)params completion:(void (^)(NSDictionary *dict))completion;

- (void)openSharePage:(NSDictionary *)params closeCallBack:(void (^)(NSDictionary *dict))completion;

- (void)openCategoryPage:(NSDictionary *)params;

- (void)openTodayCategoryPage:(NSDictionary *)params;

- (void)openAddressPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

- (void)openAddressDetailPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

- (void)openHomePage:(NSDictionary *)params;

-(void)openIMTalkPage:(NSDictionary *)params;

- (void)openSpecialShop:(NSDictionary *)params completion:(void (^)(NSDictionary *dict))completion;


/**
* 每日十件
*/
- (void)openDailyTenPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 签到页面
*/
- (void)openCheckInPage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;

/**
* 精选预告
*/
- (void)openForenoticePage:(NSDictionary *)params closeCallback:(void (^)(NSDictionary *ret))closeCallback;
@end
