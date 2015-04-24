//
//  Tao800PaymentCreateOrderFinishBVO.m
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderFinishBVO.h"
#import "TBCore/TBCore.h"

@implementation Tao800PaymentCreateOrderFinishBVO

+ (Tao800PaymentCreateOrderFinishBVO *)convertCreateOrderFinishBVOWith:(NSDictionary *)dict {

    Tao800PaymentCreateOrderFinishBVO *bvo = [[Tao800PaymentCreateOrderFinishBVO alloc] init];
    NSString *ret = [dict objectForKey:@"ret" convertNSNullToNil:YES];
    if ([ret isEqualToString:@"0"]) {
        bvo.successful = YES;
    } else {
        bvo.successful = NO;
    }

    if (bvo.successful) {
        bvo.orderNo = [dict objectForKey:@"data" convertNSNullToNil:YES];
    } else {
        bvo.errorCode = [dict objectForKey:@"ret" convertNSNullToNil:YES];
        bvo.errorMessage = [dict objectForKey:@"msg" convertNSNullToNil:YES];

        if (!bvo.errorMessage) {
             bvo.errorMessage = @"服务器错误";
        }
    }

    return bvo;
}


@end
