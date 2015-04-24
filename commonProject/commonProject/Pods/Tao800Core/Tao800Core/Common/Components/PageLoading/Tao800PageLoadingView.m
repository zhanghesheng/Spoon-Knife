//
//  Tao800PageLoadingView.m
//  Tao800Core
//
//  Created by suminjie on 15/2/13.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800PageLoadingView.h"
#import "Tao800StyleSheet.h"
#import <TBUI/TBUI.h>
#import <TBCore/TBCore.h>

typedef enum : NSUInteger {
    Tao800PLTSmallImageWidth = 35,
    Tao800PLTSmallImageHeight = 35,
    Tao800PLTLeftLabelWidth = 50,
    Tao800PLTRightLabelWidth = 84,
    Tao800PLTMidLabelWidth = 160,
    //Tao800PLTUponSmallImage =
} Tao800PageLoadingType;

@implementation Tao800PageLoadingView

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.leftLabel.text = @"搜罗商品";
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        self.leftLabel.textColor = TEXT_COLOR_BLACK2;
        self.leftLabel.font = V3_20PX_FONT;
        
        self.midLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.midLabel.text = text;
        self.midLabel.textAlignment = NSTextAlignmentCenter;
        self.midLabel.textColor = TEXT_COLOR_BLACK2;
        self.midLabel.font = V3_20PX_FONT;
        self.midLabel.numberOfLines = 2;
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.rightLabel.text = @"商品终于和你见面";
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        self.rightLabel.textColor = TEXT_COLOR_BLACK2;
        self.rightLabel.font = V3_20PX_FONT;
        
        self.leftImageView = [[TBImageView alloc] initWithFrame:CGRectZero];
        self.leftImageView.backgroundColor = [UIColor yellowColor];
        
        self.rightImageView = [[TBImageView alloc] initWithFrame:CGRectZero];
        self.rightImageView.backgroundColor = [UIColor yellowColor];
        
        self.midImageView = [[TBImageView alloc] initWithFrame:CGRectZero];
        self.midImageView.backgroundColor = [UIColor yellowColor];

        CGFloat halfH = CGRectGetHeight(frame)/2;
        CGFloat w = CGRectGetWidth(frame)*3;
        CGFloat h = 55;
        CGFloat x = -CGRectGetWidth(frame);
        CGFloat y = halfH;
        CGRect rect = CGRectMake(x, y, w, h);
        self.loadingAnimation = [[Tao800PageLoadingAnimation alloc] initWithFrame:rect];
        [self addSubview:self.loadingAnimation];
        
        [self addSubview:self.leftLabel];
        [self addSubview:self.midLabel];
        [self addSubview:self.rightLabel];
        
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.midImageView];
        
        [self startAnimating];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat halfH = (self.height/2);
    CGFloat sepY = 5;
    if (TBIsIPhone6()) {
        sepY = TBGetIphone6HeightByScaleWidth320Height(sepY);
    }else if (TBIsIPhone6Plus()){
        sepY = TBGetIphone6PlusHeightByScaleWidth320Height(sepY);
    }
    CGFloat maxLabelWidth = Tao800PLTRightLabelWidth;
    if (TBIsIPhone6()) {
        maxLabelWidth = TBGetIphone6HeightByScaleWidth320Height(maxLabelWidth);
    }else if (TBIsIPhone6Plus()){
        maxLabelWidth = TBGetIphone6PlusHeightByScaleWidth320Height(maxLabelWidth);
    }else{
        maxLabelWidth = 98;
    }
    
    CGFloat w = Tao800PLTLeftLabelWidth;
    CGFloat h = 15;
    CGFloat x = (maxLabelWidth - w)/2;
    CGFloat y = halfH - h - sepY;
    CGRect rect = CGRectMake(x, y, w, h);
    self.leftLabel.frame = rect;
    //self.leftLabel.backgroundColor = [UIColor yellowColor];
    
    x = self.width - maxLabelWidth;
    w = maxLabelWidth;
    rect = CGRectMake(x, y, w, h);
    self.rightLabel.frame = rect;
    //self.rightLabel.backgroundColor = [UIColor yellowColor];
    
    w = Tao800PLTMidLabelWidth;
    x = (self.width - w)/2;
    rect = CGRectMake(x, y, w, h+15);
    self.midLabel.frame  = rect;
    //self.midLabel.backgroundColor = [UIColor yellowColor];
    
    CGFloat sep2 = 7;
    CGFloat centerImgX = maxLabelWidth/2;
    //leftSmallImage X
    x = centerImgX - Tao800PLTSmallImageWidth/2;
    y = y - sep2 - Tao800PLTSmallImageHeight;
    w = Tao800PLTSmallImageWidth;
    h = Tao800PLTSmallImageHeight;
    rect = CGRectMake(x, y, w, h);
    self.leftImageView.frame = rect;
    
    //rightImageView
    x = self.width - x - Tao800PLTSmallImageWidth;
    rect = CGRectMake(x, y, w, h);
    self.rightImageView.frame = rect;
    
    //
    x = (self.width - Tao800PLTSmallImageWidth)/2;
    rect = CGRectMake(x, y, w, h);
    self.midImageView.frame = rect;
    
    rect = self.loadingAnimation.frame;
    rect.origin.y = halfH+15;
    self.loadingAnimation.frame = rect;
}

- (BOOL)isAnimating {
    return self.loadingAnimation.isAnimating;
}

- (void)startAnimating {
    [self.loadingAnimation startAnimating];
    self.loadingAnimation.hidden = NO;
    [self layoutSubviews];
}

- (void)stopAnimating {
    [self.loadingAnimation stopAnimating];
    self.loadingAnimation.hidden = YES;
    [self layoutSubviews];
}

- (void)dealloc
{
    //[self.loadingAnimation stopAnimating];
}

@end
