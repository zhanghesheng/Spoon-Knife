//
//  TBLogVo.h
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBLogVo : NSObject {
    NSDate *logtime;
    NSString *content;
    int contentSize;
}

@property(nonatomic, strong) NSDate *logtime;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, assign) int contentSize;
@end