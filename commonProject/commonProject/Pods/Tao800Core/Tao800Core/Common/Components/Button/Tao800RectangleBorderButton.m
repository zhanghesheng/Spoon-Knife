//
//  Tao800RectangleBorderButton.m
//  universalT800
//
//  Created by enfeng on 13-12-27.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800RectangleBorderButton.h"
#import "TBUI/TBUI.h"
#import <QuartzCore/QuartzCore.h>
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"

@implementation Tao800RectangleBorderButton

- (void) resetButtonStyle {
    self.backgroundColor = [UIColor clearColor];
    
    UIImage *image = TBIMAGE(@"bundle://v6_common_border_button_orange_bg@2x.png");
    UIImage *borderImage = TBIMAGE(@"bundle://v6_common_border_button_bg@2x.png");
    borderImage = [borderImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];

    [self setBackgroundImage:borderImage forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [self setTitleColor:V600_FONT_BLACK_COLORC forState:UIControlStateNormal];
}

- (void)redBorderButtonStyle {
    self.backgroundColor = [UIColor clearColor];

    UIImage *image = TBIMAGE(@"bundle://tip_red_bg_btn@2x.png");
    UIImage *borderImage = TBIMAGE(@"bundle://tip_red_border_btn@2x.png");
    borderImage = [borderImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];

    [self setBackgroundImage:borderImage forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateNormal];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self resetButtonStyle];
    }
    return self;
}

- (void)layoutSubviews {

    if (self.highlighted) {
        if (!self.touchInside) {
            return;
        }
    }
    [super layoutSubviews];

}
@end
