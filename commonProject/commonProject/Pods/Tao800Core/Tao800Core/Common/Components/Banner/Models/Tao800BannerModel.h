//
//  Tao800BannerModel.h
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

typedef NS_ENUM(NSInteger, Tao800BannerType) {
    Tao800BannerTypeHome = 1
};

@interface Tao800BannerModel : TBModel

@property (nonatomic) Tao800BannerType bannerType;
@property (nonatomic, strong) NSArray * bannerArray;


@property (nonatomic, strong) NSArray *bannerItems;
@end
