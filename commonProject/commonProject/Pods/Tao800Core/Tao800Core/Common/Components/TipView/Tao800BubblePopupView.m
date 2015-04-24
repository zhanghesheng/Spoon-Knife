//
//  Tao800BubblePopupView.m
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BubblePopupView.h"
#import "TBCore/TBCoreCommonFunction.h"
#import "Tao800ConfigManage.h"

//CGFloat const BubblePopupViewImageHeight = 51.0f;

@interface Tao800BubblePopupView ()

//气泡视图
@property(nonatomic, weak) UIView *bubbleView;
@property(nonatomic, assign) CGRect originalImageViewRect;

@property(nonatomic, assign) CGPoint senderCenter;


@end

@implementation Tao800BubblePopupView

- (void)dealloc {
    TBDPRINT(@"release Tao800BubblePopupView ..........");
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHex:0xEEEEEE alpha:.6];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)showInView:(UIView *)view {
    CGRect rect = view.bounds;
    self.frame = rect;
    [view addSubview:self];
}

- (void)showBubbleView:(UIView *)paramImageView inRect:(CGRect)rect {
    self.originalImageViewRect = paramImageView.frame;

    [self addSubview:paramImageView];

    self.bubbleView = paramImageView;


    rect.origin.x = 0;

    self.superview.superview.userInteractionEnabled = NO;
    __weak Tao800BubblePopupView *instance = self;

    [UIView animateWithDuration:.3
                     animations:^{
                         paramImageView.frame = rect;
                     } completion:^(BOOL finish) {
        instance.superview.superview.userInteractionEnabled = YES;
    }];
}

- (void)showBubbleView:(UIView *)paramImageView
                    on:(UIView *)sender
             direction:(BubblePopupViewDirection)direction {

    CGFloat changeY = 0;

    CGRect rect = sender.frame;
    rect = [sender.superview convertRect:rect toView:self.superview];
    rect = [self.superview convertRect:rect toView:self];

    //气泡消失时的中心位置
    CGFloat centerX = rect.origin.x + self.senderCenter.x + rect.size.width / 2;
    CGFloat centerY = 0;

    rect.origin.x = 0;


    switch (direction) {

        case BubblePopupViewDirectionTop: {
            rect.origin.y = rect.origin.y + rect.size.height;
            changeY = rect.origin.y - 12;
            centerY = changeY;
        }
            break;
        case BubblePopupViewDirectionBottom: {
            rect.origin.y = rect.origin.y;
            changeY = rect.origin.y - self.imageHeight + 2;
            centerY = changeY + self.imageHeight;
        }
            break;
    }
    rect.size = CGSizeMake(5, 5);
    paramImageView.frame = rect;
    rect.origin.x = 0;
    rect.origin.y = changeY;
    rect.size = CGSizeMake(self.width, self.imageHeight);

    self.senderCenter = CGPointMake(centerX, centerY);

    [self showBubbleView:paramImageView inRect:rect];
}

- (void)closeBubble {
    self.superview.superview.userInteractionEnabled = NO;
    __weak Tao800BubblePopupView *instance = self;

    [UIView animateWithDuration:.3
                     animations:^{
//                         CGRect rect = instance.bubbleView.frame;
                         //scale 不能设置为0，ios5动画会有问题
                         instance.bubbleView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         instance.bubbleView.center = self.senderCenter;
                     } completion:^(BOOL finish) {
        instance.superview.superview.userInteractionEnabled = YES;

        Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
        [configManage saveBubbleStateOfHome:@"1"];

        [instance removeFromSuperview];
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.clickCallBack) {
        self.clickCallBack(self, point, event);
    } else {
        [self closeBubble];
    }

    return self;
}

@end
