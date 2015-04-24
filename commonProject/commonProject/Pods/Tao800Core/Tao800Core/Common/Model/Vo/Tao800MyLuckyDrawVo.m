//
//  Tao800MyLuckyDrawVo.m
//  tao800
//
//  Created by worker on 14-10-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MyLuckyDrawVo.h"

@implementation Tao800MyLuckyDrawVo

@synthesize dealId = _dealId;
@synthesize title = _title;

//成都
@synthesize userId = _userId;
@synthesize listImage = _listImage;
@synthesize joinCount = _joinCount;
@synthesize returnStatus = _returnStatus;
@synthesize originPrice = _originPrice;
@synthesize image = _image;
@synthesize totalCount = _totalCount;
@synthesize dealDescription = _dealDescription;
@synthesize begunAt = _begunAt;
@synthesize endedAt = _endedAt;
@synthesize runTime = _runTime;
@synthesize cost = _cost;
@synthesize orderStatus = _orderStatus;
@synthesize orderId = _orderId;
@synthesize delivery = _delivery;
@synthesize userInfos = _userInfos;
@synthesize luckyUsers = _luckyUsers;
@synthesize myLucky = _myLucky;
@synthesize lotteryCount = _lotteryCount;
@synthesize overRate = _overRate;
@synthesize intro = _intro;
@synthesize hasShow = _hasShow;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    
    //成都
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.listImage forKey:@"listImage"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInt:self.dealId forKey:@"dealId"];
    [aCoder encodeObject:self.dealDescription forKey:@"dealDescription"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.begunAt forKey:@"begunAt"];
    [aCoder encodeObject:self.endedAt forKey:@"endedAt"];
    [aCoder encodeObject:self.runTime forKey:@"runTime"];
    [aCoder encodeObject:self.cost forKey:@"cost"];
    [aCoder encodeObject:self.delivery forKey:@"delivery"];
    [aCoder encodeObject:self.userInfos forKey:@"userInfos"];
    [aCoder encodeObject:self.luckyUsers forKey:@"luckyUsers"];
    [aCoder encodeObject:self.myLucky forKey:@"myLucky"];
    [aCoder encodeObject:self.intro forKey:@"intro"];
    [aCoder encodeObject:self.orderId forKey:@"orderId"];
    
    [aCoder encodeFloat:self.originPrice forKey:@"originPrice"];
    
    [aCoder encodeInt:self.returnStatus forKey:@"returnStatus"];
    [aCoder encodeInt:self.joinCount forKey:@"joinCount"];
    [aCoder encodeInt:self.totalCount forKey:@"totalCount"];
    [aCoder encodeInt:self.lotteryCount forKey:@"lotteryCount"];
    [aCoder encodeInt:self.runStatus forKey:@"runStatus"];
    [aCoder encodeFloat:self.orderStatus forKey:@"orderStatus"];
    [aCoder encodeFloat:self.overRate forKey:@"overRate"];
    
    [aCoder encodeBool:self.hasShow forKey:@"hasShow"];
    
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    
    //成都
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.listImage = [aDecoder decodeObjectForKey:@"listImage"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.dealId = [aDecoder decodeIntForKey:@"dealId"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.dealDescription = [aDecoder decodeObjectForKey:@"dealDescription"];
    self.begunAt = [aDecoder decodeObjectForKey:@"begunAt"];
    self.endedAt = [aDecoder decodeObjectForKey:@"endedAt"];
    self.runTime = [aDecoder decodeObjectForKey:@"runTime"];
    self.cost = [aDecoder decodeObjectForKey:@"cost"];
    self.delivery = [aDecoder decodeObjectForKey:@"delivery"];
    self.userInfos = [aDecoder decodeObjectForKey:@"userInfos"];
    self.luckyUsers = [aDecoder decodeObjectForKey:@"luckyUsers"];
    self.myLucky = [aDecoder decodeObjectForKey:@"myLucky"];
    self.intro = [aDecoder decodeObjectForKey:@"intro"];
    self.orderId = [aDecoder decodeObjectForKey:@"orderId"];
    self.originPrice = [aDecoder decodeFloatForKey:@"originPrice"];
    
    self.returnStatus = [aDecoder decodeIntForKey:@"returnStatus"];
    self.joinCount = [aDecoder decodeIntForKey:@"joinCount"];
    
    self.totalCount = [aDecoder decodeIntForKey:@"totalCount"];
    self.runStatus = [aDecoder decodeIntForKey:@"runStatus"];
    self.orderStatus = [aDecoder decodeIntForKey:@"orderStatus"];
    self.lotteryCount = [aDecoder decodeIntForKey:@"lotteryCount"];
    self.overRate = [aDecoder decodeFloatForKey:@"overRate"];
    
    self.hasShow = [aDecoder decodeBoolForKey:@"hasShow"];
    
    return self;
}


@end
