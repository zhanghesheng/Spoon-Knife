//
//  Tao800SinaWeiboVo.h
//  tao800
//
//  Created by zhangwenguang on 13-7-8.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800SinaWeiboVo : NSObject <NSCoding> {
    NSString *_nickName;
    NSDate *_expiresAt;
    NSString *_accessToken;
    NSInteger _partnerType;
}

@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, strong) NSDate *expiresAt;
@property(nonatomic, copy) NSString *accessToken;
@property(nonatomic, assign) NSInteger partnerType;

@end