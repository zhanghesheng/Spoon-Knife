//
//  Tao800ExposureService.h
//  tao800
//
//  Created by adminName on 14-5-22.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBService/Tuan800API.h>

@interface Tao800ExposureService : TBBaseNetworkApi

//上传曝光
- (void)sendSaveDealLogs:(NSDictionary *)paramsExt
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure;

//上传init 事件
- (void)sendInitLogs:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

//启动3分钟后上传的init 事件
- (void)sendInitThreeMinuteLogs:(NSDictionary *)paramsExt
                     completion:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure;

//用户n次后调用，立刻请求回调相应接口
- (void)sendCpaOutLogs:(NSDictionary *)paramsExt
                     completion:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure;

//用户n次后调用，立刻请求回调相应接口
- (void)sendRegisterLogs:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

//引导页后上传客户端激活信息
- (void)sendAppActiveLogs:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;

@end
