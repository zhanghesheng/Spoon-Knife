//
//  Tao800CustomStatueBar.m
//  tao800
//
//  Created by Rose on 15/1/8.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CustomStatueBar.h"
#import "Tao800StyleSheet.h"

@interface Tao800CustomStatueBar ()
@property(nonatomic)CGRect statusNormalRect;
@property(nonatomic)CGRect labelNormalRect;
@property(nonatomic)BOOL animate;
@property(nonatomic)BOOL autoHide;
@end

@implementation Tao800CustomStatueBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.animate = NO;
        self.autoHide = NO;
        //self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        CGRect rect = [UIApplication sharedApplication].statusBarFrame;
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            CGFloat w = rect.size.width;//75;
            rect.origin.x = rect.size.width - w;
            rect.size.width = w;
            self.frame = CGRectZero;
        }else{
            self.frame = CGRectZero;
        }
        self.statusNormalRect = rect;
        
        self.backgroundColor = BACKGROUND_COLOR_RED1;//TEXT_COLOR_RED1;//
        CGRect labelFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.labelNormalRect = labelFrame;
        defaultLabel = [[UILabel alloc]initWithFrame:labelFrame];
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.textColor = [UIColor whiteColor];
        defaultLabel.font = [UIFont systemFontOfSize:10.0f];
        defaultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:defaultLabel];
        //defaultLabel.clipsToBounds = YES;
        
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDetected:)];
        [self addGestureRecognizer:tapGes];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)cancelMethod{
    if (_autoHide) {
        _autoHide = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHide:) object:nil];
    }
}

-(void)touchDetected:(UITapGestureRecognizer*)tap{
    if (_barDelegate && [_barDelegate respondsToSelector:@selector(touchStatusBar)]) {
        [_barDelegate touchStatusBar];
    }
    if (_autoHide) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHide:) object:nil];
        self.animate = NO;
        [self hide];
    }else{
        [self hide];
    }
}

- (void)showStatusMessage:(NSString *)message autoHide:(BOOL)autohide{
    if (self.animate) {
        return;
    }
    self.animate = YES;
    defaultLabel.text = message;
    CGRect rectStart = self.statusNormalRect;
    CGFloat h = rectStart.size.height;
    rectStart.origin.y = h;
    rectStart.size.height = 0;
    self.frame = rectStart;
    defaultLabel.frame = self.labelNormalRect;
    __weak Tao800CustomStatueBar* instance = self;
    if (self.hidden) {
        self.hidden = NO;
    }
    [UIView animateWithDuration:.4 animations:^() {
        instance.frame = instance.statusNormalRect;
    } completion:^(BOOL finish){
        if (autohide) {
            [instance performSelector:@selector(autoHide:) withObject:nil afterDelay:5];
            instance.autoHide = YES;
        }else{
            instance.animate = NO;
        }
    }];
    
}

- (void)autoHide:(id)sender{
    self.autoHide = NO;
    self.animate = NO;
    [self hide];
}

- (void)hide{
    if (self.animate) {
        return;
    }
    self.animate = YES;
    __weak Tao800CustomStatueBar* instance = self;
    //__weak UILabel* weakLabel = defaultLabel;
    //defaultLabel.frame = self.labelNormalRect;
    
    [UIView animateWithDuration:1 animations:^() {
        CGRect rectStart = instance.statusNormalRect;
        CGFloat h = rectStart.size.height;
        rectStart.origin.y = h;
        rectStart.size.height = 0;
        instance.frame = rectStart;
        
//        CGRect labRect = instance.labelNormalRect;
//        labRect.origin.y = labRect.size.height;
//        labRect.size.height = 0;
//        weakLabel.frame = labRect;
    } completion:^(BOOL finish){
        //instance.frame = CGRectZero;
        instance.animate = NO;
        instance.hidden = YES;
        //[instance removeFromSuperview];
    }];
}

@end
