//
//  Tao800PromotionHomePictureVo.m
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800PromotionHomePictureVo.h"

@implementation Tao800PromotionHomePictureVo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.iphone6plusImage forKey:@"iphone6plusImage"];
    [aCoder encodeObject:self.iphone6Image forKey:@"iphone6Image"];
    [aCoder encodeObject:self.iphone5Image forKey:@"iphone5Image"];
    [aCoder encodeObject:self.iphone4Image forKey:@"iphone4Image"];
    [aCoder encodeObject:self.color forKey:@"color"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.iphone6plusImage = [aDecoder decodeObjectForKey:@"iphone6plusImage"];
    self.iphone6Image = [aDecoder decodeObjectForKey:@"iphone6Image"];
    self.iphone5Image = [aDecoder decodeObjectForKey:@"iphone5Image"];
    self.iphone4Image = [aDecoder decodeObjectForKey:@"iphone4Image"];
    self.color = [aDecoder decodeObjectForKey:@"color"];

    return self;
}

+(Tao800PromotionHomePictureVo*) wrapperPictureVo:(NSDictionary*)dic{
    Tao800PromotionHomePictureVo *pictureVo = [[Tao800PromotionHomePictureVo alloc] init];
    pictureVo.iphone6plusImage = [dic objectForKey:@"1242x192" convertNSNullToNil:YES];
    pictureVo.iphone6Image = [dic objectForKey:@"750x128" convertNSNullToNil:YES];
    pictureVo.iphone5Image = [dic objectForKey:@"640x128" convertNSNullToNil:YES];
    pictureVo.iphone4Image = [dic objectForKey:@"640x88" convertNSNullToNil:YES];
    pictureVo.color = [dic objectForKey:@"color" convertNSNullToNil:YES];
    
    return pictureVo;
}
@end
