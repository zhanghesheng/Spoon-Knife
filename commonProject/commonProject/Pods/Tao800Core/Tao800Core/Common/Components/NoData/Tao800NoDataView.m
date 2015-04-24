//
//  Tao800NoDataView.m
//  tao800
//
//  Created by enfeng on 14/11/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800NoDataView.h"

@implementation Tao800NoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    TBDPRINT(@"release Tao800NoDataView");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.tipBackgroundView.frame;
    rect.origin.x = (self.width-rect.size.width)/2;
    rect.origin.y = (self.height-rect.size.height)/2;
    self.tipBackgroundView.frame = rect;
}

@end
