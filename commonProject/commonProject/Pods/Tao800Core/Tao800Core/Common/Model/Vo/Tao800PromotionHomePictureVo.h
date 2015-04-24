//
//  Tao800PromotionHomePictureVo.h
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PromotionHomePictureVo : NSObject<NSCoding>

@property (nonatomic,strong) NSString* iphone6plusImage;     //pic
@property (nonatomic,strong) NSString* iphone6Image;     //pic
@property (nonatomic,strong) NSString* iphone5Image;     //pic
@property (nonatomic,strong) NSString* iphone4Image;     //pic
@property (nonatomic,strong) NSString* color;

+(Tao800PromotionHomePictureVo*) wrapperPictureVo:(NSDictionary*)dic;
@end
