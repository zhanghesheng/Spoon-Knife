//
//  TBPointRuleVo.h
//  Tuan800API
//  积分攻略、积分规则
//  Created by enfeng on 14-1-14.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBPointRuleVo : NSObject <NSCoding, NSCopying> {
    NSNumber *_pointRuleId;   //规则ID
    NSNumber *_pointRuleScore;   //赚取积分值
    NSString *_pointRuleDescription;  //规则描述
    NSString *_pointRuleKey;  //客户端调用的积分规则KEY
    NSString *_title;
}
@property(nonatomic, strong) NSNumber *pointRuleId;
@property(nonatomic, strong) NSNumber *pointRuleScore;
@property(nonatomic, copy) NSString *pointRuleDescription;
@property(nonatomic, copy) NSString *pointRuleKey;
@property(nonatomic, copy) NSString *title;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (id)copyWithZone:(NSZone *)zone;

@end
