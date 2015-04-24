//
//  Tao800LoadMoreFinishTipView.m
//  tao800
//
//  Created by enfeng on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800LoadMoreFinishTipView.h"
#import "Tao800StyleSheet.h"
#import "TBUI/TBUI.h"
#import "TBCore/TBCore.h"

@interface Tao800LoadMoreFinishTipView()

@property(nonatomic, weak) UIImageView *imageView;

@end

@implementation Tao800LoadMoreFinishTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];//BACKGROUND_COLOR_GRAY2;
        UIImage *image = TBIMAGE(@"bundle://common_loadmore_finish@2x.png") ;
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView2];
        self.imageView = imageView2;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.imageView.frame;
    rect.size.width = 287;
    rect.size.height = 25;
    rect.origin.x = (self.width-rect.size.width)/2;
    rect.origin.y = (self.height-rect.size.height)/2;
    self.imageView.frame = rect;
}

@end
