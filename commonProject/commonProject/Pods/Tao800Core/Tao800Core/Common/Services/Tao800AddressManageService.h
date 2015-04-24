//
//  Tao800AddressManageService.h
//  tao800
//
//  Created by LeAustinHan on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800AddressManageService : Tao800BaseService

/**
 * 获取地址列表
 *@param
 *user_id (string)
 *access_token (string)
 *default (string，非必须) 1时只获取默认的地址
 *access_token
 */
- (void)getAddressList:(NSDictionary *)paramt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取地址详情
 */
- (void)getAddressDetail:(NSDictionary *)paramt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**
 * 新增地址接口
 *
 */
- (void)addAddress:(NSDictionary *)paramt
        completion:(void (^)(NSDictionary *))completion
           failure:(void (^)(TBErrorDescription *))failure;

/**
 * 设置当前地址为默认地址
 *
 */
- (void)getDefaultAddress:(NSDictionary *)paramt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;

/**
 * 修改收货地址接口
 *
 */
- (void)editAddress:(NSDictionary *)paramt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
 * 删除收货地址接口
 *
 */
- (void)getDeleteAddress:(NSDictionary *)paramt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

/**
 * 读取本地城市信息
 *
 */
- (void)getCitiesList:(void (^)(NSDictionary *))completion;


/**
* 获取定位城市所在省信息
*
*/
- (void)getLocationProvince:(void (^)(NSDictionary *))completion;


@end
