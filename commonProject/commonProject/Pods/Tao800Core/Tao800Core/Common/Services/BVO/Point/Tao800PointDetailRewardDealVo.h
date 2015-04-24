//
//  Tao800PointDetailRewardDealVo.h
//  tao800
//
//  Created by hanyuan on 13-4-1.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PointDetailCommonDealVo.h"


enum{
    Reward_Status_InComing,
    Reward_Status_InProgress,
    Reward_Status_Finished,
};

@interface Tao800PointDetailRewardDealVo : Tao800PointDetailCommonDealVo{
    int rewardStatus;
    
    NSArray *winners; 
}

@property(nonatomic, assign)int rewardStatus;
@property(nonatomic, strong)NSArray *winners;

@end
