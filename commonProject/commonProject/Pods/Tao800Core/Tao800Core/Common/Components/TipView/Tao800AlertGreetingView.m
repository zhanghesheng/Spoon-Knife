//
//  Tao800AlertGreetingView.m
//  tao800
//
//  Created by Rose on 15/1/5.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AlertGreetingView.h"
#import "Tao800StyleSheet.h"

@implementation Tao800AlertGreetingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.greetingImageView = [[TBImageView alloc] initWithFrame:CGRectZero];
        self.greetingImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_greetingImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = TEXT_COLOR_PINK;
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_titleLabel];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = 20;
    CGFloat y = 0;
    CGFloat w = 60;
    CGFloat h = 60;
    CGRect rect = CGRectMake(x, y, w, h);
    self.greetingImageView.frame = rect;
    
    w = self.width - CGRectGetMaxX(self.greetingImageView.frame) - 15;
    h = 24;
    x = CGRectGetMaxX(self.greetingImageView.frame) + 10;
    y = self.height - h - 5;
    rect = CGRectMake(x, y, w, h);
    self.titleLabel.frame = rect;
}
@end
