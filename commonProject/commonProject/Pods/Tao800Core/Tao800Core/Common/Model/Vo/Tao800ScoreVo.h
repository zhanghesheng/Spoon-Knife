//
//  Tao800ScoreVo.h
//  tao800
//
//  Created by tuan800 on 14-3-7.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800ScoreVo : NSObject

@property (nonatomic, assign) BOOL checkInFinishToday; //今天签到是否完成

@property (nonatomic, copy) NSString * checkInDateString; //签到 的日期
@property (nonatomic, assign) int totalScore;
@property (nonatomic, assign) int todayScore;//今日可得积分
@property (nonatomic, assign) int tomorrowScore;//明日可得积分
@property (nonatomic, assign) int continuousCheckInDays;

@property (nonatomic,copy) NSString * queryCheckInInforDateString; // 查询签到信息的时间


@end
