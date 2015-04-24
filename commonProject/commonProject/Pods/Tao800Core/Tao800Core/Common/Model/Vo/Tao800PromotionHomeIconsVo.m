//
//  Tao800PromotionHomeIconsVo.m
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800PromotionHomeIconsVo.h"

@implementation Tao800PromotionHomeIconsVo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.normalImage forKey:@"normalImage"];
    [aCoder encodeObject:self.highLightImage forKey:@"highLightImage"];
    [aCoder encodeObject:self.iconType forKey:@"iconType"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.normalImage = [aDecoder decodeObjectForKey:@"normalImage"];
    self.highLightImage = [aDecoder decodeObjectForKey:@"highLightImage"];
    self.iconType = [aDecoder decodeObjectForKey:@"iconType"];
    return self;
}
+(Tao800PromotionHomeIconsVo*) wrapperIconsVo:(NSDictionary*)dic{
    Tao800PromotionHomeIconsVo *iconsVo = [[Tao800PromotionHomeIconsVo alloc] init];
    iconsVo.normalImage = [dic objectForKey:@"icon_before_ios" convertNSNullToNil:YES];
    iconsVo.highLightImage = [dic objectForKey:@"icon_after_ios" convertNSNullToNil:YES];
    iconsVo.iconType = [dic objectForKey:@"icon_type" convertNSNullToNil:YES];
    return iconsVo;
}
@end
