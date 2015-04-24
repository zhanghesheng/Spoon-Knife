//
//  Tao800ScrollPageVCL.m
//  tao800
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ScrollPageVCL.h"
#import "Tao800FunctionCommon.h"
#import "Tao800StyleSheet.h"
#import "TBBaseViewCTLAdditions.h"

@interface Tao800ScrollPageVCL () {

}

@end

@implementation Tao800ScrollPageVCL

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    

}

-(void)hiddenLayer:(BOOL)status{
    lineLayer.hidden = status;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *layer = [CALayer layer];

    [self.view.layer addSublayer:layer];
    lineLayer = layer;

    [self addBackButtonToNavigator];

    self.pagingScrollView.backgroundColor = [UIColor whiteColor];

    CGRect topBarRect = self.scrollPageTopBar.frame;
    topBarRect.size.height = 40;
    self.scrollPageTopBar.frame = topBarRect;

    CGFloat height = SuitOnePixelHeight();

    //布局线条
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGRect rect = self.scrollPageTopBar.frame;
    rect.origin.y = rect.origin.y+rect.size.height;
    rect.size.height = height;
    lineLayer.frame = rect;
    lineLayer.backgroundColor = [UIColor colorWithHex:0xE5E5E5].CGColor;
    [CATransaction commit];

    //布局滚动视图
    rect = self.pagingScrollView.frame;
    rect.origin.y = topBarRect.origin.y+topBarRect.size.height+height;
    rect.size.height = self.view.height-self.tbNavigatorView.height-rect.origin.y;
    self.pagingScrollView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
