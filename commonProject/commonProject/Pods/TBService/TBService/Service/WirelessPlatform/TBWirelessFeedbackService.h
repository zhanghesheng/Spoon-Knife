//
//  TBWirelessFeedbackService.h
//  Tuan800API
//  --- 用户反馈相关的接口 ---
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//


#import <TBUI/TBErrorDescription.h>
#import "TBWirelessBaseService.h"

@interface TBWirelessFeedbackService : TBWirelessBaseService

/**
 * 添加用户反馈
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: platform (NSString*)  表示客户端请求的来源平台 例如：android,iphone
 *    key: product 产品类型 	例如：tuan800,hui800,tao800
 *    key: contact 表示联系方式, ---可以不传---
 *    key: version 版本号
 *    key: content 表示反馈内容
 *    key: extinfo 表示手机信息 ---可以不传---
 *    key: key 表示MD5.getMD5(参数字符串)  ---可以不传（未登录必须写）---
 */
- (void)addFeedBack:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
 * 团购纠错
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: platform (NSString*)  表示客户端请求的来源平台 例如：android,iphone
 *    key: product 产品类型 	例如：tuan800,hui800,tao800
 *    key: contact 表示联系方式, ---可以不传---
 *    key: username 用户名, ---可以不传---
 *    key: pversion 版本号
 *    key: content 表示反馈内容
 *    key: reason 表示反馈理由
 *    key: extinfo 表示手机信息 ---可以不传---
 */
- (void)addDealFeedBack:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;
@end
