//
//  Tao800RemotePushBVO.m
//  tao800
//
//  Created by tuan800 on 14-10-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800RemotePushBVO.h"

@implementation Tao800RemotePushBVO

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.pushId = [aDecoder decodeObjectForKey:@"pushId"];
        self.pushTime = [aDecoder decodeObjectForKey:@"pushTime"];
        self.pushDidFinishLuanch = [aDecoder decodeBoolForKey:@"pushDidFinishLuanch"];
        self.pushBadge = [aDecoder decodeIntForKey:@"pushBadge"];
        self.pushAlert = [aDecoder decodeObjectForKey:@"pushAlert"];
        self.pushDetailMessage = [aDecoder decodeObjectForKey:@"pushDetailMessage"];
        self.pushSound = [aDecoder decodeObjectForKey:@"pushSound"];
        self.pushDic = [aDecoder decodeObjectForKey:@"pushDic"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pushId forKey:@"pushId"];
    [aCoder encodeObject:self.pushTime forKey:@"pushTime"];
    [aCoder encodeBool:self.pushDidFinishLuanch forKey:@"pushDidFinishLuanch"];
    [aCoder encodeInt:self.pushBadge forKey:@"pushBadge"];
    [aCoder encodeObject:self.pushAlert forKey:@"pushAlert"];
    [aCoder encodeObject:self.pushDetailMessage forKey:@"pushDetailMessage"];
    [aCoder encodeObject:self.pushSound forKey:@"pushSound"];
    [aCoder encodeObject:self.pushDic forKey:@"pushDic"];
    
    
}

@end
