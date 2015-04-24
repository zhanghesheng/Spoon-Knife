//
//  TBStack.m
//  Core
//
//  Created by enfeng on 14-5-22.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "TBStack.h"

@implementation TBStack

- (id)init {
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] initWithCapacity:300];
    }
    return self;
}

- (void)push:(NSObject *)object {
    [_array addObject:object];
}

- (id)pop {
    if (_array.count > 0) {
        id object = _array.lastObject;
        [_array removeLastObject];
        return object;
    }
    return nil;
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
    TBStack *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->_array = [_array copy];
    }

    return copy;
}

- (NSUInteger)count {
    return _array.count;
}

@end
