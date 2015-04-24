//
//  Tao800PromotionHomeSettingVo.m
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//
#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800PromotionHomeSettingVo.h"

@implementation Tao800PromotionHomeSettingVo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeInteger:self.promotionHomeSettingHomeKey forKey:@"promotionHomeSettingHomeKey"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.homekey forKey:@"homekey"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.promotionHomeSettingHomeKey = (Tao800PromotionHomeSettingHomeKey) [aDecoder decodeIntegerForKey:@"promotionHomeSettingHomeKey"];
    self.point = [aDecoder decodeObjectForKey:@"point"];
    self.value = [aDecoder decodeObjectForKey:@"value"];
    self.homekey = [aDecoder decodeObjectForKey:@"homekey"];
    return self;
}

+(Tao800PromotionHomeSettingVo*) wrapperSettingVo:(NSDictionary*)dic{
    Tao800PromotionHomeSettingVo *settingVo = [[Tao800PromotionHomeSettingVo alloc] init];
    settingVo.content = [dic objectForKey:@"content" convertNSNullToNil:YES];
    settingVo.homekey = [dic objectForKey:@"homekey" convertNSNullToNil:YES];
    settingVo.point = [dic objectForKey:@"point" convertNSNullToNil:YES];
    settingVo.title = [dic objectForKey:@"title" convertNSNullToNil:YES];
    settingVo.image = [dic objectForKey:@"pic_ios" convertNSNullToNil:YES];
    settingVo.value = [dic objectForKey:@"value" convertNSNullToNil:YES];
    
    return settingVo;
}
@end
