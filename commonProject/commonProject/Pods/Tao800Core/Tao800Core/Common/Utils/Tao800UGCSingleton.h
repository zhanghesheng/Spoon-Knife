//
//  Tao800UGCSingleton.h
//  TBUIDemo
//
//  Created by enfeng on 12-10-12.
//  Copyright (c) 2012年 com.tuan800.ios.framework.uidemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBService/TBUserLogApi.h"

typedef enum Tao800PageTag {
    TodayBigStatePageTag = 1,    //今日推荐 大图
    DealPreviewPageTag, //精品预告 页面
    TomorrowStatePageTag, //明日预告 大图
    TodayListStatePageTag,    //今日推荐 列表模式
    TomorrowListStatePageTag, //明日预告 列表模式
    DealTomorrowPageTag, //明日预告页面
    TodayCategoryPageTag, //今日精选分类页面
    SettingsPageTag,  //设置页面
    TaoBaoWapPageTag,  //商品详情页面
    TaoBaoShopWapPageTag,
    TomrrowAdvertWapPageTag, // 优质商品点击（明日预报）
    WorthBuyingWebPageTag, // 值得买
    HotMerchantList, //热门商家
            FeedbackPageTag,  // 意见反馈页面
    AboutPageTag,  // 关于页面
    WebCommonPageTag, //Web通用跳转页面
    SharePageTag,  // 分享页面
    LaunchPageTag,  // 新手引导页面
    ShareSettingsPageTag, // 分享设置页面
    StartSellRemindPageTag, // 开卖提醒页面
    SettingLoginPageTag, // 登录页面
            SettingRegistPageTag, //注册页面
    AwakeAcountPageTag, //激活账户
    ChangePasswordPageTag, //修改密码
    TaobaoLoginPageTag, //淘宝登录页面
    PostsListPageTag, // 晒单列表页面
    SettingPageTag, //设置页面
    AddressPageTag, // 收货地址页面

    TN800NavigationHotCityPage,    //热门城市
    TN800NavigationAllCityPage,    //全部城市

    PostsDetailPageTag, // 晒单详情页面
    PublishPostsPageTag, // 发布晒单页面

    ScoreRewardPageTag,         //积分回馈
    ScoreRewardDetailPageTag,   //积分回馈商品详情
    ScoreRewardExchangePageTag, //积分兑换商品详情
    ScoreRewardAuctionPageTag, //积分拍卖商品详情

    MyFavoriteShopsPageTag, //我收藏的店铺
    MyFavoriteGoodsPageTag, //我收藏的商品
    
    MyLuckyDrawPageTag,  //我的抽奖
    MyLuckyDrawWinPageTag,  //中奖
    MyLuckyDrawNotWinPageTag,  //未中奖
    MyLuckyDrawShowMylotteryCode,   //查看我的所有抽奖码
    MyLuckyDrawShowMylotteryShowPage,   //查看我的所有抽奖码

    MyScorePageTag, //我的积分
    PointRulePageTag, //积分规则
    SignPageTag, //签到页面
    ShareManagerPageTag, //分享管理页面
    ScoreFeedbackOrderListPageTag, //返积分订单界面
    HotActivityListPageTag, //热门活动页面
    TopicActivityListPageTag, //专业活动页面
            NoFilterURlWebPage,
    SearchDealsPage, // 搜索商品列表页面
    BarcodePage, // 扫描条形码页面
    OpenGroupRemindPage, //开团提醒页面
    PersonalInfoPage, // 我的账户页面
    MyFavoritePage, // 我的收藏页面
    SearchPage,         // 搜索页面
    MyRemindPage,       // 开卖提醒页面
    OperationWebPage, //用于运营或者和本地交互的wap
    TaoBaoAccountMergeWebPage,
    MyPromotionPage,//大促页面

} Tao800PageTag;


typedef enum Tao800MainTabBarTag {
    Tao800MainTabBarHome =1,
    Tao800MainTabBarSaunter,
    Tao800MainTabBarBrand,
    Tao800MainTabBarPoint,
    Tao800MainTabBarPersonal,
    
}Tao800MainTabBarTag;
@interface Tao800UGCSingleton : NSObject <TBUserLogApiDelegate> {
    TBUserLogApi *_logService;
    BOOL _sendingNow;
    NSTimer *_nsTimer;
}

@property(nonatomic, retain) NSTimer *nsTimer;

+ (Tao800UGCSingleton *)sharedInstance;

// 记录打点
- (void)paramsLog:(NSString *)eventid params:(NSDictionary *)params;

// 提交打点
- (void)commitLog:(BOOL)startNow;

// 启动定时器打点
- (void)StartLogTimer;

// 上传曝光打点 c_type：频道，0 聚频道，1 逛频道 str 暂时未使用到 默认传nil
-(void)uploadingExposureLog:(NSString *)str ctype:(int)ctype;

// 90天内每天是否访问折800
-(void)updateVisitDate:(NSString *)key;

// 上传init 打点
-(void)uploadIntlog:(NSDictionary *)dict;

// 3分钟上传init 打点
- (void)delayThreeMinuteUpInitLog:(NSDictionary *)dict;

-(void)countEachDayOut;

/**
 * 获取曝光的字符串 zbb|dealid|deviceid|userid|cType|cId|version|index
 */
-(NSString *)getExposureStringByDealId:(int)dealId
                                 index:(int)index
                                 ctype:(int)ctype
                                   cId:(NSString *)cId;

-(NSDictionary *)getCpaOutParams;

// 注册 打点用户身份角色，拼接方式：新老用户_用户身份_是否学生 如：新用户女学生 0_4_0，老用户男，1_1_0
-(NSString *)getUserTypeUserRoleStudentString;


- (void)uploadRegisterLog;
@end
