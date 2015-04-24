//
//  TBActivityLabel.m
//  TBUI
//
//  Created by enfeng on 12-11-23.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import "TBActivityLabel.h"
#import "TBUICommon.h"
#import "UIViewAdditions.h"
#import "TBCore/TBCoreMacros.h"

static CGFloat TBActivityBannerPadding = 8.0f;
static CGFloat TBActivitySpacing = 6.0f;

@interface TBActivityLabel () {
    CGFloat _imgWidth;
    CGFloat _imgHeight;
}

@end

@implementation TBActivityLabel

@synthesize activityIndicator = _activityIndicator;
@synthesize label = _label;
@synthesize centerImageView = _centerImageView;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame style:UIActivityIndicatorViewStyleWhite text:nil];
    if (self) {
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style {
    self = [self initWithFrame:frame style:style text:nil];
    if (self) {
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask =
                UIViewAutoresizingFlexibleWidth |
                        UIViewAutoresizingFlexibleHeight;

        _label = [[UILabel alloc] init];
        _label.text = text;
        _label.backgroundColor = [UIColor clearColor];
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.font = [UIFont systemFontOfSize:17];

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                style];

        switch (style) {

            case UIActivityIndicatorViewStyleWhiteLarge: {
                _label.textColor = [UIColor whiteColor];
            }
                break;
            case UIActivityIndicatorViewStyleWhite: {
                _label.textColor = [UIColor whiteColor];
            }
                break;
            case UIActivityIndicatorViewStyleGray: {
                _label.textColor = RGBCOLOR(99, 109, 125);
            }
                break;
        }

        [self addSubview:_activityIndicator];
        [self addSubview:_label];
        [_activityIndicator startAnimating];
    }
    return self;
}

- (id)initWithStyle:(UIActivityIndicatorViewStyle)style {
    self = [self initWithFrame:CGRectZero style:style text:nil];
    if (self) {
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images imgWidth:(CGFloat) imgWidth imgHeight:(CGFloat)imgHeight text:(NSString *)text; {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.text = text;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor grayColor];
        _label.textAlignment = NSTextAlignmentCenter;

        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.animationImages = images;
        _centerImageView.animationDuration = 0.8f;

        [self addSubview:_centerImageView];
        [self addSubview:_label];
        _imgWidth = imgWidth;
        _imgHeight = imgHeight;
        [_centerImageView startAnimating];
    }
    return self;
}


- (void)dealloc {
    [_activityIndicator stopAnimating];
    [_centerImageView stopAnimating]; 
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_centerImageView) {
        CGFloat  height = 0;
        CGFloat  labelHeight = 20;
        CGRect rect = _centerImageView.frame;
        rect.size = CGSizeMake(_imgWidth, _imgHeight);
        rect.origin.x = (self.frame.size.width-rect.size.width)/2;

        height = height + rect.size.height + labelHeight + 20 ;
        rect.origin.y = (self.frame.size.height-height)/2;
        _centerImageView.frame = rect;

        rect = _label.frame;
        rect.size = CGSizeMake(320, labelHeight);
        rect.origin.x = 0;
        rect.origin.y = _centerImageView.frame.size.height + _centerImageView.frame.origin.y + 20;
        _label.frame = rect;

    } else {
        CGSize textSize = [_label.text sizeWithFont:_label.font];

        CGFloat indicatorSize = 0.0f;
        [_activityIndicator sizeToFit];
        if (_activityIndicator.isAnimating) {
            if (_activityIndicator.height > textSize.height) {
                indicatorSize = textSize.height;

            } else {
                indicatorSize = _activityIndicator.height;
            }
        }

        CGFloat contentWidth = indicatorSize + TBActivitySpacing + textSize.width;
        CGFloat contentHeight = textSize.height > indicatorSize ? textSize.height : indicatorSize;

        CGFloat margin, padding, bezelWidth, bezelHeight;

        margin = 0;
        padding = TBActivityBannerPadding;
        bezelWidth = self.width;
        bezelHeight = self.height;

        CGFloat maxBevelWidth = TBScreenBounds().size.width - margin * 2;
        if (bezelWidth > maxBevelWidth) {
            bezelWidth = maxBevelWidth;
            contentWidth = bezelWidth - (TBActivitySpacing + indicatorSize);
        }

        CGFloat textMaxWidth = (bezelWidth - (indicatorSize + TBActivitySpacing)) - padding * 2;
        CGFloat textWidth = textSize.width;
        if (textWidth > textMaxWidth) {
            textWidth = textMaxWidth;
        }

        double yy = padding + floor((bezelHeight - padding * 2) / 2 - contentHeight / 2);
        double xx = floor((bezelWidth / 2 - contentWidth / 2) + indicatorSize + TBActivitySpacing);
        CGFloat y = (CGFloat) yy;
        CGFloat x = (CGFloat) xx;

        _label.frame = CGRectMake(x, y, textWidth, textSize.height);

        _activityIndicator.frame = CGRectMake(_label.left - (indicatorSize + TBActivitySpacing), y,
                indicatorSize, indicatorSize);
    }
}

@end
