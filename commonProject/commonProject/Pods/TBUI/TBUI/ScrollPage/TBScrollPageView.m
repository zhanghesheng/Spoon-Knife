//
//  TBScrollPageView.m
//  TBUI
//
//  Created by enfeng on 14-4-21.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBScrollPageView.h"

@implementation TBScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.enableDragToRight = YES;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gestureRecognizer;
        
        CGFloat velocityX = [panGesture velocityInView:self.superview].x;

        if ( velocityX > 0) {//在向右拽
            if (self.contentOffset.x==0 && !self.enableDragToRight) {
                return NO;
            }
        } else {
            CGFloat xWidth = self.contentSize.width - self.frame.size.width;
            if (self.contentOffset.x >= xWidth && !self.enableDragToRight) { 
                return NO;
            }
        }
    }
    return YES;
}
@end
