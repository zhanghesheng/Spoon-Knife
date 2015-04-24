//
//  Tao800AlertView.h
//  tao800
//
//  Created by Rose on 15/1/4.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "Tao800AlertGreetingView.h"
#import "Tao800AlertCheckBox.h"

@class Tao800AlertTableView;
@protocol Tao800AlertViewDelegate;

typedef enum : NSUInteger {
    Tao800GreetingStyleChanPin = 1,
    Tao800GreetingStyleYanFa = 2,
} Tao800GreetingStyle;

typedef enum _Tao800AlertViewStyle {
    Tao800AlertViewStyleDefault,
    Tao800AlertViewStyleWithCheckBtn
} Tao800AlertViewStyle;

@interface Tao800AlertView : UIView {
    Tao800AlertCheckBox *_checkBtn;
    __weak UILabel *_detailLabel;
}

@property(nonatomic, weak) id <Tao800AlertViewDelegate> delegate;
@property(nonatomic, strong) Tao800AlertCheckBox *checkBtn;
@property(nonatomic, weak) UILabel *detailLabel;
@property(nonatomic, weak) Tao800AlertGreetingView* greetingView;
@property(nonatomic, weak) Tao800AlertTableView* alertTableView;
@property(nonatomic) BOOL enableClose;

/**
 *
 *
 
 Tao800AlertView *alertView = [[Tao800AlertView alloc] initWithTitle:@"标题"
 detail:@"仅仅是一个测试而已，你觉得怎么样？"
 delegate:Nil
 style:Tao800AlertViewStyleWithCheckBtn
 buttonTitles:@"确定",@"取消",  nil];
 [alertView show];
 */

- (id)initWithTitle:(NSString *)title
             detail:(NSString *)detail
           delegate:(id <Tao800AlertViewDelegate>)delegate
              style:(Tao800AlertViewStyle)style
       buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle2:(NSString *)title
              detail:(NSString *)detail
            delegate:(id <Tao800AlertViewDelegate>)delegate
               style:(Tao800AlertViewStyle)style
        buttonTitles:(NSArray *)buttonTitles;

- (void)show;

- (void)close;

- (void) close:(CGFloat)animateWithDuration completion:(void (^)(void))completion;

- (void)greetingStyleSet:(Tao800GreetingStyle) style;
@end


@protocol Tao800AlertViewDelegate <NSObject>
@optional
- (void)Tao800AlertView:(Tao800AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

//////////////////////////////////////////////////////////////////////////////////////
#pragma  mark  --- Tao800AlertTableView -------

typedef enum : NSUInteger {
    //tableview最高限制在130
    Tao800AlertTableViewMinHeight = 37,
    Tao800AlertTableViewMaxHeight = 132,
} Tao800AlertTableEnum;

@interface Tao800AlertTableView : UITableView<UITableViewDataSource, UITableViewDelegate> {
}
@property(nonatomic, strong) NSMutableArray *itemListArray;
@property(nonatomic,strong) NSString* word;
@property(nonatomic)Tao800AlertTableEnum cellHeight;

+ (CGSize)dynamicHeight:(CGFloat)width font:(UIFont*)theFont text:(NSString*)text;
@end

@interface Tao800AlertTableItem : NSObject {
}
@property(nonatomic,strong)NSString* word;
@property(nonatomic) NSTextAlignment textAlignment;
@end

@interface Tao800AlertTableCell : UITableViewCell

@property (nonatomic, strong) NSObject *item;
@property (nonatomic, strong) UILabel *itemTextLabel;
@property (nonatomic,strong) NSString* word;
- (void) setObject:(NSObject*)obj;
- (void) setObjectWord:(NSString*)objWord;
@end
