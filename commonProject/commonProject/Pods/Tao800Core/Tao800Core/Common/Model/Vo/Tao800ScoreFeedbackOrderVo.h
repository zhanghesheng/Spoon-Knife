//
//  Tao800ScoreFeedbackOrderVo.h
//  tao800
//
//  Created by hanyuan on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800OrderVo.h"

@interface Tao800ScoreFeedbackOrderVo : Tao800OrderVo
{
    NSString *tradeId;
    NSString *tradeTopic;
    NSString *earnScore;
    int readStatus;
    NSDictionary *topic;
    BOOL hasPosted;
}

@property(nonatomic, copy)NSString *tradeId;
@property(nonatomic, copy)NSString *tradeTopic;
@property(nonatomic, copy)NSString * earnScore;
@property(nonatomic, assign)int readStatus;
@property(nonatomic, strong)NSDictionary *topic;
@property(nonatomic, assign)BOOL hasPosted;

@end
