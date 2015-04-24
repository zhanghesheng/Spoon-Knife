//
//  Tao800StartBannerModel.m
//  tao800
//
//  Created by enfeng on 14/12/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800StartBannerModel.h"
#import "Tao800StartInfoVo.h"
#import "Tao800BannerVo.h"

@implementation Tao800StartBannerModel

- (Tao800BannerVo *)getBannerVo {

    Tao800BannerVo *bannerVo = [[Tao800BannerVo alloc] init];
    bannerVo.title = self.startInfoVo.title;
    bannerVo.smallImageUrl = self.startInfoVo.smallImageUrl;
    bannerVo.bannerId = self.startInfoVo.bannerId;
    bannerVo.bannerType = self.startInfoVo.type;
    bannerVo.value = self.startInfoVo.value;
    bannerVo.wapUrl = self.startInfoVo.wapUrl;
    return bannerVo;
}
@end
