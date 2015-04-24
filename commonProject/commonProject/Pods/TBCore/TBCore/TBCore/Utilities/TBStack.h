//
//  TBStack.h
//  Core
//
//  Created by enfeng on 14-5-22.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBStack : NSObject <NSCoding, NSCopying> {
    NSMutableArray *_array;
}
- (NSUInteger)count;

- (void) push:(NSObject *) object;

- (id) pop;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (id)copyWithZone:(NSZone *)zone;
@end
