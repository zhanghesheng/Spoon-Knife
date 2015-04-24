//
//  Tao800TabButton.h
//  universalT800
//
//  Created by enfeng on 13-12-24.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBUI.h"

typedef void (^Tao800TabButtonDoubleTapBlock)(void);

@interface Tao800TabButton : TBButton

@property(nonatomic) CGFloat vGap; //垂直间距
@property(nonatomic) id userData;
@property (nonatomic, assign) BOOL verticalLayout;
@property (nonatomic, assign) BOOL flag; //防止重复调用layoutSubviews
@property (nonatomic)CGFloat imgWidth;
@property (nonatomic)CGFloat imgHeight;
@property (nonatomic, copy) Tao800TabButtonDoubleTapBlock doubleTapBlock;
@end
