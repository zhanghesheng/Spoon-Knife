//
// Created by enfeng on 13-2-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBNavigatorItem : NSObject {
    NSArray *_leftBarButtonItems;
    NSArray *_rightBarButtonItems;

    UIView *_titleView;
    NSString *_title;

    UIBarButtonItem *_leftBarButtonItem;
    UIBarButtonItem *_rightBarButtonItem;
}
@property(nonatomic, strong) NSArray *leftBarButtonItems;
@property(nonatomic, strong) NSArray *rightBarButtonItems;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@end


@interface TBNavigatorView : UIView {
@private
    TBNavigatorItem *_navigatorItem;

    CGFloat _leftPadding;
    CGFloat _rightPadding;

    NSArray *_navigatorItemPropertyNames;

    UIView *_leftView;
    UIView *_rightView;
    UIView *_titleView;

    BOOL _displayShadow;
    UIFont *_titleFont;
    UIFont *_buttonFont;
}
@property(nonatomic, strong) TBNavigatorItem *navigatorItem;
@property(nonatomic) CGFloat leftPadding;
@property(nonatomic) CGFloat rightPadding;
@property(nonatomic) BOOL displayShadow;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIFont *buttonFont;
@property(nonatomic, strong) UIColor *titleColor;


@end