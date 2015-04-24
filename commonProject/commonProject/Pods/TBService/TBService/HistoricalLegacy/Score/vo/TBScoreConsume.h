//
//  TBScoreConsume.h
//  hui800
//
//  Created by enfeng on 12-9-17.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBScoreConsume : NSObject {
    NSNumber *userId;
    NSString *spendDescription;
    NSString *createAt;
    NSString *ruleId;
    NSNumber *score;
    NSNumber *income;
    NSNumber *spendId;
    NSString *title;
    int sendChannel;
    NSString *todayTaskKey;
    BOOL taskStatus;
    NSString *expireDate;
}
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, copy) NSString *spendDescription;
@property(nonatomic, copy) NSString *createAt;
@property(nonatomic, copy) NSString *ruleId;
@property(nonatomic, strong) NSNumber *score;
@property(nonatomic, strong)NSNumber *income;
@property(nonatomic, strong) NSNumber *spendId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic)int sendChannel;
@property(nonatomic, strong) NSString *todayTaskKey;
@property(nonatomic)BOOL taskStatus;
@property(nonatomic, copy)NSString *expireDate;
@end
