//
//  Tao800PaymentService.h
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800PaymentService : Tao800BaseService
/**
* 创建订单 积分现金购
* @params
*   key: user_id
*   key: access_token
*   key: seller_id 商家Id
*   key: trade_code 
        Z0001:积分兑换类
        Z0002:话费充值
        Z0003:实体宝贝交易
        Z0004:货到付款
*   key: amount 订单总价格
*   key: pay_channel 买家留言
*   key: product_id
*   key: product_name
*   key: sku_num
*   key: cur_price
*   key: org_price
*   key: count
*   key: postage
*   key: receiver_name
*   key: receiver_mobile
*   key: receiver_tele
*   key: address_id
*   key: receiver_address
*   key: score
*
* @link http://wrd.tuan800-inc.com/mywiki/OrderCreateOfZhe
*/
- (void)createOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
* 订单支付, 返回支付所需要的参数
*   key: user_id
*   key: access_token
*   key: order_id
*   key: pay_channel  支付方式
*   key: order_id
*/
- (void)pay:(NSDictionary *)paramsExt
 completion:(void (^)(NSDictionary *))completion
    failure:(void (^)(TBErrorDescription *))failure;


/*
 订单详情所需要的参数
 key: user_id
 key: access_token
 key: order_id
 */
- (void)getOrderDetail:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;


/*
 订单取消接口
 key: user_id
 key: access_token
 key: order_id
 */

- (void)cancelOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;


/*
 订单删除接口
 key: user_id
 key: access_token
 key: order_id
 */
- (void)deleteOrder:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;


/*
 订单确认收货接口
 key: user_id
 key: access_token
 key: order_id
 */
- (void)confirmOrder:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;

/*
 参数名	类型	描述	 备注
 user_id	string	tuan800 的id		与数据库tuan800中的表users数据对应
 access_token	string	passport登录时access_token
 order_state	String	订单状态		默认0是全状态
 page	String	第几页
 per_page	String	每页数
 */

- (void)getOrderList:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;
@end
