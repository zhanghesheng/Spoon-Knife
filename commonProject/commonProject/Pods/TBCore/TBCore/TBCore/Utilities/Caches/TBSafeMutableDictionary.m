//
//  TBSafeMutableDictionary.m
//  Core
//
//  Created by enfeng on 15/3/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "TBSafeMutableDictionary.h"

@interface TBSafeMutableDictionary ()
@property(nonatomic, strong) NSMutableDictionary *mutableDictionary;
@property(nonatomic, strong) dispatch_queue_t cacheQueue;
@end

@implementation TBSafeMutableDictionary

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:100];
        //创建一个顺序执行的队列
        self.cacheQueue = dispatch_queue_create("com.zhe800.urlcache.queue",
                DISPATCH_QUEUE_SERIAL);
    }

    return self;
}


- (id)objectForKey:(id)aKey {
    if (!aKey) {
        return nil;
    }

    __block id obj = nil;
    __weak TBSafeMutableDictionary *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        obj = instance.mutableDictionary[aKey];
    });

    return obj;
}

- (void)removeObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }

    __weak TBSafeMutableDictionary *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        [instance.mutableDictionary removeObjectForKey:aKey];
    });
}


- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject || !aKey) {
        return;
    }
    __weak TBSafeMutableDictionary *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        instance.mutableDictionary[aKey] = anObject;
    });

}

- (void)removeAllObjects {
    __weak TBSafeMutableDictionary *instance = self;
    dispatch_sync(instance.cacheQueue, ^{
        [instance.mutableDictionary removeAllObjects];
    });
}
@end
