//
//  Tao800AuctionLastBider.h
//  tao800
//
//  Created by LeAustinHan on 14-1-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800PointDetailAuctionLastBiderVo : NSObject
{
    NSString * createTime;
    NSString * userId;                      //竞拍状态
    NSString * consumeScore;                //每次竞拍积分数值
    BOOL       getOrNot;
}

@property(nonatomic, copy) NSString * createTime;
@property(nonatomic, copy) NSString * userId;
@property(nonatomic, copy) NSString * consumeScore;
@property(nonatomic,assign) BOOL       getOrNot;

@end
