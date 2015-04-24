//
//  Tao800BannerVo.m
//  tao800
//
//  Created by worker on 12-11-1.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BannerVo.h"

@implementation Tao800BannerVo

@synthesize bannerId = _bannerId;
@synthesize title = _title;
@synthesize bannerType = _bannerType;
@synthesize value = _value;
@synthesize dealUrl = _dealUrl;
@synthesize wapUrl = _wapUrl;
@synthesize bigImageUrl = _bigImageUrl;
@synthesize normalImageUrl = _normalImageUrl;
@synthesize smallImageUrl = _smallImageUrl;
@synthesize show_model = _show_model;
@synthesize detailString = _detailString;
@synthesize childTopics = _childTopics;

- (id)init {
    self = [super init];
    if (self) {
        self.dealDetailFrom = Tao800DealDetailFromBanner;
    }
    return self;
}

@end
