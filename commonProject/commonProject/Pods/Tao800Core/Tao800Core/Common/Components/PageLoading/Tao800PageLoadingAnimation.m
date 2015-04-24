//
//  Tao800PageLoadingAnimation.m
//  Tao800Core
//
//  Created by suminjie on 15/2/13.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800PageLoadingAnimation.h"

@interface Tao800PageLoadingAnimation ()
@property(nonatomic, assign) BOOL animating;
@property(nonatomic, assign) BOOL isAnimatingAppWillResignActivate;  //切换到后台时是否正在执行动画
@property(nonatomic, weak) UIView* testView;
@property(nonatomic, assign) CGRect animationViewInitRect;
@end

@implementation Tao800PageLoadingAnimation
- (void)appActivate:(NSNotification *) note {
    if (self.isAnimatingAppWillResignActivate) {
        //[self startAnimating];
    }
}

- (void)appWillResignActivate:(NSNotification *) note {
    self.isAnimatingAppWillResignActivate = self.isAnimating;
    //[self stopAnimating];
}

- (void)dealloc {
    //[self startAnimating];
    [self stopAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        TBImageView *imageView = [[TBImageView alloc] initWithFrame:self.bounds];
        self.animationView = imageView;
        self.animationView.backgroundColor = [UIColor purpleColor];
        self.animationViewInitRect = self.bounds;
        [self addSubview:self.animationView];
        
        CGFloat w = 50;
        CGFloat h = 55;
        CGFloat x = CGRectGetWidth(self.bounds)/3;
        CGFloat y = CGRectGetHeight(self.bounds)-h;
        CGRect rect = CGRectMake(x, y, w, h);
        UIView* tView = [[UIView alloc] initWithFrame:rect];
        self.testView = tView;
        self.testView.backgroundColor = [UIColor blueColor];
        [self.animationView addSubview:self.testView];
        
        self.animating = NO;
        self.animationView.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appActivate:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResignActivate:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)startAnimating {
    if (self.animating) {
        return;
    }
    self.animating = YES;
    self.animationView.hidden = NO;
    
    NSString *kCAPostionKeyPath = @"position";
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint pi = self.animationView.layer.position;
    [path moveToPoint:self.animationView.layer.position];
    //CGRect rect = self.animationView.frame;
    //CGPoint sPoint = CGPointMake(CGRectGetMinX(self.animationView.frame), CGRectGetMinY(self.animationView.frame));
    //CGPoint ePoint = CGPointMake(CGRectGetMinX(self.animationView.frame)+(CGRectGetWidth(self.bounds)/3), CGRectGetMinY(self.animationView.frame));
    //[path moveToPoint:sPoint];
    CGPoint ePoint = pi;
    ePoint.x = ePoint.x + CGRectGetWidth(self.bounds)/3;
    [path addLineToPoint:ePoint];
    //[path addCurveToPoint:sPoint controlPoint1:sPoint controlPoint2:ePoint];
    
    //路径动画
    CAKeyframeAnimation *posAnimation = [CAKeyframeAnimation animationWithKeyPath:kCAPostionKeyPath];
    posAnimation.path = path.CGPath;
    posAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //posAnimation.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[posAnimation];
    group.duration = 2;
    group.removedOnCompletion = YES;
    group.repeatCount = MAXFLOAT;
    //group.fillMode = kCAFillModeForwards;
    //group.delegate = self;
    [self.animationView.layer addAnimation:group forKey:nil];
     
//    
//    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    shake.fromValue = [NSNumber numberWithFloat:0];
//    shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
//    shake.duration = 0.8;
//    shake.autoreverses = NO;
//    shake.repeatCount = MAXFLOAT;
//    
//    [self.centerImageView.layer addAnimation:shake forKey:@"shakeAnimation"];
//    
//    self.centerImageView.animationDuration = 0.3f;
//    [self.centerImageView startAnimating];
}

- (void)stopAnimating {
    if (!self.animating) {
        return;
    }
    [self.layer removeAllAnimations];
    [self.animationView.layer removeAllAnimations];
    //[self.animationView stopAnimating];
    self.animationView.hidden = YES;
    self.animating = NO;
}


- (BOOL)isAnimating {
    return self.animating;
}

@end
