//
//  Tao800DealBaseItem.h
//  Tao800Core
//
//  Created by 恩锋 杨 on 15/3/4.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"

@interface Tao800DealBaseItem : NSObject 

@property (nonatomic, assign) int sortId;
@property (nonatomic, copy) NSString *cId;

@property(nonatomic, assign) Tao800DealDetailFrom dealDetailFrom;

@property(nonatomic) NSTimeInterval appearTime; //商品进入显示界面的时间
@property(nonatomic) NSTimeInterval disappearTime; //商品退出显示界面的时间
@end
