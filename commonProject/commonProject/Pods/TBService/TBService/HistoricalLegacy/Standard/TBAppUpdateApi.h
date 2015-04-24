//
//  TBAppUpdateApi.h
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h"

enum {
    TBAppUpdateApiNoUpdate = 0,
    TBAppUpdateApiMustUpdate = 1,
    TBAppUpdateApiHadUpdate = 2
};

@protocol TBAppUpdateApiDelegate <TBBaseNetworkDelegate>
@optional
- (void)getUpdateVersionFinish:(NSDictionary *)params;
@end

@interface TBAppUpdateApi : TBBaseNetworkApi <ASIHTTPRequestDelegate> {
    NSString *_urlStr;
}

@property(nonatomic, retain) NSString *urlStr;

- (id)initWithUpdateUrl:(NSString *)urlStr;

/**
 * 获取更新信息
 * @params
 *   key:currentVer(NSString*) 当前版本
 */
- (void)getUpdateVersion:(NSDictionary *)params;
@end 
