//
//  Tao800PointService.h
//  tao800
//
//  Created by enfeng on 14-4-30.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800PointService : Tao800BaseService

/**
* 0元兑换

*/
- (void)getZeroExchangeDeals:(NSDictionary *)paramsExt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure;

/**
 *0元兑换详情
 *
 **/
- (void)getZeroExchangeDealDetail:(NSDictionary *)paramt
                       completion:(void (^)(NSDictionary *))completion
                          failure:(void (^)(TBErrorDescription *))failure;

/**
 *开始兑换
 *
 **/
- (void)startExchange:(NSDictionary *)paramt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;

/**
* 积分抽奖

*/
- (void)getRewardDeals:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**积分抽奖详情
 *
 **/
- (void)getRewardDealDetail:(NSDictionary *)paramt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure;

/**
 *开始抽奖
 *
 **/
- (void)startReward:(NSDictionary *)paramt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
* 积分竞拍
*
*/
- (void)getAuctionDeals:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

/**
 * 积分竞拍详情
 *
 */
- (void)getAuctionDealDetail:(NSDictionary *)paramt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure;


/**
 *积分竞拍竞拍人列表
 *
 **/
-(void)getBidersList:(NSDictionary *)paramt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;


/**
 *竞拍开始出价
 *
 **/
- (void)startAuctionPrice:(NSDictionary *)paramt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;

/**
 *积分现金购详情
 *
 **/
- (void)getScoreCashDealDetail:(NSDictionary *)paramt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;

/**
 *提醒信息
 *
 **/
- (void)getNotice:(NSDictionary *)paramt
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure;


/**
 *积分返回订单列表
 *
 **/
- (void)getScoreFeedbackOrderList:(NSDictionary *)paramt
                       completion:(void (^)(NSDictionary *))completion
                          failure:(void (^)(TBErrorDescription *))failure;

///////////////////////////////////////////////////////////////////////////////

//请求我的抽奖奖品  列表接口
/**
 *@params
 
 **/
- (void)getMyPresentList:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;


//请求我的积分兑换商品  列表接口
/**
 *@params
 
 **/
- (void)getExchangeDealList:(NSDictionary *)params
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure;


//请求我的积分拍卖商品  列表接口
/**
 *@params
 
 **/
- (void)getMyPresentAuctinList:(NSDictionary *)params
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;

@end
