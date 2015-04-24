//
//  TBUserManualService.h
//  Tuan800API
//  --- 运营相关，后台用户操作的 ---
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//


#import "TBWirelessBaseService.h"

@interface TBUserManualService : TBWirelessBaseService

/**
 * 获取最新版本信息
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: product 如，tuan800,zhe800
 *    key: platform 如，iPhone, iPad
 *    key: cityid
 *    key: trackid 渠道号
 */
- (void)getLatestVersion:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

@end
