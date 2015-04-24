//
//  Tao800PageLoadingAnimation.h
//  Tao800Core
//
//  Created by suminjie on 15/2/13.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TBUI/TBUI.h>

@interface Tao800PageLoadingAnimation : UIView
@property(nonatomic,weak) TBImageView* animationView;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
