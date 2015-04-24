//
//  Tao800NetworkNotReachableTipView.h
//  universalT800
//
//  Created by enfeng on 13-11-14.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBUI.h"


@protocol TBBMessageViewDelegate;

typedef enum {
    TBBMessageViewStyleSuccess = 0,
    TBBMessageViewStyleFailure,
    TBBMessageViewStyleNotify,
    TBBMessageViewStyleWarning,
} TBBMessageViewStyle;

typedef enum {
    TBBMessageViewPositionTop = 0,
    TBBMessageViewPositionBottom,
} TBBMessageViewPosition;

typedef enum {
    TBBMessageViewStateShowing = 0,
    TBBMessageViewStateHiding,
    TBBMessageViewStateMovingForward,
    TBBMessageViewStateMovingBackward,
    TBBMessageViewStateVisible,
    TBBMessageViewStateHidden
} TBBMessageViewState;

enum {
    Tao800NetworkNotReachableTipViewTag = 2329944
};
@interface Tao800NetworkNotReachableTipView : UIButton


@property (nonatomic , weak) id<TBBMessageViewDelegate> delegate;
@property (nonatomic) TBBMessageViewPosition position;
@property (nonatomic) TBBMessageViewStyle style;
@property (nonatomic) BOOL containRightButton;

@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *rightImageView;
@property (nonatomic, weak) UILabel *messageLabel;

@property (nonatomic, weak) CALayer *bottomLineLayer;

- (id) initWithTitle:(NSString*) title
            delegate:(id<TBBMessageViewDelegate>) delegate
               style:(TBBMessageViewStyle) style
            position:(TBBMessageViewPosition) position
  containRightButton:(BOOL) containRightButton;

/**
 *
 TBBMessageView *mView = [[TBBMessageView alloc]
 initWithTitle:@"喜欢我们的应用吗？去appstore打个分吧。产品经理的季度奖就靠大家喽~"
 delegate:self
 style:TBBMessageViewStyleWarning
 position:TBBMessageViewPositionTop
 containRightButton:YES];

 [mView show];
 */
- (void) show;

- (void) dismissMessageView;
@end

@protocol TBBMessageViewDelegate <NSObject>

- (void) didClickMessageView:(Tao800NetworkNotReachableTipView*) messageView;

@end
