//
//  TBPointRuleVo.m
//  Tuan800API
//
//  Created by enfeng on 14-1-14.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import "TBPointRuleVo.h"

@implementation TBPointRuleVo

@synthesize pointRuleId = _pointRuleId;
@synthesize pointRuleScore = _pointRuleScore;
@synthesize pointRuleDescription = _pointRuleDescription;
@synthesize pointRuleKey = _pointRuleKey;
@synthesize title = _title;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.pointRuleId = [coder decodeObjectForKey:@"pointRuleId"];
        self.pointRuleScore = [coder decodeObjectForKey:@"pointRuleScore"];
        self.pointRuleDescription = [coder decodeObjectForKey:@"pointRuleDescription"];
        self.pointRuleKey = [coder decodeObjectForKey:@"pointRuleKey"];
        self.title = [coder decodeObjectForKey:@"title"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.pointRuleId forKey:@"pointRuleId"];
    [coder encodeObject:self.pointRuleScore forKey:@"pointRuleScore"];
    [coder encodeObject:self.pointRuleDescription forKey:@"pointRuleDescription"];
    [coder encodeObject:self.pointRuleKey forKey:@"pointRuleKey"];
    [coder encodeObject:self.title forKey:@"title"];
}

- (id)copyWithZone:(NSZone *)zone {
    TBPointRuleVo *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.pointRuleId = self.pointRuleId;
        copy.pointRuleScore = self.pointRuleScore;
        copy.pointRuleDescription = self.pointRuleDescription;
        copy.pointRuleKey = self.pointRuleKey;
        copy.title = self.title;
    }

    return copy;
}


@end
