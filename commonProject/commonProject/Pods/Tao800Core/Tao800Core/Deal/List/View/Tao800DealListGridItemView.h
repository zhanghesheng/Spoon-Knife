//
//  Tao800DealListGridItemView.h
//  tao800
//
//  Created by enfeng on 14-2-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBUI.h"

#import "Tao800DealListItemBaseView.h"

@interface Tao800DealListGridItemView : Tao800DealListItemBaseView

@property (nonatomic, strong) id userData;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, weak) UIButton *maskButton;
@property(nonatomic) CGRect imageViewRect;//记录图片的frame

@end