//
//  Tao800TabButton.m
//  universalT800
//
//  Created by enfeng on 13-12-24.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800TabButton.h"

@implementation Tao800TabButton

- (void)initContent {
    self.vGap = 3;
    self.verticalLayout = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        if (self.doubleTapBlock) {
            self.doubleTapBlock();
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initContent];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initContent];
    }
    return self;
}

/**
* 图片和标题上下居中
* 图片和文字水平居中
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.verticalLayout) {
        return;
    }

    if (self.flag) {
        return;
    }
    CGFloat sumHeight = self.vGap;

    NSString *title = self.titleLabel.text;
    UIFont *font = self.titleLabel.font;
    CGFloat height = self.titleLabel.frame.size.height;
    CGSize size = [title sizeWithFont:font
                    constrainedToSize:CGSizeMake(MAXFLOAT, height)
                        lineBreakMode:self.titleLabel.lineBreakMode];
    size.width = self.frame.size.width;

    sumHeight = sumHeight + size.height;

    CGFloat width = self.imageView.image.size.width;
    height = self.imageView.image.size.height;
    sumHeight = sumHeight + height;

    if (self.imgWidth) {
        width = self.imgWidth;
    }
    if (self.imgHeight) {
        height = self.imgHeight;
    }
    CGFloat x = (self.frame.size.width - width) / 2;
    CGFloat y = (self.frame.size.height - sumHeight) / 2;
    CGRect rect;
    rect.origin = CGPointMake(x, y);
    rect.size = CGSizeMake(width, height);
    self.imageView.frame = rect;

    x = 0;
    y = self.imageView.frame.origin.y + self.imageView.frame.size.height + self.vGap;
    rect.origin = CGPointMake(x, y);
    rect.size = CGSizeMake(self.frame.size.width, size.height);
    self.titleLabel.frame = rect;
}
@end
