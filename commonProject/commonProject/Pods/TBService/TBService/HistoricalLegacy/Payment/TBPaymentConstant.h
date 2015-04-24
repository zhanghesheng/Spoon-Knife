//
// Created by enfeng on 13-1-11.
//
// To change the template use AppCode | Preferences | File Templates.
//
//client_sign：0:电影票 1:团购大全 2：hui800 3：天天向膳
typedef enum _TBClientSign {
    TBClientSignMovie = 0, //电影票
    TBClientSignTN800 = 1,  //团购大全
    TBClientSignHui800 = 2,  //hui800
    TBClientSignTTXS = 4,  //天天向膳
} TBClientSign;

/**
*
1: 渠道代购
2: 渠道直购
3: 手动代购
4: 自动代购
5: WAP CPS
*/
typedef enum {
    TBOrderDaiGouTypeNothing = 0,
    TBOrderDaiGouTypeChannelAgent = 1,   //渠道代购
    TBOrderDaiGouTypeChannelImmediate = 2,   //1: 渠道直购
    TBOrderDaiGouTypeManual = 3,   //手动代购
    TBOrderDaiGouTypeAuto = 4,   //自动代购
    TBOrderDaiGouTypeWapCPS = 5,   //WAP CPS
} TBOrderDaiGouType;

/**
* 支付方式
*/
typedef enum TBPayMethodFlag {
    TBPayMethodFlagAlixPay = 1, //支付宝
    TBPayMethodFlagUnionPay = 3, //银联
//    TBPayMethodFlagTenPay = 4, //财付通  4这个值已经废弃  团购大全5.5.2开始已经废弃
    TBPayMethodFlagTenPay = 7, //财付通
    TBPayMethodFlagAlixWapPay = 5, //支付宝网页支付
    TBPayMethodFlagTenWapPay = 1232331, //财付通网页支付 ， 客户端定义
    TBPayMethodFlagWeixinPay = 10, //微信支付

} TBPayMethodFlag;

/**
* 订单状态
*/
typedef enum {
    TBOrderProcessWaitingPay = 1, //等待付款1: 创建订单后的状态
    TBOrderProcessHadPay = 2,       //已经付款2: 接受到支付宝通知处理订单为已经付款
    TBOrderProcessWaitingSend = 3,       //等待发货3: 客户支付后设置为等待发货
    TBOrderProcessWaitingReceiving = 4,       //等待收货4: 客户支付成功后且商家已发货，设置为等待收货
    TBOrderProcessFinish = 5,       //交易完成5: 客户确认收到货后设置为交易完成
} TBOrderProcess;