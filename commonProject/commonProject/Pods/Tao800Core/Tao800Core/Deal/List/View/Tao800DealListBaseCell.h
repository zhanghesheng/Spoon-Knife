//
//  Tao800DealListBaseCell.h
//  tao800
//
//  Created by enfeng on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MenuCell.h"
#import "Tao800DealListItemBaseView.h"
#import "Tao800DealListItem.h"

@class Tao800DealVo;

@interface Tao800DealListBaseCell : Tao800MenuCell
+ (void)resetItemView:(Tao800DealListItemBaseView *)itemView deal:(Tao800DealVo *)deal;
+ (void)resetItemView:(Tao800DealListItemBaseView *)itemView deal:(Tao800DealVo *)deal item:(Tao800DealBaseItem *)item;
@end
