//
//  Tao800ScreenTipView.h
//  testImageAnimate
//
//  Created by enfeng on 13-12-3.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Tao800ScreenTipViewDelegate;
@class Tao800RectangleBorderButton;

typedef enum {
    Tao800ScreenTipViewStyleDefault = 0,
    Tao800ScreenTipViewStyleContainButton
} TBBScreenTipViewStyle;

@interface Tao800ScreenTipView : UIView {
    TBBScreenTipViewStyle _style;
    
}
@property (nonatomic, weak) UIImageView *centerImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *subtitleLabel;
@property (nonatomic, weak) Tao800RectangleBorderButton *centerButton;
@property (nonatomic) int userTag;
@property (nonatomic, strong) NSObject *userData;

@property (nonatomic, weak) id<Tao800ScreenTipViewDelegate> delegate;

- (id) initWithTitle:(NSString*) title
            delegate:(id<Tao800ScreenTipViewDelegate>) delegate
               style:(TBBScreenTipViewStyle) style;

- (id) initWithTitle:(NSString*) title
            subtitle:(NSString*) subTitle
            delegate:(id<Tao800ScreenTipViewDelegate>) delegate
               style:(TBBScreenTipViewStyle) style;
@end

@protocol Tao800ScreenTipViewDelegate <NSObject>

- (void) didClickScreenTipView:(Tao800ScreenTipView *) messageView sender:(id) sender;

@end
