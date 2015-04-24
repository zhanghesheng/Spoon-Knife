//
//  TN800StaticConstant.h
//  Tuan800
//
//  Created by enfeng yang on 11-10-26.
//  Copyright (c) 2011年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
* 定义详情页来源
*/
typedef enum _Tao800DealDetailFrom {
    Tao800DealDetailFromHome = 0,    //来自首页
    Tao800DealDetailFromSaunter = 1, //来自值得逛
    Tao800DealDetailFromBanner = 2,  //首页banner
    Tao800DealDetailFromStartInfo = 3, //大图
    Tao800DealDetailFromPush = 4,     //push
    Tao800DealDetailFromMobile = 5,   //来自手机周边
    Tao800DealDetailFromBrand = 6,    //来自品牌团（目前只是分类方式）
    Tao800DealDetailFromToday = 7,      //今日更新
    Tao800DealDetailFromPromotion = 8,  //大促banner
    Tao800DealDetailFromPersonal = 9,   //个人中心
    Tao800DealDetailFromForenotice = 10, //精选预告
    Tao800DealDetailFromSearch = 11,      //搜索
    Tao800DealDetailFromTopic = 12,  //专题页面
    Tao800DealDetailFromScore = 13,  //积分商城
    Tao800DealDetailFromTen = 14,   //每日十件
    Tao800DealDetailFromJuBanner = 15,  //聚banner
    Tao800DealDetailFromSaunterChoiceBanner = 16, //逛精选banner
    Tao800DealDetailFromSaunterCategoryBanner = 17, //逛分类banner
    
    Tao800DealDetailFromFavourite = 18, //收藏
    Tao800DealDetailFromCampus = 19, //校园入口
    Tao800DealDetailFromBarcode = 20, //二维码扫描
    Tao800DealDetailFromWishList = 21,//心愿单列表页
    
    Tao800DealDetailFromMuYingDealsList = 24,//母婴列表
    Tao800DealDetailFromPromotionHome = 25,//新大促页运营位（不含8个固定位置）
    Tao800DealDetailFromNewCategory = 26,//	新分类入口
    
    Tao800DealDetailFromMuYingSingleDealsList = 90, //母婴单品
    Tao800DealDetailFromMuYingBrandDealList = 91, //母婴品牌列表
    
    Tao800DealDetailFromTag = 100,//分类 banner打点
    
} Tao800DealDetailFrom;

typedef enum _TBBShareToTag {
    TBBShareToNothing = -2,
    TBBShareToSMS,
    TBBShareToWeixin,
    TBBShareToWeixinFriends
//    TBBShareToMail
} TBBShareToTag;

typedef enum _Tao800UGCExposureCtype{
    Tao800UGCGatherChannel = 0,         //聚频道曝光 c_type
    Tao800UGCSaunterChannel = 1,        //值得逛频道曝光 c_type
} Tao800UGCExposureCtype;


typedef enum _TBBThirdLoginToTag {
    TBBLoginToNothing = -2,
    TBBLoginToTaobao = 2332,
    TBBLoginToQQ,
    TBBLoginToSina,
} TBBThirdLoginToTag;

#define kTabBarHeight 49

extern NSString *const AppName;
extern NSString *const DateFormatString1;

extern NSString *const DBFileName;
extern NSString *const CategoryFileName;
extern NSString *const StartSellFileName;
extern NSString *const AddressCityFileName;
extern NSString *const CategoryCacheFileName;
extern NSString *const CategoryLocalFileName;

extern NSString *const DealOrderDefault;
extern NSString *const DealOrderPrice;  // 按价格排序
extern NSString *const DealOrderSalesVolume;
extern NSString *const DealOrderPriced;
extern NSString *const DealOrderPriceNew;//价格最新

extern NSString *const AppStoreCommentUrl;
extern NSString *const Tao800DownloadingAppsRemindTipNotShowAgain;
extern NSString *const UserDefaultKeyHomeToday;  //今日更新，点, 提醒的显示

extern NSString *const Tao800PaycChannelAlixPay;
extern NSString *const Tao800PaycChannelWexinPay;

extern NSString *const Tao800PassportSessionURLPath;

extern NSString *const Tao800DealListVCLCountEachDayOut; //30天内进入主页列表和分类列表详情页的次数
extern NSString *const UserDefaultKeyUGCSingletonNoteVisitZhe800Date;   //90天内是否访问客户端统计
extern NSString *const UserDefaultKeyUGCSingletonNoteVisitSaunterDate;   //90天内是否访问值得逛统计

extern const CGFloat Tao800DefaultTabbarHeight;
extern NSString *const Tao800InviteFriendsWeixinShareURL;

//渠道号，默认为appstore的(批量打包时会修改这行记录) 旧的渠道号：0d42d8
#define PARTNER_VALUE @"b2e1cc"

enum Tao800TaoBaoLogin_Flag_APP {
    Tao800TaoBaoLogin_Flag_HAVE_PARTNER_API_NO_PHONE = 9100, // 淘宝没有关闭并且没有绑定手机号
    Tao800TaoBaoLogin_Flag_NO_PARTNER_API_NO_PHONE = 9200,   // 淘宝关闭了并且没有绑定手机号
    Tao800TaoBaoLogin_Flag_NO_PARTNER_API_HAVE_PHONE = 9300, // 淘宝关闭了并且有绑定手机号
    Tao800TaoBaoLogin_Flag_HAVE_MERGE_PHONE = 9400,          // 账户已经不能用了，但是绑定了其它账户的手机号
};
//弹出提示tag
typedef enum TipTagStatus {
    TipSetAddress = 2260,   //完善收货地址
    TipSureExchange,        //确认兑换
    TipCheckOrder,          //查看订单
    TipScoreStrategy,       //积分攻略
    TipShowOrder,           //积分抽奖
    TipBidPhone,            //绑定手机
    TipRewardAgain,         //再次抽奖
    TipPointRule,           //积分规则
    TipAddAddress,          //增加收货地址
    TipInputAlert,               //输入信息错误提示
    TipDeleteAddress,       //删除收货地址提示
    TipDefalutAddress,      //设置默认收货地址提示
    TipUpdateAddress,       //更新收货地址提示
}tipTag;


