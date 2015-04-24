//
// Created by enfeng on 13-4-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800BorderCellBackgroundView.h"
#import "Tao800StyleSheet.h"


@interface Tao800BorderCellBackgroundView () {
    CAShapeLayer *shapeLayer;
}
- (void)drawDashInContext:(CGContextRef)context;
@end


@implementation Tao800BorderCellBackgroundView
@synthesize needDrawDash = _needDrawDash;
@synthesize hideBottomLine = _hideBottomLine;
@synthesize hPadding = _hPadding;
@synthesize needDrawBottomLine = _needDrawBottomLine;


- (void)needHideBottomLine {
//    if (!self.needDrawDash) {   //放弃layer方式
//        if (shapeLayer) {
//            [shapeLayer removeFromSuperlayer];
//            shapeLayer = nil;
//        }
//    }

    //如果含有破折线，则将下面的横线隐藏
    if (_needDrawDash || _hideBottomLine) {
        CGRect rect = [self bounds];
        CGFloat minX = CGRectGetMinX(rect);
        CGFloat maxY = CGRectGetMaxY(rect);

        rect.size.height = 1;
        rect.size.width = rect.size.width - 1;
        rect.origin.x = minX + .5;
        rect.origin.y = maxY - 1;

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);

        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextAddRect(context, rect);
        CGContextFillPath(context);

        CGContextRestoreGState(context);

    }
    if (_needDrawDash) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self drawDashInContext:context];
    }
}

- (void)drawDashInContext:(CGContextRef)context {
    CGRect rect = [self bounds];
    CGFloat minX = CGRectGetMinX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);

    // Drawing lines with a white stroke color
    CGColorRef color = self.lineColor.CGColor;
    CGContextSetStrokeColorWithColor(context, color);

    // Each dash entry is a run-length in the current coordinate system
    // The concept is first you determine how many points in the current system you need to fill.
    // Then you start consuming that many pixels in the dash pattern for each element of the pattern.
    // So for example, if you have a dash pattern of {10, 10}, then you will draw 10 points, then skip 10 points, and repeat.
    // As another example if your dash pattern is {10, 20, 30}, then you draw 10 points, skip 20 points, draw 30 points,
    // skip 10 points, draw 20 points, skip 30 points, and repeat.
    // The dash phase factors into this by stating how many points into the dash pattern to skip.
    // So given a dash pattern of {10, 10} with a phase of 5, you would draw 5 points (since phase plus 5 yields 10 points),
    // then skip 10, draw 10, skip 10, draw 10, etc.
    CGFloat dashPhase = 0; //从距离左侧0的距离开始画
    CGFloat dashPattern[] = {2, 5};  //每隔5个像素画2个像素
    size_t dashCount = 2;
    CGContextSetLineDash(context, dashPhase, dashPattern, dashCount);

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context); //todo 避免异常
    // Draw a horizontal line, vertical line, rectangle and circle for comparison
    CGContextMoveToPoint(context, minX + _hPadding, maxY);
    CGContextAddLineToPoint(context, maxX - _hPadding, maxY);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextStrokePath(context);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _radius = 3;
//        _lineWidth = (int) (suitOnePixelHeight() * 2);
        _lineWidth = 1;
        _hPadding = 10;
//        self.lineColor = GlobalLineColor;
        self.lineColor = TEXT_COLOR_BLACK5;
        self.bgRGBAColor = [UIColor whiteColor];
    }
    return self;
}

- (BOOL)isOpaque {
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews]; 
}

/*
 对于非分组表格，有时需要画分割线
 */
- (void)drawBottomLine :(CGContextRef)context {

    if (!_needDrawBottomLine) {
        return;
    }

    [self drawBackgroundInContext:context];
    
//    CGFloat lineWidth = (int) (suitOnePixelHeight() * 2);
        CGFloat lineWidth = 1;
    CGContextSetLineWidth(context, lineWidth);

    CGColorRef color = self.lineColor.CGColor;

//    Using the color reference and the context we can now specify that the color is to be used when drawing the line:
    CGContextSetStrokeColorWithColor(context, color);

    CGRect rect = [self bounds];
    CGFloat minX = CGRectGetMinX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextStrokePath(context);
}

- (void) drawBackgroundInContext:(CGContextRef)context {

    CGRect rect = [self bounds];
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect), maxY = CGRectGetMaxY(rect);

//绘制背景填充
//    CGContextSetFillColorWithColor(context, self.bgRGBAColor.CGColor);
//    CGContextAddRect(context, rect);
//    CGContextFillRect(context, rect);

    //todo 可以绘制一个过度色，过度色只会显示在绘制区域
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
    CGPoint fromPoint = CGPointMake(minX, minY);
    CGPoint toPoint = CGPointMake(minX, maxY);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGGradientRef myGradient = CGGradientCreateWithColorComponents(colorSpace, bgComponents, locations, 2);
    CGContextDrawLinearGradient(context, myGradient, fromPoint, toPoint, 0);

    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(myGradient);
}

- (void)drawCustomRectangle {

}

- (void)drawRect:(CGRect)aRect {
    
    //In order to draw a line on an iPhone screen using Quartz 2D we first need to obtain the graphics context for the view:
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    [self drawBackgroundInContext:context];

    CGContextBeginPath(context);

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

    CGMutablePathRef path = nil;

    switch (_position) {
        case TBCellBackgroundViewPositionNothing:
            break;
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
    }

    CGContextSaveGState(context);
    if (path) {
        CGContextAddPath(context, path);
        //创建了一个剪辑区域，接下来所有的绘制都会被限制在这个区域内，绘制在区域外的会不可见
        CGContextClip(context);
    }

//    [self drawBackgroundInContext:context];

    if (path) {
        CGContextAddPath(context, path);
        CGPathRelease(path);
    }

    CGContextStrokePath(context);
    CGContextRestoreGState(context);

    //不和分组一起用
    [self drawBottomLine:context];

    [self needHideBottomLine];


    return;
}

- (void)setPosition:(TBCellBackgroundViewPosition)newPosition {
    if (_position != newPosition) {
        _position = newPosition;
        [self setNeedsDisplay];
    }
}
@end