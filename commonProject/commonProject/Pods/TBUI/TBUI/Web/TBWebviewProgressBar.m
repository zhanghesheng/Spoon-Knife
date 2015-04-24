//
// Created by enfeng on 13-5-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBWebViewProgressBar.h"
#import "TBCore/TBCoreCommonFunction.h"

CGFloat const DefaultProgressarValue = 0.1f;

@implementation TBWebViewProgressBar

- (void)drawRect:(CGRect)rect {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapSquare);

    CGRect progressRect = rect;

    //change bar width on progress value (%)
    progressRect.size.width *= [self progress];

    //Fill color
    CGContextSetFillColorWithColor(ctx, [_tintColor CGColor]);
    CGContextFillRect(ctx, progressRect);

    //Hide progress with fade-out effect
//    if (self.progress == 1.0f) {
//        [self performSelector:@selector(hideWithFadeOut) withObject:nil afterDelay:.3];
//    }

}

- (void)hideWithFadeOut:(void (^)(BOOL finish))complete {
    //initialize fade animation 
//    CATransition *animation = [CATransition animation];
//    animation.type = kCATransitionFade;
//    animation.duration = 0.5;
//    [self.layer addAnimation:animation forKey:nil];
//
//    //Do hide progress bar
//    self.hidden = YES;

    [UIView animateWithDuration:1.0
            animations:^{
                self.alpha = 0.0;
            } completion:complete];
}

- (void)setProgress:(CGFloat)value animated:(BOOL)animated {
    if (value < DefaultProgressarValue && value > 0) {
        return;
    }
    if ((!animated && value > self.progress) || animated) {
        self.progress = value;
    }
}

- (TBWebViewProgressBar *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //set bar color
        _tintColor = [UIColor colorWithRed:51.0f / 255.0f
                                      green:153.0f / 255.0f
                                       blue:255.0f / 255.0f
                                      alpha:1];
        self.progress = 0;
        if (RequireSysVerGreaterOrEqual(@"5")) {
            self.trackTintColor = [UIColor clearColor];
        }
    }

    return self;
}

- (void) setProgress2:(NSNumber*)value {
    float pStep = [value floatValue];
    if (pStep < self.progress && pStep > 0) {
        return;
    }
    if (pStep<0.1) {

        self.progress = pStep;
        pStep = pStep + 0.01;
        NSNumber *num = [NSNumber numberWithDouble:pStep];

        [self performSelector:@selector(setProgress2:) withObject:num afterDelay:0.03];
    }
}

- (void)dealloc {
   
}
@end
