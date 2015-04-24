//
//  Tao800BannerItemView.m
//  tao800
//
//  Created by enfeng on 14/12/8.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BannerItemView.h"

@implementation Tao800BannerItemView


@synthesize imageView = _imageView;
@synthesize bannerVo = _bannerVo;
@synthesize pageSpacing = _pageSpacing;


- (void)layoutSubviews {
    [super layoutSubviews];
    //    CGFloat shadowHeight = 5;
    CGFloat shadowHeight = 0;
    _imageView.frame = CGRectMake(_pageSpacing, 0, self.frame.size.width - _pageSpacing * 2,
            self.frame.size.height - shadowHeight);
    //    _imageView.backgroundColor = [UIColor whiteColor];
    //    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    _imageView.layer.shadowOffset = CGSizeMake(0, shadowHeight);
    //    _imageView.layer.shadowRadius = 3;
    //    _imageView.layer.shadowOpacity = .8;
    _imageView.backgroundColor = [UIColor grayColor];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier {
    self = [super initWithFrame:frame reuseIdentifier:identifier];
    if (self) {
        _imageView = [[TBImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.defaultImage = TBIMAGE(@"bundle://common_banner_default@2x.png");
        [self addSubview:_imageView];
    }
    return self;
}

@end
