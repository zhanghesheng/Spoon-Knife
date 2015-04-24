//
//  Tao800PageController.m
//  tao800
//
//  Created by enfeng on 14-3-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PageController.h"
#import "Tao800ShareVo.h"
#import "Tao800ForwardSegue.h"
#import "TBUI/TBUI.h"

@implementation Tao800PageController

@synthesize navigationController = _navigationController;

#pragma mark Singleton Methods

+ (id)shareInstance {
    static Tao800PageController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (UINavigationController *)navigationController {
    UIApplication *application = [UIApplication sharedApplication];
    UIViewController *viewCTL = application.keyWindow.rootViewController;

    UIViewController *ctl = nil;

    //先判断是不是弹出的model窗口
    ctl = viewCTL.presentedViewController;

    if (ctl) {
        viewCTL = ctl;
    }
    UIViewController *topViewCTL = viewCTL.topViewController;

    _navigationController = nil;
    if (topViewCTL.navigationController) {
        _navigationController = topViewCTL.navigationController;
    }

    return _navigationController;
}


@end
