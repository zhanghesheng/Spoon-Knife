//
//  Tao800DealListItemMaskView.h
//  tao800
//  蒙层，用于显示‘未开始’， ‘已卖光’， ‘已过期’
//  Created by enfeng on 14/11/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tao800DealListItemMaskView : UIView
@property (nonatomic) BOOL showCircle;

@property (nonatomic, weak) UILabel *titleLabel;
@end
