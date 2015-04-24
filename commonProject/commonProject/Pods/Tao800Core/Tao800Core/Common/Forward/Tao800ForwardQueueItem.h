//
//  Tao800ForwardQueueItem.h
//  tao800
//
//  Created by enfeng on 14/12/21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800ForwardQueueItem : NSObject <NSCopying>
@property (nonatomic) int queueOrder;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *urlMd5;

- (NSComparisonResult)compare:(Tao800ForwardQueueItem *)item2;

- (id)copyWithZone:(NSZone *)zone;
@end
