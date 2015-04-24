//
//  Tao800PaymentCreateOrderDealItem.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderBaseItem.h"
#import "Tao800PaymentProductVo.h"

@interface Tao800PaymentCreateOrderDealItem : Tao800PaymentCreateOrderBaseItem

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *styleText; //款式
@property (nonatomic, strong) Tao800PaymentProductVo *productVo;
@end
