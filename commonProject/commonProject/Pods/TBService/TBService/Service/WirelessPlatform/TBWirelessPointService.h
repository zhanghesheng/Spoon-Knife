//
//  TBWirelessPointService.h
//  Tuan800API
//  --- 积分相关的接口 ---
//  Created by enfeng on 14-1-13.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//


#import "TBWirelessBaseService.h"


@interface TBWirelessPointService : TBWirelessBaseService

/**
 * 获取积分规则
 * 获取赚取积分的任务列表
 * 积分攻略
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: version 客户端版本号
 *    key: product 产品类型 	例如：tuan800,hui800,tao800
 */
- (void)getPointRules:(NSDictionary *)params
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;

/**
 * 增加积分
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: user_id
 *    key: point_key 表示积分操作关键字
 *    key: api_key 由无线后台统一管理，按产品和开发平台分配给客户端，例如团购大全ios有统一的一个key，团购大全android有统一的一个key
 *    key: timestamp ---不需要传该参数--- 时间戳，从1970年1月1日开始所经过的秒数，客户端与服务器时间差不能超过30分钟
 *    key: sign  ---不需要传该参数---
 *  sign字段签名算法如下：
 *
 *  1. 对除api_key、timestamp、sign以外的所有请求参数进行字典升序排列；
 *  2. 将以上排序后的参数表进行字符串连接，如key1value1key2value2key3value3...keyNvalueN；
 *  3. 将api_key作为前缀，将timestamp作为后缀，对该字符串进行MD5计算, 中文的参数值需先转换为UTF8编码
 *  4. 转换为全大写形式后即获得签名串

 *  将以上三个参数附在请求的URL后面进行访问，即可通过验证
 *
 * @return http://wrd.tuan800-inc.com/mywiki/AddIntegralPointV2
 */
- (void)addPoint:(NSDictionary *)params
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure;

/**
 * 查询用户积分
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: user_id
 *
 * @return {"status":true,"user_id":1531784,"score":1013,"query_at":"2014-01-14 13:50:13"}
 * 参看文档 http://wrd.tuan800-inc.com/mywiki/GetIntegralPoint
 */
- (void)getUserPoint:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取用户今日执行的积分任务
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: user_id
 *
 * @return {"tuan800-sign_in_days": 3}
 * 参看文档 http://wrd.tuan800-inc.com/mywiki/GetIntegralTasks
 */
- (void)getTodayTasks:(NSDictionary *)params
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;

/**
 * 邀请好友注册返积分/代金券。
 *
 * @params 参数没有特殊说明的都是字符串类型
 *    key: format  如果需要json格式数据，请设置format=json ---不需要传该参数---
 *    key: product   产品key
 *    key: platform   所属平台key
 *    key: cityid   城市ID
 *    key: trackid   渠道ID
 *    key: inviter_uid   邀请人ID
 *    key: invitee_uid   被邀请人ID
 *    key: device_id    如果不传，不给任何奖励；一个设备只能奖励一次
 *
 * @return
 * 参看文档 http://wrd.tuan800-inc.com/mywiki/InviteFriendsAward
 */
- (void)getPointsByInviter:(NSDictionary *)params
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

@end
