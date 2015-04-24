//
//  TBWirelessBaseService.m
//  Tuan800API
//
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import "TBWirelessBaseService.h"

#ifdef DEBUG
NSString *const TBWrdUrlBase = @"http://116.255.244.38";
#else
NSString *const TBWrdUrlBase = @"http://m.api.tuan800.com";
#endif


@implementation TBWirelessBaseService

- (id)init {
    self = [super init];
    if (self) {
        self.baseUrlString = TBWrdUrlBase;
    }
    return self;
}

@end
