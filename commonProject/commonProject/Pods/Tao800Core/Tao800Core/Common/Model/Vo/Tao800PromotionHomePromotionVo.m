//
//  Tao800PromotionHomePromotionVo.m
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800PromotionHomePromotionVo.h"

@implementation Tao800PromotionHomePromotionVo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeInteger:self.promotionHomePromotionHomeKey forKey:@"promotionHomePromotionHomeKey"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.homekey forKey:@"homekey"];
    [aCoder encodeObject:self.promotionTopicArray forKey:@"promotionTopicArray"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.content = [aDecoder decodeObjectForKey:@"content"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.value = [aDecoder decodeObjectForKey:@"value"];
    self.promotionHomePromotionHomeKey = (Tao800PromotionHomePromotionHomeKey) [aDecoder decodeIntegerForKey:@"promotionHomePromotionHomeKey"];
    self.point = [aDecoder decodeObjectForKey:@"point"];
    self.homekey = [aDecoder decodeObjectForKey:@"homekey"];
    self.promotionTopicArray = [aDecoder decodeObjectForKey:@"promotionTopicArray"];
    
    return self;
}

+(Tao800PromotionHomePromotionVo*) wrapperPromotionVo:(NSDictionary*)dict{
    Tao800PromotionHomePromotionVo *promotionVo = [[Tao800PromotionHomePromotionVo alloc] init];
    promotionVo.homekey = [dict objectForKey:@"homekey" convertNSNullToNil:YES];
    promotionVo.content = [dict objectForKey:@"content" convertNSNullToNil:YES];
    promotionVo.image = [dict objectForKey:@"pic_ios" convertNSNullToNil:YES];
    promotionVo.value = [dict objectForKey:@"value" convertNSNullToNil:YES];
    promotionVo.point = [dict objectForKey:@"point" convertNSNullToNil:YES];
    promotionVo.bannerId = [dict objectForKey:@"id" convertNSNullToNil:YES];
    
    if (promotionVo.homekey.intValue == 6) {
        NSArray *topicArray = [dict objectForKey:@"value" convertNSNullToNil:YES];
        promotionVo.promotionTopicArray = topicArray;
    }
    if (promotionVo.homekey.intValue == Tao800PromotionHomePromotionHomeKeyCategory) {
        NSDictionary *dic = [dict objectForKey:@"value" convertNSNullToNil:YES];
        promotionVo.promotionTagArray = [NSMutableArray arrayWithCapacity:1];
        if (dic) {
            [promotionVo.promotionTagArray addObject:dic];
        }
    }
    return promotionVo;
}
@end
