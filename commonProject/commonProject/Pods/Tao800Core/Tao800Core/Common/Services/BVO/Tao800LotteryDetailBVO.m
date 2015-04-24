//
//  Tao800LotteryDetailBVO.m
//  Tao800Core
//
//  Created by Rose on 15/3/11.
//  Copyright (c) 2015年 tao800. All rights reserved.
//
#import <TBCore/NSObjectAdditions.h>
#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800LotteryDetailBVO.h"


@implementation Tao800LotteryDetailBVO

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lotteryStatus = Tao800LotteryDetailStatusNone;
    }
    return self;
}

+ (Tao800LotteryDetailBVO *)wrapperLotteryDetailBVO:(NSDictionary *)dict{
    //NSDictionary *isReachedDict = [dict objectForKey:@"response"];
    Tao800LotteryDetailBVO *lotteryBvo = [[Tao800LotteryDetailBVO alloc] init];
    lotteryBvo.dealId = [dict objectForKey:@"id" convertNSNullToNil:YES];
    if (lotteryBvo.dealId && [lotteryBvo.dealId isKindOfClass:[NSNumber class]]) {
        NSNumber* num = (NSNumber*)lotteryBvo.dealId;
        lotteryBvo.dealId = [NSString stringWithFormat:@"%@",[num stringValue]];
    }
    lotteryBvo.title = [dict objectForKey:@"title" convertNSNullToNil:YES];
    lotteryBvo.image = [dict objectForKey:@"image" convertNSNullToNil:YES];
    lotteryBvo.listImage = [dict objectForKey:@"list_image" convertNSNullToNil:YES];
    lotteryBvo.originPrice = [dict objectForKey:@"origin_price" convertNSNullToNil:YES];
    //lotteryBvo.originPrice = [NSNumber numberWithFloat:lotteryBvo.originPrice.floatValue * 100];
    lotteryBvo.totalCount = [dict objectForKey:@"total_count" convertNSNullToNil:YES];
    lotteryBvo.descriptions = [dict objectForKey:@"description" convertNSNullToNil:YES];
    lotteryBvo.begunAt = [dict objectForKey:@"begun_at" convertNSNullToNil:YES];
    lotteryBvo.endedAt = [dict objectForKey:@"ended_at" convertNSNullToNil:YES];
    lotteryBvo.runTime = [dict objectForKey:@"run_time" convertNSNullToNil:YES];
    lotteryBvo.nowTime = [dict objectForKey:@"now_time" convertNSNullToNil:YES];
    lotteryBvo.joinCount = [dict objectForKey:@"join_count" convertNSNullToNil:YES];
    lotteryBvo.lotteryNotice = [dict objectForKey:@"lottery_notice" convertNSNullToNil:YES];
    lotteryBvo.cost = [[dict objectForKey:@"cost" convertNSNullToNil:YES] intValue];
    NSNumber* status = [dict objectForKey:@"code" convertNSNullToNil:YES];
    if (status) {
        lotteryBvo.lotteryStatus = (Tao800LotteryDetailStatus)[status intValue];
    }else{
        lotteryBvo.lotteryStatus = Tao800LotteryDetailStatusNone;
    }
    
    lotteryBvo.userInfo = [dict objectForKey:@"user_infos" convertNSNullToNil:YES];
    if (lotteryBvo.userInfo) {
        lotteryBvo.joinStatus = (Tao800LotteryJoinStatus)[[lotteryBvo.userInfo objectForKey:@"join_status" convertNSNullToNil:YES] intValue];
        lotteryBvo.lotteryCount = [[lotteryBvo.userInfo objectForKey:@"lottery_count" convertNSNullToNil:YES] intValue];
        
        //lotteryBvo.overRate = [lotteryBvo.userInfo objectForKey:@"over_rate" convertNSNullToNil:YES];
        //if ([lotteryBvo.overRate isKindOfClass:[NSNull class]]) {
        id rate = [lotteryBvo.userInfo objectForKey:@"over_rate" convertNSNullToNil:YES];
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
            lotteryBvo.overRate = result;
        }else{
            lotteryBvo.overRate = rate;
        }
        
        //}
        
        lotteryBvo.daygetStatus = [[lotteryBvo.userInfo objectForKey:@"dayget_status" convertNSNullToNil:YES] boolValue];
        lotteryBvo.daygetCount = [[lotteryBvo.userInfo objectForKey:@"dayget_count" convertNSNullToNil:YES] intValue];
        lotteryBvo.address = [lotteryBvo.userInfo objectForKey:@"address" convertNSNullToNil:YES];
        if (lotteryBvo.address) {
            lotteryBvo.addressInfo = [lotteryBvo.address objectForKey:@"info" convertNSNullToNil:YES];
            lotteryBvo.addressConsigneeName = [lotteryBvo.address objectForKey:@"consignee_name" convertNSNullToNil:YES];
            lotteryBvo.addressZipCode = [lotteryBvo.address objectForKey:@"zipcode" convertNSNullToNil:YES];
            lotteryBvo.addressTelephone = [lotteryBvo.address objectForKey:@"telephone" convertNSNullToNil:YES];
            lotteryBvo.addressPhoneNumber = [lotteryBvo.address objectForKey:@"phone_number" convertNSNullToNil:YES];
        }
        NSDictionary* motive_words = [lotteryBvo.userInfo objectForKey:@"motive_words" convertNSNullToNil:YES];
        if (motive_words) {
            lotteryBvo.dayget = [[motive_words objectForKey:@"dayget" convertNSNullToNil:YES] intValue];
            lotteryBvo.invite = [[motive_words objectForKey:@"invite" convertNSNullToNil:YES] intValue];
            lotteryBvo.exchange = [[motive_words objectForKey:@"exchange" convertNSNullToNil:YES] intValue];
        }
        lotteryBvo.inviteLink = [lotteryBvo.userInfo objectForKey:@"invite_link" convertNSNullToNil:YES];
        lotteryBvo.isShared = [[lotteryBvo.userInfo objectForKey:@"is_shared" convertNSNullToNil:YES] boolValue];
        lotteryBvo.shareGet = [[lotteryBvo.userInfo objectForKey:@"share_get" convertNSNullToNil:YES] intValue];
    }
    lotteryBvo.hasFreshow = [[dict objectForKey:@"has_freshow" convertNSNullToNil:YES] boolValue];
    lotteryBvo.hasShow = [[dict objectForKey:@"has_show" convertNSNullToNil:YES] boolValue];
    lotteryBvo.showUrl = [dict objectForKey:@"show_url" convertNSNullToNil:YES];
    lotteryBvo.sharedUrl = [dict objectForKey:@"shared_url" convertNSNullToNil:YES];
    [lotteryBvo resetNullProperty];
    return lotteryBvo;
}

@end
