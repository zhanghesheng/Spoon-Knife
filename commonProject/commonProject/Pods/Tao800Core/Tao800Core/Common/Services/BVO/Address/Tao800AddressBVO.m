//
//  Tao800AddressBVO.m
//  tao800
//
//  Created by LeAustinHan on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressBVO.h"
#import "Tao800AddressListVo.h"
#import "TBCore/NSObjectAdditions.h"
#import "Tao800DataModelSingleton.h"

@implementation Tao800AddressBVO

+ (NSArray *)wrapperAddressList:(NSArray *)tags {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *item in tags) {
        Tao800AddressListVo *vo = [Tao800AddressBVO wrapperAddressVo:item];
        [array addObject:vo];
    }
    return array;
}

+ (Tao800AddressListVo *)wrapperAddressVo:(NSDictionary *)item
{
    Tao800AddressListVo *vo = [[Tao800AddressListVo alloc] init];
    vo.idStr = item[@"id"];
    vo.userId = item[@"userId"];
    vo.receiverName = item[@"receiverName"];
    vo.mobile = item[@"mobile"];
    vo.telCode = item[@"telCode"];
    vo.tel = item[@"tel"];
    vo.telExtNumber = item[@"telExtNumber"];
    vo.postCode = item[@"postCode"];
    vo.provinceName = item[@"provinceName"];
    vo.provinceId = item[@"provinceId"];
    vo.cityName = item[@"cityName"];
    vo.cityId = item[@"cityId"];
    vo.countyName = item[@"countyName"];
    vo.countyId = item[@"countyId"];
    vo.address = item[@"address"];
    vo.isDefault = [item[@"isDefault"] boolValue];
    vo.isRemote = [item[@"isFar"] boolValue];
    [vo resetNullProperty];
    return vo;
}

+ (void)addUserInfo:(NSMutableDictionary *)dic
{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    [dic setObject:dm.user.userId forKey:@"user_id"];
    [dic setObject:dm.user.token forKey:@"access_token"];
}

@end
