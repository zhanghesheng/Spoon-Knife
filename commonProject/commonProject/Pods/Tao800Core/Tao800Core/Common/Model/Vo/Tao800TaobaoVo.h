//
//  Tao800TaobaoVo.h
//  tao800
//
//  Created by worker on 13-2-4.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800TaobaoVo : NSObject <NSCoding> {
    NSString *_nickName;
    NSDate *_expiresAt;
    NSString *_accessToken;
    int _partnerType;
}

@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, strong) NSDate *expiresAt;
@property(nonatomic, copy) NSString *accessToken;
@property(nonatomic, assign) int partnerType;

@end
