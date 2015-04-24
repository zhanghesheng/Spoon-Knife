//
//  Tao800AlertCheckBox.m
//  tao800
//
//  Created by Rose on 15/1/5.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AlertCheckBox.h"
#import <TBCore/TBCore.h>

@implementation Tao800AlertCheckBox

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self settingCheckBox];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self settingCheckBox];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.imageView.frame;
    rect.size.width = 20;
    rect.size.height = 32/2;
    rect.origin.x = 10;
    rect.origin.y = (self.height - rect.size.height)/2;
    self.imageView.frame = rect;
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.size.width = (self.width - CGRectGetMaxX(rect)-5);
    titleRect.size.height = 16;
    titleRect.origin.x = CGRectGetMaxX(rect) + 5;
    titleRect.origin.y = (self.height - titleRect.size.height)/2;
    self.titleLabel.frame = titleRect;
    
}

-(void)settingCheckBox{
    self.selected = NO;
    UIImage* image = nil;
    if (TBIsIPhone6Plus()) {
        image = TBIMAGE(@"bundle://alert_unselect@3x.png");
    }
    else{
        image = TBIMAGE(@"bundle://alert_unselect@2x.png");
    }
    [self setImage:image forState:UIControlStateNormal];
    
    if (TBIsIPhone6Plus()) {
        image = TBIMAGE(@"bundle://alert_select@3x.png");
    }
    else{
        image = TBIMAGE(@"bundle://alert_select@2x.png");
    }
    [self setImage:image forState:UIControlStateSelected];
}



@end
