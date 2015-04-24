//
//  Tao800ForwardQueueItem.m
//  tao800
//
//  Created by enfeng on 14/12/21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ForwardQueueItem.h"

@implementation Tao800ForwardQueueItem

- (NSComparisonResult)compare:(Tao800ForwardQueueItem *)item2 {
    NSNumber *number1 = @(self.queueOrder);
    NSNumber *number2 = @(item2.queueOrder);

    return [number1 compare:number2];
}

- (id)copyWithZone:(NSZone *)zone {
    Tao800ForwardQueueItem *copy = [[Tao800ForwardQueueItem allocWithZone:zone] init];

    if (copy != nil) {
        copy.queueOrder = self.queueOrder;
        copy.url = self.url;
        copy.urlMd5 = self.urlMd5;
    }

    return copy;
}

@end
