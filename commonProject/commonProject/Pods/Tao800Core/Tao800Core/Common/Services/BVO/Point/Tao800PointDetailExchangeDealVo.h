//
//  Tao800PointDetailExchangeDealVo.h
//  tao800
//
//  Created by hanyuan on 13-4-1.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PointDetailCommonDealVo.h"


enum{
    Exchange_Status_InComing,
    Exchange_Status_InProgress,
};

@interface Tao800PointDetailExchangeDealVo : Tao800PointDetailCommonDealVo
{
    int exchangeStatus;
    NSDictionary *dealProperty;
}

@property(nonatomic, assign)int exchangeStatus;
@property(nonatomic, strong)NSDictionary *dealProperty;
@property(nonatomic, copy)NSString *htmlString; //wap图文详情
@property(nonatomic, strong)NSNumber *sellerId;
@property(assign)int maxLimit;
@property(nonatomic, strong)NSDictionary *postInfo;
@property(nonatomic, copy)NSString *zId; //积分现金购id
@property BOOL noAddr; //ture:虚拟物品，不用填写地址；false:需要填写地址
@property BOOL mustMemo; //true：必须填写备忘；false：非必填
@property(nonatomic, copy)NSString *memoContent; //备忘内容
@property(nonatomic, copy)NSString *memoPlaceholder; //备忘内容
@end
