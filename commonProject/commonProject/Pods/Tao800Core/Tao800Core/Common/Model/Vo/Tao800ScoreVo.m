//
//  Tao800ScoreVo.m
//  tao800
//
//  Created by tuan800 on 14-3-7.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ScoreVo.h"

@implementation Tao800ScoreVo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.checkInFinishToday) forKey:@"checkInFinishToday"];
    [aCoder encodeObject:self.checkInDateString forKey:@"checkInDateString"];
    [aCoder encodeObject:@(self.totalScore) forKey:@"totalScore"];
    [aCoder encodeObject:@(self.todayScore) forKey:@"todayScore"];
    [aCoder encodeObject:@(self.tomorrowScore) forKey:@"tomorrowScore"];
    [aCoder encodeObject:@(self.continuousCheckInDays) forKey:@"continuousCheckInDays"];
    [aCoder encodeObject:self.queryCheckInInforDateString forKey:@"queryCheckInInforDateString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        id obj1 = [aDecoder decodeObjectForKey:@"checkInFinishToday"];
        self.checkInFinishToday = [obj1 boolValue];
        self.checkInDateString = [aDecoder decodeObjectForKey:@"checkInDateString"];
        self.totalScore = [[aDecoder decodeObjectForKey:@"totalScore"] intValue];
        self.todayScore = [[aDecoder decodeObjectForKey:@"todayScore"] intValue];
        self.tomorrowScore = [[aDecoder decodeObjectForKey:@"tomorrowScore"] intValue];
        self.continuousCheckInDays = [[aDecoder decodeObjectForKey:@"continuousCheckInDays"] intValue];
        self.queryCheckInInforDateString = [aDecoder decodeObjectForKey:@"queryCheckInInforDateString"];
        
    }

    return self;
}

@end
