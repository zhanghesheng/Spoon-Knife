//
//  Tao800PaymentCreateOrderModel.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PaymentCreateOrderModel.h"
#import "Tao800PaymentCreateOrderCarriageItem.h"
#import "Tao800PaymentCreateOrderCarriageDescriptionItem.h"
#import "Tao800PaymentCreateOrderDealCountItem.h"
#import "Tao800AddressListVo.h"
#import "Tao800PaymentProductVo.h"
#import "Tao800PaymentPayFinishBVO.h"
#import "Tao800PaymentCreateOrderDealItem.h"
#import "Tao800PaymentCreateOrderPayMethodItem.h"
#import "Tao800PaymentCreateOrderFinishBVO.h"
#import "Tao800PaymentCreateOrderReceiverItem.h"
#import "Tao800PaymentCreateOrderReceiverSetItem.h"
#import "Tao800PaymentCreateOrderReceiverTitleItem.h"
#import "Tao800PaymentCreateOrderTitleItem.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800PaymentService.h"
#import "Tao800AddressManageService.h"
#import "Tao800AddressListVo.h"
#import "Tao800PaymentCreateOrderReceiverBottomItem.h"
#import "Tao800PaymentCreateOrderReceiverErrorItem.h"
#import "Tao800PaymentCreateOrderFinishBVO.h"
#import "Tao800PaymentPayFinishBVO.h"
#import "Tao800InfoPlistVo.h"
#import "Tao800PaymentPayFinishAlixPayBVO.h"
#import "Tao800StaticConstant.h"
#import "Tao800PaymentPayFinishWeixinBVO.h"
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"
#import "Tao800FunctionCommon.h"
#import "TBCore/TBCoreCommonFunction.h"
#import "TBCore/TBCoreUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import <TBShareKit/WXApi.h>
#import <TBShareKit/WXApiObject.h>
#import "TBSharekit/TBSharekit.h"
#import "TBCore/NSString+Addition.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPayPlugin.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800PaymentPayFinishUnipayBVO.h"

#import "Tao800NotifycationConstant.h"

enum {
    CreateOrderModelWeixinAlertTag = 3424
};

@interface Tao800PaymentCreateOrderModel ()
@property(nonatomic, strong) Tao800PaymentService *paymentService;
@property(nonatomic, strong) Tao800AddressManageService *addressManageService;
@end

@implementation Tao800PaymentCreateOrderModel

#pragma mark --- UPPayPluginResult ---
- (void)UPPayPluginResult:(NSString *)result {
    NSString* msg = [result copy];
 
    msg = [msg lowercaseString];
    NSString *tip = @"支付失败";
    if([msg isEqualToString:@"success"]){
        tip= nil;
        if (self.paySuccessBlock)  {
            self.paySuccessBlock();
        }
        //支付成功，直接返回
        return;
    }else if([msg isEqualToString:@"fail"]){
        tip=@" 支付失败! ";
    }else if([msg isEqualToString:@"cancel"]){
        tip=@"你已取消了本次订单的支付!";
    }
    if (self.payFailBlock) {
        TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
        tbd.errorMessage = tip;
        self.payFailBlock(tbd);
    }
}

- (void)upPay:(PaySuccessBlock)completion
          failure:(PayFailBlock)failure {
    if (!self.payFinishBVO || !self.payFinishBVO.successful) {
        TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
        tbd.errorMessage = @"支付失败";
        failure(tbd);
        return;
    }
    self.payFailBlock = failure;
    self.paySuccessBlock = completion;
    Tao800ForwardSingleton *fs = [Tao800ForwardSingleton sharedInstance];
    NSString *orderStr = self.payFinishBVO.unipayBVO.tn;
    
#if DEBUG
    NSString *upModel = @"01";
#else
    NSString *upModel = @"00";
#endif
    
    [UPPayPlugin startPay:orderStr mode:upModel viewController:fs.navigationController delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.payFailBlock) {
        TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
        tbd.errorMessage = @"支付失败";
        self.payFailBlock(tbd);
    }
    switch (alertView.tag) {
        case CreateOrderModelWeixinAlertTag: {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
        }
            break;
        default:
            break;
    }
}

- (void)onWeixinPayResp:(NSNotification *)note {
    BaseResp *resp = note.userInfo[@"resp"];

    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess: {
                if (self.paySuccessBlock) {
                    self.paySuccessBlock();
                }
            }
                break;
            default: {
                TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
                tbd.errorMessage = @"微信支付失败";
                if (resp.errStr && resp.errStr.length > 0) {
                    tbd.errorMessage = resp.errStr;
                }
                if (self.payFailBlock) {
                   self.payFailBlock(tbd);
                }
                
            }
                break;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {
        self.paymentService = [[Tao800PaymentService alloc] init];
        self.addressManageService = [[Tao800AddressManageService alloc] init];

        self.productCount = 1;
        self.payChannel = Tao800PaycChannelAlixPay;

        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(onWeixinPayResp:)
                       name:TBBAppWeixinDidResponseNotification
                     object:nil];
        TBAddObserver(Tao800AlipayDidFinishNotification, self, @selector(alipayCallBackNotify:), nil);
        self.getAddressError = NO;
    }
    return self;
}

- (NSString *)getPostage {
    if (self.productVo.postType == PaymentProductPostTypeFree) {
        return nil;
    } else {
        //部分地区包邮
        if (self.productVo.noFree && self.productVo.noFree.length > 0) {

            NSArray *noFreeArr = [self.productVo.noFree componentsSeparatedByString:@","];
            NSString *provinceId = self.receiver.provinceId;

            BOOL isFree = YES;
            for (NSString *item in noFreeArr) {
                if ([item isEqualToString:provinceId]) {
                    isFree = NO;
                    break;
                }
            }

            if (isFree) {
                return nil; //包邮
            }
        }
        if (self.productCount < 2) {
            return self.productVo.firstPostPrice;
        } else {
            int ct = self.productCount - 1;
            NSDecimalNumber *basePrice = [[NSDecimalNumber alloc] initWithString:self.productVo.firstPostPrice];
            NSDecimalNumber *addPrice = [[NSDecimalNumber alloc] initWithString:self.productVo.addPostPrice];
            NSDecimalNumber *countNumber = [[NSDecimalNumber alloc] initWithInt:ct];
            NSDecimalNumber *price2 = [addPrice decimalNumberByMultiplyingBy:countNumber];
            price2 = [price2 decimalNumberByAdding:basePrice];
            return price2.stringValue;
        }
    }
}

- (void)weixinPay:(PaySuccessBlock)completion
          failure:(PayFailBlock)failure {
    if (!self.payFinishBVO || !self.payFinishBVO.successful) {
        TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
        tbd.errorMessage = @"支付失败";
        failure(tbd);
        return;
    }
    self.payFailBlock = failure;

    if (![WXApi isWXAppInstalled]) {
        // 没有安装微信
        UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"您还没有安装微信，是否立即下载？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"立即下载", nil];
        [alertUpdate setTag:CreateOrderModelWeixinAlertTag];
        [alertUpdate show];
        return;
    }

    self.paySuccessBlock = completion;

    Tao800PaymentPayFinishWeixinBVO *weixinBVO = self.payFinishBVO.weixinBVO;

    PayReq *request = [[PayReq alloc] init];
    request.partnerId = weixinBVO.partnerId;
    request.prepayId = weixinBVO.prepayId;
    request.nonceStr = weixinBVO.nonceStr;
    request.timeStamp = (uint) [weixinBVO.timestamp intValue];
    request.package = weixinBVO.package;
    request.sign = weixinBVO.sign;

    // 检查微信是否已被用户安装
    if ([WXApi isWXAppInstalled]) {
        // 安装微信了
        [WXApi safeSendReq:request];
    }else {
        // 没有安装微信
        UIAlertView *alertUpdate = [[UIAlertView alloc]
                initWithTitle:nil
                      message:@"您还没有安装微信，是否立即下载？"
                     delegate:self
            cancelButtonTitle:@"取消"
            otherButtonTitles:@"立即下载", nil];
        [alertUpdate setTag:1111];
        [alertUpdate show];
    }

}


- (void) alipayCallBackNotify:(NSNotification*) note {
    NSDictionary *dict = note.userInfo;
    [self checkAlipayResult:dict];
}


- (void) checkAlipayResult :(NSDictionary *)dict{
    NSString *message = dict[@"memo"];
    NSString *resultStatus = dict[@"resultStatus"];
    
    int status = [resultStatus intValue];
    if (message && [message trim].length < 1) {
        message = nil;
    }
    
    if (status == 9000) {
        if (self.paySuccessBlock)  {
            self.paySuccessBlock();
        }
    } else {
        if (status == 6001) {//用户取消了支付
            message = @"支付失败";
        }
        if (!message) {
            message = @"支付失败";
        }
        
        TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
        tbd.errorMessage = message;
        if (self.payFailBlock) {
            self.payFailBlock(tbd);
        }
    }
}

- (void)simpleAlixPay:(PaySuccessBlock)completion
              failure:(PayFailBlock)failure {
    if (!self.payFinishBVO || !self.payFinishBVO.successful) {
        return;
    }
    self.paySuccessBlock = completion;
    self.payFailBlock = failure;

//    NSString *orderStr = self.payFinishBVO.alixPayBVO.alixStr;
    NSString *orderStr = self.payFinishBVO.alixPayBVO.orderStr;
    if (!orderStr || orderStr.trim.length<1) {
        orderStr = self.payFinishBVO.alixPayBVO.alixStr;
    }

    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
    NSString *appScheme = da.infoPlistVo.alixpay;

    __weak Tao800PaymentCreateOrderModel *weakInstance = self;
    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *dict) {
  
        [weakInstance checkAlipayResult:dict];

    }];
}

- (void)pay:(NSDictionary *)paramsExt
 completion:(void (^)(NSDictionary *))completion
    failure:(void (^)(TBErrorDescription *))failure {

    __weak Tao800PaymentCreateOrderModel *instance = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsExt];
    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
    NSString *userId = da.user.userId;
    NSString *accessToken = da.user.token;

    NSString* ipAddress = [TBCoreUtil getIpAddress];

    [params setValue:userId forKey:@"user_id"];
    [params setValue:accessToken forKey:@"access_token"];
    [params setValue:@"app" forKey:@"pay_platform"]; //
    [params setValue:self.payChannel forKey:@"pay_channel"];  //支付方式
    [params setValue:ipAddress forKeyPath:@"additional_info"];

//    [params setValue:@"true" forKey:@"debug"];
    [self.paymentService pay:params
                  completion:^(NSDictionary *cDict) {
                      instance.payFinishBVO = cDict[@"payFinishBVO"];
                      if (instance.payFinishBVO.successful) {
                          //调用支付
                          completion(nil);
                      } else {
                          completion(@{@"errorMessage" : instance.payFinishBVO.errorMessage});
                      }
                  }
                     failure:^(TBErrorDescription *error) {
                         failure(error);
                     }];
}

- (NSString *)getUGCJSONString {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    TBLogAnalysisBaseHeader *headerVo = [dm getHeaderVo];
    NSDictionary *jsonDict = @{
            @"source" : headerVo.appName,
            @"platform" : headerVo.platform,
            @"version" : headerVo.appVersion,
            @"channelId" : headerVo.partner,
            @"deviceId" : headerVo.macAddress,
            @"userId" : dm.user.userId
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:(NSJSONWritingOptions) 0
                                                         error:&error];

    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (void)createOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure {

    NSString *jsonString = [self getUGCJSONString];

    __weak Tao800PaymentCreateOrderModel *instance = self;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:16];
    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
    NSString *userId = da.user.userId;
    NSString *accessToken = da.user.token;

    //购买数量
    NSString *count = [NSString stringWithFormat:@"%d", self.productCount];

    //不要直接将字符串转为double后做运算，对于某些double值会导致运算出错
    NSDecimalNumber *singlePrice = [Tao800Util convertToPayPrice:self.productVo.price];

    NSString *totalPrice = [self totalPrice];
    NSString *totalScore = [self totalScore];  //需要的积分
    NSString *postage = [self getPostage]; //邮费
    if (!postage) {
        postage = @"0";
    }

    [params setValue:userId forKey:@"user_id"];
    [params setValue:accessToken forKey:@"access_token"];
    [params setValue:self.productVo.sellerId forKey:@"seller_id"]; //商家id
    [params setValue:self.productVo.tradeCode forKey:@"trade_code"];    //Z0001 积分兑换类
    [params setValue:totalPrice forKey:@"amount"];      //总金额
    [params setValue:self.payChannel forKey:@"pay_channel"];  //支付方式
    [params setValue:self.productVo.productId forKey:@"product_id"]; //产品id
    [params setValue:self.productVo.skuNum forKey:@"sku_num"];
    [params setValue:singlePrice.stringValue forKey:@"cur_price"]; //商品单价
    [params setValue:count forKey:@"count"];
    [params setValue:postage forKey:@"postage"];  //邮费
    [params setValue:self.receiver.receiverName forKey:@"receiver_name"]; //收货人
    [params setValue:self.receiver.idStr forKey:@"address_id"];           //收货地址id
    [params setValue:self.receiver.address forKey:@"receiver_address"];  //收货地址
    [params setValue:totalScore forKey:@"score"];  //所需积分
    [params setValue:self.productVo.title forKey:@"product_name"];  //产品名称
    [params setValue:jsonString forKey:@"client_info"];  //产品名称

    [self.paymentService createOrder:params
                          completion:^(NSDictionary *cDict) {
                              instance.orderFinishBVO = cDict[@"orderFinishBVO"];
                              if (!instance.orderFinishBVO.successful) {
                                  completion(@{@"errorMessage" : instance.orderFinishBVO.errorMessage});
                              } else {
                                  NSDictionary *dict = @{@"order_id" : instance.orderFinishBVO.orderNo};
                                  [instance pay:dict
                                     completion:completion
                                        failure:failure];
                              }
                          }
                             failure:^(TBErrorDescription *error) {
                                 failure(error);
                             }];

}

- (void)wrapperItems {

    [self.items removeAllObjects];

    Tao800PaymentCreateOrderDealItem *dealItem = [[Tao800PaymentCreateOrderDealItem alloc] init];
    Tao800PaymentCreateOrderDealCountItem *countItem = [[Tao800PaymentCreateOrderDealCountItem alloc] init];
    Tao800PaymentCreateOrderReceiverTitleItem *receiverTitleItem = [[Tao800PaymentCreateOrderReceiverTitleItem alloc] init];

    dealItem.productVo = self.productVo;

    countItem.text = [NSString stringWithFormat:@"%d", self.productCount];
    countItem.productCount = self.productCount;
    countItem.limitCount = self.productVo.maxBuyLimit;

    [self.items addObject:dealItem];   //商品详情
    [self.items addObject:countItem];  //数量
    [self.items addObject:receiverTitleItem]; //收货信息标题

    if (!self.receiver) {
        //设置收货地址
        Tao800PaymentCreateOrderReceiverSetItem *setItem = [[Tao800PaymentCreateOrderReceiverSetItem alloc] init];
        Tao800PaymentCreateOrderReceiverErrorItem *errorItem = [[Tao800PaymentCreateOrderReceiverErrorItem alloc] init];
        if(self.getAddressError){
            [self.items addObject:errorItem];
        }else{
            [self.items addObject:setItem];
        }
        receiverTitleItem.editButtonEnabled = NO;
    } else {
        receiverTitleItem.editButtonEnabled = YES;
        Tao800PaymentCreateOrderReceiverItem *receiver = [[Tao800PaymentCreateOrderReceiverItem alloc] init];
        Tao800PaymentCreateOrderReceiverItem *receiverAddress = [[Tao800PaymentCreateOrderReceiverItem alloc] init];
        Tao800PaymentCreateOrderReceiverItem *receiverMobile = [[Tao800PaymentCreateOrderReceiverItem alloc] init];

        NSString *provinceName = self.receiver.provinceName;
        NSString *cityName = self.receiver.cityName;
        NSString *countyName = self.receiver.countyName;
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",
                        provinceName,
                        cityName,
                        countyName,
                        self.receiver.address
        ];

        receiver.title = @"收货人：";
        receiver.text = self.receiver.receiverName;
        receiverAddress.title = @"收货地址：";
        receiverAddress.text = address;
        receiverMobile.title = @"手机号：";
        receiverMobile.text = self.receiver.mobile;

        [self.items addObject:receiver];        //收货人
        [self.items addObject:receiverAddress]; //收货地址
        [self.items addObject:receiverMobile];  //手机号

        Tao800PaymentCreateOrderReceiverBottomItem *receiverBottomItem = [[Tao800PaymentCreateOrderReceiverBottomItem alloc] init];
        [self.items addObject:receiverBottomItem];
    }

    //配送方式
    Tao800PaymentCreateOrderTitleItem *carriageTitleItem = [[Tao800PaymentCreateOrderTitleItem alloc] init];
    Tao800PaymentCreateOrderCarriageDescriptionItem *carriageDescriptionItem = [[Tao800PaymentCreateOrderCarriageDescriptionItem alloc] init];

    carriageTitleItem.text = @"支付及配送方式";
    carriageTitleItem.bgColor = BACKGROUND_COLOR_GRAT2;
    carriageDescriptionItem.text = @"由于参与兑换的人数较多，工作人员会在兑换成功后的15-20个工作日内将礼品发出兑换成功后，可在个人中心-我的礼品中根据快递单号查看订单配送情况";

    [self.items addObject:carriageTitleItem];           //配送方式标题
    if (self.receiver) {

        Tao800PaymentCreateOrderCarriageItem *carriageItem = [[Tao800PaymentCreateOrderCarriageItem alloc] init];
        if (self.productVo.postType == PaymentProductPostTypeFree) {
            //包邮
            carriageItem.text = @"包邮";
            carriageItem.postFree = YES;
        } else {
            NSString *postage = [self getPostage];
            NSString *postageLabelText = FenToYuanFormat(postage.intValue);
            if (!postage) {
                carriageItem.text = @"包邮";
                carriageItem.postFree = YES;
            } else {
                carriageItem.text = [NSString stringWithFormat:@"%@元", postageLabelText];
                carriageItem.postFree = NO;
            }
        }
        [self.items addObject:carriageItem];                //运费

    } else {
        carriageDescriptionItem.top = 5;
    }
    [self.items addObject:carriageDescriptionItem];     //配送描述

    //支付方式标题
    Tao800PaymentCreateOrderTitleItem *payTitleItem = [[Tao800PaymentCreateOrderTitleItem alloc] init];
    Tao800PaymentCreateOrderPayMethodItem *alixPayItem = [[Tao800PaymentCreateOrderPayMethodItem alloc] init];

    payTitleItem.text = @"选择支付方式";
    alixPayItem.title = @"支付宝";
    alixPayItem.subTitle = @"支付宝，知托付";
    alixPayItem.imageUrl = @"bundle://v6_payment_alix_icon@2x.png";

    [self.items addObject:payTitleItem];   //支付方式，标题
    [self.items addObject:alixPayItem];    //支付宝

}

- (void)wrapperDefaultReceiver {
    for (Tao800AddressListVo *addressListVo in self.receivers) {
        if (addressListVo.isDefault) {
            self.receiver = addressListVo;
            return;
        }
    }
    if (self.receivers.count > 0) {
        self.receiver = self.receivers[0];
    }
}

- (void)getReceivers:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *userId = dm.user.userId;
    NSString *token = dm.user.token;

    __weak Tao800PaymentCreateOrderModel *instance = self;
    NSDictionary *receiverParam = @{
            @"user_id" : userId,
            @"access_token" : token,
            @"default" : @"1",
    };

    [self.addressManageService getAddressList:receiverParam
                                   completion:^(NSDictionary *dict) {
                                       self.getAddressError = NO;
                                       instance.receivers = [dict objectForKey:@"items"];
                                       [instance wrapperDefaultReceiver];
                                       completion(dict);
                                   } failure:^(TBErrorDescription *error) {
                                       self.getAddressError = YES;
                                       int i=0;
                                       for(i=0; i<self.items.count; ++i){
                                           Tao800PaymentCreateOrderBaseItem *oneItem = [self.items objectAtIndex:i];
                                           if([oneItem isKindOfClass:[Tao800PaymentCreateOrderReceiverSetItem class]]){
                                               break;
                                           }
                                       }
                                       if(i != self.items.count){
                                           Tao800PaymentCreateOrderReceiverErrorItem *errorItem = [[Tao800PaymentCreateOrderReceiverErrorItem alloc] init];
                                           [self.items removeObjectAtIndex:i];
                                           [self.items insertObject:errorItem atIndex:i];
                                       }
                                       failure(error);
    }];

}

- (NSString *)totalPrice {

    //不要直接将字符串转为double后做运算，对于某些double值会导致运算出错
    NSDecimalNumber *singlePrice = [Tao800Util convertToPayPrice:self.productVo.price];
    NSDecimalNumber *countNum = [[NSDecimalNumber alloc] initWithInt:self.productCount];
    NSDecimalNumber *totalPriceFen = [singlePrice decimalNumberByMultiplyingBy:countNum];

    //邮费
    NSString *postage = [self getPostage];
    if (postage) {
        NSDecimalNumber *postageNumber = [Tao800Util convertToPayPrice:postage];
        totalPriceFen = [totalPriceFen decimalNumberByAdding:postageNumber];
    }
    return [NSString stringWithFormat:@"%@", totalPriceFen];
}

- (NSString *)totalScore {

    //不要直接将字符串转为double后做运算，对于某些double值会导致运算出错
    NSString *score = self.productVo.score;
    NSDecimalNumber *countNum = [[NSDecimalNumber alloc] initWithInt:self.productCount];
    NSDecimalNumber *scoreNum = [[NSDecimalNumber alloc] initWithString:score];

    NSDecimalNumber *totalScore = [scoreNum decimalNumberByMultiplyingBy:countNum];

    return [NSString stringWithFormat:@"%@", totalScore];
}
@end
