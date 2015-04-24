//
//  Tao800AddressListModel.h
//  tao800
//
//  Created by LeAustinHan on 14-4-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>
#import "Tao800DealListModel.h"
#import "Tao800AddressListVo.h"

@interface Tao800AddressListModel : Tao800DealListModel
{
    Tao800AddressListVo *_addressVo;
}

@property (nonatomic,strong)Tao800AddressListVo *addressVo;

-(void)loadAddressListItems:(NSDictionary *)params
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure;

@end
