//
//  TBUserCampusVo.h
//  Tuan800API
//
//  Created by worker on 13-11-21.
//  Copyright (c) 2013年 com.tuan800.framework.Tuan800API. All rights reserved.
//
//  用户校园信息

#import <Foundation/Foundation.h>

@interface TBUserCampusVo : NSObject <NSCoding>
{
    NSString *name;
    NSString *schoolName;
    NSString *departmentName;
    NSString *admissionDate;
    NSString *education;
    NSString *schoolSepcialCode; // 校园推广码
    NSString *wirelessInviteCode; // 无线邀请码
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *schoolName;
@property (nonatomic,retain) NSString *departmentName;
@property (nonatomic,retain) NSString *admissionDate;
@property (nonatomic,retain) NSString *education;
@property (nonatomic,retain) NSString *schoolSepcialCode;
@property (nonatomic,retain) NSString *wirelessInviteCode;

@end
