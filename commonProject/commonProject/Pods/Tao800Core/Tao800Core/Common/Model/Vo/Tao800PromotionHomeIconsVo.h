//
//  Tao800PromotionHomeIconsVo.h
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PromotionHomeIconsVo : NSObject<NSCoding>

@property (nonatomic,strong) NSString* normalImage;         //图标点击前
@property (nonatomic,strong) NSString* highLightImage;      //图标点击后
@property (nonatomic,strong) NSNumber* iconType;            //icon位置

+(Tao800PromotionHomeIconsVo*) wrapperIconsVo:(NSDictionary*)dic;
@end
