//
//  Tao800PaymentPayFinishBVO.h
//  tao800
//
//  Created by enfeng on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TBService/Tuan800API.h>

@class Tao800PaymentPayFinishAlixPayBVO;
@class Tao800PaymentPayFinishWeixinBVO;
@class Tao800PaymentPayFinishUnipayBVO;

@interface Tao800PaymentPayFinishBVO : NSObject

@property (nonatomic) BOOL successful;

@property (nonatomic, copy) NSString *callBackUrl;
@property (nonatomic, copy) NSString *sellerAccountName; // seller_account_name,供客户端和wap在提交wap支付宝时使用
@property (nonatomic, copy) NSString *md5Key;  //支付宝md5Key
@property (nonatomic, copy) NSString *pubKey;  //支付宝公钥

@property (nonatomic, strong) Tao800PaymentPayFinishAlixPayBVO *alixPayBVO;  //支付宝
@property (nonatomic, strong) Tao800PaymentPayFinishWeixinBVO *weixinBVO;  //微信支付
@property (nonatomic, strong) Tao800PaymentPayFinishUnipayBVO *unipayBVO;  //银联支付

@property (nonatomic, copy) NSString* errorCode;
@property (nonatomic, copy) NSString* errorMessage;

+ (Tao800PaymentPayFinishBVO *)convertPaymentPayFinishBVOWith:(NSDictionary *)dict payMethod:(TBPayMethodFlag) payMethodFlag;
@end
