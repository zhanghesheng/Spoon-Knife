//
//  Tao800LoadingActivityLabel.m
//  tao800
//
//  Created by enfeng on 14-3-6.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>
#import "Tao800LoadingActivityLabel.h"
#import "Tao800StyleSheet.h"

@implementation Tao800LoadingActivityLabel

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask =
                UIViewAutoresizingFlexibleWidth |
                        UIViewAutoresizingFlexibleHeight;

        _label = [[UILabel alloc] init];
        UILabel *tempLabel = [[UILabel alloc] init];
        _label.text = text;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = V3_24PX_FONT;

        _activityIndicator = [[Tao800ActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _label.textColor = TEXT_COLOR_BLACK4;

        CGRect rect = _activityIndicator.frame;
        if (style == UIActivityIndicatorViewStyleWhiteLarge) {
            rect.size= CGSizeMake(31, 31);
            _activityIndicator.centerImageView.image = TBIMAGE(@"bundle://message_big_loading@2x.png");
        } else {
            rect.size= CGSizeMake(22, 22);
            _activityIndicator.centerImageView.image = TBIMAGE(@"bundle://message_small_loading@2x.png");
        }

        _activityIndicator.frame = rect;

        self.subLabel = tempLabel;
        self.subLabel.font = V3_20PX_FONT;
        self.subLabel.backgroundColor = [UIColor clearColor];
        self.subLabel.textColor = TEXT_COLOR_BLACK4;

        [self addSubview:_activityIndicator];
        [self addSubview:_label];
        [self addSubview:tempLabel];
        [_activityIndicator startAnimating];
    }
    return self;
}

- (void)dealloc {
    [_activityIndicator stopAnimating];
    [_centerImageView stopAnimating];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat hGap = 5;
    CGFloat labelGap = 15;
    CGSize textSize1 = [_label.text sizeWithFont:_label.font];
    CGSize textSize2 = [self.subLabel.text sizeWithFont:self.subLabel.font];
 
    [_activityIndicator sizeToFit];

    CGFloat sumHeight = textSize2.height;

    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat activityX = (self.width-textSize1.width-_activityIndicator.width-hGap)/2;;
    CGFloat activityY = 0;

    //如果图片比文字高
    if (_activityIndicator.height>_label.height) {
        sumHeight += _activityIndicator.height + labelGap;
        activityY = (self.height-sumHeight)/2;

        labelY = (_activityIndicator.height-textSize1.height)/2+ activityY;
    } else {
        sumHeight += textSize1.height + labelGap;
        labelY = (self.height-sumHeight)/2;

        activityY = (textSize1.height-_activityIndicator.height)/2+ labelY;
    }

    labelX = activityX+_activityIndicator.width+hGap;

    _activityIndicator.frame = CGRectMake(activityX, activityY,
            _activityIndicator.width, _activityIndicator.height);

    _label.frame = CGRectMake(labelX, labelY, textSize1.width, textSize1.height);

    CGRect subLabelRect = self.subLabel.frame;
    subLabelRect.size = textSize2;
    subLabelRect.origin.x = (self.width-textSize2.width)/2;
    if (_label.height>_activityIndicator.height) {
        subLabelRect.origin.y = _label.frame.origin.y+_label.height+labelGap;
    } else {
        subLabelRect.origin.y = _activityIndicator.frame.origin.y+_activityIndicator.height+labelGap;
    }

    self.subLabel.frame = subLabelRect;
}

@end
