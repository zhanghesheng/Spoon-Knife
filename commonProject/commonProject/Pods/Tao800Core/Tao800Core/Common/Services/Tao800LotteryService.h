//
//  Tao800LotteryService.h
//  tao800
//
//  Created by LeAustinHan on 14-10-11.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800LotteryService : Tao800BaseService


/**
 * 获取首页0元抽奖入口
 */
- (void)getLotteryEntrance:(NSDictionary *)paramsExt
                complation:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取首页0元抽奖详情
 */
- (void)getLotteryDetail:(NSDictionary *)paramsExt
              complation:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

//通过ID
- (void)getLotteryDetailByLotteryIdChengDu:(NSDictionary *)paramsExt
                                complation:(void (^)(NSDictionary *))completion
                                   failure:(void (^)(TBErrorDescription *))failure;

//本期活动
- (void)getLotteryDetailByCurrentLotteryChengDu:(NSDictionary *)paramsExt
                                     complation:(void (^)(NSDictionary *))completion
                                        failure:(void (^)(TBErrorDescription *))failure;
//下期预告
- (void)getLotteryDetailByNoticeChengDu:(NSDictionary *)paramsExt
                             complation:(void (^)(NSDictionary *))completion
                                failure:(void (^)(TBErrorDescription *))failure;


/**
 * 获取首页0元抽奖返回结果：验证码和开奖时间
 */
- (void)getLotteryResult:(NSDictionary *)paramsExt
              complation:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

- (void)getLotteryResultChengDu:(NSDictionary *)paramsExt
                     complation:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure;


/*
 每日领取
 *GET http://zapi.zhe800.com/cn/inner/lottery/:id/dayget
 */
- (void)getLotteryGetEverydayChengDu:(NSDictionary *)paramsExt
                          complation:(void (^)(NSDictionary *))completion
                             failure:(void (^)(TBErrorDescription *))failure;

/*
 首次分享
 */
- (void)getLotteryShareFirstChengDu:(NSDictionary *)paramsExt
                         complation:(void (^)(NSDictionary *))completion
                            failure:(void (^)(TBErrorDescription *))failure;

/*
 积分兑换
 GET http://zapi.zhe800.com/cn/inner/lottery/:id/exchange
 */
- (void)getLotteryExchangeChengDu:(NSDictionary *)paramsExt
                       complation:(void (^)(NSDictionary *))completion
                          failure:(void (^)(TBErrorDescription *))failure;


@end
