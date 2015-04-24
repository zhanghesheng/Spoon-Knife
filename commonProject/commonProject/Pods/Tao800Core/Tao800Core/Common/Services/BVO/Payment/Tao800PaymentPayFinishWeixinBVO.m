//
//  Tao800PaymentPayFinishWeixinBVO.m
//  tao800
//
//  Created by enfeng on 14-5-7.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
#import "TBCore/TBCore.h"
#import "Tao800PaymentPayFinishWeixinBVO.h"

@implementation Tao800PaymentPayFinishWeixinBVO

+ (Tao800PaymentPayFinishWeixinBVO *)convertPaymentPayFinishWeixinBVOWith:(NSDictionary *)dict {
    Tao800PaymentPayFinishWeixinBVO *bvo = [[Tao800PaymentPayFinishWeixinBVO alloc] init];
    NSDictionary *paymentInfo = [dict objectForKey:@"payment_info" convertNSNullToNil:YES];

    if (paymentInfo) {

        bvo.appId = [paymentInfo objectForKey:@"appid" convertNSNullToNil:YES];
        bvo.appKey = [paymentInfo objectForKey:@"appkey" convertNSNullToNil:YES];
        bvo.nonceStr = [paymentInfo objectForKey:@"noncestr" convertNSNullToNil:YES];
        bvo.package = [paymentInfo objectForKey:@"package" convertNSNullToNil:YES];
        bvo.partnerId = [paymentInfo objectForKey:@"partnerid" convertNSNullToNil:YES];
        bvo.prepayId = [paymentInfo objectForKey:@"prepayid" convertNSNullToNil:YES];
        bvo.sign = [paymentInfo objectForKey:@"sign" convertNSNullToNil:YES];
        bvo.timestamp = [paymentInfo objectForKey:@"timestamp" convertNSNullToNil:YES];
    }

    return bvo;
}
@end
