//
//  Tao800DailyTenVo.m
//  tao800
//
//  Created by Rose on 14-7-18.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DailyTenVo.h"

@implementation Tao800DailyTenVo


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.beginTime forKey:@"beginTime"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];
    [aCoder encodeObject:self.wapUrl forKey:@"wapUrl"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.relatedRecommend forKey:@"relatedRecommend"];
    [aCoder encodeObject:self.recommendReason forKey:@"recommendReason"];
    
    [aCoder encodeInt:self.dealId forKey:@"dealId"];
    [aCoder encodeInt:self.oos forKey:@"oos"];
    [aCoder encodeInt:self.type forKey:@"type"];
    [aCoder encodeInt:self.price forKey:@"price"];
    
    [aCoder encodeBool:self.isBaoyou forKey:@"isBaoyou"];
    
    
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self.isBaoyou = [aDecoder decodeBoolForKey:@"isBaoyou"];
    
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.beginTime = [aDecoder decodeObjectForKey:@"beginTime"];
    self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
    self.wapUrl = [aDecoder decodeObjectForKey:@"wapUrl"];
    self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
    self.relatedRecommend = [aDecoder decodeObjectForKey:@"relatedRecommend"];
    self.recommendReason = [aDecoder decodeObjectForKey:@"recommendReason"];
    
    self.dealId = [aDecoder decodeIntForKey:@"dealId"];
    self.price = [aDecoder decodeIntForKey:@"price"];
    self.oos = [aDecoder decodeIntForKey:@"oos"];
    self.type = [aDecoder decodeIntForKey:@"type"];
    
    return self;
}

@end
