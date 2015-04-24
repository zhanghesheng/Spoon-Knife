//
//  TBQueue.m
//  Core
//
//  Created by enfeng on 14-5-22.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "TBQueue.h"

@implementation TBQueue
- (id)init {
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] initWithCapacity:300];
    }
    return self;
}

- (void)addObject:(id)object {
    [_array addObject:object];
}

- (id)takeObject {
    id object = nil;
    if ([_array count] > 0) {
        object = [_array objectAtIndex:0];
        [_array removeObjectAtIndex:0];
    }
    return object;
}

- (NSEnumerator *)objectEnumerator {
    return [_array reverseObjectEnumerator];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _array = [coder decodeObjectForKey:@"_array"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_array forKey:@"_array"];
}

- (id)copyWithZone:(NSZone *)zone {
    TBQueue *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->_array = [_array copy];
    }

    return copy;
}

- (NSUInteger)count {
    return _array.count;
}
@end
