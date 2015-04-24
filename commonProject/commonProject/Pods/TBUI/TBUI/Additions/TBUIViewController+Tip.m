//
//  TBUIViewController+Tip.m
//  TBUI
//
//  Created by enfeng on 13-9-4.
//  Copyright (c) 2013年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBUIViewController+Tip.h"
#import <objc/runtime.h>
#import "TBActivityLabel.h"

#import "TBCore/TBCoreCommonFunction.h"
#import "TBUI.h"

@implementation UIViewController (Tip)

- (BOOL)isLoadingViewExists {
    MBProgressHUD *progressLoading = (MBProgressHUD *) [self.view viewWithTag:TBProgressLoadingTag];
    if (progressLoading && progressLoading.alpha > 0) {
        return YES;
    }
    return NO;
}

- (UIWindow *)window {
    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *arr = app.windows;
//    for (UIWindow *win in arr) {
//        const char *className = class_getName([win class]);
//        NSString *sName = [NSString stringWithUTF8String:className];
//        //避免loading被键盘盖住, 需要调用端先隐藏键盘
//        if ([sName isEqualToString:@"UITextEffectsWindow"]) {
//            return win;
//        }
//    }
    return [app.windows objectAtIndex:0];
}

- (void)showLoadingView:(NSString *)message {
    MBProgressHUD *progressLoading = (MBProgressHUD *) [self.view viewWithTag:TBProgressLoadingTag];
    if (progressLoading == nil) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.tag = TBProgressLoadingTag;
        [self.view addSubview:hud];
        progressLoading = (MBProgressHUD *) [self.view viewWithTag:TBProgressLoadingTag];
    }
    progressLoading.labelText = message;
    [progressLoading show:YES];
    progressLoading.frame = self.view.bounds;
//    progressLoading.backgroundColor = [UIColor purpleColor];
    [self.view bringSubviewToFront:progressLoading];
}

- (void)showEmpty:(BOOL)show alertMsg:(NSString *)msg {

}

- (void)showLoading:(BOOL)show {
    TBActivityLabel *label1 = (TBActivityLabel *) [self.view viewWithTag:TBLoadingActivityLabelTag];
    if (show) {
        if (label1) {
            [self.view bringSubviewToFront:label1];
            return;
        }
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        rect.size.height = rect.size.height - 42;

        BOOL ret = NeedResetUIStyleLikeIOS7();
        if (ret) {
            rect.origin.y = TBDefaultStatusBarHeight + TBDefaultPortraitToolbarHeight;
        }

        CGRect r2 = [self getLoadingRect];
        if (r2.size.width>1) {
            rect = r2;
        }

        TBActivityLabel *label =
                [[TBActivityLabel alloc] initWithFrame:rect
                                                 style:UIActivityIndicatorViewStyleGray
                                                  text:@"正在加载..."];
        label.backgroundColor = self.view.backgroundColor;
        label.tag = TBLoadingActivityLabelTag;

        [self.view addSubview:label];
    } else {
        if (label1) {
            [label1 removeFromSuperview];
        }
    }
}

- (void)hideLoadingView {
    MBProgressHUD *progressLoading = (MBProgressHUD *) [self.view viewWithTag:TBProgressLoadingTag];
    if (progressLoading) {
        [progressLoading hide:NO];
    }
}

- (UIInterfaceOrientation)currentOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (void)showTip:(NSString *)message imageName:(NSString *)imageName {
    UIImageView *imageView;
    if (imageName == nil) {
        imageView = [[UIImageView alloc] init];
    } else {
        imageView = [[UIImageView alloc] initWithImage:TBIMAGE(imageName)];
    }
//    self.window.windowLevel = UIWindowLevelNormal;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.window];
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    if (message.length>16) {
        hud.labelText = @"";
        hud.detailsLabelText = message;
    } else {
        hud.labelText = message;
    }

    hud.tag = TBMessageTipTag;
    [self.window addSubview:hud];

    hud.bounds = self.window.bounds;

    [hud show:YES];
    hud.alpha = .7;
    [hud hide:YES afterDelay:2];
    [self.window bringSubviewToFront:hud];
}

- (void)showErrorTip:(NSString *)message {
    MBProgressHUD *tip = (MBProgressHUD *) [self.window viewWithTag:TBMessageTipTag];
    if (tip) {
        return;
    }
    [self showTip:message imageName:@"bundle://network_error.png"];
}

- (void)showFailTip:(NSString *)message {
    MBProgressHUD *tip = (MBProgressHUD *) [self.window viewWithTag:TBMessageTipTag];
    if (tip) {
        return;
    }
    [self showTip:message imageName:@"bundle://tip_error.png"];
}

- (void)showSuccessTip:(NSString *)message {
    MBProgressHUD *tip = (MBProgressHUD *) [self.window viewWithTag:TBMessageTipTag];
    if (tip) {
        return;
    }
    [self showTip:message imageName:@"bundle://tip_ok.png"];
}

- (void)showTextTip:(NSString *)message {
    MBProgressHUD *tip = (MBProgressHUD *) [self.window viewWithTag:TBMessageTipTag];
    if (tip) {
        return;
    }
    [self showTip:message imageName:nil];
}

- (void)hideTip {
    MBProgressHUD *tip = (MBProgressHUD *) [self.window viewWithTag:TBMessageTipTag];
    if (tip) {
        [tip hide:NO];
    }
}

- (BOOL)isTipExits {
    MBProgressHUD *tip = (MBProgressHUD *) [self.window viewWithTag:TBMessageTipTag];
    if (tip) {
        return YES;
    }
    return NO;
}

- (UIViewController *)topViewController {
    UIViewController *controller;
    if (self.navigationController) {
        controller = self.navigationController;
        if (self.navigationController.topViewController) {
            return self.navigationController.topViewController;
        }
    } else {
        controller = self;
    }
    UIViewController *ctl = self.presentedViewController;
    if (ctl) {
        return ctl;
    }

    return controller;
}

- (void) assignParamDict:(NSDictionary *) sParamDict {}

- (CGRect) getLoadingRect {
    return CGRectZero;
}
@end
