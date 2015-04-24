//
//  TBConstants.m
//  Core
//
//  Created by enfeng yang on 12-1-29.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBConstants.h"

NSString *const TBStoreDBFileName = @"tb.sqlite";

NSString *const TBGpsManagerDidStartNotification = @"TBGpsManagerDidStartNotification"; //开始定位
NSString *const TBGpsManagerDidErrorNotification = @"TBGpsManagerDidErrorNotification"; //定位错误
NSString *const TBGpsManagerDidSuccessNotification = @"TBGpsManagerDidSuccessNotification"; //定位成功
NSString *const TBGpsManagerDidGetAddressNotification = @"TBGpsManagerDidGetAddressNotification"; //地址获取完成，客户端需要判断TBGpsAddressVo中的地址状态
NSString *const TBGpsManagerGettingAddressNotification = @"TBGpsManagerGettingAddressNotification"; //正在获取地址

@implementation TBConstants

@end
