//
//  Tao800ScoreRewardCommonDealVo.m
//  tao800
//
//  Created by hanyuan on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PointDetailCommonDealVo.h"

@implementation Tao800PointDetailCommonDealVo

@synthesize dealId;
@synthesize needScore;
@synthesize urlName;
@synthesize title;
@synthesize description;
@synthesize price;
@synthesize beginTime;
@synthesize endTime;
@synthesize smallImgUrl;
@synthesize bigImgUrl;
@synthesize dealImgUrls;
@synthesize joinCount;
@synthesize dealCount;
@synthesize oos;
@synthesize grade;
@synthesize dealType;

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    
    return self;
}

@end
