//
//  Tao800MenuScrollView.h
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

 
enum MenuScrollViewTouch {
    MenuScrollViewTouchesBegan = 1,
    MenuScrollViewTouchesMoved = 2,
    MenuScrollViewTouchesEnded = 3
};

typedef void (^MenuTouchesEventBlock)(NSSet *touches, UIEvent *event, int flag);

@interface Tao800MenuScrollView : UIScrollView
@property(copy) MenuTouchesEventBlock touchesBeganCallback;

@property (nonatomic, assign) CGFloat slideWidth;

@property (nonatomic, assign) BOOL menuAppeared;
@end