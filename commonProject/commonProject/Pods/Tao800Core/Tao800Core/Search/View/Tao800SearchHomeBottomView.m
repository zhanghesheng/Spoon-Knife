//
//  Tao800SearchHomeBottomView.m
//  tao800
//
//  Created by worker on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchHomeBottomView.h"
#import "TBUI/TBUI.h"
#import "Tao800Util.h"
#import "Tao800StyleSheet.h"

@implementation Tao800SearchHomeBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(10, 10, self.width - 20, self.height-20);
        _clearButton.backgroundColor = [UIColor clearColor];
        [_clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //_clearButton.layer.borderColor = [UIColor colorWithHex:0xA2A2A2].CGColor;
        //_clearButton.layer.borderWidth = 1;
        UIImage *btnImg = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
        [Tao800Util resetButton:_clearButton withBackgroundImg:btnImg];
        _clearButton.layer.cornerRadius = 3;
        _clearButton.clipsToBounds = YES;
        
        [self addSubview:_clearButton];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
