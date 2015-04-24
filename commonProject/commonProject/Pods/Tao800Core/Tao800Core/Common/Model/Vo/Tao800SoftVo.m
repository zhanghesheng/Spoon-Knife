//
//  Tao800SoftVo.m
//  tao800
//
//  Created by worker on 12-10-31.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SoftVo.h"

@implementation Tao800SoftVo {

}
@synthesize minVersion = _minVersion;
@synthesize url = _url;
@synthesize version = _version;
@synthesize softDescription = _softDescription;
@synthesize mustUpdate = _mustUpdate;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.minVersion forKey:@"minVersion"];
    [aCoder encodeObject:self.url forKey:@"softVoUrl"];
    [aCoder encodeObject:self.version forKey:@"softVersion"];
    [aCoder encodeObject:self.softDescription forKey:@"softDescription"];
    [aCoder encodeObject:self.minimumSystemVersion forKey:@"minimumSystemVersion"];
    [aCoder encodeObject:@(self.mustUpdate) forKey:@"mustUpdate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self.minVersion = [aDecoder decodeObjectForKey:@"minVersion"];
    self.url = [aDecoder decodeObjectForKey:@"softVoUrl"];
    self.version = [aDecoder decodeObjectForKey:@"softVersion"];
    self.softDescription = [aDecoder decodeObjectForKey:@"softDescription"];
    self.minimumSystemVersion = [aDecoder decodeObjectForKey:@"minimumSystemVersion"];
    NSNumber* number =  [aDecoder decodeObjectForKey:@"mustUpdate"];
    self.mustUpdate = [number boolValue];
    return self;
}

- (void)dealloc {

}

- (id)copyWithZone:(NSZone *)zone {
    Tao800SoftVo *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.minVersion = self.minVersion;
        copy.url = self.url;
        copy.version = self.version;
        copy.mustUpdate = self.mustUpdate;
        copy.softDescription = self.softDescription;
    }

    return copy;
}

@end
