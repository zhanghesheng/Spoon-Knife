//
//  TBPaymentSuitsVo.h
//  Core
//  团购套餐Vo
//  Created by 卢 飞 on 13-1-24.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBPaymentSuitsVo : NSObject <NSCoding> {
    NSString *_name;
    NSNumber *_price;
    NSString *_misSuitId;//套餐ID
}
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *price;
@property(nonatomic, strong) NSString *misSuitId;//套餐ID
@end
