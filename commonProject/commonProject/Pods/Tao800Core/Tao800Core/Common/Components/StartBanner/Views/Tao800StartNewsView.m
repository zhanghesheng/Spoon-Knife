//
//  Tao800StartNewsView.m
//  tao800
//
//  Created by worker on 12-10-24.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/UIViewAdditions.h>
#import "Tao800StartNewsView.h"
#import "TBCore/TBCoreMacros.h"
#import "Tao800Util.h"
#import "Tao800StyleSheet.h"

@interface Tao800StartNewsView () {
}
@property(nonatomic) CGPoint beginPoint;

@end

@implementation Tao800StartNewsView

- (void) layoutSubviews {
    [super layoutSubviews];
    
    
    [self resetShadowViewStyle];
}

- (void)resetShadowViewStyle {
    self.shadowView.backgroundColor = [UIColor blackColor];

    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    //绘制一个渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.shadowView.bounds;
    gradient.colors = @[
            (__bridge id) UIColor.clearColor.CGColor,
            (__bridge id) [UIColor whiteColor].CGColor
    ];

    gradient.locations = @[@0.0F, @2.0F];

    self.shadowView.layer.mask = gradient;
    [CATransaction commit];
}

- (void)resetButtonStyle {
    UIImage *detailImage = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
    UIImage *skipImage = [Tao800Util imageWithColor:[UIColor colorWithHex:0x5D9DCE] bounds:CGRectMake(0, 0, 2, 2)];

    [self.detailButton setBackgroundImage:detailImage forState:UIControlStateNormal];
    [self.detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.skipOverButton setBackgroundImage:skipImage forState:UIControlStateNormal];
    [self.skipOverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self resetButtonStyle];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.beginPoint = CGPointZero;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (!self.dragEnable) {
//        return;
//    }
//
//    UITouch *touch = [touches anyObject];
//    self.beginPoint = [touch locationInView:self];
//    
//    NSLog(@"self.beginPoint.x=%f", self.beginPoint.x);
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//    if (!self.dragEnable) {
//        return;
//    }
//
//    UITouch *touch = [touches anyObject];
//    CGPoint nowPoint = [touch locationInView:self];
//    float offsetX = nowPoint.x - self.beginPoint.x;
//    
//    NSLog(@"nowPoint=%f", nowPoint.x);
//
//    if (self.center.x + offsetX > 160) {
//        return;
//    }
//
//    // 移动自身
//    CGRect rect = self.frame;
//    rect.origin.x += offsetX;
//    self.frame = rect;
//
//    // 代理回调
//    if (self.startNewsDelegate && [self.startNewsDelegate respondsToSelector:@selector(startNewsViewTouchesMoved:)]) {
//        [self.startNewsDelegate startNewsViewTouchesMoved:offsetX];
//    }
//
//    // 判断是否关闭
//    if (offsetX <= 0) {
//        //NSLog(@"关闭");
//        self.isClosed = YES;
//    } else {
//        //NSLog(@"不关闭");
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (!self.dragEnable) {
//        return;
//    }
//
//    if (self.isClosed) {
//        // 代理回调
//        if (self.startNewsDelegate && [self.startNewsDelegate respondsToSelector:@selector(startNewsViewClosed)]) {
//            [self.startNewsDelegate startNewsViewClosed];
//        }
//
//        self.isClosed = NO;
//    }
//}

- (void)dealloc {

}

 
@end
