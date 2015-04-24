//
// Created by enfeng on 12-9-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h"


@protocol TBPassportApiDelegate <TBBaseNetworkDelegate>
@optional

/**
* 注册回调方法
*/
- (void)signUpFinish:(NSDictionary *)params;

/**
* 老版本程序登陆回调方法，新版本程序建议用loginSuccessFinish
*/
//-(void)loginFinish:(NSDictionary*) params;

/**
* 登陆回调方法
*/
- (void)loginSuccessFinish:(NSDictionary *)params;

/**
* 注销回调方法
*/
- (void)logoutFinish:(NSDictionary *)params;

/**
* 发送短信验证码回调方法
*/
- (void)sendShortMessageFinish:(NSDictionary *)params;

/**
* 验证验证码是否正确回调(注册或修改密码)
*/
- (void)verifyIfPhoneVerificationCodeIsRightFinish:(NSDictionary *)params;

/**
* 修改密码回调方法
*/
- (void)modifyPasswdFinish:(NSDictionary *)params;

/**
* 验证短信验证码回调方法
*/
- (void)verifyShortMessageFinish:(NSDictionary *)params;

/**
* 绑定手机回调方法
*/
- (void)bindPhoneFinish:(NSDictionary *)params;

- (void)ssoRedirectToUrlFinish:(NSDictionary *)params;

- (void)updateUserCampusFinish:(NSDictionary *)params;

@end


@interface TBPassportApi : TBBaseNetworkApi

@property(nonatomic, copy) NSString *baseURLPath;

/**
* 获取短信验证码
* @params
*   key: phone(NSString*)
*/
- (void)sendShortMessage:(NSDictionary *)params;

/**
* 用户注册
* @params
*   key: phone(NSString*)
*   key: code(NSString*)
*   key: password(NSString*)
*   key: cpassword(NSString*)
*   key: domain(NSString*)
*/
- (void)signUp:(NSDictionary *)params;

/**
* 用户登陆
* @params
*   key: phone(NSString*)
*   key: password(NSString*)
*   key: domain:(NSString*)
*   key: client_flag:(NSString*)   !!! 注意：domain, 与 client_flag 必须而选其一 - mobile_ying800: 表示电影票客户端
*   key: captcha 用户输入验证码的值, 只有需要验证图片验证码的时候，才传入此参数
#               获取验证码的接口是：https://passport.tuan800.com/m/captcha_img.json?t=[timestamp]
*   key: captcha_key 验证码接口返回的key, 与captcha参数一起返回
*/
- (void)login:(NSDictionary *)params;

/**
* 用户注销
* @params
*   key: domain(NSString*)
*/
- (void)logout:(NSDictionary *)params;

/**
* 验证短信验证码
* @params
*   key: phone(NSString*)
*   key: code(NSString*)
*/
- (void)verifyShortMessage:(NSDictionary *)params;

/**
* 验证手机号验证码是否正确
*/

- (void)verifyIfPhoneVerificationCodeIsRight:(NSDictionary *)params;

/**
* 修改密码
* @params
*   key: phone_number(NSString*)
*   key: phone_confirmation(NSString*)
*   key: password(NSString*)
*   key: cpassword(NSString*)
*/
- (void)modifyPassword:(NSDictionary *)params;

/**
* 绑定手机
* @params
*   key: user_id(NSString*)
*   key: phone_number(NSString*)
*   key: phone_confirmation(NSString*)
*/
- (void)bindPhone:(NSDictionary *)params;

/**
* 第三方账户登陆
* @params
*   key: partner_type(NSString*)
*   key: domain:(NSString*)
*/
- (void)thirdPartLogin:(NSDictionary *)params;

/**
* 第三方账户自动登陆
* @params
*   key: mobile_access_token(NSString*)
*   key: partner_type(NSString*)
*   key: domain:(NSString*)
*/
- (void)thirdPartAutoLogin:(NSDictionary *)params;

/**
* wap自动登录
* @params
*   key: redirectUrl (NSString*)
*   key: ssoBaseUrl(NSString*)如：http://sso.tuan800.com/m/jump_request
*/
- (void)ssoRedirectToUrl:(NSDictionary *)params;

/**
* 更新个人校园信息接口
* @params
*/
//- (void)updateUserCampus:(NSDictionary *)params;
@end
