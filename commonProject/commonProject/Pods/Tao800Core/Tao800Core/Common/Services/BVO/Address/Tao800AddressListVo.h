//
//  Tao800AddressListVo.h
//  tao800
//
//  Created by LeAustinHan on 14-4-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800AddressListVo : NSObject
@property(nonatomic,copy) NSString *idStr;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *receiverName;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *telCode;
@property(nonatomic,copy) NSString *tel;
@property(nonatomic,copy) NSString *telExtNumber;
@property(nonatomic,copy) NSString *postCode;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *provinceName;
@property(nonatomic,copy) NSString *provinceId;
@property(nonatomic,copy) NSString *cityName;
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,copy) NSString *countyName;
@property(nonatomic,copy) NSString *countyId;
@property(nonatomic,copy) NSString *address;
@property(nonatomic) int isDefault;  //是否是默认地址
@property(nonatomic) BOOL isSelected;  //是否是选中状态
@property(nonatomic) BOOL isRemote;    //是否是偏远地址

@end
