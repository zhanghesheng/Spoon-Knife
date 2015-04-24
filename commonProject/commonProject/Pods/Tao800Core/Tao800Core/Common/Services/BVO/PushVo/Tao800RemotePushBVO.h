//
//  Tao800RemotePushBVO.h
//  tao800
//
//  Created by tuan800 on 14-10-13.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800RemotePushBVO : NSObject<NSCoding>

@property (nonatomic, copy) NSString * pushId; // push id
@property (nonatomic, copy) NSString * pushTime; // push 时间
@property (nonatomic, copy) NSString * pushAlert; // pushAlert
@property (nonatomic, copy) NSString * pushDetailMessage; // push详细信息
@property (nonatomic, copy) NSString * pushSound; // push声音字符串
@property (nonatomic, assign) int pushBadge;
@property (nonatomic, strong) NSDictionary * pushDic; //原来的push字典
@property (nonatomic, assign) BOOL pushDidFinishLuanch; // 该条push完成

@end
