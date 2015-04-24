//
//  Tao800NavigationVCL.m
//  tao800
//
//  Created by enfeng on 12-10-18.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800NavigationVCL.h"
#import "Tao800DataModelSingleton.h"

@interface Tao800NavigationVCL ()

@end

@implementation Tao800NavigationVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canDragBack = YES;
    
    self.recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(paningGestureReceive:)];
    [self.recognizer delaysTouchesBegan];
    self.recognizer.delegate = (id <UIGestureRecognizerDelegate>) self;
    [self.view addGestureRecognizer:self.recognizer];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gestureRecognizer;
    
    if ([Tao800DataModelSingleton sharedInstance].isSlip) {
        return NO;
    }
    
    CGPoint translation = [panGesture translationInView:self.view];
    
    if (!([panGesture velocityInView:self.view].x < 600 && sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1)) {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
