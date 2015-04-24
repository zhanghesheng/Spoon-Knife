//
//  Tao800FavoriteShopsItem.m
//  tao800
//
//  Created by lixuefeng on 13-4-7.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800FavoriteShopsItem.h"

@implementation Tao800FavoriteShopsItem
@synthesize dealVo;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.dealVo forKey:@"dealVo"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self.dealVo = [aDecoder decodeObjectForKey:@"dealVo"];

    return self;
}



@end
