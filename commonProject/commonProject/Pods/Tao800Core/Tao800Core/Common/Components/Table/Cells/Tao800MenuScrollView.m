//
//  Tao800MenuScrollView.m
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MenuScrollView.h"

@implementation Tao800MenuScrollView

- (id) init {
    self =[super init];
    if (self) {
        self.slideWidth = 74.0f;
        
    }
    return self;
}

- (void)dealloc {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchesBeganCallback) {
        self.touchesBeganCallback(touches, event, MenuScrollViewTouchesBegan);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchesBeganCallback) {
        self.touchesBeganCallback(touches, event, MenuScrollViewTouchesEnded);
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gestureRecognizer;
        
        if ([panGesture velocityInView:self.superview].x < 0) {
            return YES;
        } else {
            return self.menuAppeared;
        }
    }
    return YES;
}
@end
