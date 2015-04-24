//
//  TBShareVo.m
//  universalT800
//
//  Created by enfeng on 13-11-28.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBShareVo.h"

@implementation TBShareVo
- (id) init {
    self = [super init];
    if (self) {
        self.needAppendTuan800Download = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.appTitle = [coder decodeObjectForKey:@"appTitle"];
        self.message = [coder decodeObjectForKey:@"message"];
        self.data = [coder decodeObjectForKey:@"data"];
        self.order = [coder decodeObjectForKey:@"order"];
        self.imageNormal = [coder decodeObjectForKey:@"imageNormal"];
        self.imageSmall = [coder decodeObjectForKey:@"imageSmall"];
        self.shareUrl = [coder decodeObjectForKey:@"shareUrl"];
        self.previewText = [coder decodeObjectForKey:@"previewText"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.appTitle forKey:@"appTitle"];
    [coder encodeObject:self.message forKey:@"message"];
    [coder encodeObject:self.data forKey:@"data"];
    [coder encodeObject:self.order forKey:@"order"];
    [coder encodeObject:self.imageNormal forKey:@"imageNormal"];
    [coder encodeObject:self.imageSmall forKey:@"imageSmall"];
    [coder encodeObject:self.shareUrl forKey:@"shareUrl"];
    [coder encodeObject:self.previewText forKey:@"previewText"];
}

- (id)copyWithZone:(NSZone *)zone {
    TBShareVo *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.title = self.title;
        copy.appTitle = self.appTitle;
        copy.message = self.message;
        copy.data = [self.data copyWithZone:zone];
        copy.order = [self.order copyWithZone:zone];
        copy.imageNormal = self.imageNormal;
        copy.imageSmall = self.imageSmall;
        copy.shareUrl = self.shareUrl;
        copy.previewText = self.previewText;
    }

    return copy;
}


@end
