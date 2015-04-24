//
//  Tao800CustomStatueBar.h
//  tao800
//
//  Created by Rose on 15/1/8.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Tao800CustomStatueBarDelegate;
@interface Tao800CustomStatueBar : UIWindow
{
    UILabel *defaultLabel;
}
@property(nonatomic,weak) id<Tao800CustomStatueBarDelegate> barDelegate;
- (void)showStatusMessage:(NSString *)message autoHide:(BOOL)autohide;
- (void)hide;
- (void)cancelMethod;
@end

@protocol Tao800CustomStatueBarDelegate <NSObject>
-(void)touchStatusBar;
@end
