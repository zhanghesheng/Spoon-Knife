//
//  TBPaymentService.m
//  Tuan800API
//
//  Created by enfeng on 14-1-16.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <TBUI/TBErrorDescription.h>
#import "TBPaymentService.h"
#import "TBPaymentCashCouponVo.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "TBOrderVo.h"


#ifdef DEBUG
NSString *const TBPaymentBaseURL1 = @"http://116.255.143.150:8130";
NSString *const TBPaymentBaseURL2 = @"http://116.255.143.150:8131";
NSString *const TBPaymentBaseURL3 = @"http://116.255.143.150:8133";
NSString *const TBPaymentBaseURL4 = @"http://116.255.143.150:8136";

#else
NSString *const TBPaymentBaseURL1 = @"http://m.api.tuan800.com";
NSString *const TBPaymentBaseURL2 = @"http://m.api.tuan800.com";
NSString *const TBPaymentBaseURL3 = @"http://m.api.tuan800.com";
NSString *const TBPaymentBaseURL4 = @"http://m.api.tuan800.com";
#endif

@implementation TBPaymentService
- (TBPaymentCashCouponVo *)convertJsonToPaymentCashCouponVo:(NSDictionary *)dict {
    if (dict) {
        TBPaymentCashCouponVo *couponVo = [[TBPaymentCashCouponVo alloc] init];
        NSString *status = [dict objectForKey:@"status" convertNSNullToNil:YES];
        NSString *saveOn = [dict objectForKey:@"save_on" convertNSNullToNil:YES];
        NSString *couponNo = [dict objectForKey:@"coupon_no" convertNSNullToNil:YES];
        NSString *couponNo2 = [dict objectForKey:@"couponNo" convertNSNullToNil:YES];
        if (couponNo == nil) {
            couponNo = couponNo2;
        }
        NSString *endDate = [dict objectForKey:@"end_date" convertNSNullToNil:YES];
        NSString *type = [dict objectForKey:@"type" convertNSNullToNil:YES];
        NSString *msg = [dict objectForKey:@"msg" convertNSNullToNil:YES];
        NSString *scopeDesc = [dict objectForKey:@"scope_desc" convertNSNullToNil:YES];
        NSNumber *selectedType = [dict objectForKey:@"select_type" convertNSNullToNil:YES];
        NSNumber *sendChannel = [dict objectForKey:@"sendChannel" convertNSNullToNil:YES];

        int st = status.intValue;
        int tp = type.intValue;

        int sType = selectedType.intValue;
        int iSendChannel = sendChannel.intValue;

        couponVo.scopeDesc = scopeDesc;
        couponVo.msg = msg;
        couponVo.endDate = endDate;
        couponVo.price = [saveOn doubleValue];
        couponVo.couponNumber = couponNo;
        couponVo.couponType = (TBPaymentCashCouponType) tp;
        couponVo.couponState = (TBPaymentCashCouponState) st;

        couponVo.sendChannel = (TBPaymentCashCouponChannel) iSendChannel;
        couponVo.selectType = (TBOrderDaiGouType) sType;

        return couponVo;
    }
    return nil;
}

- (NSArray *)convertMyCouponJsonToPaymentCashCouponVo:(NSArray *)array {
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *dict in array) {
        TBPaymentCashCouponVo *couponVo = [self convertJsonToPaymentCashCouponVo:dict];
        [array1 addObject:couponVo];
    }
    return array1;
}

- (void)getCouponsOfDeal:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:
            @"%@/coupons-api/get-valid-coupons.json",
            TBPaymentBaseURL4];

    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPaymentService *instance = self;

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        NSMutableDictionary *retObj = nil;
        if (dict) {
            NSArray *arr = [dict objectForKey:@"coupons"];
            arr = [instance convertMyCouponJsonToPaymentCashCouponVo:arr];
            NSString *select_type = [dict objectForKey:@"select_type" convertNSNullToNil:YES];
            retObj = [NSMutableDictionary dictionaryWithObject:arr forKey:@"items"];
            if (select_type) {
                [retObj setValue:select_type forKey:@"select_type"];
            }
        }
        completion(retObj);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)createOrder:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure {

    NSMutableDictionary *paramsExt = [NSMutableDictionary dictionaryWithDictionary:params];

    NSDictionary *clientInfoParams = params[@"clientInfo"];

    //client_info组装参数
    NSString *partner = [clientInfoParams objectForKey:@"partner"];
    NSString *cityId = [clientInfoParams objectForKey:@"cityId"];
    NSString *orderFrom = [clientInfoParams objectForKey:@"orderFrom"];
    NSString *currVer = [clientInfoParams objectForKey:@"currVer"];
    NSString *dealVoFrom = [clientInfoParams objectForKey:@"dealVoFrom"];
    NSString *zeroPay = [clientInfoParams objectForKey:@"zeroPay"];//0--不支持；1--支持

    if (orderFrom == nil) {
        orderFrom = [NSString stringWithFormat:@"%d", TBOrderTypeMovie];
    }

    if (cityId == nil) {
        cityId = @"";
    }
    if (dealVoFrom == nil) {
        dealVoFrom = @"";
    }
    if (!zeroPay) {
        zeroPay = @"0";
    } else {
        zeroPay = @"1";
    }

    //渠道号码|_|客户端类型|_|客户端版本号|_|来源|_|城市编码|_|utmsource|_|联盟编号|_|CPS联盟编号|_|客户端来源页面
    //渠道号码|_|客户端类型|_|客户端版本号|_|来源|_|城市编码
    //渠道号码|_|客户端类型|_|客户端版本号
    NSMutableArray *clientInfoArr = [NSMutableArray arrayWithCapacity:10];
    [clientInfoArr addObject:partner]; //渠道号码
    [clientInfoArr addObject:@"2"]; //客户端类型 0:不确定  1：android， 2：ios 3:wap, 4wp ...
    [clientInfoArr addObject:currVer]; //客户端版本号
    [clientInfoArr addObject:orderFrom]; //来源
    [clientInfoArr addObject:cityId]; //城市编码
    [clientInfoArr addObject:@""]; //utmsource
    [clientInfoArr addObject:@""]; //联盟编号
    [clientInfoArr addObject:@""]; //CPS联盟编号
    [clientInfoArr addObject:dealVoFrom]; //客户端来源页面
    [clientInfoArr addObject:zeroPay]; //零元换购

    NSString *clientInfo = [clientInfoArr componentsJoinedByString:@"|_|"];

    [paramsExt setValue:clientInfo forKey:@"client_info"];

    //删除传入的clientInfo参数
    [paramsExt removeObjectForKey:@"clientInfo"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/create.json",
                                                                 TBPaymentBaseURL2]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPaymentService *instance = self;

    [self wrapperPostRequest:paramsExt request:request];

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }

        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)orderPay:(NSDictionary *)params
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pay.json", TBPaymentBaseURL2]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;

    __weak ASIFormDataRequest *pRequest = request;
    __weak TBPaymentService *instance = self;

    [self wrapperPostRequest:params request:request];

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }

        completion(dict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}


@end
