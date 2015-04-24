//
//  Tao800ActivityLabel.h
//  universalT800
//
//  Created by enfeng on 13-12-10.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tao800ActivityIndicatorView.h"
#import "TBUI/TBUI.h"

@interface Tao800ActivityLabel : UIView {
}
@property(nonatomic, weak) UILabel *label;
@property(nonatomic, weak) Tao800ActivityIndicatorView *activityIndicatorView;
@property(nonatomic) BOOL isAnimating;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text;

- (void)startAnimating;

- (void)stopAnimating;
@end
