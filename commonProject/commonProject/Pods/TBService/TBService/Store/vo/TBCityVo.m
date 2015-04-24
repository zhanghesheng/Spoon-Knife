//
//  TBCityVo.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBCityVo.h"

@implementation TBCityVo 
@synthesize longitude, latitude, cityId, name, pinyin, shopNextUpdateTime, flag;
@synthesize cityOrder;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone; {
    TBCityVo *cityVo = [[TBCityVo alloc] init];
    cityVo.name = [self.name copyWithZone:zone];
    cityVo.pinyin = [self.pinyin copyWithZone:zone];
    cityVo.latitude = self.latitude;
    cityVo.longitude = self.longitude;
    cityVo.flag = self.flag;
    cityVo.cityId = [self.cityId copyWithZone:zone];
    return cityVo;
}


-(void) encodeWithCoder:(NSCoder *)aCoder { 
    [aCoder encodeObject:pinyin forKey:@"pinyin"];
    [aCoder encodeObject:name forKey:@"name"]; 
    [aCoder encodeObject:shopNextUpdateTime forKey:@"shopNextUpdateTime"];
    [aCoder encodeObject:cityId forKey:@"cityId"]; 
    [aCoder encodeDouble:longitude forKey:@"longitude"];
    [aCoder encodeDouble:latitude forKey:@"latitude"];
    [aCoder encodeInt:flag forKey:@"flag"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self.pinyin = [aDecoder decodeObjectForKey:@"pinyin"];
    self.name = [aDecoder decodeObjectForKey:@"name"]; 
    self.shopNextUpdateTime = [aDecoder decodeObjectForKey:@"shopNextUpdateTime"];
    self.cityId = [aDecoder decodeObjectForKey:@"cityId"]; 
    self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
    self.flag = [aDecoder decodeIntForKey:@"flag"];
	return self;
}

-(void) dealloc {
    
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.cityId=%@", self.cityId];
    [description appendFormat:@", self.name=%@", self.name];
    [description appendString:@">"];

    return description;
}

@end
