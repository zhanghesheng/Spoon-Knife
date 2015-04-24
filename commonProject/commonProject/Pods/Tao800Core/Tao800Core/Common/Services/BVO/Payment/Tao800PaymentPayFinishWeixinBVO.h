//
//  Tao800PaymentPayFinishWeixinBVO.h
//  tao800
//
//  Created by enfeng on 14-5-7.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PaymentPayFinishWeixinBVO : NSObject

@property(nonatomic, copy) NSString *timestamp;
@property(nonatomic, copy) NSString *nonceStr;
@property(nonatomic, copy) NSString *partnerId;
@property(nonatomic, copy) NSString *prepayId;
@property(nonatomic, copy) NSString *package;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *appId;

+ (Tao800PaymentPayFinishWeixinBVO *)convertPaymentPayFinishWeixinBVOWith:(NSDictionary *)dict;
@end
