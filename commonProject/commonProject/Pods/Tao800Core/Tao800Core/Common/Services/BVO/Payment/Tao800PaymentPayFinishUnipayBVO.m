//
//  Tao800PaymentPayFinishUnipayBVO.m
//  tao800
//
//  Created by enfeng on 14/11/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
#import "TBCore/TBCore.h"
#import "Tao800PaymentPayFinishUnipayBVO.h"

@implementation Tao800PaymentPayFinishUnipayBVO
+ (Tao800PaymentPayFinishUnipayBVO *)convertUniPayFinishWeixinBVOWith:(NSDictionary *)dict {
    Tao800PaymentPayFinishUnipayBVO *bvo = [[Tao800PaymentPayFinishUnipayBVO alloc] init];
    NSDictionary *paymentInfo = [dict objectForKey:@"payment_info" convertNSNullToNil:YES];
    
    if (paymentInfo) {
        
        bvo.respCode = [paymentInfo objectForKey:@"respCode" convertNSNullToNil:YES];
        bvo.tn = [paymentInfo objectForKey:@"tn" convertNSNullToNil:YES];
        bvo.signMethod = [paymentInfo objectForKey:@"signMethod" convertNSNullToNil:YES];
        bvo.transType = [paymentInfo objectForKey:@"transType" convertNSNullToNil:YES];
        bvo.charset = [paymentInfo objectForKey:@"charset" convertNSNullToNil:YES];
        bvo.signature = [paymentInfo objectForKey:@"signature" convertNSNullToNil:YES];
        bvo.version = [paymentInfo objectForKey:@"version" convertNSNullToNil:YES];
    }
    
    return bvo;
}
@end
