//
//  Tao800PageLoadingView.h
//  Tao800Core
//
//  Created by suminjie on 15/2/13.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TBUI/TBUI.h>
#import "Tao800PageLoadingAnimation.h"

@interface Tao800PageLoadingView : UIView
@property(nonatomic,strong) TBImageView* leftImageView;
@property(nonatomic,strong) TBImageView* rightImageView;
@property(nonatomic,strong) TBImageView* midImageView;

@property(nonatomic,strong) UILabel* leftLabel;
@property(nonatomic,strong) UILabel* rightLabel;
@property(nonatomic,strong) UILabel* midLabel;
@property(nonatomic,strong) Tao800PageLoadingAnimation* loadingAnimation;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style text:(NSString *)text;

- (void)stopAnimating;
@end
