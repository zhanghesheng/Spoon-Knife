//
//  Tao800BannerVCL.h
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800VCL.h"

@class Tao800BannerDataSource;

typedef void(^BannerClickCallBack)(int bannerIndex, int bannerId); //第一个参数是点击的banner的顺序，第二个参数是bannerId

@interface Tao800BannerVCL : Tao800VCL  <TBUICycleScrollViewDelegate>
 
@property(nonatomic, strong) Tao800BannerDataSource* dataSource;
@property (nonatomic, copy) BannerClickCallBack userDidClickOneItem;

- (void) loadRemoteImageEnabled :(BOOL) enableLoad;
@end
