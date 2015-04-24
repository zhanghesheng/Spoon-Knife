//
//  Tao800LoadingView.h
//  tao800
//
//  Created by enfeng on 14-4-17.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Tao800LoadingViewCloseCallback)(void);

@class Tao800LoadingActivityLabel;

@interface Tao800LoadingView : UIView {

}

@property(nonatomic, weak) UIButton *closeButton;

@property(nonatomic, weak) Tao800LoadingActivityLabel *activityLabel; //黑色半透明
@property(nonatomic, copy) Tao800LoadingViewCloseCallback closeCallback;

/**
* @param subText 可以为nil
*/
- (id)initWithFrame:(CGRect)frame text:(NSString *)text subText:(NSString *)subText;
@end
