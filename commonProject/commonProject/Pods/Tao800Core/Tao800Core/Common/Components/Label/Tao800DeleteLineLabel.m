//
//  Tao800DeleteLineLabel.m
//  tao800
//
//  Created by enfeng on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DeleteLineLabel.h"
#import "Tao800FunctionCommon.h"

@implementation Tao800DeleteLineLabel

- (void)drawRect:(CGRect)rect {

    CGFloat height = SuitOnePixelHeight();

    UIColor *tColor = self.textColor;
    if (!tColor) {
        tColor = [UIColor lightGrayColor];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, tColor.CGColor);

    CGContextSetLineWidth(ctx, height);

    CGFloat y = self.bounds.size.height / 2 + height;
    CGContextMoveToPoint(ctx, 0, y);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, y);

    CGContextStrokePath(ctx);

    [super drawRect:rect];
}
@end
