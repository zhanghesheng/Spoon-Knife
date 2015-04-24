//
//  Tao800ActivityLabel.m
//  universalT800
//
//  Created by enfeng on 13-12-10.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800ActivityLabel.h"

CGFloat const TBBActivityImgWidth = 23.0f;

@interface Tao800ActivityLabel () {
}
@end

@implementation Tao800ActivityLabel

- (BOOL)isAnimating {
    return self.activityIndicatorView.isAnimating;
}

- (void)startAnimating {
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
    [self layoutSubviews];
}

- (void)stopAnimating {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat hGap = 7.0f;
    CGSize textSize = [self.label.text sizeWithFont:self.label.font];
    CGFloat centerWidth = TBBActivityImgWidth + textSize.width + hGap;
    CGFloat x = (self.width - centerWidth) / 2;

    CGRect rect = self.activityIndicatorView.frame;
    rect.size = CGSizeMake(TBBActivityImgWidth, TBBActivityImgWidth);
    if (!self.isAnimating) {
//        x = 10;
    }
    rect.origin.x = x;
    rect.origin.y = (self.height - rect.size.height) / 2;
    self.activityIndicatorView.frame = rect;

    rect = self.label.frame;
    rect.size = textSize;
    rect.origin.x = self.activityIndicatorView.width + self.activityIndicatorView.frame.origin.x + hGap;
    rect.origin.y = (self.height - rect.size.height) / 2;
    self.label.frame = rect;

    if (self.activityIndicatorView.hidden) {
        rect.size = textSize;
        rect.origin.x = (self.width-rect.size.width)/2;
        rect.origin.y = (self.height - rect.size.height) / 2;
        self.label.frame = rect;
    }
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask =
                UIViewAutoresizingFlexibleWidth |
                        UIViewAutoresizingFlexibleHeight;

        UILabel *mLabel = [[UILabel alloc] init];
        self.label = mLabel;
        _label.text = text;
        _label.backgroundColor = [UIColor clearColor];
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.font = [UIFont systemFontOfSize:17];

        Tao800ActivityIndicatorView *indicatorView = [[Tao800ActivityIndicatorView alloc]
                initWithFrame:CGRectZero];

        self.activityIndicatorView = indicatorView;
        UIImage *image = TBIMAGE(@"bundle://message_small_loading@2x.png");
        indicatorView.centerImageView.image = image;

        [self addSubview:indicatorView];
        [self addSubview:mLabel];
        [self startAnimating];
    }
    return self;
}

- (void)dealloc {
    if (self.isAnimating) {
        [self stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
