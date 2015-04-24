//
//  Tao800PersonalCenterService.h
//  tao800
//
//  Created by tuan800 on 14-5-27.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800PersonalCenterService : Tao800BaseService


/*
 *获取 获取积分账号过期记录
 *参数
   key: page
   key: per_page
   key: type
   key: detail
 */

-(void)getUserScoreAccountsInformation:(NSDictionary *)extraParams
                            completion:(void (^)(NSDictionary *))completion
                               failure:(void (^)(TBErrorDescription *))failure;


/*
 *获取用户等级信息
 *
 */
-(void)getUserGradeInformation:(NSDictionary *)extraParams
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;


/*
 *获取用户优惠券
 参数说明:
 overFlag,----过期状态 0-未过期 1-已过期
 status----代金券状态　0-未使用,1-已使用,2-已发放,3-已禁用
 */
-(void)getUserCouponsInformation:(NSDictionary *)extraParams
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;



/*
 *获取用户积分历史记录
 *餐数
    key: page
    key: per_page
    key: type
    key: order
    key: begin_time
    key: end_time
    key: rule
 */

-(void)getUserScoreHistoryInformation:(NSDictionary *)extraParams
                           completion:(void (^)(NSDictionary *))completion
                              failure:(void (^)(TBErrorDescription *))failure;

@end
