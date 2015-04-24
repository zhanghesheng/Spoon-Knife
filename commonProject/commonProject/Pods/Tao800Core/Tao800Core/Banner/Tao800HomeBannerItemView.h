//
// Created by enfeng on 12-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"
#import "Tao800BannerVo.h"

@interface Tao800HomeBannerItemView : TBUICycleScrollSubView {
    TBImageView *_imageView;
    Tao800BannerVo *_bannerVo;
    CGFloat _pageSpacing;
}
@property(nonatomic, strong) TBImageView *imageView;
@property(nonatomic, strong) Tao800BannerVo *bannerVo;
@property(nonatomic) CGFloat pageSpacing;

@end