//
//  Tao800NewScreenTipView.h
//  tao800
//
//  Created by Rose on 15/1/6.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800RectangleBorderButton.h"
//@interface Tao800NewScreenTipView : NSObject
//
//@end


@protocol Tao800NewScreenTipViewDelegate;
@class Tao800RectangleBorderButton;

typedef enum {
    Tao800NewScreenTipViewStyleDefault = 0,
    Tao800NewScreenTipViewStyleContainButton
} Tao800NewScreenTipViewStyle;

@interface Tao800NewScreenTipView : UIView {
    Tao800NewScreenTipViewStyle _style;
    
}
@property (nonatomic, weak) UIImageView *centerImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *subtitleLabel;
@property (nonatomic, weak) Tao800RectangleBorderButton *centerButton;
@property (nonatomic) int userTag;
@property (nonatomic, strong) NSObject *userData;

@property (nonatomic, weak) id<Tao800NewScreenTipViewDelegate> delegate;

- (id) initWithTitle:(NSString*) title
            delegate:(id<Tao800NewScreenTipViewDelegate>) delegate
               style:(Tao800NewScreenTipViewStyle) style;

- (id) initWithTitle:(NSString*) title
            subtitle:(NSString*) subTitle
            delegate:(id<Tao800NewScreenTipViewDelegate>) delegate
               style:(Tao800NewScreenTipViewStyle) style;
@end

@protocol Tao800NewScreenTipViewDelegate <NSObject>

- (void) didClickScreenTipView:(Tao800NewScreenTipView *) messageView sender:(id) sender;
@optional
- (void) didClickButton:(Tao800NewScreenTipView *) messageView sender:(id) sender;
@end
