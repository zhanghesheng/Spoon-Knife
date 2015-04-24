//
//  Tao800FavoriteGoodsItem.m
//  tao800
//
//  Created by ayvin on 13-4-17.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800FavoriteGoodsItem.h"

@implementation Tao800FavoriteGoodsItem
@synthesize dealVo;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.dealVo forKey:@"dealVo"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self.dealVo = [aDecoder decodeObjectForKey:@"dealVo"];
    
    return self;
}

@end
