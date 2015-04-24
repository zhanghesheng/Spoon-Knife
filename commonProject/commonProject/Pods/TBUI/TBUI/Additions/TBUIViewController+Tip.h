//
//  TBUIViewController+Tip.h
//  TBUI
//
//  Created by enfeng on 13-9-4.
//  Copyright (c) 2013年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    TBProgressLoadingTag = 103900,
    TBLoadingActivityLabelTag,
    TBPageLoadingViewTag,
    TBMessageTipTag
};

@interface UIViewController(Tip)


- (BOOL)isLoadingViewExists;

- (void)showLoadingView:(NSString *)message;

- (void)hideLoadingView;

- (void)showTip:(NSString *)message imageName:(NSString *)imageName;

/**
* 显示提示信息
*/
- (void)showErrorTip:(NSString *)message;

- (void)showFailTip:(NSString *)message;

- (void)showSuccessTip:(NSString *)message;

- (void)showTextTip:(NSString *)message;

- (BOOL) isTipExits;

- (void)hideTip;

- (UIViewController *)topViewController;

- (UIWindow *)window;

/**
* 需要子类重写改方法
*/
- (void)showEmpty:(BOOL)show alertMsg:(NSString *)msg;

/**
* 需要子类重写改方法
*/
- (void)showLoading:(BOOL)show;

- (void) assignParamDict:(NSDictionary *) sParamDict;

- (CGRect) getLoadingRect;
@end
