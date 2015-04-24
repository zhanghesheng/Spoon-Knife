//
//  Tao800KeyboardController.m
//  universalT800
//
//  Created by enfeng on 13-11-20.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800KeyboardController.h"
#import "TBUI/TBUI.h"

CGFloat const TBBToolbarHeight = 44;

@interface Tao800KeyboardController () {
    CGFloat refundKeyboardHeight;

}

@end

@implementation Tao800KeyboardController

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.keyboardDisplayed) {
        self.viewOriginY = self.view.frame.origin.y;
    } else {
        return;
    }
    self.keyboardDisplayed = YES;

    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    refundKeyboardHeight = keyboardFrameBeginRect.size.height;

    /*
     保持和键盘动画同步
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [UIView animateWithDuration:animationDuration animations:^() {

        CGRect rect = self.view.frame;
        rect.origin.y = -self.offset;
        self.view.frame = rect;
    }];

}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.keyboardDisplayed) {
        return;
    }
    self.keyboardDisplayed = NO;
    NSDictionary *userInfo = [notification userInfo];

    /*
     保持和键盘动画同步
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^() {

        CGRect rect = self.view.frame;
        rect.origin.y = self.viewOriginY;
        self.view.frame = rect;
    }];
}

- (void)addOffset:(CGFloat)offset1 duration:(CGFloat)duration {
    if (!self.keyboardDisplayed) {
        return;
    }

    [UIView animateWithDuration:duration animations:^() {

        CGRect rect = self.view.frame;
        rect.origin.y = rect.origin.y - offset1;
        self.view.frame = rect;
    }];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (UIToolbar *)getAccessoryView {
    if (self.toolbar) {
        return self.toolbar;
    }
    UIScreen *screen = [UIScreen mainScreen];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,
            screen.bounds.size.width,
            TBDefaultRowHeight)];

    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;

    UIBarButtonItem *itemHidden = [[UIBarButtonItem alloc] initWithTitle:@"隐藏"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(hideKeyboard)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSArray *arr = [NSArray arrayWithObjects:spaceItem, itemHidden, nil];
    toolbar.items = arr;

    self.toolbar = toolbar;
    return toolbar;
}

- (id)initWithView:(UIView *)view scrollOffset:(CGFloat)offset {
    self = [super init];
    if (self) {
        refundKeyboardHeight = 0;
        self.view = view;
        self.offset = offset;
        self.viewOriginY = 0;

        UIView *superView = view.superview;
        if (superView) {

        }

        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(keyboardWillShow:)
                       name:UIKeyboardWillShowNotification
                     object:nil];
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(keyboardWillHide:)
                       name:UIKeyboardWillHideNotification
                     object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
