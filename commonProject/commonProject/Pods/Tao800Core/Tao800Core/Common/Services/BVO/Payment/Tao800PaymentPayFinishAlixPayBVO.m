//
//  Tao800PaymentPayFinishAlixPayBVO.m
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentPayFinishAlixPayBVO.h"
#import "TBCore/NSDictionaryAdditions.h"

@implementation Tao800PaymentPayFinishAlixPayBVO


- (NSString *)encodeString:(NSString *)str {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (__bridge CFStringRef) str,
            NULL,
            CFSTR("!*'\"();:@&=+$,/?%#[]% "),
            kCFStringEncodingUTF8));
}

- (NSString *)alixStr {

    NSString *psign = [_sign stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    psign = [self encodeString:psign];
    NSMutableString *oStr = [NSMutableString stringWithFormat:@"partner=\"%@\"", _partner];
    [oStr appendString:@"&"];
    [oStr appendFormat:@"seller=\"%@\"", _seller];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"out_trade_no=\"%@\"", _outTradeNo];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"subject=\"%@\"", _subject];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"body=\"%@\"", _body];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"total_fee=\"%@\"", _totalFee];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"notify_url=\"%@\"", _notifyUrl];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"sign=\"%@\"", psign];
    [oStr appendString:@"&"];

    [oStr appendFormat:@"sign_type=\"%@\"", _signType];

    return oStr;
}


+ (Tao800PaymentPayFinishAlixPayBVO *)convertPaymentPayFinishAlixPayBVOWith:(NSDictionary *)dict {
    Tao800PaymentPayFinishAlixPayBVO *bvo = [[Tao800PaymentPayFinishAlixPayBVO alloc] init];
    NSDictionary *paymentInfo = [dict objectForKey:@"payment_info" convertNSNullToNil:YES];

    if (paymentInfo) {
        bvo.sign = [paymentInfo objectForKey:@"sign" convertNSNullToNil:YES];
        bvo.body = [paymentInfo objectForKey:@"body" convertNSNullToNil:YES];
        bvo.totalFee = [paymentInfo objectForKey:@"total_fee" convertNSNullToNil:YES];
        bvo.subject = [paymentInfo objectForKey:@"subject" convertNSNullToNil:YES];
        bvo.signType = [paymentInfo objectForKey:@"sign_type" convertNSNullToNil:YES];
        bvo.notifyUrl = [paymentInfo objectForKey:@"notify_url" convertNSNullToNil:YES];
        bvo.partner = [paymentInfo objectForKey:@"partner" convertNSNullToNil:YES];
        bvo.outTradeNo = [paymentInfo objectForKey:@"out_trade_no" convertNSNullToNil:YES];
        bvo.seller = [paymentInfo objectForKey:@"seller" convertNSNullToNil:YES];
        bvo.orderStr = [paymentInfo objectForKey:@"orderStr" convertNSNullToNil:YES];
    }

    return bvo;
}
@end
