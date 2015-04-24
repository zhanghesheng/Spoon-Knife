//
// Created by enfeng on 12-8-6.
//      orderNo	String	订单号

//等待付款1: 创建订单后的状态
//已经付款2: 接受到支付宝通知处理订单为已经付款
//等待发货3: 客户支付后设置为等待发货
//等待收货4: 客户支付成功后且商家已发货，设置为等待收货
//交易完成5: 客户确认收到货后设置为交易完成


// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "TBPaymentConstant.h"

typedef enum {
    TBOrderStatusRefund = 5, //退款成功
    TBOrderStatusRefunding = 6, //退款中
    TBOrderStatusRefundReject = 9, //退款申请被拒绝
} TBOrderStatus;

typedef enum {
    TBOrderTypeMovie = 0, //电影
    TBOrderTypeGroup = 1, //团购代购订单
} TBOrderType;

typedef enum {
    TBOrderResultOk = 1, //成功
    TBOrderResultFail = 0, //失败
} TBOrderResult;

@interface TBOrderVo : NSObject<NSCoding> {
    NSString *_orderNo;
    NSString *_productName;
    NSString *_payTime;
    double _productPrice;
    int _productNum;
    TBPayMethodFlag _payMethod;
    double _total;
    double _payment;
    NSString *_mobile;
    double _couponPrice;
    NSString *_createTime;
    NSString *_supplier;
    TBOrderStatus _orderStatus;
    TBOrderProcess _orderProcess;

    TBOrderResult _ret;
    //String	返回信息	成功时，显示OK；失败是显示异常信息。
    NSString *_msg;
    TBOrderType _orderType;
    //	String 	团购的out链接（团800）
    NSString *_url;
    //	String	团购券号
    NSString *_code;
    //	String	团购站的订单号
    NSString *_siteOrderNO;
    //	String	到期时间
    NSString *_expireTime;
    NSString *_cue; //用户须知
    NSString *_tel;         //客服电话
    NSString *_orderProcessDesc;   //订单进程描述
    TBOrderDaiGouType _daiGouType;   //代购类型
    NSString *_imageUrl;//订单分享使用
    NSString        *_productPackageId;   //套餐ID
    NSString        *_productPackageName; //套餐名称
    NSString        *_productPackagePrice;//套餐价格

    NSArray *_refundDescription;
    BOOL _isRefund;
    NSString *_refundUrl;
    NSString *_wpUrl;
    
    BOOL _clientMarkUsed;
    NSString *_dealId;
    NSString *_shopId;
}
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *payTime;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *supplier;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *siteOrderNO;
@property(nonatomic, strong) NSString *expireTime;
@property(nonatomic) double payment;
@property(nonatomic) double couponPrice;
@property(nonatomic) double total;
@property(nonatomic) int productNum;
@property(nonatomic) TBPayMethodFlag payMethod;
@property(nonatomic) double productPrice;
@property(nonatomic) TBOrderStatus orderStatus;
@property(nonatomic) TBOrderProcess orderProcess;
@property(nonatomic) TBOrderType orderType;
@property(nonatomic) TBOrderResult ret;
@property(nonatomic, strong) NSString *orderNo;
@property(nonatomic, copy) NSString *cue;
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString *orderProcessDesc;
@property(nonatomic) TBOrderDaiGouType daiGouType;
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *productPackageId;   //套餐ID
@property(nonatomic,strong)NSString *productPackageName; //套餐名称
@property(nonatomic,strong)NSString *productPackagePrice;
@property(nonatomic, strong) NSArray *refundDescription;
@property(nonatomic) BOOL isRefund;
@property(nonatomic, strong) NSString* refundUrl;
@property(nonatomic, copy) NSString *wpUrl;
@property(nonatomic,copy) NSString *shopId;

@property(nonatomic) BOOL clientMarkUsed;//消费状态
@property(nonatomic, strong) NSString *dealId;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;
//套餐价格

@end
