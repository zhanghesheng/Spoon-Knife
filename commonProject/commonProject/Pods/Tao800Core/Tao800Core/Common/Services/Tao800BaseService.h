//
//  Created by enfeng on 12-4-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBService/TBBaseNetworkApi.h"
#import "TBCore/NSObjectAdditions.h"
#import "TBService/TBPaymentApi.h"

typedef NS_ENUM(NSInteger, ServiceTag) {
    ServiceGetTodayDeals = 100,
    ServiceGetPreviewDeals,
    ServiceGetSellingDeals,
    ServiceGetWillSellDeals,
    ServiceGetTopicActivityContent,//获得某专题的信息--imageUrl、ContentString、ids
    ServiceGetTopicActivityDeals,//根据ids获得该专题的deals
    ServiceGetTomorrowDeals,
    ServiceGetDealDetail,
    ServiceGetAdvertisement,
    ServiceGetCategory,
    ServiceGetTomorrowAdvert,
    ServiceGetCheckConfig,
    ServiceGetTodayListBanner,
    ServiceGetShowCheapBanner,
    ServiceGetStartInfo,
    ServiceGetStartSellRemind,
    ServiceCheckins,
    ServiceCheckinsHistory,
    ServiceShouldPurchaseListTag,
    ServiceShouldPurchaseDetailDataTag,
    ServiceGetMerchantViewTag,
    ServiceGetPresentListViewTag,
    ServiceGetExchangeDealTag,
    ServiceGetPresentAuctionTag,    //我的奖品，竞拍
    //    ServiceGetPresentDetailDataTag,
    ServiceGetAddressCityListTag,
    ServiceGetCheapGoodsListDataTag,
    ServiceGetCheapGoodsClassifyTag,
    ServiceGetAddressTag,
    ServiceGetAddressListTag,
    ServiceNewAddressTag,
    ServiceUpdateAddressTag,
    ServiceGetHotActivityTag,
    ServiceGetMyGradeTag,
    ServiceGetRuleTag,
    ServicePublishPostsTag,
    
    ServiceGetRewardDealListTag,        //获取抽奖商品列表
    ServiceGetRewardDealDetailTag,      //获取抽奖商品详情
    ServiceStartRewardTag,              //开始抽奖
    ServiceGetExchangeDealListTag,      //获取兑换商品列表
    ServiceGetExchangeDealDetailTag,    //获取兑换商品详情
    ServiceGetScoreCashDealDetailTag,    //获取积分现金购商品详情
    ServiceGetAuctionDealListTag,       //获取竞拍商品列表
    ServiceGetAuctionDealDetailTag,     //获取竞拍商品详情
    ServiceStartAuctionPriceTag,         //竞拍出价
    ServiceGetAuctionBidersListTag,     //获取竞拍人信息列表
    ServiceStartExchangeTag,            //开始兑换
    ServiceGetNoticeTag,                //获取抽奖／兑换 规则与注意事项
    ServiceGetScoreFeedbackOrderListTag,//获取返积分订单列表
    
    
    ServiceTagGetUrlFilterJsonTag,
    ServiceSearchDealsTag,              // 搜索deals
    ServiceAddOpenGroupRemindTag,       // 增加开团提醒
    ServiceDeleteOpenGroupRemindTag,    // 删除开团提醒
    ServiceDealSubscibeTag,             // 订阅统计
    
    // v2.7.0新增
    ServiceGetRecommendCidTag,          // 获取设备被推荐的淘宝分类id值。
    ServiceWeixinFollowCheckTag,        // 微信关注接口。
    ServiceQQZoneFollowCheckTag,        // QQ空间关注状态接口
    ServiceUploadWishListTag,           //上传心愿单
    
    ServiceLotteryEntranceTag,          //首页0元抽奖入口
    ServiceLotteryDetailTag,            //首页0元抽奖详情
    ServiceLotteryResultTag,            //首页0元抽奖详情
};


extern NSString *const UrlBase;
extern NSString *const UrlBaseNeedLogin;
extern NSString *const UrlBaseScore;
extern NSString *const UrlScoreReward;
extern NSString *const UrlSSO;
extern NSString *const UrlBaseTodo;

@interface Tao800BaseService : TBBaseNetworkApi

- (NSObject *)convertNSNullClass:(NSObject *)obj;


@end