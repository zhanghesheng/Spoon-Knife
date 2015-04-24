//
//  TBSafeMutableDictionary.h
//  Core
//
//  Created by enfeng on 15/3/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSafeMutableDictionary : NSObject

- (id)objectForKey:(id)aKey;

- (void)removeObjectForKey:(id)aKey;

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;

- (void)removeAllObjects;
@end
