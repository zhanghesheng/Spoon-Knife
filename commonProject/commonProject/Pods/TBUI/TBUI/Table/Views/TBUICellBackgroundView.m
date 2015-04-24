//
//  TBUICellBackgroundView.m
//  TBUI
//
//  Created by enfeng on 12-12-6.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBUICellBackgroundView.h"
#import "TBUICommon.h"

@implementation TBUICellBackgroundView

@synthesize position = _position;
@synthesize radius = _radius;
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize bgRGBAColor = _bgRGBAColor;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _radius = 0;
        _lineWidth = 1;
        self.lineColor = RGBCOLOR(208, 208, 208);
        self.bgRGBAColor = [UIColor whiteColor];
    }
    return self;
}

- (BOOL)isOpaque {
    return NO;
}

- (void)drawRect:(CGRect)aRect {

    //In order to draw a line on an iPhone screen using Quartz 2D we first need to obtain the graphics context for the view:
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

//    Once the context has been obtained, the width of the line we plan to draw needs to be specified:
    CGContextSetLineWidth(context, _lineWidth);

//  Next, we need to create a color reference.
//  We can do this by specifying the RGBA components of the required color (in this case opaque blue):
//    float color[]={红色分量, 绿色分量, 蓝色分量, alpha分量};
//    这4个数值都是0-1区间，0表示黑（不发光），数字越大这种颜色的光线越强，alpha分量表示透明度。比如{1.0, 0, 0,1.0}就是纯红色而且完全不透明。
//    CGFloat components[] = {0.63, 0.63, 0.61, 1.0};
//    CGColorRef color = CGColorCreate(colorSpace, components);
    CGColorRef color = self.lineColor.CGColor;

//    Using the color reference and the context we can now specify that the color is to be used when drawing the line:
    CGContextSetStrokeColorWithColor(context, color);

    CGRect rect = [self bounds];
    CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);
    minY -= 1;

    //背景填充
    CGGradientRef myGradient = nil;
    CGColorRef bgColor = self.bgRGBAColor.CGColor;
    size_t numComponents = CGColorGetNumberOfComponents(bgColor);
    CGFloat bgComponents[] = {1.0f, 1.0f, 1.0f, 1.0f};  //默认用白色
    //这里绘制纯色背景
    CGFloat locations[2] = {1.0, 1.0};

    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(bgColor);
        bgComponents[0] = components[0];
        bgComponents[1] = components[1];
        bgComponents[2] = components[2];
        bgComponents[3] = components[3];
    }

    CGMutablePathRef path = nil;
    CGPoint fromPoint = CGPointMake(minX, minY);
    CGPoint toPoint = CGPointMake(minX, maxY);

    switch (_position) {
        case TBCellBackgroundViewPositionSingle: {
            //覆盖顶部白边
            minY += 1;
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, minX, midY);
            CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, _radius);
            CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, midY, _radius);
            CGPathAddArcToPoint(path, NULL, maxX, maxY, midX, maxY, _radius);
            CGPathAddArcToPoint(path, NULL, minX, maxY, minX, midY, _radius);
            CGPathCloseSubpath(path);
        }
            break;
        case TBCellBackgroundViewPositionTop: {
            //覆盖顶部白边
            minY += 1;
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, minX, maxY);
            CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, _radius);
            CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, maxY, _radius);
            CGPathAddLineToPoint(path, NULL, maxX, maxY);
            CGPathAddLineToPoint(path, NULL, minX, maxY);
            CGPathCloseSubpath(path);
        }
            break;
        case TBCellBackgroundViewPositionBottom: {
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, minX, minY);
            CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, _radius);
            CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, minY, _radius);
            CGPathAddLineToPoint(path, NULL, maxX, minY);
            CGPathAddLineToPoint(path, NULL, minX, minY);
            CGPathCloseSubpath(path);
        }
            break;
        case TBCellBackgroundViewPositionMiddle: {

            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, minX, minY);
            CGPathAddLineToPoint(path, NULL, maxX, minY);
            CGPathAddLineToPoint(path, NULL, maxX, maxY);
            CGPathAddLineToPoint(path, NULL, minX, maxY);
            CGPathAddLineToPoint(path, NULL, minX, minY);
            CGPathCloseSubpath(path);
        }
            break;
        case TBCellBackgroundViewPositionNothing: break;
    }

    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    //创建了一个剪辑区域，接下来所有的绘制都会被限制在这个区域内，绘制在区域外的会不可见
    CGContextClip(context);

    //todo 可以绘制一个过度色，过度色只会显示在绘制区域
    myGradient = CGGradientCreateWithColorComponents(colorSpace, bgComponents, locations, 2);
    CGContextDrawLinearGradient(context, myGradient, fromPoint, toPoint, 0);

    CGContextAddPath(context, path);
    CGPathRelease(path);

    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
//    CGColorRelease(color);

    CGGradientRelease(myGradient);
    return;
}

- (void)dealloc { 
}

- (void)setPosition:(TBCellBackgroundViewPosition)newPosition {
    if (_position != newPosition) {
        _position = newPosition;
        [self setNeedsDisplay];
    }
}

@end