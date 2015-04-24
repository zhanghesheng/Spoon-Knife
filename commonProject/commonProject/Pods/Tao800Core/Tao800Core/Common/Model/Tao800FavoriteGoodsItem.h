//
//  Tao800FavoriteGoodsItem.h
//  tao800
//
//  Created by ayvin on 13-4-17.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>
#import "Tao800DealVo.h"

@interface Tao800FavoriteGoodsItem : TBTableItem{
    Tao800DealVo *dealVo;
}

@property(nonatomic, strong) Tao800DealVo *dealVo;

@end
