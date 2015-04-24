//
//  Tao800BusinessDataService.h
//  tao800
//
//  Created by tuan800 on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

/*
 *该类是Ruby API中 关于 业务逻辑的API 的接口
 */

@interface Tao800BusinessDataService : Tao800BaseService


/*
 签到接口
 */
- (void)checkIn:(NSDictionary *)paramsExt
     completion:(void (^)(NSDictionary *))completion
        failure:(void (^)(TBErrorDescription *))failure;

/*
 *获取签到积分历史 也可以用来查询签没签过到
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetIntegralPayout
 */
- (void)getCheckInHistory:(NSDictionary *)paramsExt
               complation:(void (^)(NSDictionary *))complation
                  failure:(void (^)(TBErrorDescription *))failure;

/*
 *获取积分和现金之间的兑换比 用户未登录时显示
 */
- (void)getCommonScoreAndCashInformation:(NSDictionary *)paramsExt
                              complation:(void (^)(NSDictionary *))complation
                                 failure:(void (^)(TBErrorDescription *))failure;

/**
* 开卖提醒统计
* @params
*   key: deal_id
*/
- (void)addDealSubscibe:(NSDictionary *)paramsExt
             complation:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

//设置重新开团商品的id以及手机设备id接口。
/**
 *@params
 **/
- (void)addOpenGroupRemind:(NSDictionary *)params
                complation:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

//取消设置重新开团商品的id以及手机设备id接口。
/**
 *@params
 **/
- (void)deleteOpenGroupRemind:(NSDictionary *)params
                   complation:(void (^)(NSDictionary *))completion
                      failure:(void (^)(TBErrorDescription *))failure;


/*
 *查看微信关注状态
 */
-(void)checkWeiXinFollowStatus:(NSDictionary *)paramsExt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;

/*
 *查看QQ关注状态
 */
-(void)checkQQZoneFollowStatus:(NSDictionary *)paramsExt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;

/*
 *查看分享类型的积分历史
 */
- (void)getPushToExistsHistory:(NSDictionary *)paramsExt
                    complation:(void (^)(NSDictionary *))complation
                       failure:(void (^)(TBErrorDescription *))failure;


@end
