//
//  TBUserVo.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBUserVo.h"
#import "TBCore/NSDictionaryAdditions.h"

@implementation TBUserVo
@synthesize userId, name, password,email, userStatus,lastLoginTime, nameForLogin;
@synthesize phone;
@synthesize token;
@synthesize inviteCode;
@synthesize hasCampusInformation;
@synthesize campusCode;

-(void) dealloc {
 
}

- (id)copyWithZone:(NSZone *)zone {
    TBUserVo *beanCopy = [[[self class] allocWithZone:zone] init];
    beanCopy.userId = self.userId;
    beanCopy.name = self.name;
    beanCopy.password = self.password;
    beanCopy.userStatus = self.userStatus;
    beanCopy.phone = self.phone;
    beanCopy.token = self.token;
    beanCopy.email = self.email;
    beanCopy.inviteCode = self.inviteCode;
    beanCopy.lastLoginTime = [self.lastLoginTime copy ];
    beanCopy.nameForLogin = self.nameForLogin;
    return beanCopy;
}

-(void) encodeWithCoder:(NSCoder *)aCoder { 
	[aCoder encodeObject:userId forKey:@"userId"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:password forKey:@"password"];
    [aCoder encodeInteger:userStatus forKey:@"userStatus"];
    [aCoder encodeObject:lastLoginTime forKey:@"lastLoginTime"];
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:token forKey:@"token"];
    [aCoder encodeObject:inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:nameForLogin forKey:@"stringUsedForLogin"];
    [aCoder encodeBool:hasCampusInformation forKey:@"hasCampusInformation"];
    [aCoder encodeObject:campusCode forKey:@"campusCode"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    NSObject *userIdObj = [aDecoder decodeObjectForKey:@"userId"];
    if ([userIdObj isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber*)userIdObj;
        self.userId = [num stringValue];
    } else {
        self.userId = (NSString*)userIdObj;
    }
    
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.password = [aDecoder decodeObjectForKey:@"password"]; 
    self.userStatus = [aDecoder decodeIntegerForKey:@"userStatus"]; 
    self.lastLoginTime=[aDecoder decodeObjectForKey:@"lastLoginTime"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"]; 
    self.token = [aDecoder decodeObjectForKey:@"token"];
    self.inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
    self.nameForLogin = [aDecoder decodeObjectForKey:@"stringUsedForLogin"];
    self.hasCampusInformation = [aDecoder decodeBoolForKey:@"hasCampusInformation"];
    self.campusCode = [aDecoder decodeObjectForKey:@"campusCode"];
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (TBUserVo *)convertJSONToUser:(NSDictionary *)params {
     TBUserVo *userVo = [[TBUserVo alloc] init];

     NSObject *userId = [params objectForKey:@"id" convertNSNullToNil:YES];
     NSString *userIdString = nil;
     if ([userId isKindOfClass:[NSNumber class]]) {
         NSNumber *num = (NSNumber *) userId;
         userIdString = [num stringValue];
     } else {
         userIdString = (NSString *) userId;
     }

     userVo.userId = userIdString;
     userVo.phone = [params objectForKey:@"phone_number"];
     userVo.token = [params objectForKey:@"access_token"];
     userVo.name = [params objectForKey:@"user_name"];
     userVo.inviteCode = [params objectForKey:@"invite_code"];
    
     if ([[params objectForKey:@"active_status"] intValue] == 0) {
         // 未激活
         userVo.userStatus = TN800UserStatusUnActivate;
     } else {
         // 已激活
         userVo.userStatus = TN800UserStatusActivated;
     }

     userVo.lastLoginTime = [NSDate date];
     return userVo;
 }

@end
