//
//  Tao800TaobaoVo.m
//  tao800
//
//  Created by worker on 13-2-4.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800TaobaoVo.h"

@implementation Tao800TaobaoVo

@synthesize nickName = _nickName;
@synthesize expiresAt = _expiresAt;
@synthesize accessToken = _accessToken;
@synthesize partnerType = _partnerType;

- (void)dealloc {

}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_nickName forKey:@"nickName"];
    [aCoder encodeObject:_expiresAt forKey:@"expiresAt"];
    [aCoder encodeObject:_accessToken forKey:@"accessToken"];
    [aCoder encodeInteger:_partnerType forKey:@"partnerType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
    self.expiresAt = [aDecoder decodeObjectForKey:@"expiresAt"];
    self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
    self.partnerType = (int) [aDecoder decodeIntegerForKey:@"partnerType"];
    return self;
}

@end
