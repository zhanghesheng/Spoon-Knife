//
//  TBUserVo.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBUserVo.h"
#import <Foundation/Foundation.h>

typedef enum _TBUserVoUserStatusFlag {
	TN800UserStatusUnActivate = 1,  //未激活
	TN800UserStatusActivated = 2,   //已激活
} TBUserStatusFlag;

@interface TBUserVo : NSObject<NSCoding, NSCopying> {
    NSString* userId;
    NSString* name;
    NSString * email;
    NSString* password;
    NSInteger userStatus;
    NSDate* lastLoginTime;
    NSString *phone;
    NSString *token;
    NSString *inviteCode; // 邀请码
    NSString * nameForLogin;
    BOOL hasCampusInformation; //是否有校园推广信息
    NSString * campusCode; //如果是校园用户的话 会由校园码 就是这个
}

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, assign) NSInteger userStatus;
@property (nonatomic, strong) NSDate* lastLoginTime;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *inviteCode; // 邀请码
@property (nonatomic, copy) NSString * nameForLogin;
@property (nonatomic, assign) BOOL hasCampusInformation;
@property (nonatomic, copy) NSString * campusCode;

+ (TBUserVo *)convertJSONToUser:(NSDictionary *)params;
@end

