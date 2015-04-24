//
//  TBSafeMutableArray.m
//  Core
//
//  Created by enfeng on 15/3/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "TBSafeMutableArray.h"

@interface TBSafeMutableArray ()
@property(nonatomic, strong) NSMutableArray *mutableArray;
@property(nonatomic, strong) dispatch_queue_t cacheQueue;
@end

@implementation TBSafeMutableArray

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableArray = [NSMutableArray arrayWithCapacity:100];
        //创建一个顺序执行的队列
        self.cacheQueue = dispatch_queue_create("com.zhe800.urlcache.queue",
                DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (NSUInteger)count {
    __block NSUInteger countRet = 0;
    __weak TBSafeMutableArray *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        countRet = [instance.mutableArray count];
    });

    return countRet;
}


- (void)addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    __weak TBSafeMutableArray *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        [instance.mutableArray addObject:anObject];
    });
}

- (id)objectAtIndex:(NSUInteger)index {
    __weak TBSafeMutableArray *instance = self;
    __block id obj = nil;
    dispatch_sync(instance.cacheQueue, ^{
        obj = instance.mutableArray[index];
    });

    return obj;
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    __weak TBSafeMutableArray *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        [instance.mutableArray removeObjectAtIndex:index];
    });
}

- (void)removeAllObjects {
    __weak TBSafeMutableArray *instance = self;

    dispatch_sync(instance.cacheQueue, ^{
        [instance.mutableArray removeAllObjects];
    });
}

- (void)removeObject:(id)object {
    __weak TBSafeMutableArray *instance = self;

    dispatch_sync(instance.cacheQueue, ^{
        [instance.mutableArray removeObject:object];
    });
}
@end
