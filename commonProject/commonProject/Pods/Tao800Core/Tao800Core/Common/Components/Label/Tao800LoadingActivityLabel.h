//
//  Tao800LoadingActivityLabel.h
//  tao800
//
//  Created by enfeng on 14-3-6.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tao800ActivityIndicatorView.h"
 
@interface Tao800LoadingActivityLabel : UIView {
    Tao800ActivityIndicatorView *_activityIndicator;
    UILabel *_label;
    
    UIImageView *_centerImageView;
}
@property(nonatomic, readonly) UILabel *label;
@property(nonatomic, weak) UILabel *subLabel;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style text:(NSString *)text;
@end