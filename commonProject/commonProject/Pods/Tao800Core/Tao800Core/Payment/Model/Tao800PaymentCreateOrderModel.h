//
//  Tao800PaymentCreateOrderModel.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>


#import "UPPayPluginDelegate2.h"

@class Tao800PaymentProductVo;
@class Tao800AddressListVo;
@class Tao800PaymentPayFinishBVO;
@class Tao800PaymentCreateOrderFinishBVO;

typedef void (^PaySuccessBlock)(void);

typedef void (^PayFailBlock)(TBErrorDescription *);

@interface Tao800PaymentCreateOrderModel : TBModel<UPPayPluginDelegate>
@property(nonatomic, strong) Tao800PaymentPayFinishBVO *payFinishBVO;
@property(nonatomic, strong) Tao800PaymentCreateOrderFinishBVO *orderFinishBVO;
@property(nonatomic, strong) NSArray *receivers; //收货人列表数据
@property(nonatomic, strong) Tao800AddressListVo *receiver; //收货人
@property(nonatomic, strong) Tao800PaymentProductVo *productVo; //商品
@property(nonatomic) int productCount;
@property(nonatomic, copy) NSString *payChannel;

@property(nonatomic, copy) PaySuccessBlock paySuccessBlock;
@property(nonatomic, copy) PayFailBlock payFailBlock;
@property BOOL getAddressError;

- (void)pay:(NSDictionary *)paramsExt
 completion:(void (^)(NSDictionary *))completion
    failure:(void (^)(TBErrorDescription *))failure;

- (void)wrapperItems;

- (void)upPay:(PaySuccessBlock)completion
      failure:(PayFailBlock)failure;

/**
* 支付宝极简收银台
*/
- (void)simpleAlixPay:(PaySuccessBlock)completion
              failure:(PayFailBlock)failure;

/**
* 微信支付
*/
- (void)weixinPay:(PaySuccessBlock)completion
          failure:(PayFailBlock)failure;

/**
* 创建订单
*/
- (void)createOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
* 获取收货人列表
*/
- (void)getReceivers:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;

- (NSString *)totalPrice;

- (NSString *)totalScore;
@end
