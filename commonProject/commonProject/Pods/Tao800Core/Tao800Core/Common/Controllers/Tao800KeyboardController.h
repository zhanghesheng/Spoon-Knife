//
//  Tao800KeyboardController.h
//  universalT800
//
//  Created by enfeng on 13-11-20.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tao800KeyboardController : NSObject

@property (nonatomic, weak) UIView* view; 
@property (nonatomic) CGFloat offset;
@property (nonatomic) BOOL keyboardDisplayed;
@property (nonatomic) UIToolbar *toolbar;

@property (nonatomic) CGFloat viewOriginY;

- (id) initWithView:(UIView*) view scrollOffset:(CGFloat) offset;

- (UIToolbar*) getAccessoryView;

/**
 * 当键盘显示时调用
 * 每增加一次offset，会同时有个向上滚动的动画
 * 键盘隐藏时会从新恢复y坐标的初始值
 */
- (void) addOffset:(CGFloat) offset1 duration:(CGFloat) duration;

- (void)hideKeyboard;
@end
