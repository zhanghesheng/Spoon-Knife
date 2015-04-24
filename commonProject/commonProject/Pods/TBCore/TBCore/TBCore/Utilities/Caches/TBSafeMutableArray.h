//
//  TBSafeMutableArray.h
//  Core
//
//  Created by enfeng on 15/3/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSafeMutableArray : NSObject

- (void)addObject:(id)anObject;

- (NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)index;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeAllObjects;

- (void)removeObject:(id) object;
@end
