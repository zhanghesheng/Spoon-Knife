//
//  Tao800AddressListModel.m
//  tao800
//
//  Created by LeAustinHan on 14-4-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressListModel.h"

#import "Tao800AddressManageService.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800AddressListVo.h"
#import "Tao800AddressListItems.h"
#import "Tao800LoadMoreItem.h"

@interface Tao800AddressListModel ()
@property(nonatomic, strong) Tao800AddressManageService *dealService;
@end


@implementation Tao800AddressListModel
@synthesize addressVo = _addressVo;

-(id)init{
    self = [super init];
    if (self) {
        self.dealService = [[Tao800AddressManageService alloc] init];
    }
    return self;
}

-(void)wrapperLoadMoreItem{
    for (NSObject *objItem in self.items) {
        if ([objItem isKindOfClass:[Tao800LoadMoreItem class]]) {
            [self.items removeObject:objItem];
            break;
        }
    }
    if (self.hasNext) {
        Tao800LoadMoreItem *item = [[Tao800LoadMoreItem alloc] init];
        item.text = @"努力加载中...";
        [self.items addObject:item];
    }
}

-(void)loadAddressListItems:(NSDictionary *)params
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *userId = dm.user.userId;
    if (!userId) {
        userId = @"";
    }
    NSString *token = dm.user.token;
    if (!token) {
        token = @"";
    }
    __weak Tao800AddressListModel *instance = self;
    NSDictionary *paramt = @{
                           @"user_id": userId,
                           @"access_token":token};
    
    [self.dealService getAddressList:paramt
                               completion:^(NSDictionary *dict) {
                                   NSArray *array = [dict objectForKey:@"items"];
                                   if (array) {
                                       if (_pageNumber <= 1) {
                                           [instance.items removeAllObjects];
                                       }
                                       BOOL hasInputVo = NO;
                                       if (instance.addressVo&&instance.addressVo.idStr) {
                                           NSString *addressId = instance.addressVo.idStr;
                                           
                                           for (Tao800AddressListVo *vo in array) {
                                               if ([vo.idStr isEqualToString:addressId]) {
                                                   vo.isSelected = YES;
                                                   instance.addressVo = vo;
                                                   hasInputVo = YES;
                                               }
                                               //vo.isDefault = 0; 管理地址时对勾
                                               Tao800AddressListItems *item = [[Tao800AddressListItems alloc] init];
                                               item.vo = vo;
                                               [instance.items addObject:item];
                                           }
                                       }
                                       else
                                       {
                                           for (Tao800AddressListVo *vo in array) {
                                               Tao800AddressListItems *item = [[Tao800AddressListItems alloc] init];
                                               item.vo = vo;
                                               
                                               [instance.items addObject:item];
                                           }
                                       }
                                       if (instance.addressVo&&instance.addressVo.idStr&&!hasInputVo) {
                                           if (instance.items.count) {//选择列表时，未找到传入地址回传首条地址
                                               Tao800AddressListItems *item = instance.items[0];
                                               instance.addressVo = item.vo;
                                               item.vo.isSelected = YES;
                                           }
                                           else{
                                               instance.addressVo = nil;
                                           }
                                       }
                                       
                                       
                                       completion(dict);
                                   }
                               } failure:^(TBErrorDescription *error) {
                                   failure(error);
                               }];
    
}

@end
