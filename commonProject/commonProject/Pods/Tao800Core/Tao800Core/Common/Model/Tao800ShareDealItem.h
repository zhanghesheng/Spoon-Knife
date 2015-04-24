//
//  Tao800ShareDealItem.h
//  tao800
//
//  Created by enfeng on 14/12/1.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800DealVo;
@class Tao800LotteryDetailHeaderVo;
@class Tao800MyLuckyDrawVo;
#import "Tao800LotteryDetailBVO.h"

@interface Tao800ShareDealItem : NSObject

@property (nonatomic, strong) Tao800DealVo* dealVo;
@property (nonatomic, strong) Tao800LotteryDetailHeaderVo* lotteryDetailHeaderVo;
@property (nonatomic, strong) Tao800MyLuckyDrawVo* myLuckyDrawVo;
@property (nonatomic, strong) Tao800LotteryDetailBVO* lotteryBVO;
@end
