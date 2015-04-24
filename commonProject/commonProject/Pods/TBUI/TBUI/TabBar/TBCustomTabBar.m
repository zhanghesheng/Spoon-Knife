//
//  TBCustomTabBar.m
//  CustomTabBar
//
//  Created by enfeng on 13-5-21.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBCustomTabBar.h"

@implementation TBCustomTabBar
@synthesize delegate = _delegate;
@synthesize selectedIndex = _selectedIndex;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews]; 

}

- (void)dealloc {

}

+ (CGFloat)tabBarHeight {
    return 49;
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
