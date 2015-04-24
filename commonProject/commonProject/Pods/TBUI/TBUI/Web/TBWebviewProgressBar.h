//
// Created by enfeng on 13-5-9.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class UIProgressView;

@interface TBWebViewProgressBar : UIProgressView {
    UIColor *_tintColor;
}


- (TBWebViewProgressBar *)initWithFrame:(CGRect)frame;

- (void)setProgress:(CGFloat)value animated:(BOOL)animated;

- (void)hideWithFadeOut:(void (^)(BOOL finish))complete;

- (void)setProgress2:(NSNumber *)value;
@end
