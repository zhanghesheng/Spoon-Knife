//
//  Tao800OrderVo.m
//  tao800
//
//  Created by hanyuan on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800OrderVo.h"

@implementation Tao800OrderVo

@synthesize orderId;
@synthesize dealId;
@synthesize title;
@synthesize description;
@synthesize originPrice;
@synthesize price;
@synthesize discount;
@synthesize imgUrl;
@synthesize createTime;


-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}


@end
