//
//  EFAlertView.h
//  testImageAnimate
//
//  Created by enfeng on 13-12-2.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EFAlertViewDelegate;

typedef enum _EFAlertViewStyle {
    EFAlertViewStyleDefault,
    EFAlertViewStyleWithCheckBtn
} EFAlertViewStyle;

@interface EFAlertView : UIView {
    __weak UIButton *_checkBtn;
    __weak UILabel *_detailLabel;

}
@property(nonatomic, weak) id <EFAlertViewDelegate> delegate;
@property(nonatomic, weak) UIButton *checkBtn;
@property(nonatomic, weak) UILabel *detailLabel;

@property(nonatomic) BOOL enableClose;

/**
 *
 *
 
 EFAlertView *alertView = [[EFAlertView alloc] initWithTitle:@"标题"
 detail:@"仅仅是一个测试而已，你觉得怎么样？"
 delegate:Nil
 style:EFAlertViewStyleWithCheckBtn
 buttonTitles:@"确定",@"取消",  nil];
 [alertView show];
 */

- (id)initWithTitle:(NSString *)title
             detail:(NSString *)detail
           delegate:(id <EFAlertViewDelegate>)delegate
              style:(EFAlertViewStyle)style
       buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle2:(NSString *)title
              detail:(NSString *)detail
            delegate:(id <EFAlertViewDelegate>)delegate
               style:(EFAlertViewStyle)style
        buttonTitles:(NSArray *)buttonTitles;

- (void)show;

- (void)close;

- (void) close:(CGFloat)animateWithDuration completion:(void (^)(void))completion;

-(void)resetTitleWithColor:(UIColor *)color withFont:(UIFont *)font;
@end


@protocol EFAlertViewDelegate <NSObject>
@optional
- (void)EFAlertView:(EFAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end