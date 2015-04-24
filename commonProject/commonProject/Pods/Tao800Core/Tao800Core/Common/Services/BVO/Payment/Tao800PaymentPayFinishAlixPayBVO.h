//
//  Tao800PaymentPayFinishAlixPayBVO.h
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PaymentPayFinishAlixPayBVO : NSObject

@property(nonatomic, copy) NSString *sign;  //数字签名
@property(nonatomic, copy) NSString *body;   //商品具体描述信息
@property(nonatomic, copy) NSString *totalFee;  //总费用，单位元,
@property(nonatomic, copy) NSString *subject;  //商品名称
@property(nonatomic, copy) NSString *signType;   //签名格式
@property(nonatomic, copy) NSString *notifyUrl; //支付宝notify的url
@property(nonatomic, copy) NSString *partner; //支付宝partner
@property(nonatomic, copy) NSString *outTradeNo;  //订单编号
@property(nonatomic, copy) NSString *seller; //支付宝ID

@property(nonatomic, copy) NSString *orderStr; //

+ (Tao800PaymentPayFinishAlixPayBVO *)convertPaymentPayFinishAlixPayBVOWith:(NSDictionary *)dict;

- (NSString *)alixStr;
@end
