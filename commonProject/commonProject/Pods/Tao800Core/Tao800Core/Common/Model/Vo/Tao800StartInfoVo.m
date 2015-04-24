//
//  Tao800StartInfoVo.m
//  tao800
//
//  Created by worker on 12-11-1.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800StartInfoVo.h"

@implementation Tao800StartInfoVo

@synthesize bannerId = _bannerId;
@synthesize type = _type;
@synthesize title = _title;
@synthesize value = _value;
@synthesize dealUrl = _dealUrl;
@synthesize wapUrl = _wapUrl;
@synthesize bigImageUrl = _bigImageUrl;
@synthesize normalImageUrl = _normalImageUrl;
@synthesize smallImageUrl = _smallImageUrl;
@synthesize updateTime = _updateTime;
@synthesize detail = _detail;
@synthesize show_model = _show_model;

- (id)copyWithZone:(NSZone *)zone {
    Tao800StartInfoVo *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->_startInfoId = _startInfoId;
        copy.type = self.type;
        copy.title = self.title;
        copy.dealUrl = self.dealUrl;
        copy.wapUrl = self.wapUrl;
        copy.value = self.value;
        copy.bigImageUrl = self.bigImageUrl;
        copy.normalImageUrl = self.normalImageUrl;
        copy.smallImageUrl = self.smallImageUrl;
        copy.updateTime = self.updateTime;
        copy.detail = self.detail;
        copy.show_model = self.show_model;
        copy.bannerId = self.bannerId;
    }

    return copy;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _startInfoId = [coder decodeObjectForKey:@"_startInfoId"];
        self.type = [coder decodeObjectForKey:@"self.type"];
        self.title = [coder decodeObjectForKey:@"self.title"];
        self.dealUrl = [coder decodeObjectForKey:@"self.dealUrl"];
        self.wapUrl = [coder decodeObjectForKey:@"self.wapUrl"];
        self.value = [coder decodeObjectForKey:@"self.value"];
        self.bigImageUrl = [coder decodeObjectForKey:@"self.bigImageUrl"];
        self.normalImageUrl = [coder decodeObjectForKey:@"self.normalImageUrl"];
        self.smallImageUrl = [coder decodeObjectForKey:@"self.smallImageUrl"];
        self.updateTime = [coder decodeObjectForKey:@"self.updateTime"];
        self.detail = [coder decodeObjectForKey:@"self.detail"];
        self.show_model = [coder decodeBoolForKey:@"self.show_model"];
        self.beginTime = [coder decodeObjectForKey:@"self.beginTime"];
        self.expireTime = [coder decodeObjectForKey:@"self.expireTime"];
        self.bannerId = [coder decodeObjectForKey:@"self.bannerId"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_startInfoId forKey:@"_startInfoId"];
    [coder encodeObject:self.type forKey:@"self.type"];
    [coder encodeObject:self.title forKey:@"self.title"];
    [coder encodeObject:self.dealUrl forKey:@"self.dealUrl"];
    [coder encodeObject:self.wapUrl forKey:@"self.wapUrl"];
    [coder encodeObject:self.value forKey:@"self.value"];
    [coder encodeObject:self.bigImageUrl forKey:@"self.bigImageUrl"];
    [coder encodeObject:self.normalImageUrl forKey:@"self.normalImageUrl"];
    [coder encodeObject:self.smallImageUrl forKey:@"self.smallImageUrl"];
    [coder encodeObject:self.updateTime forKey:@"self.updateTime"];
    [coder encodeObject:self.detail forKey:@"self.detail"];
    [coder encodeBool:self.show_model forKey:@"self.show_model"];
    [coder encodeObject:self.beginTime forKey:@"self.beginTime"];
    [coder encodeObject:self.expireTime forKey:@"self.expireTime"];
    [coder encodeObject:self.bannerId forKey:@"self.bannerId"];
}


@end
