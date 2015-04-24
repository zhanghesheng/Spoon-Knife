//
//  Tao800StartBannerModel.h
//  tao800
//
//  Created by enfeng on 14/12/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

@class Tao800StartInfoVo;
@class Tao800BannerVo;

@interface Tao800StartBannerModel : TBModel
@property(nonatomic, strong) Tao800StartInfoVo *startInfoVo;

- (Tao800BannerVo *)getBannerVo;
@end
