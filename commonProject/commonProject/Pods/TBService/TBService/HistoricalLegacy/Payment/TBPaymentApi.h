//
// Created by enfeng on 12-8-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h"
#import "TBPaymentConstant.h"

#import "TBPaymentParamResultVo.h"
#import "TBPaymentCashCouponVo.h" 
#import "TBUnionPayVo.h"

//订单来源
typedef enum {
    TBOrderFromMovie800 = 0,
    TBOrderFromTuan800 = 1,
    TBOrderFromZhe800Recharge =5
} TBOrderFrom;

extern NSString *const TBPayBackUrl;

@protocol TBPaymentApiDelegate <TBBaseNetworkDelegate>
@optional
- (void)createOrderFinish:(NSDictionary *)finish;

- (void)getOrdersFinish:(NSDictionary *)finish;

- (void)getCouponCodeFinish:(NSDictionary *)finish;

- (void)getPaymentParamsFinish:(NSDictionary *)finish;

- (void)deleteOrderFinish:(NSDictionary *)finish;

- (void)getPayResultFinish:(NSDictionary *)finish;

- (void)getCouponIntroFinish:(NSDictionary *)finish;

- (void)refundOrderFinish:(NSDictionary *)finish;

- (void)getPaymentSuitsFinish:(NSDictionary *)finish;

- (void)getValidCouponsFinish:(NSDictionary *)params;

- (void)setOrderUsedFinish:(NSDictionary *)params;

- (void)deleteOrderV55Finish:(NSDictionary *)params;

- (void)getOrderDetailFinish:(NSDictionary*) params;

- (void)getPayMethodByDealIdFinish:(NSDictionary *)params;

- (void) showOrderLoading;

- (void)preLoadItems:(NSDictionary*) params;

- (void)uploadPayResultFinish:(NSDictionary*) params;
@end


@interface TBPaymentApi : TBBaseNetworkApi

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
 */
- (void)createOrder:(NSDictionary *)params;

- (void)createOrderV2:(NSDictionary *)params;

/**
 * 获取订单列表请求接口
 * @params
 *    key:pageNum(NSString*) 第几页
 *    key:pageSize(NSString*) 每页的记录行数
 *    key:status(NSString*) 0：新订单，1：已支付
 *    key:token(NSString*) 用户登陆后的得到的secToken
 *    key:userName(NSString*)
 */
- (void)getOrders:(NSDictionary *)params;


/**
 * 获取订单列表请求接口
 * @params
 *    key:userId
 *    key:orderNo
 *    key:access_token
 *    key:page
 *    key:pageSize
 *    key:status  表示订单支付状态 0：未支付，1：已支付 
 *    key:client_sign 0--影800，1 --团购大全，不传值时默认为0（影800）
 *    key:mobile
 *    key:verifyCode 表示手机验证码 使用手机号查询时使用
 *    key:client_mark_used 表示订单是否消费 0--未消费，1--已消费，不填写值表示全部数据 
 *    key:readed 表示订单是否已读 0--未读，1--已读 ，不填写值表示全部数据
 * @return 缓存
 */
- (NSDictionary *)getOrdersV6:(NSDictionary *)params;

/**
* @return 返回缓存过的数据，如果没有缓存则返回空
*/
- (NSDictionary*) getOrderDetail:(NSDictionary*) params;

/**
 *  key: pageNo (NSString*) 第几页
 *  key: pageSize(NSString*) 每页的记录行数
 *  key: phone_number(NSString*) 手机号码
 *  key: coder(NSString*) 验证码
 *  Finish 方法用getOrdersFinish:方法。
 *
 */
- (void)getHistoryDealOrder:(NSDictionary *)params;


/**
 * 使用电子兑换码请求接口
 * @params
 *   key:qcode
 *   key:user_id
 *   key:device_id
 */
- (void)getCouponCode:(NSDictionary *)params;

/**
 * 获取支付请求需要的参数请求接口
 * @params
 *   key:order_no(NSString*) 支付服务器订单号
 *   key:pay_method(NSString*)1 支付宝 2 银联
 *   key:tracking_id(NSString*)表示手机设备	M	就是request_key
 */
- (void)getPaymentParams:(NSDictionary *)params;

- (void)getPaymentParamsV2:(NSDictionary *)param;

/**
 *删除指定订单记录请求接口
 * @params
 *   key:order_no
 *   key:user_id
 *   key:token
 */
- (void)deleteOrder:(NSDictionary *)params;

/**
 *获取订单成功后的状态
 *
 */
- (void)getPayResult:(NSDictionary *)params;

/**
 *获取代金券使用说明
 */
- (void)getCouponIntro:(NSDictionary *)params;

/**
 *申请退款
 */
- (void)refundOrder:(NSDictionary *)params;

/**
 *获取团购套餐
 *
 * @params
 *    key: deal_id
 *    key: product_id   原接口调用如果不传product_id和select_type字段则按直购套餐处理
 *    key: select_type 表示套餐类型，与deal详情接口的selected_type对应 原接口调用如果不传product_id和select_type字段则按直购套餐处理
 *
 */
- (void)getPaymentSuits:(NSDictionary *)params;

/**
* 我的已有代金券
* @params
*    key: userId(NSString*)
*    key: dealId(NSString*)
*    key: deviceId(NSString*)可以传入mac地址
*    key: clientSign(NSString*)
*    key: hasZhi(NSString*) 是否含有直购券  0:不包含直购券 1：包含
*/
- (void)getValidCoupons:(NSDictionary *)params;

/*
 用户手工设置订单已消费功能
 http请求方式 get
 是否需要登录 true

 order_no 表示订单编号
 user_id 表示用户id
 access_token  表示passport的token
*/
- (void)setOrderUsed:(NSDictionary *)params;

//删除订单
- (void)deleteOrderV55:(NSDictionary *)params;


/**
* 上传支付结果, 支付成功后调用该接口
*
* @params
*   key: order_no
*   key: user_id
*   key: access_token
*/
- (void)uploadPayResult:(NSDictionary *)params;

/**
 * @params
 *  key: deal_id
 *  key: select_type (NSString*)
 */
- (void)getPayMethodByDealId:(NSDictionary *)params;
@end
