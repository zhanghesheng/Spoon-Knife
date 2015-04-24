//
//  Tao800PaymentPayFinishBVO.m
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBService/TBPaymentConstant.h>
#import "Tao800PaymentPayFinishBVO.h"
#import "Tao800PaymentPayFinishAlixPayBVO.h"
#import "TBCore/TBCore.h"
#import "Tao800PaymentPayFinishWeixinBVO.h"
#import "Tao800PaymentPayFinishUnipayBVO.h"

@implementation Tao800PaymentPayFinishBVO

+ (Tao800PaymentPayFinishBVO *)convertPaymentPayFinishBVOWith:(NSDictionary *)dict payMethod:(TBPayMethodFlag) payMethodFlag {

    Tao800PaymentPayFinishBVO *bvo = [[Tao800PaymentPayFinishBVO alloc] init];
    bvo.callBackUrl = [dict objectForKey:@"call_back_url" convertNSNullToNil:YES];
    bvo.sellerAccountName = [dict objectForKey:@"seller_account_name" convertNSNullToNil:YES];
    bvo.md5Key = [dict objectForKey:@"md5_key" convertNSNullToNil:YES];
    bvo.pubKey = [dict objectForKey:@"pub_key" convertNSNullToNil:YES];

    NSString *successful = [dict objectForKey:@"successful" convertNSNullToNil:YES];

    if (!successful) {
        bvo.successful = NO;
    } else {
        bvo.successful = successful.boolValue;
    }

    if (bvo.successful) {
        if (payMethodFlag == TBPayMethodFlagAlixPay) {
            bvo.alixPayBVO = [Tao800PaymentPayFinishAlixPayBVO convertPaymentPayFinishAlixPayBVOWith:dict];
        } else if (payMethodFlag == TBPayMethodFlagWeixinPay) {
            bvo.weixinBVO = [Tao800PaymentPayFinishWeixinBVO convertPaymentPayFinishWeixinBVOWith:dict];
        } else if (payMethodFlag == TBPayMethodFlagUnionPay) {
            bvo.unipayBVO = [Tao800PaymentPayFinishUnipayBVO convertUniPayFinishWeixinBVOWith:dict];
        }

    } else {
        bvo.errorCode = [dict objectForKey:@"error_code" convertNSNullToNil:YES];
        bvo.errorMessage = [dict objectForKey:@"error_msg" convertNSNullToNil:YES];
    }
    if (!bvo.errorMessage) {
        bvo.errorMessage = @"服务器错误";
    }
    return bvo;
}


@end
