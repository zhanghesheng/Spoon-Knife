//
//  TBConstants.h
//  Core
//
//  Created by enfeng yang on 12-1-29.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TBGpsManagerStateNothing=-1,
    TBGpsManagerStateUpdating,
    TBGpsManagerStateFail,
    TBGpsManagerStateSuccess
} TBGpsManagerState;

extern NSString *const TBStoreDBFileName;

extern NSString *const TBGpsManagerDidStartNotification; //开始定位
extern NSString *const TBGpsManagerDidErrorNotification; //定位错误
extern NSString *const TBGpsManagerDidSuccessNotification; //定位成功
extern NSString *const TBGpsManagerDidGetAddressNotification; //地址获取完成，客户端需要判断TBGpsAddressVo中的地址状态
extern NSString *const TBGpsManagerGettingAddressNotification; //正在获取地址

@interface TBConstants : NSObject

@end
