//
//  Tao800LoadMoreFinishTipView.m
//  tao800
//
//  Created by enfeng on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddToWishTipView.h"
#import "Tao800StyleSheet.h"
#import "TBUI/TBUI.h"
#import "TBCore/TBCore.h"
#import "Tao800NotifycationConstant.h"

@interface Tao800AddToWishTipView()
@property(nonatomic)CGRect endinglineRect;
@property(nonatomic)CGRect wishButtonRect;
@end

@implementation Tao800AddToWishTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"Tao800AddToWishTipView" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];//BACKGROUND_COLOR_GRAY2;
        [self addSubview:self.customView];
        self.endinglineRect = self.endingLine.frame;
        self.wishButtonRect = self.wishButton.frame;
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
    
    rect = self.wishButtonRect;
    rect.origin.x = rect.origin.x + deltaX;
    self.wishButton.frame = rect;

}

-(IBAction)addToWishListBtnClicked:(id)sender{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(addToWishList)]){
        [self.delegate addToWishList];
    }
}

@end
