//
//  Tao800LoadingView.m
//  tao800
//
//  Created by enfeng on 14-4-17.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800LoadingView.h"
#import "Tao800ActivityIndicatorView.h"
#import "Tao800LoadingActivityLabel.h"
#import "Tao800DataModelSingleton.h"
#import <QuartzCore/QuartzCore.h>
#import <TBUI/UIViewAdditions.h>
#import "TBUI/TBUI.h"

@implementation Tao800LoadingView

- (void)handlerButtonTap:(id)sender {
    if (self.closeCallback) {
        self.closeCallback();
    }
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text subText:(NSString *)subText {
    self = [super initWithFrame:frame];
    if (self) {
        Tao800LoadingActivityLabel *loadingActivityLabel = [[Tao800LoadingActivityLabel alloc] initWithFrame:CGRectZero
                                                                                                       style:UIActivityIndicatorViewStyleWhiteLarge
                                                                                                        text:text];
        self.activityLabel = loadingActivityLabel;
        [self addSubview:loadingActivityLabel];

        loadingActivityLabel.layer.cornerRadius = 3;
        loadingActivityLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];

        if (!subText) {
            Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
            loadingActivityLabel.subLabel.text = [dm getLoadingTip];
        }

        UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];

        UIImage *image = TBIMAGE(@"bundle://common_loading_close.png");
        [cButton setImage:image forState:UIControlStateNormal];

        CGRect btnRect = self.closeButton.frame;
        btnRect.size = CGSizeMake(30, 30);
        cButton.frame = btnRect;

        [self.activityLabel addSubview:cButton];

        [cButton addTarget:self action:@selector(handlerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton = cButton;

        self.closeButton.hidden = YES;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.activityLabel.frame;
    rect.size = CGSizeMake(180, 106);
    rect.origin.x = (self.width - rect.size.width) / 2;
    rect.origin.y = (self.height - rect.size.height) / 2;
    self.activityLabel.frame = rect;

    CGRect btnRect = self.closeButton.frame;
    btnRect.origin.x = rect.size.width-btnRect.size.width;
    btnRect.origin.y = 0;
    self.closeButton.frame = btnRect;
}

@end
