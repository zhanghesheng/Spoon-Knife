//
//  TBTabButton.m
//  TBUI
//
//  Created by enfeng on 13-3-20.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBTabButton.h"

@implementation TBTabButton
 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *title = self.titleLabel.text;
    UIFont *font = self.titleLabel.font;
    CGFloat height = self.titleLabel.frame.size.height;
    CGSize size = [title sizeWithFont:font
                    constrainedToSize:CGSizeMake(MAXFLOAT, height)
                        lineBreakMode:self.titleLabel.lineBreakMode];
    
    CGFloat width = self.imageView.image.size.width;
    height = self.imageView.image.size.height;
    
    //图片顶部对齐
    CGFloat x = (self.frame.size.width-width)/2;
    CGFloat y = 0;
    CGRect rect;
    rect.origin = CGPointMake(x, y);
    rect.size = CGSizeMake(width, height);
    self.imageView.frame = rect;

    //文字按底边对齐
    x = (self.frame.size.width-size.width)/2;
    y = self.frame.size.height-size.height;
    rect.origin = CGPointMake(x, y);
    rect.size = CGSizeMake(width, size.height);
    self.titleLabel.frame = rect;
}

@end
