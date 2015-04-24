//
//  Tao800BannerItemView.h
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//
#import "TBUI/TBUI.h"
#import "Tao800BannerVo.h"

@interface Tao800BannerItemView : TBUICycleScrollSubView {
    TBImageView *_imageView;
    Tao800BannerVo *_bannerVo;
    CGFloat _pageSpacing;
}
@property(nonatomic, strong) TBImageView *imageView;
@property(nonatomic, strong) Tao800BannerVo *bannerVo;
@property(nonatomic) CGFloat pageSpacing;

@end