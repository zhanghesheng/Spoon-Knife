//
//  Tao800Service.h
//  tao800
//
//  Created by enfeng yang on 12-4-19.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tao800BaseService.h"

typedef enum DealSellStatus {
    DealSellStatusSelling = 0, // 正在热卖
    DealSellStatusWillSell // 将要开卖
}DealSellStatus;

@protocol Tao800ServiceDelegate <TBBaseNetworkDelegate>
@optional

- (void)getDealsFinish:(NSDictionary *)params;
- (void)getTodayDealsFinish:(NSDictionary *)params;
- (void)getTomorrowDealsFinish:(NSDictionary *)params;
- (void)getDealDetailFinish:(NSDictionary *)params;
- (void)getAdvertisementFinish:(NSDictionary *)params;

- (void)getCategoryFinish:(NSDictionary*)params;
- (void)getTomorrowAdvertFinish:(NSDictionary*)params;
- (void)getCheckConfigFinish:(NSDictionary *)param;
- (void)getTodayListBannerFinish:(NSDictionary *)param;
- (void)getShowCheapClassifyBannerFinish:(NSDictionary *)param;
- (void)getStartInfoFinish:(NSDictionary *)param;
- (void)getStartSellRemindFinish:(NSDictionary *)params;
- (void)checkinsFinish:(NSDictionary *)params;
- (void)checkinsHistoryFinish:(NSDictionary *)params;
- (void)getTopicDetailForPushFinish:(NSDictionary *)param;
- (void)getPreviewDealsFinish:(NSDictionary *)params;
- (void)searchDealsFinish:(NSDictionary *)params;
- (void)addOpenGroupRemindFinish:(NSDictionary *)params;
- (void)deleteOpenGroupRemindFinish:(NSDictionary *)params;
- (void)dealSubscibeFinish:(NSDictionary *)params;
- (void)getRecommendCidFinish:(NSDictionary *)params;
- (void)weixinFollowCheckFinish:(NSDictionary *)params;


- (void)getSellingDealsFinish:(NSDictionary *)params;
- (void)getWillSellDealsFinish:(NSDictionary *)params;
- (void)qqZoneFollowCheckFinish:(NSDictionary *)params;
- (void)getTopicActivityDealsFinish:(NSDictionary *)params;
@end

@interface Tao800Service : Tao800BaseService

/**
* @param params
*     key: pageSize(NSString*)
*     key: pageNum(NSString*)
*/
- (void)getTodayDeals:(NSDictionary *)params;

- (void)getTomorrowDeals:(NSDictionary *)params;

/**
 * 获取精品预告商品
 * @params
 */
- (void)getPreviewDeals:(NSDictionary *)params;

/**
 * 获取正在热卖商品
 * @params
 */
- (void)getSellingDeals:(NSDictionary *)params;

/**
 * 获取即将开卖商品
 * @params
 */
- (void)getWillSellDeals:(NSDictionary *)params;

/**
 * 获取商品详情
 * @params
 *
 */
- (void)getDealDetail:(NSDictionary *)params;

/**
* 查询广告
* @params
*
*/
- (void)getAdvertisement:(NSDictionary *)params;


//获取分类请求接口
/**
 *@params
 **/
- (void)getCategory:(NSDictionary *)params;

/**
 *
 * 明日预告之前的广告
 */
- (void)getTomorrowAdvert:(NSDictionary*)params;

//升级检查接口
/**
 *@params
 **/
- (void)getCheckConfig:(NSDictionary *)params;

//获取今日列表页面banner接口
/**
 *@params
 **/
- (void)getTodayListBanner:(NSDictionary *)params;

//获取值得逛页面banner接口
/**
 *@params
 **/
- (void)getShowCheapClassifyBanner:(NSDictionary *)params;

//获取启动页数据接口
/**
 *@params
 **/
- (void)getStartInfo:(NSDictionary *)params;

//获取开卖提醒商品列表接口
/**
 *@params
 **/
- (void)getStartSellRemind:(NSDictionary *)params;

//签到接口
/**
 *@params
 **/
- (void)checkins:(NSDictionary *)params;

//获取用户签到日期信息列表
/**
 *@params
 **/
- (void)getCheckinsHistory:(NSDictionary *)params;

//获取活动专题列表接口
/**
 *@params
 **/
- (void)getTopicActivityDeals:(NSDictionary *)params;

//用push得到的专题活动id 请求该专题的信息
- (void)getTopicDetailForPush:(NSDictionary *)params;

//设置重新开团商品的id以及手机设备id接口。
/**
 *@params
 **/
- (void)addOpenGroupRemind:(NSDictionary *)params;

//取消设置重新开团商品的id以及手机设备id接口。
/**
 *@params
 **/
- (void)deleteOpenGroupRemind:(NSDictionary *)params;

//订阅统计接口。
/**
 *@params
 **/
- (void)dealSubscibe:(NSDictionary *)params;

//获取设备被推荐的淘宝分类id值。
/**
 *@params
 **/
- (void)getRecommendCid:(NSDictionary *)params;

//微信关注接口
/**
 *@params
 **/
- (void)weixinFollowCheck:(NSDictionary *)params;


/*
 *请求push内容
 */
-(void)getRemotePushes:(NSDictionary *)params
            completion:(void (^)(NSArray *))completion
                failue:(void (^)(TBErrorDescription *))failure;

@end
