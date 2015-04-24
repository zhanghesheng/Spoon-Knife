//
//  Tao800DealBaseItem.m
//  Tao800Core
//
//  Created by 恩锋 杨 on 15/3/4.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800DealBaseItem.h"

@implementation Tao800DealBaseItem

- (instancetype) init {
    self = [super init];
    if (self) {
        self.appearTime = 0;
        self.disappearTime = 0;
    }
    return self;
}
@end
