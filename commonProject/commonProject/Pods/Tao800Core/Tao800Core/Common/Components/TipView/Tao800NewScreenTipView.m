//
//  Tao800NewScreenTipView.m
//  tao800
//
//  Created by Rose on 15/1/6.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800NewScreenTipView.h"
#import <QuartzCore/QuartzCore.h>
#import "TBCore/TBCore.h"
#import "Tao800StyleSheet.h"
#import "Tao800RectangleBorderButton.h"

CGFloat const Tao800NewScreenTipViewImgWidth = (230.0/2);
CGFloat const Tao800NewScreenTipViewImgHeight = (280/2);
CGFloat const Tao800NewScreenTipViewVerticalGap = 20.0f;
CGFloat const Tao800NewScreenTipViewTitlesGap = 10.0f;    //主标题和子标题的间隔
CGFloat const Tao800NewScreenTipViewTitleLabelWidth = 240.0f;  //主标题的最大宽度
CGFloat const Tao800NewScreenTipViewSubTitleLabelWidth = 280.0f;  //子标题的最大宽度

#define Tao800NewScreenTipViewTitleFont [UIFont systemFontOfSize:17]
#define Tao800NewScreenTipViewSubtitleFont [UIFont systemFontOfSize:14]

@interface Tao800NewScreenTipView () <UIGestureRecognizerDelegate>

@end

@implementation Tao800NewScreenTipView

- (void)createTitleLabel:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.titleLabel = label;
    label.numberOfLines = 0;
    label.font = Tao800NewScreenTipViewTitleFont;
    label.text = title;
    label.textColor = TEXT_COLOR_BLACK1;
}

- (void)createSubTitleLabel:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.subtitleLabel = label;
    label.numberOfLines = 0;
    label.font = Tao800NewScreenTipViewSubtitleFont;
    label.text = title;
    label.textColor = TEXT_COLOR_BLACK6;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)handleTouch:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickScreenTipView:sender:)]) {
        [self.delegate didClickScreenTipView:self sender:sender];
    }
}
//- (void) didClickButton:(Tao800NewScreenTipView *) messageView sender:(id) sender
- (void)buttonClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButton:sender:)]) {
        [self.delegate didClickButton:self sender:sender];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self handleTouch:gestureRecognizer.view];
}

/**
 * 图片文字上下居中
 * 提示信息的显示分为以下几种：
 * 1：图片+主标题
 * 2：图片+主标题+子标题
 * 3：图片+主标题+按钮
 * 4：图片+主标题+子标题+按钮
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //先计算中间部分的整体高度
    CGFloat centerHeight = 0;
    CGFloat verticalGapsHeight = 0;   //中间间隔高度的总和
    
    CGRect titleRect = self.titleLabel.frame;
    CGRect subtitleRect = self.subtitleLabel.frame;
    CGRect imageRect = self.centerImageView.frame;
    CGRect buttonRect = self.centerButton.frame;
    
    imageRect.size = CGSizeMake(Tao800NewScreenTipViewImgWidth, Tao800NewScreenTipViewImgHeight);
    verticalGapsHeight = verticalGapsHeight + Tao800NewScreenTipViewVerticalGap;
    titleRect.size = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                      constrainedToSize:CGSizeMake(Tao800NewScreenTipViewTitleLabelWidth, MAXFLOAT)];
    
    if (self.subtitleLabel) {
        verticalGapsHeight = verticalGapsHeight + Tao800NewScreenTipViewTitlesGap;
        subtitleRect.size = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font
                                                constrainedToSize:CGSizeMake(Tao800NewScreenTipViewSubTitleLabelWidth, MAXFLOAT)];
    } else {
        subtitleRect = CGRectZero;
    }
    
    if (self.centerButton) {
        verticalGapsHeight = verticalGapsHeight + Tao800NewScreenTipViewVerticalGap*3.5;
        buttonRect.size = [self.centerButton.titleLabel.text sizeWithFont:self.centerButton.titleLabel.font
                                                        constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        buttonRect.size.width = buttonRect.size.width + 20;
        buttonRect.size.height = 35;
    } else {
        verticalGapsHeight = verticalGapsHeight + Tao800NewScreenTipViewVerticalGap*3.5;
        buttonRect.size.height = 30;
    }
    centerHeight = imageRect.size.height
    + titleRect.size.height
    + subtitleRect.size.height
    + buttonRect.size.height
    + verticalGapsHeight;
    
    //图片的位置 左右居中
    CGFloat y = (self.frame.size.height - centerHeight)/2;
    if(y < 0){
        y = 0;
    }
    CGFloat x = (self.frame.size.width - imageRect.size.width)/2;
    imageRect.origin = CGPointMake(x, y);
    self.centerImageView.frame = imageRect;
    
    //主标题的位置 左右居中
    y = imageRect.origin.y + imageRect.size.height + Tao800NewScreenTipViewVerticalGap;
    x = (self.frame.size.width - titleRect.size.width)/2;
    titleRect.origin = CGPointMake(x, y);
    self.titleLabel.frame = titleRect;
    
    //子标题位置 左右居中
    if (self.subtitleLabel) {
        y = titleRect.origin.y + titleRect.size.height + Tao800NewScreenTipViewTitlesGap;
        x = (self.frame.size.width - subtitleRect.size.width)/2;
        subtitleRect.origin = CGPointMake(x, y);
        self.subtitleLabel.frame = subtitleRect;
    } else {
        //用于按钮位置的计算
        y = titleRect.origin.y + titleRect.size.height;
        subtitleRect.origin = CGPointMake(0, y);
    }
    
    //子标题的位置 左右居中
    if (self.centerButton) {
        y = subtitleRect.origin.y + subtitleRect.size.height + Tao800NewScreenTipViewVerticalGap*3.5;
        x = (self.frame.size.width - buttonRect.size.width)/2;
        buttonRect.origin = CGPointMake(x, y);
        self.centerButton.frame = buttonRect;
    }
}

- (id)initWithTitle:(NSString *)title
           delegate:(id <Tao800NewScreenTipViewDelegate>)delegate
              style:(Tao800NewScreenTipViewStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        self.delegate = delegate;
        [self createTitleLabel:title];
        
        UIImageView *iView = [[UIImageView alloc] init];
        self.centerImageView = iView;
        [self addSubview:iView];
        
        if (style == Tao800NewScreenTipViewStyleContainButton) {
            Tao800RectangleBorderButton *btn = [Tao800RectangleBorderButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:btn];
            [btn setTitle:@"查看详情" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            self.centerButton = btn;
            btn.titleLabel.font = Tao800NewScreenTipViewTitleFont;
            //            [btn setTitleColor:V600_FONT_BLACK_COLORC forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [btn resetButtonStyle];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleGesture:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subTitle
           delegate:(id <Tao800NewScreenTipViewDelegate>)delegate style:(Tao800NewScreenTipViewStyle)style {
    self = [self initWithTitle:title delegate:delegate style:style];
    if (self) {
        [self createSubTitleLabel:subTitle];
    }
    return self;
}


@end
