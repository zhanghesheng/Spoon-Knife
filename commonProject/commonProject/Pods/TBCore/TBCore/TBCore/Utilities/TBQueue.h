//
//  TBQueue.h
//  Core
//
//  Created by enfeng on 14-5-22.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBQueue : NSObject <NSCoding, NSCopying> {
    NSMutableArray *_array;
}
- (void)addObject:(id)object;

- (id)takeObject;

- (NSEnumerator *) objectEnumerator;

- (NSUInteger)count;
@end
