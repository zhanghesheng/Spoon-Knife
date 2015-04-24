//
//  Tao800PrdValueView.m
//  Tao800Core
//
//  Created by Rose on 15/2/9.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800PrdValueView.h"

typedef enum : NSUInteger {
    Tao800PrdValueViewImgWidth = 332/2,
    Tao800PrdValueViewImgHeight = 820/2,
} Tao800PrdValueViewUIType;

@interface Tao800PrdValueView ()
@property(nonatomic,strong)TBImageView* imageView;
@end

@implementation Tao800PrdValueView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xFED631];
        self.imageView = [[TBImageView alloc] initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.urlPath = @"bundle://common_refresh_home@2x.png";
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = (self.width - Tao800PrdValueViewImgWidth)/2;
    CGFloat y = 0;
    CGFloat w = Tao800PrdValueViewImgWidth;
    CGFloat h = Tao800PrdValueViewImgHeight;
    self.imageView.frame = CGRectMake(x, y, w, h);
}
@end
