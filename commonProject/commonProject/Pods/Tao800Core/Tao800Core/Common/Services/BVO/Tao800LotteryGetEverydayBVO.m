//
//  Tao800LotteryGetEverydayBVO.m
//  Tao800Core
//
//  Created by Rose on 15/3/17.
//  Copyright (c) 2015年 tao800. All rights reserved.
//
#import <TBCore/NSObjectAdditions.h>
#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800LotteryGetEverydayBVO.h"

@implementation Tao800LotteryGetEverydayBVO

+ (Tao800LotteryGetEverydayBVO *)wrapperLotteryGetEverydayBVO:(NSDictionary *)dict{
    Tao800LotteryGetEverydayBVO *getEverydayBVO = [[Tao800LotteryGetEverydayBVO alloc] init];
    getEverydayBVO.dealId = [dict objectForKey:@"id" convertNSNullToNil:YES];
    getEverydayBVO.code = [dict objectForKey:@"code" convertNSNullToNil:YES];
    getEverydayBVO.daygetCount = [dict objectForKey:@"dayget_count" convertNSNullToNil:YES];
    //getEverydayBVO.overRate = [dict objectForKey:@"over_rate" convertNSNullToNil:YES];
    
    id rate = [dict objectForKey:@"over_rate" convertNSNullToNil:YES];
    id result;
    if ([rate isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        if ([f numberFromString:rate])
        {
            result=[NSNumber numberWithFloat:[rate floatValue]];
        }
        else
        {
            result=rate;
        }
        getEverydayBVO.overRate = result;
    }else{
        getEverydayBVO.overRate = rate;
    }

    getEverydayBVO.lotteryCount = [dict objectForKey:@"lottery_count" convertNSNullToNil:YES];
    
    return getEverydayBVO;
}
@end
