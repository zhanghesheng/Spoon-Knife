//
//  Tao800LotteryShareBVO.h
//  Tao800Core
//
//  Created by Rose on 15/3/17.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800LotteryShareBVO : NSObject
@property(nonatomic,copy) NSString* dealId; //活动id
@property(nonatomic,strong) NSNumber* code; //0:不成功;1:成功
@property(nonatomic,strong) NSNumber* lotteryCount;//现有抽奖码数
@property(nonatomic,strong) NSNumber* overRate;//超过百分数

+ (Tao800LotteryShareBVO *)wrapperLotteryShareBVO:(NSDictionary *)dict;
@end
