//
// Created by enfeng on 12-8-7.
// 代金券
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBPaymentConstant.h"

//代金券状态
typedef enum {
    TBPaymentCashCouponStateOk=0,  //正常， 未使用
    TBPaymentCashCouponStateUsed, //已使用
    TBPaymentCashCouponStateInvalid,  //已失效, 已领取
    TBPaymentCashCouponStateSent,  //已发送
    TBPaymentCashCouponStateForbidden = -2,  //已禁用
} TBPaymentCashCouponState;

typedef enum {
    TBPaymentCashCouponChannelDefault=0, //未派发
    TBPaymentCashCouponChannelPointExchange=1, //积分兑换
    TBPaymentCashCouponChannelPointPrize=2, //积分抽奖
    TBPaymentCashCouponChannelActiveEncourage=3, //活动奖励
} TBPaymentCashCouponChannel;

//代金券类型
typedef enum {
    TBPaymentCashCouponTypeNormal,  //代金券
    TBPaymentCashCouponTypeMinus //直减券
} TBPaymentCashCouponType;


@interface TBPaymentCashCouponVo : NSObject {
    TBPaymentCashCouponState _couponState;
    double _price; //代金券金额
    TBPaymentCashCouponType _couponType;
    NSString *_scopeDesc; //使用范围
    NSString *_couponNumber;
    NSString *_startDate;
    NSString *_endDate;
    NSString *_msg;
    NSString *_limitDes;

    //我的已有代金券
    TBPaymentCashCouponChannel _sendChannel;

    TBOrderDaiGouType _selectType;
}
@property(nonatomic, strong) NSString *scopeDesc;
@property(nonatomic, strong) NSString *couponNumber;
@property(nonatomic, strong) NSString *startDate;
@property(nonatomic, strong) NSString *endDate;
@property(nonatomic) TBPaymentCashCouponState couponState;
@property(nonatomic) double price;
@property(nonatomic) TBPaymentCashCouponType couponType;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSString *limitDes;
@property(nonatomic) TBPaymentCashCouponChannel sendChannel;
@property(nonatomic) TBOrderDaiGouType selectType;


@end