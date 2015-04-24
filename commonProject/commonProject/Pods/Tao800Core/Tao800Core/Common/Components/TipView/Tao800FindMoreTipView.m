//
//  Tao800LoadMoreFinishTipView.m
//  tao800
//
//  Created by enfeng on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800FindMoreTipView.h"
#import "Tao800StyleSheet.h"
#import "TBUI/TBUI.h"
#import "TBCore/TBCore.h"
#import "Tao800NotifycationConstant.h"

@interface Tao800FindMoreTipView()
@property(nonatomic)CGRect endinglineRect;
@property(nonatomic)CGRect moreButtonRect;
@end

@implementation Tao800FindMoreTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"Tao800FindMoreTipView" owner:self options:nil];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.customView];
        self.endinglineRect = self.endingLine.frame;
        self.moreButtonRect = self.moreButton.frame;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.customView.frame;
    rect.size.width = self.width;
    self.customView.frame = rect;
    
    CGFloat deltaX = 0;
    if (TBIsIPhone6()) {
        deltaX = (375 - 320)/2;
    }
    if (TBIsIPhone6Plus()) {
        deltaX = (414 - 320)/2;
    }
    rect = self.endinglineRect;
    rect.origin.x = rect.origin.x + deltaX;
    self.endingLine.frame = rect;
    
    rect = self.moreButtonRect;
    rect.origin.x = rect.origin.x + deltaX;
    self.moreButton.frame = rect;
}

-(IBAction)findMoreBtnClicked:(id)sender{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(findMore:)]){
        [self.delegate findMore:self];
    }
}

@end
