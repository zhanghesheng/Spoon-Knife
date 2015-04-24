//
//  TBActivityLabel.h
//  TBUI
//
//  Created by enfeng on 12-11-23.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    TBActivityLabelStyleDefault = 0,
    TBActivityLabelStyleCustom
}  TBActivityLabelStyle ;

@interface TBActivityLabel : UIView {
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_label;

    TBActivityLabelStyle _lableStyle;
    UIImageView *_centerImageView;
}
@property(nonatomic, readonly) UILabel *label;
@property (nonatomic, readonly) UIImageView *centerImageView;

@property(nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style text:(NSString *)text;

- (id)initWithStyle:(UIActivityIndicatorViewStyle)style;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images imgWidth:(CGFloat) imgWidth imgHeight:(CGFloat)imgHeight text:(NSString *)text;
@end
