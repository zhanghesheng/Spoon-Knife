//
//  TBPaymentService.h
//  Tuan800API
//
//  Created by enfeng on 14-1-16.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import "TBBaseService.h"

//表示客户端支付方式
typedef enum _TBPaymentServicePayType {
    TBPaymentServicePayTypeClient = 1,
    TBPaymentServicePayTypeWap = 2
} TBPaymentServicePayType;

@interface TBPaymentService : TBBaseService

/**
 * 获取积分规则
 * 获取赚取积分的任务列表
 * 积分攻略
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: user_id  表示用户id
 *    key: product_id  表示团购产品的id
 *    key: device_id  表示手机设备号
 *    key: client_sign 0--电影票， 1--团购大全， 2--hui800， 3--天天向膳
 *    key: mac 表示手机mac地址
 *    key: mobile 表示手机号
 *    key: select_type 当请求参数有select_type是会返回转换后的值，如果请求没有，则没有该参数
 *    key: total_price 表示购买总价
 *    key: page_no  不传为第一页，-1为返回全部
 *    key: page_size  不传并且page_no不为-1时默认10条
 *    key: has_zhi 表示是否返回直减券数据  0--不返回；1--返回
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetCouponsOfDeal
 */
- (void)getCouponsOfDeal:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

/**
* 创建订单
*
* @params
*     key: user_id
*     key: access_token 表示使用passport接口登录时提供的access_token
*     key: product_id
*     key: count
*     key: total_price
*     key: mobile
*     key: coupon_code 表示代金券号码
*     key: additional_info 若为兜有选座，格式为：放映序列号|_|区块编号1:rowNo1:colNo1|区块编号2:rowNo2:colNo2，最多可以定4个座位
*     key: device_id
*     key: mac
*     key: client_info
*          不做MD5，格式：渠道号码|_|客户端类型|_|客户端版本号|_|来源|_|城市编码|_|utmsource|_|联盟编号|_|CPS联盟编号|_|客户端来源页面|_|是否支持0元购；
*          （1）渠道号码：不存在时以0代替；
*          （2）客户端类型：0:不确定;1:android;2:ios; 3:wap 4:wp 5:win8 6:Lenovo TV
*          （3）客户端版本号：android客户端和ios客户端的版本号，wap以0代替。
*          （4）来源：影800 ： 0  团购大全 ： 1
*          （5）城市编码：由客户端提交过来的城市的编码.没有值时为空字符串
*          （6）utmsource。没有值时为空字符串
*          （7）联盟编号 。没有值时为空字符串
*          （8）CPS联盟编号。没有值时为空字符串。
*          （9）客户端来源页面。没有值时为空字符串。
*          （10）是否支持0元购。0--不支持；1--支持
*     key: product_package_id 表示客户端提交的套餐id
*     key: support_type 表示手机客户端支持的购买能力参数，多值 以逗号分隔
*     key: select_type 表示购买deal的最优支付方式
*     key: pay_method 1-- 支付宝;2-- 银联(已弃用) ;3--银联第二版;7 --财付通;8-- 新浪wap支付
*     key: client_pay_type 1：控件支付；2：客户端中调用网页支付。R5.6（包含该版本）之后都需上传
*     key: orderNo 未支付订单如果需要重新支付，必须传改参数，第一次创建订单不需要上传
*     key: zero_price_remark 表示0元购备注
*     key: shopId 表示0元购备注
*     key: dealSrcId 表示订单来源id
*
*
* @link http://wrd.tuan800-inc.com/mywiki/OrderCreate
*/
- (void)createOrder:(NSDictionary *)params
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
*订单支付
*
* @params
*     key: user_id
*     key: access_token 使用passport接口登录时提供的access_token
*     key: order_no
*     key: pay_method
*     key: client_pay_type
*     key: additional_info  表示客户端ip 微信支付时必须由客户端传入。
*
* @link http://wrd.tuan800-inc.com/mywiki/OrderPay
*/
- (void)orderPay:(NSDictionary *)params
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure;
@end
