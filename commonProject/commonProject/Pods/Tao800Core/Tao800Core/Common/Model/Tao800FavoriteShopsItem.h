//
//  Tao800FavoriteShopsItem.h
//  tao800
//
//  Created by lixuefeng on 13-4-7.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>
#import "Tao800DealVo.h"

@interface Tao800FavoriteShopsItem : TBTableItem
{
    Tao800DealVo *dealVo;
}

@property (nonatomic, strong) Tao800DealVo *dealVo;
@end
