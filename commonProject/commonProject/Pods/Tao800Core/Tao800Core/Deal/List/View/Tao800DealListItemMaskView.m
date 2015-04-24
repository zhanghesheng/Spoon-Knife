//
//  Tao800DealListItemMaskView.m
//  tao800
//
//  Created by enfeng on 14/11/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListItemMaskView.h"

enum {
    Tao800DealListItemMaskViewTagCircleWidth = 50
};

@implementation Tao800DealListItemMaskView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UILabel *tLabel = [[UILabel alloc] init];
        [self addSubview:tLabel];
        self.titleLabel = tLabel;
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.size = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(100, 30)];
    titleRect.origin.x = (self.frame.size.width-titleRect.size.width)/2;
    titleRect.origin.y = (self.frame.size.height-titleRect.size.height)/2;
    self.titleLabel.frame = titleRect;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showCircle = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Get the current graphics context
    UIColor *bgColor = nil;
    if (self.showCircle) {
        bgColor = [UIColor clearColor];
    } else {
        bgColor = [UIColor colorWithWhite:0 alpha:.6];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor( context, bgColor.CGColor );
    CGContextFillRect( context, rect );
    
    if (self.showCircle) {
        
        //透明区域
        CGRect circleRect = CGRectZero;
        CGFloat width = Tao800DealListItemMaskViewTagCircleWidth;
        circleRect.size = CGSizeMake(width, width);
        circleRect.origin.y = (self.frame.size.height-circleRect.size.height)/2;
        circleRect.origin.x = (self.frame.size.width-circleRect.size.width)/2;
        
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:.6].CGColor );
        CGContextFillEllipseInRect(context, circleRect);
        
        //画圆圈
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextStrokeEllipseInRect(context, circleRect);
        
    }
    
} 
@end
