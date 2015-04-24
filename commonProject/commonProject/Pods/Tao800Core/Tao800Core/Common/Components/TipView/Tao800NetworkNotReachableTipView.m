//
//  Tao800NetworkNotReachableTipView.m
//  universalT800
//
//  Created by enfeng on 13-11-14.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800NetworkNotReachableTipView.h"
#import "Tao800FunctionCommon.h"
#import "Tao800StyleSheet.h"

#import <QuartzCore/QuartzCore.h>

#import "TBUI/TBUI.h"
#import "TBCore/TBCore.h"
#import "Tao800FunctionCommon.h"


CGFloat const TBBMessageViewVerticalGap = 20.0f;
CGFloat const TBBMessageViewLabelWidth = 220.0f;
CGFloat const TBBMessageViewBtnHeight = 22.0f;

#define TBBMessageViewFont [UIFont systemFontOfSize:14]

@interface Tao800NetworkNotReachableTipView() {
    CGFloat frameHeight;
}
- (void) closeSelf;
@end

@implementation Tao800NetworkNotReachableTipView

- (CGSize) getTextSize :(NSString*) text width:(CGFloat) width {
    CGSize size  = [text sizeWithFont:TBBMessageViewFont constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    return size;
}

- (void) handleClick {
    [self disSelf:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMessageView:)]) {
        [self.delegate didClickMessageView:self];
        //todo 点击关闭
        
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.leftImageView.frame;
    rect.size = CGSizeMake(TBBMessageViewBtnHeight, TBBMessageViewBtnHeight);

    CGFloat width = 0;

    if (!self.containRightButton) {
        self.rightImageView.hidden = YES;
        width = TBBMessageViewLabelWidth + 30;
    } else {
        width = TBBMessageViewLabelWidth;
    }

    CGSize labelSize = [self getTextSize:self.messageLabel.text width:width];
//    rect.origin.x = (self.frame.size.width - rect.size.width-labelSize.width)/2;
    rect.origin.x = 28;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.leftImageView.frame = rect;

    rect.origin.x = self.frame.size.width-10-TBBMessageViewBtnHeight;
    rect.size.width = 22;
    rect.size.height = 22;
    rect.origin.y = (self.frame.size.height - rect.size.height)/2;
    self.rightImageView.frame = rect;

    rect.size = labelSize;
    rect.origin.x = self.leftImageView.frame.origin.x + self.leftImageView.frame.size.width + 10;
    rect.origin.y = TBBMessageViewVerticalGap;
    self.messageLabel.frame = rect;

    CGFloat height = SuitOnePixelHeight();

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.bottomLineLayer.frame = CGRectMake(0, self.frame.size.height-height, self.frame.size.width, height);
    [CATransaction commit];
}

- (id) initWithTitle:(NSString*) title
            delegate:(id<TBBMessageViewDelegate>) delegate
               style:(TBBMessageViewStyle) style
            position:(TBBMessageViewPosition) position
  containRightButton:(BOOL) containRightButton {
    self = [super init];
    if (self) {
        frameHeight = TBBMessageViewVerticalGap*2;

        self.delegate = delegate;
        self.position = position;
        self.style = style;
        self.containRightButton = containRightButton;

        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        self.messageLabel = label;

        UIImageView *lImageView = [[UIImageView alloc] init];
        UIImageView *rImageView = [[UIImageView alloc] init];
        [self addSubview:lImageView];
        [self addSubview:rImageView];

        self.leftImageView = lImageView;
        self.rightImageView = rImageView;

        self.messageLabel.font = TBBMessageViewFont;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.backgroundColor = [UIColor clearColor];

        switch (style) {
            case TBBMessageViewStyleSuccess: {
                self.backgroundColor = [UIColor greenColor];
            }
                break;
            case TBBMessageViewStyleFailure:
                self.backgroundColor = [UIColor redColor];
                break;
            case TBBMessageViewStyleNotify:
                self.backgroundColor = [UIColor grayColor];
                break;
            case TBBMessageViewStyleWarning: {
                self.backgroundColor = [UIColor clearColor];
//                UIImage *imageDefault = TBIMAGE(@"bundle://v6_common_message_warning_bg@2x.png");
//                UIImage *imageHighlighted = TBIMAGE(@"bundle://v6_common_message_selected_bg@2x.png");
//                [self setBackgroundImage:imageDefault forState:UIControlStateNormal];
//                [self setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
                     self.backgroundColor = [UIColor orangeColor];
//                UIImage *image1 = TBIMAGE(@"bundle://v6_common_message_warning_btn@2x.png");
//                [self.leftImageView setImage:image1];
//                self.leftImageView.backgroundColor = [UIColor clearColor];
                UIImage *bgImage = TBIMAGE(@"bundle://common_navbar_bg@2x.png");
                self.layer.contents = (id) bgImage.CGImage;
                UIImage *image1 = TBIMAGE(@"bundle://message_no_network_close@2x.png");
                [self.rightImageView setImage:image1];
                self.rightImageView.backgroundColor = [UIColor clearColor];

                self.messageLabel.textColor =[UIColor colorWithHex:0x986D47];
            }
                break;
            default:
                break;
        }

//        UIImage *image1 = TBIMAGE(@"bundle://v6_common_right_orange_arrow@2x.png");
//        [self.rightImageView setImage:image1];
//        self.rightImageView.backgroundColor = [UIColor clearColor];

        self.messageLabel.text = title;
        CGFloat width = 0;

        if (!self.containRightButton) {
            self.rightImageView.hidden = YES;
            width = TBBMessageViewLabelWidth + 30;
        } else {
            width = TBBMessageViewLabelWidth;
        }

        CGSize size = [self getTextSize:title width:width];
        frameHeight = frameHeight + size.height;
        self.userInteractionEnabled = YES;

        self.leftImageView.userInteractionEnabled = NO;
        self.messageLabel.userInteractionEnabled = NO;
        self.rightImageView.userInteractionEnabled = NO;

        [self addTarget:self action:@selector(handleClick) forControlEvents:UIControlEventTouchUpInside];

        CALayer *layer1 = [CALayer layer];
        [self.layer addSublayer:layer1];
        self.bottomLineLayer = layer1;
        self.bottomLineLayer.backgroundColor = [UIColor colorWithHex:0xDDC8B7].CGColor;
    }
    return self;
}

- (void) disSelf:(BOOL) show {
    UIScreen* screen = [UIScreen mainScreen];
//    BOOL needResetY = NeedResetUIStyleLikeIOS7();
    int detaY = 0;
//    if (needResetY) {
//        detaY = 20;
//    }

    detaY = 20;


    [UIView animateWithDuration:.3  animations:^{
        if (show) {

            CGFloat windowY = 0;

            switch (self.position) {
                case TBBMessageViewPositionTop:
                    windowY = detaY;
                    break;
                case TBBMessageViewPositionBottom:
                    windowY = screen.bounds.size.height - frameHeight;
                    break;
                default:
                    break;
            }
            CGRect r2 = self.frame;
            r2.origin.y = windowY;
            self.frame = r2;
        } else {
            CGFloat windowY = 0;

            switch (self.position) {
                case TBBMessageViewPositionTop:
                    windowY = -frameHeight;
                    break;
                case TBBMessageViewPositionBottom:
                    windowY = screen.bounds.size.height;
                    break;
                default:
                    break;
            }
            CGRect r2 = self.frame;
            r2.origin.y = windowY;
            self.frame = r2;
        }
    } completion:^(BOOL finish) {
        if (finish && !show) {
            [self removeFromSuperview];
        }
    }];
}

- (void) closeSelf {
    [self disSelf:NO];
}

- (void) show {
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [application keyWindow];

    UIView *pView = [window viewWithTag:Tao800NetworkNotReachableTipViewTag];
    if (pView) {
        //只显示一个提示
        return;
    }

    UIScreen* screen = [UIScreen mainScreen];
    CGFloat width = screen.bounds.size.width;
    CGFloat windowY = 0;

    switch (self.position) {
        case TBBMessageViewPositionTop:
            windowY = -frameHeight;
            break;
        case TBBMessageViewPositionBottom:
            windowY = screen.bounds.size.height;
            break;
        default:
            break;
    }

    CGRect rect = CGRectMake(0, windowY, width, frameHeight);
    self.frame = rect;

    self.tag = Tao800NetworkNotReachableTipViewTag;
    [window addSubview:self];

    [self disSelf:YES];
}

- (void) dismissMessageView {
    [self disSelf:NO];
}

@end