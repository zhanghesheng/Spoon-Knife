#import <Foundation/Foundation.h>
#import "TBPaymentConstant.h"

typedef enum {
    TBOrderV6StatusWaitingForPay = 1001, //等待付款
    TBOrderV6StatusPayOk = 1002, //购买成功
    TBOrderV6StatusHadUse = 1003, //已消费
    TBOrderV6StatusRefundProcess = 1004, //退款申请中
    TBOrderV6StatusRefundOk = 1005, //退款成功
    TBOrderV6StatusRefundFail = 1006, //退款失败
    TBOrderV6StatusLottery = 1007, //抽奖单
} TBOrderV6Status;

enum {
    TBVoucherTypeCoupon = 0,
    TBVoucherTypeZhi = 1
};

//标记订单状态
enum {
    TBOrderClientMarkTypeUsed = 1,
    TBOrderClientMarkTypeUnUsed = 0
};

@interface TBOrderV6Vo : NSObject <NSCoding, NSCopying> {
    NSNumber *_appointment;
    NSNumber *_clientMarkUsed;
    NSNumber *_clientOrderStatus;
    NSString *_clientOrderStatusDesc;
    NSString *_code;
    NSString *_content;
    NSNumber *_couponPrice;
    NSString *_createTime;
    NSString *_cue;
    NSNumber *_daiGouType;
    NSNumber *_dealId;
    NSString *_expireTime;
    NSString *_img;
    NSString *_mobile;
    NSString *_orderNo;
    NSNumber *_orderProcess;
    NSString *_orderProcessDesc;
    NSNumber *_orderStatus;
    NSString *_orderStatusDesc;
    NSString *_orderStatusTime;
    NSNumber *_orderType;
    NSString *_passBookUrls;
    NSNumber *_payMethod;
    NSString *_payTime;
    NSNumber *_payment;
    NSString *_productName;
    NSNumber *_productNum;
    NSString *_productPackageId;
    NSString *_productPackageName;
    NSString *_productPackagePrice;
    NSNumber *_productPrice;
    NSNumber *_readFlag;
    NSNumber *_refund;
    NSArray *_refundDescription;
    NSString *_refundUrl;
    NSString *_shopId;
    NSString *_siteOrderNO;
    NSString *_subOrders;
    NSString *_supplier;
    NSString *_tel;
    NSNumber *_total;
    NSString *_url;
    NSNumber *_voucherType;
    NSString *_wpUrl;
    NSString *_lotteriesUrl;
    NSString *_couponNo;
    TBOrderV6Status _clientOrderStatusV6;
}

@property(nonatomic, strong) NSNumber *appointment;
@property(nonatomic, strong) NSNumber *clientMarkUsed; //是否已消费，0--未消费，1--已消费。
@property(nonatomic, strong) NSNumber *clientOrderStatus;  //订单显示状态,1001--等待付款;1002--购买成功;1003--已消费;1004--退款申请中; 1005--退款成功; 1006--退款失败;1007--抽奖单
@property(nonatomic, copy) NSString *clientOrderStatusDesc; //订单显示状态描述
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *content;    //购买须知，使用说明,
@property(nonatomic, strong) NSNumber *couponPrice;
@property(nonatomic, copy) NSString *createTime;   //订单时间(团购时间)
@property(nonatomic, copy) NSString *cue;  //温馨提示
@property(nonatomic, strong) NSNumber *daiGouType;  //代购类型,1--渠道代购,2--渠道直购,3--手动代购,4--自动代购
@property(nonatomic, strong) NSNumber *dealId;
@property(nonatomic, copy) NSString *expireTime; //过期时间
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *orderNo;
@property(nonatomic, strong) NSNumber *orderProcess;  //订单进程,创建订单，0--数据库初始值等待付款，1-- 创建订单后的状态已经付款，2--接受到支付宝通知处理订单为已经付款等待发货，3-- 客户支付后设置为等待发货等待收货，4-- 客户支付成功后且商家已发货，设置为等待收货
@property(nonatomic, copy) NSString *orderProcessDesc; //订单进程的文字描述
@property(nonatomic, strong) NSNumber *orderStatus;    //订单状态,0--正常订单,1--失败订单,5--已经退款,6--退款申请中
@property(nonatomic, copy) NSString *orderStatusDesc;  //订单状态描述
@property(nonatomic, copy) NSString *orderStatusTime;  //订单显示时间
@property(nonatomic, strong) NSNumber *orderType;   //订单类型,0--普通订单,1--团购代购订单,
@property(nonatomic, copy) NSString *passBookUrls;
@property(nonatomic, strong) NSNumber *payMethod;    //支付方式,1--支付宝,2--银联旧版,3--银联新版（当前使用版),4--财付通
@property(nonatomic, copy) NSString *payTime;    //交易时间
@property(nonatomic, strong) NSNumber *payment;    //支付金额
@property(nonatomic, copy) NSString *productName;
@property(nonatomic, strong) NSNumber *productNum;   //商品数量
@property(nonatomic, copy) NSString *productPackageId; //套餐id
@property(nonatomic, copy) NSString *productPackageName; //套餐名称
@property(nonatomic, copy) NSString *productPackagePrice; //套餐价格(单位为分)
@property(nonatomic, strong) NSNumber *productPrice;   //商品价格（单位：分）
@property(nonatomic, strong) NSNumber *readFlag;  // 订单是否已读,0--未读，1--已读，
@property(nonatomic, strong) NSNumber *refund;  //是否支持退款,0--不支持；1--支持，
@property(nonatomic, strong) NSArray *refundDescription;
@property(nonatomic, copy) NSString *refundUrl;  //退款的跳转url；如果为空，跳转本地固有的地址，否则跳转到refundUrl提供的wap地址
@property(nonatomic, copy) NSString *shopId;
@property(nonatomic, copy) NSString *siteOrderNO; //团购站的订单号
@property(nonatomic, copy) NSString *subOrders;
@property(nonatomic, copy) NSString *supplier;  //供应商
@property(nonatomic, copy) NSString *tel;     //客服电话
@property(nonatomic, strong) NSNumber *total;  //总价（单位：分）
@property(nonatomic, strong) NSNumber *voucherType;  //0: 代金券 1：直减券
@property(nonatomic, copy) NSString *url;   //团购的out链接（团800）
@property(nonatomic, copy) NSString *wpUrl;  //提供给wp的外链url
@property(nonatomic, copy) NSString *wapCpsPayUrl;  //cps 支付
@property(nonatomic, copy) NSString *wapCpsViewUrl;  //cps 查看订单
@property(nonatomic, copy) NSString *lotteriesUrl;  //查看0元抽奖中奖用户的wap地址
@property(nonatomic, copy) NSString *couponNo;  //优惠券码
@property(nonatomic, readonly) TBOrderV6Status clientOrderStatusV6;

- (TBPayMethodFlag)payMethodFlag;

- (id)copyWithZone:(NSZone *)zone;

@end
