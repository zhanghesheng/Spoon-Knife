//
//  Tao800PaymentService.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBErrorDescription.h>
#import "Tao800PaymentService.h"
#import "Tao800PaymentCreateOrderFinishBVO.h"
#import "Tao800PaymentPayFinishBVO.h"
#import "Tao800OrderBVO.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBCore.h"

#ifdef DEBUG
NSString *const PaymentUrl = @"http://buy.m.xiongmaoz.com";
#else
NSString *const PaymentUrl = @"http://buy.m.zhe800.com";
#endif


@implementation Tao800PaymentService

- (void)createOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure {

    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/create", PaymentUrl];
    NSURL *url = [NSURL URLWithString:urlString];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;

    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;

    [self wrapperPostRequest:paramsExt request:request];

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        Tao800PaymentCreateOrderFinishBVO *bvo = [Tao800PaymentCreateOrderFinishBVO
                convertCreateOrderFinishBVOWith:dict];

        completion(@{@"orderFinishBVO" : bvo});
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}

- (void)pay:(NSDictionary *)paramsExt
 completion:(void (^)(NSDictionary *))completion
    failure:(void (^)(TBErrorDescription *))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/pay", PaymentUrl];
    NSURL *url = [NSURL URLWithString:urlString];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;

    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;

    [self wrapperPostRequest:paramsExt request:request];


    NSString *payChannel = paramsExt[@"pay_channel"];

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }

        TBPayMethodFlag payMethodFlag = TBPayMethodFlagAlixPay;
        if ([payChannel isEqualToString:Tao800PaycChannelAlixPay]) {
            payMethodFlag = TBPayMethodFlagAlixPay;
        } else if  ([payChannel isEqualToString:Tao800PaycChannelWexinPay]) {
            payMethodFlag = TBPayMethodFlagWeixinPay;
        }

        Tao800PaymentPayFinishBVO *bvo = [Tao800PaymentPayFinishBVO convertPaymentPayFinishBVOWith:dict payMethod:payMethodFlag];
        completion(@{@"payFinishBVO" : bvo});
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
}


- (void)getOrderDetail:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure{

    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/detail", PaymentUrl];
    //NSURL *url = [NSURL URLWithString:urlString];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;

    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;

    //[self wrapperPostRequest:paramsExt request:request];

    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }

        NSDictionary *dic = [dict objectForKey:@"data" convertNSNullToNil:YES];
        Tao800OrderBVO *orderBvo = nil;
        if ([dic isKindOfClass:[NSDictionary class]] && (dic && dic.count>0)) {
            orderBvo = [Tao800OrderBVO wrapperOrderDetail:dic];
        }

        NSDictionary *retDict = ((orderBvo!=nil)? (@{@"items" : orderBvo}):(nil));

        completion(retDict);
    }];

    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];

    [self send:request];
    
}

- (void)cancelOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure{
 
    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/cancel", PaymentUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        /*
         ret:0 非0时为错误 int
         msg:”ok”,
         data:null
         */
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];
}


- (void)deleteOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/delete", PaymentUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        /*
         ret:0 非0时为错误 int
         msg:”ok”,
         data:null
         */
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];

}

- (void)confirmOrder:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/confirm", PaymentUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodPost;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;
    
    [self wrapperPostRequest:paramsExt request:request];
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        /*
         ret:0 非0时为错误 int
         msg:”ok”,
         data:null
         */
        completion(dict);
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];

}

- (void)getOrderList:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/orders/credits/query", PaymentUrl];
    //接口那里写错了 应该是order 后面需要改回来 正式环境
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlString params:paramsExt];
    
  
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.allowCompressedResponse = YES;
    request.requestMethod = TBRequestMethodGet;
    
    __weak ASIFormDataRequest *pRequest = request;
    __weak Tao800PaymentService *instance = self;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = [instance getResponseJsonResult:pRequest];
        if (!dict) {
            TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
            failure(tbd);
            return;
        }
        
        int state = [[dict objectForKey:@"ret"] intValue];
        if (state != 0) {
            TBErrorDescription *tbd = [[TBErrorDescription alloc] init];
            tbd.errorCode = state;
            tbd.errorMessage = (NSString *)dict[@"msg"];
            failure(tbd);
            return;
        }
        //等于0时表示返回成功
        
        NSDictionary *data = [dict objectForKey:@"data" convertNSNullToNil:YES];
        NSString * pageCount = [dict objectForKey:@"pageCount" convertNSNullToNil:YES];
        
        NSArray *deals = [Tao800OrderBVO wrapperOrderBVOList:data];
        NSDictionary *retDict = @{@"items" : deals, @"pageCount":pageCount};
        completion(retDict);
        
    }];
    
    [request setFailedBlock:^{
        TBErrorDescription *tbd = [instance getErrorDescription:pRequest];
        failure(tbd);
    }];
    
    [self send:request];

}
@end
