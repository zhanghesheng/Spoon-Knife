//
//  Tao800ActivityIndicatorView.m
//  tao800
//
//  Created by enfeng on 14-3-6.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ActivityIndicatorView.h"

@interface Tao800ActivityIndicatorView ()

@property(nonatomic, assign) BOOL animating;
@property(nonatomic, assign) BOOL isAnimatingAppWillResignActivate;  //切换到后台时是否正在执行动画

@end

@implementation Tao800ActivityIndicatorView

- (void)appActivate:(NSNotification *) note {
    if (self.isAnimatingAppWillResignActivate) {
        [self startAnimating];
    }
}

- (void)appWillResignActivate:(NSNotification *) note {
    self.isAnimatingAppWillResignActivate = self.isAnimating;
    [self stopAnimating];
}

- (void)dealloc {
    [self startAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.centerImageView = imageView;
        [self addSubview:imageView];

        self.animating = NO;
        self.centerImageView.hidden = YES;

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

- (void)layoutSubviews {
    [super layoutSubviews];

    self.centerImageView.frame = self.bounds;

    if (self.isAnimating && !self.centerImageView.isAnimating) {
        [self.centerImageView startAnimating];
    }
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    return [self initWithFrame:CGRectZero];
}

- (void)startAnimating {
    if (self.animating) {
        return;
    }
    self.animating = YES;
    self.centerImageView.hidden = NO;
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:0];
    shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
    shake.duration = 0.8;
    shake.autoreverses = NO;
    shake.repeatCount = MAXFLOAT;

    [self.centerImageView.layer addAnimation:shake forKey:@"shakeAnimation"];

    self.centerImageView.animationDuration = 0.3f;
    [self.centerImageView startAnimating];
}

- (void)stopAnimating {
    if (!self.animating) {
        return;
    }
    [self.centerImageView.layer removeAllAnimations];
    [self.centerImageView stopAnimating];
    self.centerImageView.hidden = YES;
    self.animating = NO;
}

- (BOOL)isAnimating {
    return self.animating;
}

@end
