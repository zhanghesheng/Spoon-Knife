//
// Created by enfeng on 12-8-6.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TBPaymentApi.h"
#import "TBPaymentSuitsVo.h"
#import "TBNetwork/ASIDownloadCache.h"
#import "TBCore/TBURLCache.h"
#import "TBCore/TBCoreCommonFunction.h"
#import "TBOrderV6Vo.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "TBOrderVo.h"
#import "TBCore/NSString+Addition.h"
#import "TBCore/QSStrings.h"

#ifdef DEBUG
NSString *const TBBaseUrlV2 = @"http://116.255.143.150:8131/orders/v2";
NSString *const TBBaseUrl = @"http://116.255.143.150:8130";
NSString *const TBBaseUrl2 = @"http://116.255.143.150:8131";
NSString *const TBBaseUrl3 = @"http://116.255.143.150:8133";
NSString *const TBBaseUrl5 = @"http://116.255.143.150:8131";

NSString *const TBBaseUrl4 = @"http://116.255.143.150:8136";

#else
//NSString *const TBBaseUrlV2 = @"http://buy.tuan800.com/orders/v2";
NSString *const TBBaseUrlV2 = @"http://m.api.tuan800.com/orders/v2";
NSString *const TBBaseUrl = @"http://m.api.tuan800.com";
NSString *const TBBaseUrl2 = @"http://m.api.tuan800.com";
NSString *const TBBaseUrl3 = @"http://m.api.tuan800.com";
NSString *const TBBaseUrl4 = @"http://m.api.tuan800.com";
//NSString *const TBBaseUrl5 = @"http://buy.tuan800.com";
NSString *const TBBaseUrl5 = @"http://m.api.tuan800.com";
#endif

NSString *AlipayMd5Key = @"p1rdz6dqo4stu3uq5u0ggubrqgilryk4";
NSString *CallBackUrl = @"http://m.tuan800.com/orders/alipay_callback_2";
NSString *const TBPayBackUrl = @"http://m.tuan800.com/orders/alipay_callback_2";

@interface TBPaymentApi () {

}
- (NSDictionary *)getOrderDetailResult:(NSDictionary *)dict;
@end

NSObject *TBConvertNSNullClass(NSObject *obj);

@implementation TBPaymentApi {

}


//获取订单成功状态
- (void)getPayResult:(NSDictionary *)params {
    NSString *value = [params objectForKey:@"value"];
    NSString *orderNo = [params objectForKey:@"order_no"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/orders/get_client_pay_result_desc?value=%@&order_no=%@", TBBaseUrl2, value, orderNo]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetResultCode;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}

/**
 *获取团购套餐
 */
- (void)getPaymentSuits:(NSDictionary *)params {
    NSObject *dealId = [params objectForKey:@"deal_id"];
    NSObject *product_id = [params objectForKey:@"product_id"];
    NSObject *select_type = [params objectForKey:@"select_type"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/channel-zhigou-api/get-packages.json?deal_id=%@", TBBaseUrl3, dealId];
    if (product_id && select_type) {
        urlStr = [NSString stringWithFormat:@"%@&product_id=%@&select_type=%@", urlStr, product_id, select_type];
    }

    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetSuits;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}

- (void)getValidCoupons:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *mac = [params objectForKey:@"mac"];
    NSString *total_price = [params objectForKey:@"totalPrice"];
    NSString *clientSign = [params objectForKey:@"clientSign"];

    NSString *page_no = [params objectForKey:@"pageNum"];
    NSString *page_size = [params objectForKey:@"pageSize"];
    NSString *product_id = [params objectForKey:@"productId"];
    NSString *select_type = [params objectForKey:@"selectType"];
    NSString *mobile = [params objectForKey:@"mobile"];
    NSString *device_id = [params objectForKey:@"device_id"];
    NSString *hasZhi = [params objectForKey:@"hasZhi"];

    NSMutableArray *httpParams = [NSMutableArray arrayWithCapacity:10];
    [httpParams addObject:@"user_id="];
    [httpParams addObject:userId];

    [httpParams addObject:@"&product_id="];
    [httpParams addObject:product_id];

    [httpParams addObject:@"&mac="];
    [httpParams addObject:mac];

    [httpParams addObject:@"&client_sign="];
    [httpParams addObject:clientSign];

    [httpParams addObject:@"&page_no="];
    [httpParams addObject:page_no];
    [httpParams addObject:@"&page_size="];
    [httpParams addObject:page_size];
    [httpParams addObject:@"&select_type="];
    [httpParams addObject:select_type];

    if (total_price) {
        [httpParams addObject:@"&total_price="];
        [httpParams addObject:total_price];
    }

    if (mobile) {
        [httpParams addObject:@"&mobile="];
        [httpParams addObject:mobile];
    }
    if (device_id) {
        [httpParams addObject:@"&device_id="];
        [httpParams addObject:device_id];
    }
    if (hasZhi) {
        [httpParams addObject:@"&has_zhi="];
        [httpParams addObject:hasZhi];
    }

    NSString *paramStr = [httpParams componentsJoinedByString:@""];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:
            @"%@/coupons-api/get-valid-coupons.json?%@",
            TBBaseUrl4,
            paramStr]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetValidCoupons;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}


//获取订单列表解析
- (NSMutableArray *)convertJsonToOrders:(NSDictionary *)dict {
    NSArray *dataArr = [dict objectForKey:@"data"];
    if ([dataArr isKindOfClass:[NSNull class]]) {
        dataArr = nil;
    }

    @try {
        if (!(dataArr && [dataArr count] > 0)) {
            return [NSMutableArray arrayWithCapacity:1];
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
        return [NSMutableArray arrayWithCapacity:1];
    }


    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[dataArr count]];

    for (NSDictionary *item in dataArr) {
        NSString *orderNo = [item objectForKey:@"orderNo"];
        NSString *productName = [item objectForKey:@"productName"];
        NSString *payTime = [item objectForKey:@"payTime"];
        NSNumber *productPrice = [item objectForKey:@"productPrice"];
        NSNumber *productNum = [item objectForKey:@"productNum"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *payment = [item objectForKey:@"payment"];
        NSNumber *orderStatus = [item objectForKey:@"orderStatus"];
        NSNumber *daiGouType = [item objectForKey:@"daiGouType"];
        NSString *mobile = [item objectForKey:@"mobile"];
        NSString *supplier = [item objectForKey:@"supplier"];
        int orderType = ((NSString *) [item objectForKey:@"orderType"]).intValue;
        NSString *couponPrice = [item objectForKey:@"couponPrice"];


        NSString *url = [item objectForKey:@"url"];
        NSString *code = [item objectForKey:@"code"];
        NSString *siteOrderNO = [item objectForKey:@"siteOrderNO"];
        NSString *expireTime = [item objectForKey:@"expireTime"];
        NSString *createTime = [item objectForKey:@"createTime"];

        NSString *orderProcess = [item objectForKey:@"orderProcess"];
        NSString *tel = [item objectForKey:@"tel"];
        NSString *cue = [item objectForKey:@"cue"];
        NSString *orderProcessDesc = [item objectForKey:@"orderProcessDesc"];
        NSString *img = [item objectForKey:@"img"];
        NSString *productPackageId = [item objectForKey:@"productPackageId"];
        NSString *productPackageName = [item objectForKey:@"productPackageName"];
        NSString *productPackagePrice = [item objectForKey:@"productPackagePrice"];
        NSNumber *payMethod = [item objectForKey:@"payMethod"];

        NSArray *refundDescription = [item objectForKey:@"refundDescription"];
        NSNumber *isRefundNum = [item objectForKey:@"refund"];
        NSString *refundUrlStr = [item objectForKey:@"refundUrl"];

        NSString *wpUrl = [item objectForKey:@"wpUrl"];
        NSNumber *dealId = [item objectForKey:@"dealId"];
        NSNumber *clientMarkUsed = [item objectForKey:@"clientMarkUsed"];
        NSString *shopId = [item objectForKey:@"shopId"];

        refundDescription = (NSArray *) TBConvertNSNullClass(refundDescription);

        BOOL isRefund = NO;
        if (isRefundNum) {
            isRefund = [isRefundNum boolValue];
        }

        BOOL isclientMarkUsed = NO;
        if (clientMarkUsed) {
            isclientMarkUsed = [clientMarkUsed boolValue];
        }


        TBOrderDaiGouType intDaiGouType = TBOrderDaiGouTypeNothing;
        if (daiGouType) {
            intDaiGouType = (TBOrderDaiGouType) [daiGouType intValue];
        }

        double paymentPrice = 0;
        if (![payment isKindOfClass:[NSNull class]]) {
            paymentPrice = [payment doubleValue];
        }

        TBOrderVo *vo = [[TBOrderVo alloc] init];
        vo.orderNo = orderNo;
        vo.productName = productName;
        vo.productPrice = [productPrice doubleValue];
        vo.total = [total doubleValue];
        vo.productNum = [productNum intValue];
        vo.payment = paymentPrice;
        vo.orderStatus = (TBOrderStatus) [orderStatus intValue];
        vo.payTime = payTime;
        vo.mobile = mobile;
        vo.supplier = supplier;
        vo.orderType = (TBOrderType) orderType;
        vo.couponPrice = couponPrice.doubleValue;
        vo.url = url;
        vo.code = code;
        vo.expireTime = expireTime;
        vo.siteOrderNO = siteOrderNO;
        vo.orderProcess = (TBOrderProcess) ([orderProcess integerValue]);
        vo.createTime = createTime;
//        if (payMethod != NULL) {
//            vo.payMethod = (TBPayMethodFlag)[payMethod intValue];
//        }
        vo.payMethod = (TBPayMethodFlag) [(NSNumber *) TBConvertNSNullClass(payMethod) intValue];
        vo.cue = cue;
        vo.tel = tel;
        vo.daiGouType = intDaiGouType;
        vo.orderProcessDesc = orderProcessDesc;
        vo.imageUrl = img;
        vo.productPackageId = productPackageId;
        vo.productPackageName = productPackageName;
        vo.productPackagePrice = productPackagePrice;

        vo.isRefund = isRefund;
        vo.shopId = shopId;

        NSMutableArray *refundDescription2 = [NSMutableArray arrayWithCapacity:1];
        for (NSString *itemString in refundDescription) {
            NSString *string1 = [itemString trim];
            if (string1.length > 0) {
                [refundDescription2 addObject:string1];
            }
        }
        if (refundDescription2.count > 0) {
            refundDescription = refundDescription2;
        } else {
            refundDescription = nil;
        }
        vo.refundDescription = refundDescription;

        vo.refundUrl = refundUrlStr;

        vo.wpUrl = wpUrl;

        vo.clientMarkUsed = isclientMarkUsed;
        dealId = (NSNumber *) TBConvertNSNullClass(dealId);
        if (dealId)
            vo.dealId = [dealId stringValue];
        [arr addObject:vo];
    }
    return arr;

}

NSObject *TBConvertNSNullClass(NSObject *obj) {
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return obj;
}

- (TBOrderVo *)convertJsonToCreateOrder:(NSDictionary *)dict {
    TBOrderVo *vo = [[TBOrderVo alloc] init];
    NSDictionary *orderDict = [dict objectForKey:@"order_info"];
    if (nil != orderDict) {
        vo.productName = [orderDict objectForKey:@"subject"];
        vo.siteOrderNO = [orderDict objectForKey:@"out_trade_no"];
        vo.orderNo = [orderDict objectForKey:@"order_no"];
        vo.url = [orderDict objectForKey:@"url"];
        vo.total = ((NSString *) [orderDict objectForKey:@"total_fee"]).doubleValue;
    }
    return vo;
}

/**
 * 生成订单
 * @params
 user_id : 用户id
 access_token : passport登录返回的access_token
 product_id: 产品id
 count : 产品数量
 total_price: 总价格(单位为分)
 mobile : 手机号
 coupon_code: 优惠券
 additional_info: 备用 可空
 deviceId : 设备id
 mac : mac地址
 client_info: 客户端信息 格式同旧版
 product_package_id: 套餐id  可空
 //abilities : 能力参数 多个以逗号分隔。
 surport_type ： 所有支持的能力 （取代abilities参数名）
 select_type : 最优能力
 */
- (void)createOrderV2:(NSDictionary *)params {
    NSString *zhe800Url = [params objectForKey:@"_zhe800_mobile_url"];

    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *access_token = [params objectForKey:@"access_token"];
    NSString *product_id = [params objectForKey:@"product_id"];
    NSString *count = [params objectForKey:@"count"];
    NSString *total_price = [params objectForKey:@"total_price"];
    NSString *mobile = [params objectForKey:@"mobile"];
    NSString *coupon_code = [params objectForKey:@"coupon_code"];
    NSString *additional_info = [params objectForKey:@"additional_info"];
    NSString *device_id = [params objectForKey:@"device_id"];
    NSString *mac = [params objectForKey:@"mac"];
    NSString *product_package_id = [params objectForKey:@"product_package_id"];
    NSString *support_type = [params objectForKey:@"support_type"];
    NSString *select_type = [params objectForKey:@"select_type"];
    //client_info组装参数
    NSString *partner = [params objectForKey:@"partner"];
    NSString *cityId = [params objectForKey:@"cityId"];
    NSString *orderFrom = [params objectForKey:@"orderFrom"];
    NSString *currVer = [params objectForKey:@"currVer"];
    NSString *dealVoFrom = [params objectForKey:@"dealVoFrom"];
    NSString *pay_method = [params objectForKey:@"pay_method"];
    NSString *skuNum = [params objectForKey:@"skuNum"];

    //运营id
    //传首页banner或开机大图banner id
    NSString *dealSrcId = [params objectForKey:@"dealSrcId"];  //订单来源   v6

    NSString *shopId = [params objectForKey:@"shopId"];  //订单来源           v6
    NSString *orderNo = [params objectForKey:@"orderNo"];  //表示需要重新支付的订单号             v6

    //0--不支持；1--支持
    NSString *zeroPay = [params objectForKey:@"zeroPay"];

    //0元订单答案
    NSString *zero_price_remark = [params objectForKey:@"zero_price_remark"];

    NSString *clientPayType = @"1";//默认是1.调用客户端支付  2.调用WAP支付

    if (pay_method) {
        TBPayMethodFlag payMethodFlag = (TBPayMethodFlag) pay_method.intValue;
        switch (payMethodFlag) {
                
            case TBPayMethodFlagWeixinPay: {
                
            } break;

            case TBPayMethodFlagAlixPay: {

            }
                break;
            case TBPayMethodFlagUnionPay: {

            }
                break;
            case TBPayMethodFlagAlixWapPay: {
                pay_method = [NSString stringWithFormat:@"%d", TBOrderDaiGouTypeChannelAgent];
                clientPayType = @"2";
            }
                break;
            case TBPayMethodFlagTenPay: {

            }
                break;
            case TBPayMethodFlagTenWapPay: {
                pay_method = [NSString stringWithFormat:@"%d", TBPayMethodFlagTenPay];
                clientPayType = @"2";
            }
                break;
        }
    }

    if (orderFrom == nil) {
        orderFrom = [NSString stringWithFormat:@"%d", TBOrderFromMovie800];
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

//    NSString *clientInfo = [NSString stringWithFormat:@"%@|_|%@|_|%@|_|%@|_|%@",
//                    partner, @"2", currVer, orderFrom, cityId];

    NSURL *url = nil;

    if (zhe800Url) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/create",
                                                              zhe800Url]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/create.json",
                                                              TBBaseUrlV2]];
    }

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];

    request.delegate = self;
    request.serviceMethodFlag = APIPaymentCreateOrder;

    //TODO add Token
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:access_token forKey:@"access_token"];
    [request setPostValue:product_id forKey:@"product_id"];
    [request setPostValue:count forKey:@"count"];
    [request setPostValue:total_price forKey:@"total_price"];
    [request setPostValue:mobile forKey:@"mobile"];
    if (coupon_code) {
        [request setPostValue:coupon_code forKey:@"coupon_code"];
    }
    if (additional_info) {
        [request setPostValue:additional_info forKey:@"additional_info"];
    }
    [request setPostValue:device_id forKey:@"device_id"];
    [request setPostValue:mac forKey:@"mac"];
    [request setPostValue:clientInfo forKey:@"client_info"];
    if (product_package_id) {
        [request setPostValue:product_package_id forKey:@"product_package_id"];
    }
    [request setPostValue:support_type forKey:@"support_type"];
    [request setPostValue:select_type forKey:@"select_type"];
    if (pay_method) {
        [request setPostValue:pay_method forKey:@"pay_method"];
    }
    if (dealSrcId) {
        [request setPostValue:dealSrcId forKey:@"dealSrcId"];
    }
    if (shopId) {
        [request setPostValue:shopId forKey:@"shopId"];
    }
    if (orderNo) {
        [request setPostValue:orderNo forKey:@"orderNo"];
    }
    if (skuNum) {
        [request setPostValue:skuNum forKey:@"skuNum"];
    }

    if (zero_price_remark) {
        [request setPostValue:zero_price_remark forKey:@"zero_price_remark"];
    }

    //v5.6 后加的参数
    [request setPostValue:clientPayType forKey:@"client_pay_type"];
    [self send:request];
}

/**
 * 生成订单
 * @params
 *    key:user_name(NSString*) tuan800 的用户名
 *    key:deal_id(NSString*)
 *    key:count
 *    key:total_price(NSString*)
 *    key:tracking_id(NSString*)表示手机设备	M	就是request_key
 *    key:address_id(NSString*)与address_phone_num必填其一
 *    key:address_phone_num(NSString*)与address_id必填其一
 *    key:address_name(NSString*) 可选
 *    key:address_detail(NSString*) 可选
 *    key:address_zipcode(NSString*) 可选
 *    key:additional_info(NSString*) 可选 例如：网票网，放映流水号|_|座位号
 *    key:coupon_code(NSString*) 优惠券号码
 *    key:orderFrom 来源：影800 ： 0 团购大全 ： 1
 
 */
- (void)createOrder:(NSDictionary *)param {
    NSDictionary *params = [self addNoLoginParams:param];
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *deal_id = [params objectForKey:@"deal_id"];
    NSString *count = [params objectForKey:@"count"];
    NSString *total_price = [params objectForKey:@"total_price"];
    NSString *tracking_id = [params objectForKey:@"device_id"];
    NSString *address_phone_num = [params objectForKey:@"address_phone_num"];
    NSString *additional_info = [params objectForKey:@"additional_info"];
    NSString *coupon_code = [params objectForKey:@"coupon_code"];
    NSString *login_token = [params objectForKey:@"login_token"];
    NSString *access_token = [params objectForKey:@"access_token"];

    NSString *macAddress = [params objectForKey:@"madAddress"];
    NSString *currVer = [params objectForKey:@"currVer"];
    NSString *partner = [params objectForKey:@"partner"];
    NSString *cityId = [params objectForKey:@"cityId"];
    NSString *orderFrom = [params objectForKey:@"orderFrom"];
    NSString *deviceId = [params objectForKey:@"device_id"];
    NSString *mac = [params objectForKey:@"mac"];
    NSString *deviceIdSign = [params objectForKey:@"device_id_sign"];

    //套餐ID
    NSString *productPackageId = [param objectForKey:@"product_package_id"];

    if (orderFrom == nil) {
        orderFrom = [NSString stringWithFormat:@"%d", TBOrderFromMovie800];
    }

    if (cityId == nil) {
        cityId = @"";
    }

    if (additional_info == nil) {
        additional_info = @"";
    }
    if (coupon_code == nil) {
        coupon_code = @"";
    }


    NSString *sep = @"|";
    NSMutableArray *paArr = [NSMutableArray arrayWithCapacity:12];
    [paArr addObject:user_id ? user_id : @""];
    [paArr addObject:deal_id];
    [paArr addObject:count];
    [paArr addObject:total_price];
    if (login_token)
        [paArr addObject:login_token];
    else
        [paArr addObject:@""];//改用access_token login_token为空

    [paArr addObject:@""];
    [paArr addObject:address_phone_num];
    [paArr addObject:@""];
    [paArr addObject:@""];
    [paArr addObject:@""];
    [paArr addObject:coupon_code];
    [paArr addObject:additional_info];

    NSString *sign = [paArr componentsJoinedByString:sep];
    sign = [sign md5];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/orders/create",
                                                                 TBBaseUrl]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];

    request.delegate = self;
    request.serviceMethodFlag = APIPaymentCreateOrder;


    //TODO add Token
    [request setPostValue:deal_id forKey:@"deal_id"];
    [request setPostValue:count forKey:@"count"];
    [request setPostValue:total_price forKey:@"total_price"];

    if (user_id) {
        [request setPostValue:user_id forKey:@"user_id"];
    }
    if (login_token) {
        [request setPostValue:login_token forKey:@"login_token"];
    }
    if (access_token) {
        [request setPostValue:access_token forKey:@"access_token"];
    }
    if (deviceId) {
        [request setPostValue:deviceId forKey:@"device_id"];
    }
    if (mac) {
        [request setPostValue:mac forKey:@"mac"];
    }
    if (deviceIdSign) {
        [request setPostValue:deviceIdSign forKey:@"device_id_sign"];
    }

    if (productPackageId) {
        [request setPostValue:productPackageId forKey:@"product_package_id"];
    }

    [request setPostValue:tracking_id forKey:@"device_id"];
    [request setPostValue:address_phone_num forKey:@"address_phone_num"];
    [request setPostValue:coupon_code forKey:@"coupon_code"];
    [request setPostValue:sign forKey:@"sign"];
    if (additional_info) {
        [request setPostValue:additional_info forKey:@"additional_info"];
    }
    if (macAddress) {
        [request setPostValue:macAddress forKey:@"device_id"];
    }
    //渠道号码|_|客户端类型|_|客户端版本号|_|来源|_|城市编码
    //渠道号码|_|客户端类型|_|客户端版本号
    NSString *clientInfo = [NSString stringWithFormat:@"%@|_|%@|_|%@|_|%@|_|%@", partner, @"2", currVer, orderFrom, cityId];
    [request setPostValue:clientInfo forKey:@"client_info"];

    [self send:request];
}

/**
 * 获取订单列表
 * @params
 *    key:pageNum(NSString*) 第几页
 *    key:pageSize(NSString*) 每页的记录行数
 *    key:status(NSString*) 0：新订单，1：已支付
 *    key:token(NSString*) 用户登陆后的得到的secToken
 *    key:userName(NSString*)
 *    key:client_sign(NSString*) 1
 */



- (NSDictionary *)addNoLoginParams:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *user_Id = [params objectForKey:@"user_id"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *macAddress = GetWifiMacAddress();
    [paramDict setValue:macAddress forKey:@"device_id"];
    [paramDict setValue:macAddress forKey:@"mac"];
    if (userId || user_Id) {
        return paramDict;
    } else {
        NSString *macBase64 = [QSStrings encodeBase64WithString:macAddress];
        NSString *deviceIdSign = [NSString stringWithFormat:@"testkey_%@%@", macBase64, macBase64];
        [paramDict setValue:[deviceIdSign md5] forKey:@"device_id_sign"];
        return paramDict;
    }
}

- (void)getOrders:(NSDictionary *)param {
    NSDictionary *params = [self addNoLoginParams:param];
    NSString *pageNum = [params objectForKey:@"pageNum"];
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *status = [params objectForKey:@"status"];
    NSString *token = [params objectForKey:@"token"];
    NSString *access_token = [params objectForKey:@"access_token"];
    NSString *userId = [params objectForKey:@"userId"];
    NSString *clientSign = [params objectForKey:@"client_sign"];
    NSString *orderNo = [params objectForKey:@"orderNo"];
//    NSString *deviceId = [params objectForKey:@"device_id"];
//    NSString *mac = [params objectForKey:@"mac"];
    NSString *deviceIdSign = [params objectForKey:@"device_id_sign"];
    NSString *client_mark_used = [param objectForKey:@"client_mark_used"];

    NSURL *url = nil;
    NSMutableString *paramUrlStr = [NSMutableString stringWithCapacity:255];
    [paramUrlStr appendString:TBBaseUrl2];
    [paramUrlStr appendFormat:@"/orders/detail?page=%@", pageNum];
    [paramUrlStr appendFormat:@"&pageSize=%@", pageSize];
    [paramUrlStr appendFormat:@"&status=%@", status];
    [paramUrlStr appendFormat:@"&client_sign=%@", clientSign];

    if (orderNo) {
        [paramUrlStr appendFormat:@"&orderNo=%@", orderNo];
    }

    if (client_mark_used) {
        [paramUrlStr appendFormat:@"&client_mark_used=%@", client_mark_used];
    }

    if (userId) {
        [paramUrlStr appendFormat:@"&userId=%@", userId];
        if (token) {
            [paramUrlStr appendFormat:@"&token=%@", token];
        } else {
            [paramUrlStr appendFormat:@"&access_token=%@", access_token];
        }
    }
//    if (deviceId) {
//        [paramUrlStr appendFormat:@"&device_id=%@", deviceId];
//    }
//    if(mac){
//        [paramUrlStr appendFormat:@"&mac=%@", mac];
//    }
    if (deviceIdSign) {
        [paramUrlStr appendFormat:@"&device_id_sign=%@", deviceIdSign];
    }

    NSString *urlStr = [[NSString stringWithString:paramUrlStr] urlEncoded];
    url = [NSURL URLWithString:urlStr];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetOrders;
    request.serviceData = params;
    [request setRequestMethod:TBRequestMethodGet];

    SEL sel = @selector(showOrderLoading);

    int page = [pageNum intValue];
    if (page == 1) {
        TBURLCache *cache = [TBURLCache sharedCache];
        NSData *data = [cache dataForURL:request.url.absoluteString];
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (myString.length > 0) {
            NSDictionary *dict = nil;
            @try {
                dict = [myString JSONValue];
            }
            @catch (NSException *exception) {
                dict = [NSDictionary dictionary];
                [cache removeURL:request.url.absoluteString fromDisk:YES];
            }
            if (dict == nil) {
                dict = [NSDictionary dictionary];
            }

            NSObject *retObj = nil;
            sel = @selector(preLoadItems:);
            NSArray *dataArr = [dict objectForKey:@"data"];
            if ([dataArr isKindOfClass:[NSNull class]]) {
                dataArr = nil;
            }
            if (dataArr && [dataArr count] > 0) {
                NSMutableArray *arr = [self convertJsonToOrders:dict];
                retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
            } else {
                retObj = [NSDictionary dictionaryWithObject:dict forKey:@"error"];
            }
            if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:sel withObject:retObj];
#pragma clang diagnostic pop
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:sel withObject:nil];
#pragma clang diagnostic pop
            }
        }
    } else {

        if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:sel withObject:nil];
#pragma clang diagnostic pop
        }
    }

    //服务器端不支持304
//    ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
//    [request setDownloadCache:sharedCache];
//    NSString *jsonStr = [self cachedResponseJSonStringForURL:request.url];
//    BOOL isCurrentCached = [sharedCache isCachedDataCurrentForRequest:request];
//    if (!isCurrentCached) { //如果缓存已经过期，则先读取出来再发送请求
//        if (jsonStr) {
//            jsonStr = [jsonStr trim];
//            NSDictionary *dict = nil;
//            @try {
//                dict = [jsonStr JSONValue];
//            }
//            @catch (NSException *exception) {
//                dict = [NSDictionary dictionary];
//            }
//
//            NSObject *retObj = nil;
//            SEL sel = @selector(getOrdersFinish:);
//            NSArray *dataArr = [dict objectForKey:@"data"];
//            if (dataArr && [dataArr count] > 0) {
//                NSMutableArray *arr = [self convertJsonToOrders:dict];
//                retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
//            } else {
//                retObj = [NSDictionary dictionaryWithObject:dict forKey:@"error"];
//            }
//            if (self.delegate && [self.delegate respondsToSelector:sel]) {
//                [self.delegate performSelector:sel withObject:retObj];
//            }
//        }
//    }
//
//    NSNumber *tmpTime = [params objectForKey:@"cacheTime"];
//    int cacheTime = 60 * tmpTime.intValue;
//
//    if(cacheTime>0)
//    {
//        [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
//        [request setSecondsToCache:cacheTime]; //缓存时间
//        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//    }

    [self send:request];
}

- (NSDictionary *)getOrdersV6:(NSDictionary *)params {
    NSString *urlStr = [NSString stringWithFormat:@"%@/orders/v6/get_order_list", TBBaseUrl2];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *needClear = params[@"needClear"];
    if (needClear) {
        [mutableDictionary removeObjectForKey:@"needClear"];
    }

    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:mutableDictionary];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetOrdersV6;
    [request setRequestMethod:TBRequestMethodGet];
    request.serviceData = mutableDictionary;
    //支持gzip
    request.allowCompressedResponse = YES;

    NSDictionary *retObj = nil;

    NSString *pageNum = [params objectForKey:@"page"];
    int page = [pageNum intValue];
    if (page == 1) {
        TBURLCache *cache = [TBURLCache sharedCache];
        if (needClear) {
            [cache removeURL:request.url.absoluteString fromDisk:YES];

            [self send:request];
            return nil;
        }

        NSData *data = [cache dataForURL:request.url.absoluteString];
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (myString.length > 0) {
            NSDictionary *dict = nil;
            @try {
                dict = [myString JSONValue];
            }
            @catch (NSException *exception) {
                dict = [NSDictionary dictionary];
                [cache removeURL:request.url.absoluteString fromDisk:YES];
            }
            if (dict == nil) {
                dict = [NSDictionary dictionary];
            }

            NSArray *dataArr = [dict objectForKey:@"data" convertNSNullToNil:YES];
            NSNumber *hasNext = [dict objectForKey:@"hasNext"];
            if (!hasNext) {
                hasNext = @(0);
            }
            NSMutableArray *orders = [NSMutableArray arrayWithCapacity:dataArr.count];
            for (NSDictionary *dictItem in dataArr) {
                TBOrderV6Vo *order = [self wrapperOrderV6Vo:dictItem];
                if ([order.shopId isKindOfClass:[NSNumber class]]) {
                    NSNumber *ssid = (NSNumber *) order.shopId;
                    NSString *orderShopId = [ssid stringValue];
                    order.shopId = orderShopId;
                }

                [orders addObject:order];
            }
            retObj = @{
                    @"items" : orders,
                    @"hasNext" : hasNext
            };
        }

    }

    [self send:request];
    return retObj;
}


- (NSDictionary *)getOrderDetail:(NSDictionary *)params {
    NSString *urlStr = [NSString stringWithFormat:@"%@/orders/detail", TBBaseUrl2];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetOrderDetail;
    [request setRequestMethod:TBRequestMethodGet];
    request.serviceData = params;
    request.allowCompressedResponse = YES;

    NSDictionary *retObj = nil;

    //优先从缓存读取数据
    TBURLCache *cache = [TBURLCache sharedCache];
    NSData *data = [cache dataForURL:request.url.absoluteString];
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (myString.length > 0) {
        NSDictionary *dict = nil;
        @try {
            dict = [myString JSONValue];
        }
        @catch (NSException *exception) {
            dict = [NSDictionary dictionary];
            [cache removeURL:request.url.absoluteString fromDisk:YES];
        }
        if (dict == nil) {
            dict = [NSDictionary dictionary];
        }
        retObj = [self getOrderDetailResult:dict];
    }

    [self send:request];

    return retObj;
}

- (void)getCouponCode:(NSDictionary *)params {

    NSString *coupon_no = [params objectForKey:@"qcode"];
    NSString *mobile = [params objectForKey:@"mobile"];
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *device_id = [params objectForKey:@"device_id"];
    NSString *product_id = [params objectForKey:@"product_id"];
    NSString *total_price = [params objectForKey:@"total_price"];
    NSString *selectType = [params objectForKey:@"selectType"]; //add from v5.5.0
    NSString *hasZhi = [params objectForKey:@"hasZhi"]; //add from v5.7.0

    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:7];
    [paramArr addObject:@"user_id="];
    [paramArr addObject:user_id];

    [paramArr addObject:@"&device_id="];
    [paramArr addObject:device_id];

    [paramArr addObject:@"&qcode="];
    [paramArr addObject:coupon_no];

    [paramArr addObject:@"&product_id="];
    [paramArr addObject:product_id];

    if (total_price) {
        [paramArr addObject:@"&total_price="];
        [paramArr addObject:total_price];
    }

    if (selectType) {
        [paramArr addObject:@"&select_type="];
        [paramArr addObject:selectType];
    }
    if (mobile) {
        [paramArr addObject:@"&mobile="];
        [paramArr addObject:mobile];
    }
    if (hasZhi) {
        [paramArr addObject:@"&has_zhi="];
        [paramArr addObject:hasZhi];
    }

    NSString *paramString = [paramArr componentsJoinedByString:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/activity/check?%@", TBBaseUrl2, paramString];
    urlString = [urlString urlEncoded];

    NSURL *url = [NSURL URLWithString:urlString];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetCouponCode;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}

- (void)getCouponIntro:(NSDictionary *)params {

    NSString *coupon_no = [params objectForKey:@"qcode"];
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *device_id = [params objectForKey:@"device_id"];
    NSString *product_id = [params objectForKey:@"product_id"];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/activity/check?user_id=%@&device_id=%@&qcode=%@&product_id=%@",
            /*TBBaseUrl_CouponCode*/TBBaseUrl2, user_id, device_id, coupon_no, product_id] urlEncoded]];


    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetCouponIntro;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}


- (void)getHistoryDealOrder:(NSDictionary *)params {

    NSString *phone_number = [params objectForKey:@"phone_number"];
    NSString *coder = [params objectForKey:@"coder"];
    NSString *page_size = [NSString stringWithFormat:@"%@", [params objectForKey:@"page_size"]];
    NSString *page_no = [NSString stringWithFormat:@"%@", [params objectForKey:@"page_no"]];

    NSString *urlString = [NSString stringWithFormat:@"http://m.api.tuan800.com/tuan800/getordersbynum.json?phone_number=%@&code=%@&page_size=%@&page_no=%@", phone_number, coder, page_size, page_no];
    NSURL *url = [NSURL URLWithString:urlString];;

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPersonHistoryDealOrder;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;

    int page = [page_no intValue];
    if (page == 1) {
        TBURLCache *cache = [TBURLCache sharedCache];
        NSData *data = [cache dataForURL:request.url.absoluteString];
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (myString.length > 0) {
            NSDictionary *dict = nil;
            @try {
                dict = [myString JSONValue];
            }
            @catch (NSException *exception) {
                dict = [NSDictionary dictionary];
                [cache removeURL:request.url.absoluteString fromDisk:YES];
            }

            NSObject *retObj = nil;
            SEL sel = @selector(preLoadItems:);
            NSArray *dataArr = [dict objectForKey:@"data"];
            if ([dataArr isKindOfClass:[NSNull class]]) {
                dataArr = nil;
            }
            if (dataArr && [dataArr count] > 0) {
                NSMutableArray *arr = [self convertJsonToOrders:dict];
                retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
            } else {
                retObj = [NSDictionary dictionaryWithObject:dict forKey:@"error"];
            }
            if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:sel withObject:retObj];
#pragma clang diagnostic pop
            }
        }

    } else {
        SEL sel = @selector(showOrderLoading);
        if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:sel withObject:nil];
#pragma clang diagnostic pop
        }
    }

    //服务器不支持304
//    ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
//    [request setDownloadCache:sharedCache];
//    NSString *jsonStr = [self cachedResponseJSonStringForURL:request.url];
//    BOOL isCurrentCached = [sharedCache isCachedDataCurrentForRequest:request];
//    if (!isCurrentCached) { //如果缓存已经过期，则先读取出来再发送请求
//        if (jsonStr) {
//            jsonStr = [jsonStr trim];
//            NSDictionary *dict = nil;
//            @try {
//                dict = [jsonStr JSONValue];
//            }
//            @catch (NSException *exception) {
//                dict = [NSDictionary dictionary];
//            }
//            NSObject *retObj = nil;
//            //NSDictionary *dict2 = [dict objectForKey:@"objects"];
//            NSMutableArray *arr = [self convertJsonToOrders:dict];
//            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
//            SEL sel = @selector(getOrdersFinish:);
//            if (self.delegate && [self.delegate respondsToSelector:sel]) {
//                [self.delegate performSelector:sel withObject:retObj];
//            }
//        }
//    }
//
//    NSNumber *tmpTime = [params objectForKey:@"cacheTime"];
//    int cacheTime = 60 * tmpTime.intValue;
//
//    if(cacheTime>0)
//    {
//        [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
//        [request setSecondsToCache:cacheTime]; //缓存时间
//        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//    }

    [self send:request];
}

/**
 *申请退款
 */
- (void)refundOrder:(NSDictionary *)params {

    params = [self addNoLoginParams:params];
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *access_token = [params objectForKey:@"access_token"];
    NSString *deviceId = [params objectForKey:@"device_id"];
    NSString *mac = [params objectForKey:@"mac"];
    NSString *deviceIdSign = [params objectForKey:@"device_id_sign"];

    NSString *order_no = [params objectForKey:@"order_no"]; // 订单编号
    NSString *reason = [params objectForKey:@"reason"]; // 退款原因
    NSString *bank_card_number = [params objectForKey:@"bank_card_number"]; // 银行卡号
    NSString *bank_name = [params objectForKey:@"bank_name"]; // 银行卡开户行

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/refund_request/receive.json",
                                                                 TBBaseUrl2]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];

    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetRefundOrder;

    if (user_id) {
        [request setPostValue:user_id forKey:@"user_id"];
    }
    if (access_token) {
        [request setPostValue:access_token forKey:@"access_token"];
    }
    if (deviceId) {
        [request setPostValue:deviceId forKey:@"device_id"];
    }
    if (mac) {
        [request setPostValue:mac forKey:@"mac"];
    }
    if (deviceIdSign) {
        [request setPostValue:deviceIdSign forKey:@"device_id_sign"];
    }
    if (order_no) {
        [request setPostValue:order_no forKey:@"order_no"];
    }
    if (reason) {
        [request setPostValue:reason forKey:@"reason"];
    }
    if (bank_card_number) {
        [request setPostValue:bank_card_number forKey:@"bank_card_number"];
    }
    if (bank_name) {
        [request setPostValue:bank_name forKey:@"bank_name"];
    }

    [self send:request];
}

- (void)getPaymentParamsV2:(NSDictionary *)params {
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *access_token = [params objectForKey:@"access_token"];
    NSString *order_no = [params objectForKey:@"order_no"];
    NSNumber *payMethod = [params objectForKey:@"pay_method"];
    NSString *clientPayType = @"1";//默认是1.调用客户端支付  2.调用WAP支付

    NSURL *url = nil;
    NSString *zhe800Url = [params objectForKey:@"_zhe800_mobile_url"];

    if (zhe800Url) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pay",
                                                              zhe800Url]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pay.json",
                                                              TBBaseUrlV2]];
    }

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];


    request.delegate = self;
    TBPayMethodFlag payMethodFlag = (TBPayMethodFlag) payMethod.intValue;
    switch (payMethodFlag) {

        case TBPayMethodFlagAlixPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentAlixParams;
        }
            break;
        case TBPayMethodFlagUnionPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentBankParams;
        }
            break;
        case TBPayMethodFlagAlixWapPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentAlixWapParams;
            payMethod = [NSNumber numberWithInt:1];
            clientPayType = @"2";
        }
            break;
        case TBPayMethodFlagTenPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentTenPayParams;
        }
            break;
        case TBPayMethodFlagTenWapPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentTenPayParams;
            payMethod = [NSNumber numberWithInt:TBPayMethodFlagTenPay];
            clientPayType = @"2";
        }
            break;
        case TBPayMethodFlagWeixinPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentWeixinParams;
            NSString *ipAddress = GetIPAddress();
            [request setPostValue:ipAddress forKey:@"additional_info"];
        }
            break;
    }
    [request setPostValue:order_no forKey:@"order_no"];
    [request setPostValue:payMethod forKey:@"pay_method"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:access_token forKey:@"access_token"];
    [request setPostValue:clientPayType forKey:@"client_pay_type"];

    [self send:request];
}


- (void)getPaymentParams:(NSDictionary *)param {
    NSDictionary *params = [self addNoLoginParams:param];
    NSString *order_no = [params objectForKey:@"order_no"];
    NSString *login_token = [params objectForKey:@"login_token"];
    NSString *access_token = [params objectForKey:@"access_token"];
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *source = [params objectForKey:@"source"];
    NSNumber *payMethod = [params objectForKey:@"pay_method"];
    NSString *deviceId = [params objectForKey:@"device_id"];
    NSString *mac = [params objectForKey:@"mac"];
    NSString *deviceIdSign = [params objectForKey:@"device_id_sign"];
    NSString *clientPayType = @"1";//默认是1.调用客户端支付  2.调用WAP支付
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/orders/pay", TBBaseUrl]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];

    request.delegate = self;
    TBPayMethodFlag payMethodFlag = (TBPayMethodFlag) payMethod.intValue;
    switch (payMethodFlag) {
            
        case TBPayMethodFlagWeixinPay:{} break;

        case TBPayMethodFlagAlixPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentAlixParams;
        }
            break;
        case TBPayMethodFlagUnionPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentBankParams;
        }
            break;
        case TBPayMethodFlagAlixWapPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentAlixWapParams;
            payMethod = [NSNumber numberWithInt:1];
            clientPayType = @"2";
        }
            break;
        case TBPayMethodFlagTenPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentTenPayParams;
        }
            break;
        case TBPayMethodFlagTenWapPay: {
            request.serviceMethodFlag = APIPaymentGetPaymentTenPayParams;
            payMethod = [NSNumber numberWithInt:TBPayMethodFlagTenPay];
            clientPayType = @"2";
        }
            break;
    }

    NSString *sign = nil;

    if (login_token) {
        sign = [NSString stringWithFormat:@"%@|%@|%@|%@", order_no, payMethod, login_token, user_id ? user_id : @""];
    }
    else {
        sign = [NSString stringWithFormat:@"%@|%@|%@|%@", order_no, payMethod, @"", user_id ? user_id : @""];
    }
    sign = [sign md5];
    [request setPostValue:order_no forKey:@"order_no"];
    [request setPostValue:payMethod forKey:@"pay_method"];
    if (login_token)
        [request setPostValue:login_token forKey:@""];

    [request setPostValue:source forKey:@"source"];
    [request setPostValue:sign forKey:@"sign"];
    if (user_id) {
        [request setPostValue:user_id forKey:@"user_id"];
    }
    if (access_token)
        [request setPostValue:access_token forKey:@"access_token"];
    if (deviceId) {
        [request setPostValue:deviceId forKey:@"device_id"];
    }
    if (mac) {
        [request setPostValue:mac forKey:@"mac"];
    }
    if (deviceIdSign) {
        [request setPostValue:deviceIdSign forKey:@"device_id_sign"];
    }
    [request setPostValue:clientPayType forKey:@"client_pay_type"];

    [self send:request];
}

/**
 *删除指定订单记录
 *   key:order_no
 *   key:user_id
 *   key:token
 */
- (void)deleteOrder:(NSDictionary *)params {

    NSString *order_no = [params objectForKey:@"order_no"];
    NSString *user_id = [params objectForKey:@"user_id"];
    NSString *token = [params objectForKey:@"token"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/movies/inquire?order_no=%@&user_id=%@&token=%@",
                                                                 TBBaseUrl, order_no, user_id, token]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentDeleteOrder;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];

}

- (void)setOrderUsed:(NSDictionary *)params {
    NSString *order_no = [params objectForKey:@"orderNo"];
    NSString *user_id = [params objectForKey:@"userId"];
    NSString *token = [params objectForKey:@"access_token"];

    /* //正式
    NSURL *url = [NSURL URLWithString :[NSString stringWithFormat:@"%@/orders/set_used.json?order_no=%@&user_id=%@&access_token=%@",
                                        TBBaseUrl, order_no, user_id, token]];
     */

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/orders/set_used.json?order_no=%@&user_id=%@&access_token=%@",
                                                                 TBBaseUrl5, order_no, user_id, token]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentSetOrderUsed;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}


- (void)deleteOrderV55:(NSDictionary *)params {
    NSString *order_no = [params objectForKey:@"orderNo"];
    NSString *user_id = [params objectForKey:@"userId"];
    NSString *token = [params objectForKey:@"access_token"];
    /*
    NSURL *url = [NSURL URLWithString :[NSString stringWithFormat:@"%@/orders/delete.json?order_no=%@&user_id=%@&access_token=%@",
                                        TBBaseUrl, order_no, user_id, token]];
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/orders/delete.json?order_no=%@&user_id=%@&access_token=%@",
                                                                 TBBaseUrl5, order_no, user_id, token]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentDeleteOrderV55;

    [request setRequestMethod:TBRequestMethodGet];

    [self send:request];
}

/**
* 上传支付结果, 支付成功后调用该接口
*
* @params
*   key: order_no
*   key: user_id
*   key: access_token
*   成功时：{" successful ":"1"}
*   失败时：{“successful”:”0”," error_code ":"xxx"," error_msg":"xxxxxxxxxxxx"}
*/
- (void)uploadPayResult:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/orders/receive_pay_info.json", TBBaseUrl2]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentUploadPayResult;
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        [request setPostValue:value forKey:key];
    }

    [self send:request];
}

- (void)getPayMethodByDealId:(NSDictionary *)params {
    NSString *urlStr = [NSString stringWithFormat:@"%@/orders/v6/get_paymethod_by_dealid", TBBaseUrl2];
    NSURL *url = [self wrapperUrlForRequestMethodGet:urlStr params:params];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetPayMethodByDealId;
    [request setRequestMethod:TBRequestMethodPost];
    request.serviceData = params;
    //支持gzip
    request.allowCompressedResponse = YES;

    [self send:request];
}

//获取支付请求 -- 支付宝
- (TBPaymentParamResultVo *)convertJsonToPaymentParamResultVo:(NSDictionary *)dict {
    TBPaymentParamResultVo *alixVo = [[TBPaymentParamResultVo alloc] init];
    alixVo.md5Key = [dict objectForKey:@"md5_key"];
    alixVo.callBackUrl = [dict objectForKey:@"call_back_url"];
    NSRange callBackUrlRange = [alixVo.callBackUrl rangeOfString:@"?"];
    if (callBackUrlRange.length > 0) {
        alixVo.callBackUrl = [alixVo.callBackUrl substringToIndex:callBackUrlRange.location];
    }
    alixVo.sellerAccountName = [dict objectForKey:@"seller_account_name"];
    NSDictionary *payDict = [dict objectForKey:@"payment_info"];
    if (payDict != (NSDictionary *) [NSNull null]) {
        alixVo.sign = [payDict objectForKey:@"sign"];
        alixVo.body = [payDict objectForKey:@"body"];
        alixVo.totalFee = [payDict objectForKey:@"total_fee"];
        alixVo.subject = [payDict objectForKey:@"subject"];
        alixVo.signType = [payDict objectForKey:@"sign_type"];
        alixVo.notifyUrl = [payDict objectForKey:@"notify_url"];
        alixVo.partner = [payDict objectForKey:@"partner"];
        alixVo.outTradeNo = [payDict objectForKey:@"out_trade_no"];
        alixVo.seller = [payDict objectForKey:@"seller"];
        //财付通
        alixVo.tokenId = [payDict objectForKey:@"token_id"];
        alixVo.bargainorId = [payDict objectForKey:@"bargainor_id"];


        if (alixVo.tokenId && alixVo.bargainorId) {
            NSArray *arrayUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
            NSDictionary *dictSchemes = [arrayUrl objectAtIndex:0];
            NSArray *arraySchemes = [dictSchemes objectForKey:@"CFBundleURLSchemes"];
            for (NSString *schemes in arraySchemes) {
                if ([schemes hasPrefix:@"tenpay"]) {
                    alixVo.notifyUrl = [NSString stringWithFormat:@"%@://payresult?result=${result}&retcode=${retcode}&retmsg=${retmsg}&sp_data=${sp_data}", schemes];
                }
            }

        }
    }
    alixVo.pubKey = [dict objectForKey:@"pub_key"];
    return alixVo;
}


- (TBUnionPayVo *)convertJsonToUnionPayVo:(NSDictionary *)dict {
    TBUnionPayVo *payVo = [[TBUnionPayVo alloc] init];
    NSDictionary *payDict = [dict objectForKey:@"payment_info"];
    if (payDict != (NSDictionary *) [NSNull null]) {
        payVo.senderSignature = [payDict objectForKey:@"cupMobile.senderSignature"];
        payVo.merchantId = [payDict objectForKey:@"cupMobile.transaction.merchant:id"];
        payVo.order = [payDict objectForKey:@"cupMobile.transaction.order"];
        payVo.merchantCountry = [payDict objectForKey:@"cupMobile.transaction.merchant:country"];
        payVo.type = [payDict objectForKey:@"cupMobile.transaction:type"];
        payVo.merchantName = [payDict objectForKey:@"cupMobile.transaction.merchant:name"];
        payVo.resultURL = [payDict objectForKey:@"cupMobile.transaction.resultURL"];
        payVo.submitTime = [payDict objectForKey:@"cupMobile.transaction.submitTime"];
        payVo.transAmount = [payDict objectForKey:@"cupMobile.transaction.transAmount"];
        payVo.terminalId = [payDict objectForKey:@"cupMobile.transaction.terminal:id"];
        payVo.orderId = [payDict objectForKey:@"cupMobile.transaction.order:id"];
        payVo.version = [payDict objectForKey:@"cupMobile:version"];
        payVo.xmlData = [payDict objectForKey:@"xmlData"];
        payVo.spId = [payDict objectForKey:@"sp_id"];
        payVo.sysProvider = [payDict objectForKey:@"sys_provider"];
    }
    return payVo;
}

//获取支付请求 -- 支付宝WAP版
- (void)convertJsonToAlixWapVo:(NSDictionary *)dict {

    TBPaymentParamResultVo *payVo = [self convertJsonToPaymentParamResultVo:dict];
    NSString *reqData = [self convertPaymentToPaymentXML:payVo];
    CallBackUrl = payVo.callBackUrl;

    NSString *secId = @"MD5";
    NSString *partner = payVo.partner;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *reqId = [formatter stringFromDate:[NSDate date]];

    NSString *format = @"xml";
    NSString *version = @"2.0";
    NSString *service = @"alipay.wap.trade.create.direct";
    AlipayMd5Key = payVo.md5Key;//@"p1rdz6dqo4stu3uq5u0ggubrqgilryk4";

    NSString *sign = [NSString stringWithFormat:@"format=%@&partner=%@&req_data=%@&req_id=%@&sec_id=%@&service=%@&v=%@%@", format, partner, reqData, reqId, secId, service, version, AlipayMd5Key];
    sign = [sign md5];

    //    NSString *postContent = [NSString stringWithFormat:@"format=%@&partner=%@&req_data=%@&req_id=%@&sec_id=%@&service=%@&v=%@&sign=%@",format,partner,reqData,reqId,secId,service,version,sign];

    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:format, @"format",
                                                                          partner, @"partner",
                                                                          reqData, @"req_data",
                                                                          reqId, @"req_id",
                                                                          secId, @"sec_id",
                                                                          service, @"service",
                                                                          version, @"v",
                                                                          sign, @"sign", nil];
    [self getWapPaymentParams:postParams];
}

- (NSDictionary *)convertDataToUrl:(NSDictionary *)resDataDict {
    NSString *location = @"";
//    if (1 == 2) {
//        //解析header
//        NSString *setCookie = [resDataDict objectForKey:@"Set-Cookie"];
//
//        NSRange range11 = [setCookie rangeOfString:@"JSESSIONID="];
//        int location11 = range11.location + range11.length;
//        NSString *jsessionid = [setCookie substringFromIndex:location11];
//        NSRange range21 = [jsessionid rangeOfString:@"; Path"];
//        int location21 = range21.location;
//        jsessionid = [jsessionid substringToIndex:location21];
//
//
//        range11 = [setCookie rangeOfString:@"awid="];
//        location11 = range11.location + range11.length;
//        NSString *awid = [setCookie substringFromIndex:location11];
//        range21 = [awid rangeOfString:@"; Domain"];
//        location21 = range21.location;
//        awid = [awid substringToIndex:location21];
//
//        location = [NSString stringWithFormat:@"http://wappaygw.alipay.com/cashier/cashier_gateway_pay.htm;jsessionid=%@?awid=%@&apiCode=&channelType=CREDIT_CARD_EXPRESS&bankCode=", jsessionid, awid];
//    }

    NSString *resData = [resDataDict objectForKey:@"req_data"];
    NSDictionary *resParams;
    NSString *token = nil, *partner = nil, *sign, *errorMsg = nil;
    NSArray *arrData = [resData componentsSeparatedByString:@"&"];
    for (NSString *itemString in arrData) {
        if ([itemString length] <= 8) {
            continue;
        }//hasprefix

        NSString *string = itemString;
        if ([string hasPrefix:@"partner"]) {
            partner = [string substringFromIndex:8];
        } else if ([string hasPrefix:@"sign"]) {
//            sign = [string substringFromIndex:5];
        } else if ([string hasPrefix:@"res_data"]) {
            NSRange range1 = [string rangeOfString:@"%3Crequest_token%3E"];
            NSUInteger location1 = range1.location + range1.length;
            string = [string substringFromIndex:location1];
            NSRange range2 = [string rangeOfString:@"%3C%2Frequest_token%3E"];
            NSUInteger location2 = range2.location;
            token = [string substringToIndex:location2];
        } else if ([string hasPrefix:@"res_error"]) {
            NSRange range1 = [string rangeOfString:@"%3Cdetail%3E"];
            NSUInteger location1 = range1.location + range1.length;
            string = [string substringFromIndex:location1];
            NSRange range2 = [string rangeOfString:@"%3C%2Fdetail%3E"];
            NSUInteger location2 = range2.location;
            errorMsg = [string substringToIndex:location2];
        }
    }
    if (errorMsg) {
        errorMsg = [errorMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *errorDict = [NSDictionary dictionaryWithObject:errorMsg forKey:@"error_msg"];
        resParams = [NSDictionary dictionaryWithObjectsAndKeys:
                @"-1", @"successful", errorDict, @"item",
                [NSNumber numberWithInt:APIPaymentGetPaymentAlixWapParams], @"methodFlag", nil];
    } else {
        sign = [NSString stringWithFormat:@"format=xml&partner=%@&req_data=<auth_and_execute_req><request_token>%@</request_token></auth_and_execute_req>&sec_id=MD5&service=alipay.wap.auth.authAndExecute&v=2.0%@", partner, token, AlipayMd5Key];
        sign = [sign md5];

        //NSLog(@">>>>>>>>%@\n%@\n%@\n%@\n<<<<<<<",resData,token,partner,sign);
        NSString *urlString = [NSString stringWithFormat:@"http://wappaygw.alipay.com/service/rest.htm?req_data=<auth_and_execute_req><request_token>%@</request_token></auth_and_execute_req>&service=alipay.wap.auth.authAndExecute&sec_id=MD5&partner=%@&sign=%@&format=xml&v=2.0", token, partner, sign];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        resParams = [NSDictionary dictionaryWithObjectsAndKeys:
                @"1", @"successful", url, @"item",
                [NSNumber numberWithInt:APIPaymentGetPaymentAlixWapParams], @"methodFlag", CallBackUrl, @"callBackUrl", location, @"location", nil];
    }

    return resParams;
}

//获取支付宝网页res_data
- (void)getWapPaymentParams:(NSDictionary *)params {

    NSURL *url = [NSURL URLWithString:@"http://wappaygw.alipay.com/service/rest.htm"];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = APIPaymentGetPaymentAlixWapSuccessParams;
    NSArray *arrPostKey = [[params keyEnumerator] allObjects];
    for (NSString *key in arrPostKey) {
        NSString *value = [params objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    [self send:request];
}


- (NSString *)convertPaymentToPaymentXML:(TBPaymentParamResultVo *)payVo {
    //payVo.subject = @"test subject fly";
    NSString *xmlStr = [NSString stringWithFormat:@"<direct_trade_create_req><subject>%@</subject><out_trade_no>%@</out_trade_no><total_fee>%@</total_fee><seller_account_name>%@</seller_account_name><cashier_cade></cashier_cade><call_back_url>%@</call_back_url><notify_url>%@</notify_url></direct_trade_create_req>", payVo.subject, payVo.outTradeNo, payVo.totalFee, payVo.sellerAccountName, payVo.callBackUrl, payVo.notifyUrl];

    return xmlStr;
}

/**
 * 我已有的代金券
 *
 */
- (NSArray *)convertMyCouponJsonToPaymentCashCouponVo:(NSArray *)array {
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *dict in array) {
        TBPaymentCashCouponVo *couponVo = [self convertJsonToPaymentCashCouponVo:dict];
        [array1 addObject:couponVo];
    }
    return array1;
}

/**
 *
 */
- (TBPaymentCashCouponVo *)convertJsonToPaymentCashCouponVo:(NSDictionary *)dict {
    if (dict) {
        TBPaymentCashCouponVo *couponVo = [[TBPaymentCashCouponVo alloc] init];
        NSString *status = [dict objectForKey:@"status"];
        NSString *saveOn = [dict objectForKey:@"save_on"];
        NSString *couponNo = [dict objectForKey:@"coupon_no"];
        NSString *couponNo2 = [dict objectForKey:@"couponNo"];
        if (couponNo == nil) {
            couponNo = couponNo2;
        }
        NSString *startTime = [dict objectForKey:@"start_time" convertNSNullToNil:YES];
        NSArray *startCom = [startTime componentsSeparatedByString:@" "];
        NSString *startDate = @"";
        if(startCom!=nil && startCom.count>=1){
            startDate = [startCom objectAtIndex:0];
        }
        NSString *endDate = [dict objectForKey:@"end_date"];
        NSString *type = [dict objectForKey:@"type"];
        NSString *msg = [dict objectForKey:@"msg"];
        NSString *scopeDesc = [dict objectForKey:@"scope_desc"];
        NSNumber *selectedType = [dict objectForKey:@"select_type"];
        NSNumber *sendChannel = [dict objectForKey:@"sendChannel"];
        NSString *limitDes = [dict objectForKey:@"limit_des" convertNSNullToNil:YES];

        msg = (NSString *) TBConvertNSNullClass(msg);
        scopeDesc = (NSString *) TBConvertNSNullClass(scopeDesc);
        type = (NSString *) TBConvertNSNullClass(type);
        saveOn = (NSString *) TBConvertNSNullClass(saveOn);
        endDate = (NSString *) TBConvertNSNullClass(endDate);
        status = (NSString *) TBConvertNSNullClass(status);

        selectedType = (NSNumber *) TBConvertNSNullClass(selectedType);
        sendChannel = (NSNumber *) TBConvertNSNullClass(sendChannel);

        int st = status.intValue;
        int tp = type.intValue;

        int sType = selectedType.intValue;
        int iSendChannel = sendChannel.intValue;

        couponVo.scopeDesc = scopeDesc;
        couponVo.msg = msg;
        couponVo.startDate = startDate;
        couponVo.endDate = endDate;
        couponVo.price = [saveOn doubleValue];
        couponVo.couponNumber = couponNo;
        couponVo.couponType = (TBPaymentCashCouponType) tp;
        couponVo.couponState = (TBPaymentCashCouponState) st;
        couponVo.limitDes = limitDes;
        
        couponVo.sendChannel = (TBPaymentCashCouponChannel) iSendChannel;
        couponVo.selectType = (TBOrderDaiGouType) sType;

        return couponVo;
    }
    return nil;
}

- (TBOrderV6Vo *)wrapperOrderV6Vo:(NSDictionary *)dict {
    TBOrderV6Vo *orderVo = [[TBOrderV6Vo alloc] init];
    for (NSString *key in dict) {
        id value = [dict objectForKey:key];

        [self setObjectPropertyValue:orderVo value:value forKey:key];
    }
    return orderVo;
}

- (void)requestFinished:(ASIHTTPRequest *)requestParam {
    TBASIFormDataRequest *request = (TBASIFormDataRequest *) requestParam;

    BOOL isError = [self isResponseDidNetworkError:request];
    if (isError) {
        ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
        [sharedCache removeCachedDataForURL:request.url];
        return;
    }

    if (self.delegate == nil) {
        return;
    }

    NSDictionary *dict = nil;
    NSString *dataStr = [request responseString];

    @try {
        if (nil == dataStr) {
            dict = [NSDictionary dictionary];
        } else {
            dict = (NSDictionary *) [dataStr JSONValue];
        }

    }
    @catch (NSException *exception) {
        dict = [NSDictionary dictionary];
    }
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }

    SEL sel = nil;
    NSObject *retObj = nil;

    switch (request.serviceMethodFlag) {
        case APIPaymentGetOrders: {
            NSDictionary *paramDict = (NSDictionary *) request.serviceData;
            NSString *pageNum = [paramDict objectForKey:@"pageNum"];
            int page = [pageNum intValue];
            if (page == 1) {
                TBURLCache *cache = [TBURLCache sharedCache];
                [cache storeData:[request responseData] forURL:request.url.absoluteString];
            }
            sel = @selector(getOrdersFinish:);
            NSMutableArray *arr = [self convertJsonToOrders:dict];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
        }
            break;
        case APIPaymentGetOrdersV6: {
            NSDictionary *paramDict = (NSDictionary *) request.serviceData;
            NSString *pageNum = [paramDict objectForKey:@"page"];
            NSNumber *hasNext = [dict objectForKey:@"hasNext"];
            if (!hasNext) {
                hasNext = @(0);
            }
            NSArray *dataArr = [dict objectForKey:@"data" convertNSNullToNil:YES];
            int page = [pageNum intValue];
            if (page == 1 && dataArr) {
                TBURLCache *cache = [TBURLCache sharedCache];
                if (dataArr && dataArr.count > 0) {
                    [cache storeData:[request responseData] forURL:request.url.absoluteString];
                } else {
                    [cache removeURL:request.url.absoluteString fromDisk:YES];
                }
            }
            sel = @selector(getOrdersFinish:);
            NSMutableArray *orders = [NSMutableArray arrayWithCapacity:dataArr.count];
            for (NSDictionary *dictItem in dataArr) {
                TBOrderV6Vo *order = [self wrapperOrderV6Vo:dictItem];
                if ([order.shopId isKindOfClass:[NSNumber class]]) {
                    NSNumber *ssid = (NSNumber *) order.shopId;
                    NSString *orderShopId = [ssid stringValue];
                    order.shopId = orderShopId;
                }

                [orders addObject:order];
            }
            retObj = @{
                    @"items" : orders,
                    @"hasNext" : hasNext
            };
        }
            break;

        case APIPersonHistoryDealOrder: {
            NSDictionary *paramDict = (NSDictionary *) request.serviceData;
            NSString *pageNum = [paramDict objectForKey:@"page_no"];
            int page = [pageNum intValue];
            if (page == 1) {
                TBURLCache *cache = [TBURLCache sharedCache];
                [cache storeData:[request responseData] forURL:request.url.absoluteString];
            }

            sel = @selector(getOrdersFinish:);
            NSArray *dataArr = [dict objectForKey:@"data"];
            if ([dataArr isKindOfClass:[NSNull class]]) {
                dataArr = nil;
            }
            if (dataArr && [dataArr count] > 0) {
                NSMutableArray *arr = [self convertJsonToOrders:dict];
                retObj = [NSDictionary dictionaryWithObject:arr forKey:@"items"];
            } else {
                retObj = [NSDictionary dictionaryWithObject:dict forKey:@"error"];
            }
        }
            break;
        case APIPaymentCreateOrder: {
            sel = @selector(createOrderFinish:);

            NSString *successful = [dict objectForKey:@"successful"];
            TBOrderVo *orderVo = [self convertJsonToCreateOrder:dict];
            TBOrderResult ret = (TBOrderResult) ([successful intValue]);
            orderVo.ret = ret;

            TBOrderV6Vo *orderVo2 = [[TBOrderV6Vo alloc] init];
            orderVo2.orderNo = orderVo.orderNo;
            orderVo2.url = orderVo.url;
            orderVo2.total = @(orderVo.total);
            orderVo2.siteOrderNO = orderVo.siteOrderNO;

            if (ret == TBOrderResultFail) {
                //                NSNumber *errorCode = [dict objectForKey:@"error_code"];
                NSString *msg = [dict objectForKey:@"error_msg"];
                orderVo.msg = msg;
            }
            //订单创建结果根据TBOrderResult判断
            retObj = @{@"item" : orderVo, @"item2" : orderVo2, @"successful" : successful};
            NSString *errorMessage = [dict objectForKey:@"error_msg" convertNSNullToNil:YES];
            if (errorMessage) {
                retObj = @{@"item" : orderVo,
                        @"item2" : orderVo2,
                        @"successful" : successful,
                        @"errorMessage" : errorMessage
                };
            }
        }
            break;

        case APIPaymentGetCouponCode: {
            sel = @selector(getCouponCodeFinish:);
            TBPaymentCashCouponVo *vo = [self convertJsonToPaymentCashCouponVo:dict];
            if (vo) {
                retObj = [NSDictionary dictionaryWithObject:vo forKey:@"item"];
            }

        }
            break;
        case APIPaymentGetCouponIntro: {
            sel = @selector(getCouponIntroFinish:);
            NSString *result = [dict objectForKey:@"result"];
            retObj = [NSDictionary dictionaryWithObjectsAndKeys:result, @"result", nil];
        }
            break;

        case APIPaymentDeleteOrder: {
            sel = @selector(deleteOrderFinish:);

            NSString *successful = [dict objectForKey:@"successful"];
            if ([successful isEqualToString:@"1"]) {

                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"yes", @"successful",
                        nil];
            } else {

                NSNumber *errorCode = [dict objectForKey:@"error_code"];
                NSNumber *error_msg = [dict objectForKey:@"error_msg"];

                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"no", @"successful",
                        errorCode, @"error_code",
                        error_msg, @"error_msg",
                        nil];
            }
        }
            break;
        case APIPaymentGetPaymentAlixParams: {
            sel = @selector(getPaymentParamsFinish:);
            NSString *successful = [dict objectForKey:@"successful"];
            if ([successful isEqualToString:@"1"]) {
                TBPaymentParamResultVo *vo = [self convertJsonToPaymentParamResultVo:dict];
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", vo, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentAlixParams], @"methodFlag", nil];
            } else {
                successful = @"-1";
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", dict, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentAlixParams], @"methodFlag", nil];
            }
        }
            break;
        case APIPaymentGetPaymentBankParams: {
            sel = @selector(getPaymentParamsFinish:);
            NSString *successful = [dict objectForKey:@"successful"];
            if ([successful isEqualToString:@"1"]) {
                TBUnionPayVo *vo = [self convertJsonToUnionPayVo:dict];
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", vo, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentBankParams], @"methodFlag", nil];
            } else {
                successful = @"-1";
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", dict, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentBankParams], @"methodFlag", nil];
            }

        }
            break;
        case APIPaymentGetPaymentAlixWapParams: {//订单结果
            NSString *successful = [dict objectForKey:@"successful"];
            if ([successful isEqualToString:@"1"]) {
                [self convertJsonToAlixWapVo:dict];
            } else {
                successful = @"-1";
                sel = @selector(getPaymentParamsFinish:);
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", dict, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentAlixWapParams], @"methodFlag", nil];
            }
        }
            break;
        case APIPaymentGetPaymentAlixWapSuccessParams: {
            //得到支付宝返回的req_data
            //组装url
            sel = @selector(getPaymentParamsFinish:);
            NSDictionary *headDict = [requestParam responseHeaders];
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:headDict];
            [dataDict setValue:dataStr forKey:@"req_data"];
            retObj = [self convertDataToUrl:dataDict];
            //NSString *successful = @"1";//[dict objectForKey:@"successful"];
            //retObj = dict;
        }
            break;
        case APIPaymentGetPaymentWeixinParams: {

            NSString *successful = [dict objectForKey:@"successful"];
            if ([successful isEqualToString:@"1"]) {
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful",
                        dict, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentWeixinParams], @"methodFlag", nil];
            } else {
                successful = @"-1";
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful",
                        dict, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentWeixinParams], @"methodFlag", nil];
            }
            sel = @selector(getPaymentParamsFinish:);
        }
            break;
        case APIPaymentGetPaymentTenPayParams: {//财付通
            sel = @selector(getPaymentParamsFinish:);
            NSString *successful = [dict objectForKey:@"successful"];
            if ([successful isEqualToString:@"1"]) {
                TBPaymentParamResultVo *vo = [self convertJsonToPaymentParamResultVo:dict];
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", vo, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentTenPayParams], @"methodFlag", nil];
            } else {
                successful = @"-1";
                retObj = [NSDictionary dictionaryWithObjectsAndKeys:
                        successful, @"successful", dict, @"item",
                        [NSNumber numberWithInt:APIPaymentGetPaymentTenPayParams], @"methodFlag", nil];
            }
        }
            break;
        case APIPaymentGetResultCode: {
            sel = @selector(getPayResultFinish:);
            retObj = dict;
        }
            break;
        case APIPaymentGetRefundOrder: {
            sel = @selector(refundOrderFinish:);
            retObj = dict;
        }
            break;
        case APIPaymentGetSuits://获取套餐
        {
            sel = @selector(getPaymentSuitsFinish:);
            NSMutableArray *arr = [self convertJsonToSuits:dict];
            retObj = [NSDictionary dictionaryWithObject:arr forKey:@"suits"];
        }
            break;
        case APIPaymentGetValidCoupons: //我的已有代金券
        {
            sel = @selector(getValidCouponsFinish:);
            if (dict) {

                NSArray *arr = [dict objectForKey:@"coupons"];
                arr = [self convertMyCouponJsonToPaymentCashCouponVo:arr];
                NSString *select_type = [dict objectForKey:@"select_type" convertNSNullToNil:YES];
                retObj = [NSMutableDictionary dictionaryWithObject:arr forKey:@"items"];
                if (select_type) {
                    [retObj setValue:select_type forKey:@"select_type"];
                }
            }
        }
            break;
        case APIPaymentSetOrderUsed: {

            // retObj = [NSDictionary dictionaryWithObject:dict forKey:@"items"];
            sel = @selector(setOrderUsedFinish:);

            if (dict && [dict count] > 0) {
                retObj = [NSDictionary dictionaryWithObject:dict forKey:@"items"];
            }
        }
            break;

        case APIPaymentDeleteOrderV55: {
            sel = @selector(deleteOrderV55Finish:);
            if (dict && [dict count] > 0) {
                retObj = [NSDictionary dictionaryWithObject:dict forKey:@"items"];
            }
        }
            break;
        case APIPaymentUploadPayResult: {
            sel = @selector(uploadPayResultFinish:);
            retObj = dict;
        }
            break;

        case APIPaymentGetOrderDetail: {
            NSArray *dataArr = [dict objectForKey:@"data" convertNSNullToNil:YES];
            if (dataArr && dataArr.count > 0) {
                TBURLCache *cache = [TBURLCache sharedCache];
                [cache storeData:[request responseData] forURL:request.url.absoluteString];
            }
            sel = @selector(getOrderDetailFinish:);
            retObj = [self getOrderDetailResult:dict];
        }
            break;
        case APIPaymentGetPayMethodByDealId: {
            sel = @selector(getPayMethodByDealIdFinish:);
            retObj = dict;
        }
            break;
        default:
            break;
    }

    if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:retObj];
#pragma clang diagnostic pop
    }

    [super requestFinished:request];
}

- (NSMutableArray *)convertJsonToSuits:(NSDictionary *)params {
    NSArray *arrSuits = (NSArray *) params;
    NSMutableArray *mutArrSuits = [NSMutableArray arrayWithCapacity:arrSuits.count];
    for (NSDictionary *dictSuit in arrSuits) {
        TBPaymentSuitsVo *paySuits = [[TBPaymentSuitsVo alloc] init];
        paySuits.price = [dictSuit objectForKey:@"price"];
        paySuits.name = [dictSuit objectForKey:@"name"];
        paySuits.misSuitId = [dictSuit objectForKey:@"mis_suit_id"];
        if ([paySuits.misSuitId isKindOfClass:[NSNumber class]]) {
            paySuits.misSuitId = [NSString stringWithFormat:@"%@", paySuits.misSuitId];
        }
        [mutArrSuits addObject:paySuits];
    }
    return mutArrSuits;
}

- (NSDictionary *)getOrderDetailResult:(NSDictionary *)dict {
    NSDictionary *retObj = nil;
    NSArray *dataArr = [dict objectForKey:@"data" convertNSNullToNil:YES];
    NSMutableArray *orders = [NSMutableArray arrayWithCapacity:dataArr.count];
    for (NSDictionary *dictItem in dataArr) {
        TBOrderV6Vo *order = [self wrapperOrderV6Vo:dictItem];
        [orders addObject:order];
    }
    if (orders && orders.count > 0) {
        TBOrderV6Vo *order = [orders objectAtIndex:0];
        retObj = [NSDictionary dictionaryWithObject:order forKey:@"item"];
    } else {
        retObj = [NSDictionary dictionary];
    }

    return retObj;
}
@end
