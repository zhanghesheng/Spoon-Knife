//
//  TBUINavigationController.m
//  TS
//
//  Created by Coneboy_K on 13-12-2.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.  MIT
//  WELCOME TO MY BLOG  http://www.coneboy.com
//


#import "TBUINavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "TBUICommon.h"
#import "TBBaseViewCTL.h"
#import "UIViewAdditions.h"
#import "TBCore/TBCoreCommonFunction.h"
#import "TBUINotifycationConstant.h"

@interface TBUINavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;

}

@property (nonatomic,strong) UIView *backgroundView;


@property (nonatomic,assign) BOOL isMoving;
- (void)takeScreenshot:(UIViewController*) topVCL;
@end

@implementation TBUINavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = NO;
        
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = NO;

    }
    return self;
}


- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(TBIsPad()) return;
    
    self.recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                       action:@selector(paningGestureReceive:)];
    [_recognizer delaysTouchesBegan];
    self.recognizer.enabled = NO;
    [self.view addGestureRecognizer:_recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(TBIsPad()){
        [super pushViewController:viewController animated:animated];
    }else{
        UIViewController *topVCL = self.topViewController;
        if (topVCL) {
            [self takeScreenshot:topVCL];
        } else {
            //初始化 root
        }
        
        [super pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (TBIsPad()) {
        return [super popViewControllerAnimated:animated];
    }
    else {
        [self.screenShotsList removeLastObject];
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;

        TBBaseViewCTL *viewCTL = (TBBaseViewCTL *) self.topViewController;
        if ([viewCTL isKindOfClass:[TBBaseViewCTL class]] && !viewCTL.isModelViewCTL) {
            TBNotify(TBBaseViewCTLWillGobackNotifyCation, nil, viewCTL.paramDict);
            NSDictionary *dict = [viewCTL.goBackParams copy];
            if (viewCTL.goBackBlock) {
                [viewCTL preBackBlock];
                viewCTL.goBackBlock(NO, dict);
            }
            //return [viewCTL goBack:animated];
        }
        
        return [super popViewControllerAnimated:animated];
    }
}

#pragma mark - Utility Methods -

//- (void)takeScreenshot:(UIViewController *)topVCL {
//    if (TBIsIphone4OrLess()) {
//        __weak TBUINavigationController *instance = self;
//
//        dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//        dispatch_async(mainQueue, ^(void) {
//
//            UIGraphicsBeginImageContextWithOptions(topVCL.view.bounds.size, NO, 0);
//            [topVCL.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [instance.screenShotsList addObject:img];
//            });
//        });
//    } else {
//        UIGraphicsBeginImageContextWithOptions(topVCL.view.bounds.size, NO, 0);
//        [topVCL.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [self.screenShotsList addObject:img];
//    }
//}

- (void)takeScreenshot:(UIViewController *)topVCL {

    __weak TBUINavigationController *instance = self;
    UIView *paramView = topVCL.view;

    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //create a async call on the background queue
    dispatch_async(globalQueue, ^{
        CGFloat scaleFactor = [[UIScreen mainScreen] scale];
        NSUInteger width = (NSUInteger)paramView.frame.size.width * (NSUInteger) scaleFactor;
        NSUInteger height = (NSUInteger)paramView.frame.size.height * (NSUInteger) scaleFactor;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(
                nil,
                width,
                height,
                bitsPerComponent,
                bytesPerRow,
                colorSpace,
                (CGBitmapInfo)kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

        CGContextTranslateCTM(context, 0.0, height);
        CGContextScaleCTM(context, scaleFactor, -scaleFactor);

        //render the layer and its subviews
        [paramView.layer renderInContext:context];

        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        UIImage *image = [UIImage imageWithCGImage:cgImage];

        CGImageRelease(cgImage);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);

        dispatch_async(dispatch_get_main_queue(), ^{
            [instance.screenShotsList addObject:image];
        });
    });
}

- (void)moveViewWithX:(float)x
{
    CGFloat width1 = self.view.width;
    x = x>width1?width1:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/800);

    blackMask.alpha = alpha;

    CGFloat aa = abs(startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;
    
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    CGFloat lastScreenShotViewHeight = lastScreenShot.size.height/scaleFactor;
    CGFloat superviewHeight = lastScreenShotView.superview.frame.size.height;
    CGFloat verticalPos = superviewHeight - lastScreenShotViewHeight;

    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            verticalPos,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];
}



-(BOOL)isBlurryImg:(CGFloat)tmp
{
    return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if(TBIsPad()) return;
    
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
       
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        startBackViewX = startXX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];

        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:self.view.width];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}



@end



