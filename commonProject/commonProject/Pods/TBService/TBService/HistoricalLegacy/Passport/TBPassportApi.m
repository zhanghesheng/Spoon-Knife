//
// Created by enfeng on 12-9-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <sys/socket.h>
#import "TBCore/TBCoreUtil.h"
#import "TBPassportApi.h"
#import "TBCore/NSString+Addition.h"
#import "TBCore/NSDictionaryAdditions.h"

#if DEBUG
NSString *const PassportUrlBase = @"http://passport.xiongmaot.com/";
#else
NSString *const PassportUrlBase = @"https://passport.tuan800.com/";
#endif
//NSString *const PassportUrlBase = @"https://passport.tuan800.com/";

@interface TBPassportApi ()

@end

@implementation TBPassportApi {

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURLPath = PassportUrlBase;
    }
    return self;
}

- (void)send:(TBASIFormDataRequest *)request {

    NSString *urlString = request.url.absoluteString;
    if ([urlString hasPrefix:@"https"]) {
//        SecIdentityRef identity1 = NULL;
//        SecTrustRef trust = NULL;

//        NSData *PKCS12Data1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tuan800-passport" ofType:@"p12"]];

//        [TBCoreUtil extractIdentity:&identity1 andTrust:&trust fromPKCS12Data:PKCS12Data1];
//
//        [request setClientCertificateIdentity:identity1];

        NSData *cerFile1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pass" ofType:@"cer"]];
        NSData *cerFile2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sso" ofType:@"cer"]];

        SecCertificateRef cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile1);
        SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile2);

        NSArray *array = @[(__bridge id) cert1,
                (__bridge id) cert2];

        CFRelease(cert1);
        CFRelease(cert2);

        [request setClientCertificates:array];
        [request setValidatesSecureCertificate:YES];
    }

    [super send:request withRequestKey:YES];
}

/**
 * 获取短信验证码
 * @params
 *   key: phone(NSString*)
 */
- (void)sendShortMessage:(NSDictionary *)params {

    NSString *phone = [params objectForKey:@"phone"];
    NSString *registered = [params objectForKey:@"registered"];
    NSString *bind = [params objectForKey:@"newBind"]; //1: 绑定新手机号
    NSString * source = [params objectForKey:@"source"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLPath, @"m/phone_confirmations"]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportGetShortMessage;
    [request setPostValue:phone forKey:@"phone_number"];
    [request setPostValue:registered forKey:@"registered"];
    
    if (source) {
        [request setPostValue:source forKey:@"source"];
    }
    
    
    if (bind) {
        [request setPostValue:bind forKey:@"for_bind_phone_number"];
    }
    request.serviceData = params;

    [self send:request];
}

/**
 * 用户注册
 * @params
 *   key: phone(NSString*)
 *   key: code(NSString*)
 *   key: password(NSString*)
 *   key: cpassword(NSString*)
 *   key: domain(NSString*)
 */
- (void)signUp:(NSDictionary *)params {
    NSString *phone = [params objectForKey:@"phone"];
    NSString *code = [params objectForKey:@"code"];
    NSString *password = [params objectForKey:@"password"];
    NSString *cpassword = [params objectForKey:@"cpassword"];
    NSString *domain = [params objectForKey:@"domain"];
    NSString *wirelessInviteCode = [params objectForKey:@"wirelessInviteCode"];
    NSString *campusPromotionCode = [params objectForKey:@"school_spread_info[school_special_code]"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLPath, @"m/users"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportSignUp;
    if (domain == nil || [domain isEqualToString:@""]) {
        [request setPostValue:@"hui800.com" forKey:@"domain"];
    } else {
        [request setPostValue:domain forKey:@"domain"]; // 来源域，此参数必须，用于单点登录。
    }
    [request setPostValue:phone forKey:@"phone_number"];
    [request setPostValue:code forKey:@"phone_confirmation"]; // 手机验证码
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:cpassword forKey:@"password_confirmation"];
    [request setPostValue:@"true" forKey:@"agreement"]; // 同意用户协议
    [request setPostValue:@"true" forKey:@"auto_login"]; // 注册完成后是否自动登录
    
    // 无线邀请码
    if (wirelessInviteCode && wirelessInviteCode.length>0) {
        [request setPostValue:wirelessInviteCode forKey:@"school_spread_info[wireless_invite_code]"];
    }
    if (campusPromotionCode && campusPromotionCode.length>0) {
        [request setPostValue:campusPromotionCode forKey:@"school_spread_info[school_special_code]"];
    }

    // 添加公共请求参数
    [self addCommonParams:params request:request];

    request.serviceData = params;
    //保存cookie
    [request setUseCookiePersistence:YES];

    [self send:request];
}

- (NSString *)getSessionAction {
    //todo 临时修改，目前测试环境只是支持sessions
    NSString *action = @"sessions_v2";
#if DEBUG
    action = @"sessions";
#endif
    return action;
}
/**
 * 用户登陆
 * @params
 *   key: phone(NSString*)
 *   key: password(NSString*)
 *   key: domain:(NSString*)
 */
- (void)login:(NSDictionary *)params {

    // 登录前清除所有cookie
    [ASIHTTPRequest setSessionCookies:nil];

    NSString *phone = [params objectForKey:@"phone"];
    NSString *password = [params objectForKey:@"password"];
    NSString *domain = [params objectForKey:@"domain"];
    NSString *captcha = [params objectForKey:@"captcha"];
    NSString *captcha_key = [params objectForKey:@"captcha_key"];

    NSString *action = [self getSessionAction];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m/%@", self.baseURLPath, action]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportLogin;
    [request setPostValue:phone forKey:@"phone_number"];
    [request setPostValue:password forKey:@"password"];

    if (captcha_key) {
        [request setPostValue:captcha forKey:@"captcha"];
        [request setPostValue:captcha_key forKey:@"captcha_key"];
    }

    //增加请求校园信息
    [request setPostValue:@"true" forKey:@"require_school_spread_info"];

#if DEBUG
    domain = @"xiongmaoz.com";
#endif

    if (domain == nil || [domain isEqualToString:@""]) {
        [request setPostValue:@"hui800.com" forKey:@"domain"];
    } else {
        [request setPostValue:domain forKey:@"domain"]; // 来源域，此参数必须，用于单点登录。
    }

    // 添加公共请求参数
    [self addCommonParams:params request:request];

    request.serviceData = params;

    //保存cookie
    [request setUseCookiePersistence:YES];

    [self send:request];
}

/**
 * 用户注销
 * @params
 *   key: domain(NSString*)
 */
- (void)logout:(NSDictionary *)params {

    
    NSString *domain = [params objectForKey:@"domain"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLPath, @"m/sessions_v2"]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportLogout;
    [request setPostValue:@"DELETE" forKey:@"_method"];
    if (domain == nil || [domain isEqualToString:@""]) {
        [request setPostValue:@"hui800.com" forKey:@"domain"];
    } else {
        [request setPostValue:domain forKey:@"domain"]; // 来源域，此参数必须，用于单点登录。
    }

    // 添加公共请求参数
    [self addCommonParams:params request:request];

    request.serviceData = params;
    //保存cookie
    [request setUseCookiePersistence:YES];

    [self send:request];
}

/**
 * 验证短信验证码
 * @params
 *   key: phone(NSString*)
 *   key: code(NSString*)
 */
- (void)verifyShortMessage:(NSDictionary *)params {
    NSString *phone = [params objectForKey:@"phone"];
    NSString *code = [params objectForKey:@"code"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLPath, @"users/password.json"]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportVerifyShortMessage;
    [request setPostValue:phone forKey:@"username"];
    [request setPostValue:code forKey:@"phone_confirmation"]; // 手机验证码
    [request setPostValue:@"mobile" forKey:@"regtype"];
    request.serviceData = params;
    //保存cookie
    [request setUseCookiePersistence:YES];

    [self send:request];
}

/**
 * 验证手机号验证码是否正确
 */
-(void)verifyIfPhoneVerificationCodeIsRight:(NSDictionary *)params{
    NSString *phone = [params objectForKey:@"phone"];
    NSString *code = [params objectForKey:@"code"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.baseURLPath, @"phone_confirmations/validate"]];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportVerifyCode;
    [request setPostValue:phone forKey:@"phone_number"];
    [request setPostValue:code forKey:@"captcha"]; // 手机验证码
    request.serviceData = params;
    
    [request setUseCookiePersistence:NO];
    
    [self send:request];
}

/**
 * 修改密码
 * @params
 *   key: phone_number(NSString*)
 *   key: phone_confirmation(NSString*)
 *   key: password(NSString*)
 *   key: cpassword(NSString*)
 */
- (void)modifyPassword:(NSDictionary *)params {
    NSString *phone_number = [params objectForKey:@"phone_number"];
    NSString *phone_confirmation = [params objectForKey:@"phone_confirmation"];
    NSString *password = [params objectForKey:@"password"];
    NSString *cpassword = [params objectForKey:@"cpassword"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLPath, @"m/passwords"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportSendModifyPassword;
    [request setPostValue:phone_number forKey:@"phone_number"];
    [request setPostValue:phone_confirmation forKey:@"phone_confirmation"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:cpassword forKey:@"password_confirmation"];
    request.serviceData = params;

    [self send:request];
}

/**
 * 绑定手机
 * @params
 *   key: user_id(NSString*)
 *   key: phone_number(NSString*)
 *   key: phone_confirmation(NSString*)
 */
- (void)bindPhone:(NSDictionary *)params {
    NSString *phone_number = [params objectForKey:@"phone_number"];
    NSString *phone_confirmation = [params objectForKey:@"phone_confirmation"];
    NSString *user_id = [params objectForKey:@"user_id"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLPath, @"m/users/bind_phone_number"]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportBindPhone;
    [request setPostValue:phone_number forKey:@"phone_number"];
    [request setPostValue:phone_confirmation forKey:@"phone_confirmation"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:@"1" forKey:@"for_bind_phone_number"];
    request.serviceData = params;

    [self send:request];
}

/**
 * 第三方账户登陆
 * @params
 *   key: partner_type(NSString*)
 *   key: domain:(NSString*)
 */
- (void)thirdPartLogin:(NSDictionary *)params {
    
    NSString *partner_login_ticket = [params objectForKey:@"ticket"];
    NSString *partner_type = [params objectForKey:@"partner_type"];
    NSString *domain = [params objectForKey:@"domain"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m/sessions_v2", self.baseURLPath]];
    
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportLogin;
    
    [request setPostValue:partner_login_ticket forKey:@"partner_login_ticket"];
    [request setPostValue:partner_type forKey:@"partner_type"];
    
    if (domain == nil || [domain isEqualToString:@""]) {
        [request setPostValue:@"hui800.com" forKey:@"domain"];
    } else {
        [request setPostValue:domain forKey:@"domain"]; // 来源域，此参数必须，用于单点登录。
    }
    
    // 添加公共请求参数
    [self addCommonParams:params request:request];
    
    request.serviceData = params;
    
    //保存cookie
    [request setUseCookiePersistence:YES];
    
    [self send:request];
}

/**
 * 第三方账户自动登陆
 * @params
 *   key: mobile_access_token(NSString*)
 *   key: partner_type(NSString*)
 *   key: domain:(NSString*)
 */
- (void)thirdPartAutoLogin:(NSDictionary *)params {

    // 登录前清除所有cookie
    [ASIHTTPRequest setSessionCookies:nil];

    NSString *mobile_access_token = [params objectForKey:@"mobile_access_token"];
    NSString *partner_type = [params objectForKey:@"partner_type"];
    NSString *domain = [params objectForKey:@"domain"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m/sessions_v2", self.baseURLPath]];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportLogin;
    [request setPostValue:mobile_access_token forKey:@"mobile_access_token"];
    [request setPostValue:partner_type forKey:@"partner_type"];
    if (domain == nil || [domain isEqualToString:@""]) {
        [request setPostValue:@"hui800.com" forKey:@"domain"];
    } else {
        [request setPostValue:domain forKey:@"domain"]; // 来源域，此参数必须，用于单点登录。
    }

    // 添加公共请求参数
    [self addCommonParams:params request:request];

    request.serviceData = params;

    //保存cookie
    [request setUseCookiePersistence:YES];

    [self send:request];
}

- (void)ssoRedirectToUrl:(NSDictionary *)params {
    NSString *urlString = [params objectForKey:@"redirectUrl"];
    NSString *ssoBaseUrlString = [params objectForKey:@"ssoBaseUrl"];

    NSURL *url = [NSURL URLWithString:ssoBaseUrlString];

    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIPassportSSORedirectToUrl;
    [request setPostValue:urlString forKey:@"return_to"];

    request.serviceData = params;
    [request setUseCookiePersistence:YES];

    [self send:request];
}


#pragma mark - 添加公共请求参数
- (void)addCommonParams:(NSDictionary *)params request:(TBASIFormDataRequest *)request {
    // 统计信息
    NSString *app = [params objectForKey:@"app"]; // 产品名称
    NSString *platform = [params objectForKey:@"platform"]; // 平台
    NSString *version = [params objectForKey:@"version"]; // 版本
    NSString *channel = [params objectForKey:@"channel"]; //  渠道
    NSString *deviceId = [params objectForKey:@"deviceId"];
    NSString *cityId = [params objectForKey:@"cityId"];

    if (app) {
        [request setPostValue:app forKey:@"source"];
    }

    if (platform) {
        [request setPostValue:platform forKey:@"platform"];
    }

    if (version) {
        [request setPostValue:version forKey:@"version"];
    }

    if (channel) {
        [request setPostValue:channel forKey:@"channelId"];
    }
    if (deviceId) {
        [request setPostValue:deviceId forKey:@"deviceId"];
    }
    if (cityId) {
        [request setPostValue:cityId forKey:@"cityId"];
    }
}

#pragma mark - 请求完成
- (void)requestFinished:(TBASIFormDataRequest *)request {
    
    if (request.serviceMethodFlag != APIPassportVerifyCode) { // 验证注册手机码，不做错误处理,其余的捕获网络错误
        BOOL isResponseNetworkError = [self isResponseDidNetworkError:request];
        if (isResponseNetworkError) {
            //不做处理，由 viewController捕获处理, 不再执行后续解析代码
            return;
        }
    }

    // 获取http信息
    //NSDictionary *responseHeaders = [request responseHeaders]; // 头信息
    //    int responseStatusCode = [request responseStatusCode]; // 状态码
    NSString *responseString = [request responseString]; // 响应内容
    //NSArray *responseCookies = [request responseCookies]; // cookie

    //保存cookie
    [request setUseCookiePersistence:YES];

    NSDictionary *jsonDict; // 响应内容封装成字典
    @try {
        jsonDict = [responseString JSONValue];
    }
    @catch (NSException *exception) {
        jsonDict = [NSDictionary dictionary];
    }
    @finally {

    }
    SEL sel = nil;
    if (jsonDict == nil) {
        jsonDict = [NSDictionary dictionary];
    }

    switch (request.serviceMethodFlag) {
        case APIPassportSignUp: {
            sel = @selector(signUpFinish:);
        }
            break;
        case APIPassportLogin: {
            sel = @selector(loginSuccessFinish:);
        }
            break;
        case APIPassportLogout: {
            sel = @selector(logoutFinish:);
        }
            break;
        case APIPassportGetShortMessage: {
            sel = @selector(sendShortMessageFinish:);
        }
            break;
        case APIPassportSendModifyPassword: {
            sel = @selector(modifyPasswdFinish:);
        }
            break;
        case APIPassportVerifyShortMessage: {
            sel = @selector(verifyShortMessageFinish:);
        }
            break;
        case APIPassportBindPhone: {
            sel = @selector(bindPhoneFinish:);
        }
            break;
        case APIPassportSSORedirectToUrl: {
            sel = @selector(ssoRedirectToUrlFinish:);
        }
            break;
        case APIPassportVerifyCode:{
            sel = @selector(verifyIfPhoneVerificationCodeIsRightFinish:);
        }
    }

    [super requestFinished:request];
    if (sel && self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:jsonDict];
#pragma clang diagnostic pop
    }
}


@end
