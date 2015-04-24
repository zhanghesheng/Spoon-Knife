//
// Created by enfeng on 12-8-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TBPaymentParamResultVo : NSObject {
    NSString *_partner;
    NSString *_sellerid;             //团购站支付宝ID 支付宝需要
    NSString *_outTradeNo;           //团购站自己产生的订单编号 由团购站生成，支付宝需要
    NSString *_subject;              //商品名称 由团购站生成，支付宝需要
    NSString *_body;                 //商品具体描述信息 由团购站生成，支付宝需要
    NSString *_totalFee;             //总费用 由团购站生成，单位为元，支付宝需要
    NSString *_notifyUrl;            //团购站的支付宝notify的url 支付宝需要
    NSString *_sign;                 //对整个定单按支付宝约定的方式的签名 由团购站生成；通过团购站和支付宝之间的私钥生成的签名；支付宝需要
    NSString *_signType;             //签名格式 由团购站生成，支付宝需要
    NSString *_seller;
    NSString *_pubKey;

    //财付通需要
    NSString *_tokenId;
    NSString *_bargainorId;

    //version 5.3.1 new add
    NSString *_md5Key;
    NSString *_sellerAccountName;
    NSString *_callBackUrl;
}

@property(nonatomic, copy) NSString *partner;
@property(nonatomic, copy) NSString *sellerid;
@property(nonatomic, copy) NSString *outTradeNo;
@property(nonatomic, copy) NSString *subject;
@property(nonatomic, copy) NSString *body;
@property(nonatomic, copy) NSString *totalFee;
@property(nonatomic, copy) NSString *notifyUrl;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, copy) NSString *signType;
@property(nonatomic, copy) NSString *seller;
@property(nonatomic, copy) NSString *pubKey;

@property(nonatomic, copy) NSString *tokenId;
@property(nonatomic, copy) NSString *bargainorId;

@property(nonatomic, copy) NSString *md5Key;
@property(nonatomic, copy) NSString *sellerAccountName;
@property(nonatomic, copy) NSString *callBackUrl;

/**
 * 传给支付宝的字符串
 *
 */
- (NSString *) alixStr;

/**
 *传给财付通网页版URL
 *
 */
-(NSURL *)tenPayWapUrl;

@end
