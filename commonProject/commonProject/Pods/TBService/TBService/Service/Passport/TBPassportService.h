//
//  TBPassportService.h
//  Tuan800API
//
//  Created by enfeng on 14-1-14.
//  Copyright (c) 2014年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBaseService.h"

@interface TBPassportService : TBBaseService

/**
 * 注册
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: phone_number 手机号码
 *   key: phone_confirmation 验证码
 *   key: password
 *   key: password_confirmation  密码确认
 *   key: agreement  同意用户协议 true, false
 *   key: auto_login  注册完成后是否自动登录  true, false
 *   key: domain 如tuan800.com  zhe800.com
 *   key: wireless_invite_code 无线邀请码
 *
 *   --------------以下为统计参数----------------------------
 *   key: app 产品名称
 *   key: platform 平台，如iPhone, iPad
 *   key: version 客户端版本号
 *   key: channel 渠道号
 *   key: deviceId 设备id，可以是macAddress，或者openId等
 *   key: cityId
 *
 *   --------------校园版参数说明----------------------
 *
 *   key: school_spread_info[school_name] 学校名称
 *   key: school_spread_info[school_special_code]  表示校园专用码
 *   key: school_spread_info[department_name]  表示学院/院系
 *   key: school_spread_info[admission_date]  表示入学时间 格式eg: 2013-09-13
 *   key: school_spread_info[name] 表示学生姓名
 *   key: school_spread_info[wireless_invite_code] 表示无线邀请码
 *   key: school_spread_info[gender]  表示性别 -1: 未知，1：男, 2：女
 *   key: school_spread_info[age]  表示学年龄 -1: 表示未知
 *   key: school_spread_info[job_name] 表示工作名称
 *   key: school_spread_info[salary] 表示薪水(单位为元) -1: 表示未知
 *   key: school_spread_info[education]  表示学历
 *
 * @link http://wrd.tuan800-inc.com/mywiki/PassportReg
 */
- (void)signUp:(NSDictionary *)params
    completion:(void (^)(NSDictionary *))completion
       failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取短信验证码
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: phone_number 手机号码
 *   key: registered
 *      取值范围为true或false。
 *      当设置为true时，对应的手机号码必须为已注册，否则会返回错误信息；
 *      当设置为false时，对应的手机号码必须为未注册，否则会返回错误信息。
 *   key: for_bind_phone_number   如果是注册不需要传该参数，绑定新手机号时传 1
 *
 * @link http://wrd.tuan800-inc.com/mywiki/PassportPhoneVerifyCode
 */
- (void)getSecurityCode:(NSDictionary *)params
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

/**
 * 登录
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: phone_number 手机号码
 *   key: password
 *   key: domain 如tuan800.com  zhe800.com
 *
 *   --------------以下为统计参数----------------------------
 *   key: app 产品名称
 *   key: platform 平台，如iPhone, iPad
 *   key: version 客户端版本号
 *   key: channel 渠道号
 *   key: deviceId 设备id，可以是macAddress，或者openId等
 *   key: cityId
 *
 *   @link http://wrd.tuan800-inc.com/mywiki/PassportLogin
 */
- (void)login:(NSDictionary *)params
   completion:(void (^)(NSDictionary *))completion
      failure:(void (^)(TBErrorDescription *))failure;

/**
 * 注销
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: domain 如tuan800.com  zhe800.com
 *
 *   --------------以下为统计参数----------------------------
 *   key: app 产品名称
 *   key: platform 平台，如iPhone, iPad
 *   key: version 客户端版本号
 *   key: channel 渠道号
 *   key: deviceId 设备id，可以是macAddress，或者openId等
 *   key: cityId
 * @link http://wrd.tuan800-inc.com/mywiki/PassportLoginOut
 */
- (void)logout:(NSDictionary *)params
    completion:(void (^)(NSDictionary *))completion
       failure:(void (^)(TBErrorDescription *))failure;

/**
 * 验证短信验证码
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: username 可以是用户名、email、手机号等，是否为手机号根据下面的 regtype 判断
 *   key: phone_confirmation  手机验证码
 *   key: regtype 可以传 mobile
 */
- (void)verifyShortMessage:(NSDictionary *)params
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 * 修改密码
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: phone_number
 *   key: phone_confirmation 手机验证码
 *   key: password
 *   key: password_confirmation
 *
 * @link http://wrd.tuan800-inc.com/mywiki/PassportResetPasswords
 */
- (void)updatePassword:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**
 * 绑定手机号
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: phone_number
 *   key: phone_confirmation 手机验证码
 *   key: for_bind_phone_number 1--表示是绑定手机号请求
 *   key: user_id
 *
 * @link http://wrd.tuan800-inc.com/mywiki/PassportBindPhone
 */
- (void)bindPhone:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure;

/**
 * 验证手机号验证码是否正确
 *
 * @params 参数没有特殊说明的都是字符串类型
 *   key: captcha 验证码
 *   key: phone_number 手机验证码
 */
- (void)verifySecurityCode:(NSDictionary *)params
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 * wap自动登录
 *
 * @params 参数没有特殊说明的都是字符串类型
*   key: targetUrl (NSString*)
*   key: ssoBaseUrl(NSString*)如：http://sso.tuan800.com/m/jump_request
 */
- (void)ssoRedirectToUrl:(NSDictionary *)params
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

//https://passport.tuan800.com/m/captcha_img.json
- (void)captchaImg:(NSDictionary *)params
        completion:(void (^)(NSDictionary *))completion
           failure:(void (^)(TBErrorDescription *))failure;
@end
