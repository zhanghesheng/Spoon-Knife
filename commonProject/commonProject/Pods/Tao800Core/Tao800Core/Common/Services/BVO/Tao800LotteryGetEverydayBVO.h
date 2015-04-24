//
//  Tao800LotteryGetEverydayBVO.h
//  Tao800Core
//
//  Created by Rose on 15/3/17.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800LotteryGetEverydayBVO : NSObject
@property(nonatomic,copy) NSString* dealId; //活动id
@property(nonatomic,strong) NSNumber* code; //-1:领取过;0:不成功;>0:领的个数
@property(nonatomic,strong) NSNumber* daygetCount;//每日领取总数
@property(nonatomic,strong) NSNumber* lotteryCount;//现有抽奖码数
@property(nonatomic,strong) NSNumber* overRate;//超过百分数

+ (Tao800LotteryGetEverydayBVO *)wrapperLotteryGetEverydayBVO:(NSDictionary *)dict;
@end
