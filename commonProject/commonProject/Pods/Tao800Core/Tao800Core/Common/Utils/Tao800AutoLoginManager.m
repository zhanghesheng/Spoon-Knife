//
//  Tao800AutoLoginManager.m
//  tao800
//
//  Created by worker on 14-3-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AutoLoginManager.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800FirstOrderCheckerModel.h"
#import "TBCore/NSString+Addition.h"

static int alertCount = 0;

@implementation Tao800AutoLoginManager

- (id)init {
    self = [super init];
    if (self) {
        // PassportApi
        _passportApi = [[TBPassportApi alloc] init];
        _passportApi.delegate = self;
        _passportApi.baseURLPath = Tao800PassportSessionURLPath;
    }
    
    return self;
}

#pragma mark 自动登录

- (void)taobaoLogin {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    if (dm.networkStatus == NotReachable) {
        return;
    }

    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];

    // 判断当前是普通账户还是淘宝账户
    if (da.taobaoVo) {
        if (!(da.user.userId)) {
            return ;
        }

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @"zhe800.com",@"domain",
//                da.user.token,@"mobile_access_token",
                @"4",@"partner_type",
                nil];
        if(da.currentVersion){
            [params setValue:da.currentVersion forKey:@"version"];
        }

        [params setValue:da.product forKey:@"app"];
        [params setValue:@"iPhone" forKey:@"platform"];
        [params setValue:da.partner forKey:@"channel"];
        [params setValue:da.headerVo.deviceId forKey:@"deviceId"];

        [_passportApi thirdPartAutoLogin:params];
    }
}

- (void)autoLogin {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    if (dm.networkStatus == NotReachable) {
        return;
    }
    
    if (!(dm.user.password && dm.user.userId)) {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"zhe800.com",@"domain",
                                   dm.user.name, @"phone",
                                   dm.userPassword, @"password",
                                   nil];
    if(dm.currentVersion){
        [params setValue:dm.currentVersion forKey:@"version"];
    }
    
    [params setValue:dm.product forKey:@"app"];
    [params setValue:@"iPhone" forKey:@"platform"];
    [params setValue:dm.partner forKey:@"channel"];
    [params setValue:dm.headerVo.deviceId forKey:@"deviceId"];
    
    [_passportApi login:params];
  
}

#pragma mark 自动登录成功回调
-(void)loginSuccessFinish:(NSDictionary*) params{
    
    self.autoLoginParams = params;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    dm.user.phone = [params objectForKey:@"phone_number"];
    dm.user.token = [params objectForKey:@"access_token"];
    dm.user.inviteCode = [params objectForKey:@"invite_code"];
    dm.user.lastLoginTime = [NSDate date];
    
    if ([[params objectForKey:@"active_status"] intValue] == 0) {
        // 未激活
        dm.user.userStatus = TN800UserStatusUnActivate;
    }else {
        // 已激活
        dm.user.userStatus = TN800UserStatusActivated;
    }
    [dm archive];
    
    // 判断是否是第一次启动软件或升级上来的
    if (dm.oldCurrVersion.length == 0 || ![dm.currentVersion isEqualToString:dm.oldCurrVersion]) {
        return;
    }else {
        [self checkTaobaoLogin];
    }
}

#pragma mark 检查淘宝登录
- (void)checkTaobaoLogin {
    
    if (!self.autoLoginParams) {
        return;
    }
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    // 判断当前是普通账户还是淘宝账户登录
    if (dm.taobaoVo) {
        
        /*
         * 判断是否需要走账户合并
         * partner_api： 0 或者1， 0表示taobao api已经关闭， 1表示taobao api是开放的
         password_setted：0或者1,0表示用户没有设置密码，1表示用户设置了密码
         */
        NSDictionary *partnerLoginInfo = [_autoLoginParams objectForKey:@"partner_login_info"];
        NSNumber *partner_api_obj = [partnerLoginInfo objectForKey:@"partner_api"];
        self.mergePhoneNumber = [partnerLoginInfo objectForKey:@"merged_phone_number"];
        
        // 判断merged_phone_number是否有值，如果有值，则代表此账户已经合并到其它账户了。
        if (_mergePhoneNumber != nil && _mergePhoneNumber.length > 0) {
            alertCount++;
            // 退出登录
            [self logout];
            if (alertCount > 1) {
                return;
            }
            UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你的账户已经不能登录了，你可以用绑定的手机号 %@ 进行登录",self.mergePhoneNumber] delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"去登录", nil];
            [alertUpdate setTag:Tao800TaoBaoLogin_Flag_HAVE_MERGE_PHONE];
            [alertUpdate show];
            return;
        }
        
        // 判断partner_api值有没有
        if (partner_api_obj != nil) {
            int partner_api = partner_api_obj.intValue;
            
            if (partner_api == 1 && dm.user.phone.length == 0) {
                alertCount++;
                // 退出登录
                [self logout];
                if (alertCount > 1) {
                    return;
                }
                UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:nil message:@"亲，用淘宝账号登录存在安全隐患，并可能导致积分丢失，去绑定个手机用手机号登录吧。没绑定过手机号的会被强制退出呦~" delegate:self cancelButtonTitle:@"退出登录" otherButtonTitles:@"绑定手机", nil];
                [alertUpdate setTag:Tao800TaoBaoLogin_Flag_HAVE_PARTNER_API_NO_PHONE];
                [alertUpdate show];
                
            }else if (partner_api == 0 && dm.user.phone.length == 0) {
                alertCount++;
                // 退出登录
                [self logout];
                if (alertCount > 1) {
                    return;
                }
                UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:nil message:@"很遗憾，淘宝已关闭第三方账号，你已经无法用淘宝账号登录请重新注册账号" delegate:self cancelButtonTitle:@"退出登录" otherButtonTitles:@"注册账号", nil];
                [alertUpdate setTag:Tao800TaoBaoLogin_Flag_NO_PARTNER_API_NO_PHONE];
                [alertUpdate show];
                
            }else if (partner_api == 0 && dm.user.phone.length > 0) {
                alertCount++;
                // 退出登录
                [self logout];
                if (alertCount > 1) {
                    return;
                }
                UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"淘宝已关闭第三方账号，你可以用绑定的手机号 %@ 进行登录",dm.user.phone] delegate:self cancelButtonTitle:@"退出登录" otherButtonTitles:@"去登录", nil];
                [alertUpdate setTag:Tao800TaoBaoLogin_Flag_NO_PARTNER_API_HAVE_PHONE];
                [alertUpdate show];
                
            }
        }
    }
}

#pragma mark 退出登录
- (void)logout
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.currentVersion) {
        [params setValue:dm.currentVersion forKey:@"version"];
    }
    [params setValue:dm.product forKey:@"app"];
    [params setValue:@"iPhone" forKey:@"platform"];
    [params setValue:dm.partner forKey:@"channel"];
    [params setValue:@"zhe800.com" forKey:@"domain"];
    _passportApi.baseURLPath = Tao800PassportSessionURLPath;
    [_passportApi logout:params];
}

#pragma mark 退出登录回调
- (void)logoutFinish:(NSDictionary *)params {
    NSNumber *status = [params objectForKey:@"status"];
    int st = [status intValue];
    
    if (st == 200) {
        Tao800DataModelSingleton *dataModel = [Tao800DataModelSingleton sharedInstance];
        dataModel.user = nil;
        dataModel.signDate = nil;
        dataModel.taobaoVo = nil;
        dataModel.tencentVo = nil;
        dataModel.sinaWeiboVo = nil;
        [dataModel archive];
        // 清除cookie
        [ASIHTTPRequest setSessionCookies:nil];
        
        //退出后显示首单返利入口
        Tao800FirstOrderCheckerModel *firstOrderChecker = [[Tao800FirstOrderCheckerModel alloc] init];
        [firstOrderChecker notifyEntryState:YES];
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:Tao800SettingsViewCTLLogoutSuccessNotifyCation
     object:nil];
}

#pragma mark - 网络出错
- (void)didNetworkError:(NSDictionary *)params{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:Tao800SettingLoginCTLDidCheckLoginNotifyCation
     object:nil];
    
    TBASIFormDataRequest *request = [params objectForKey:@"request"];
    int responseStatusCode = request.responseStatusCode;
    NSString *responseString = request.responseString;
    NSDictionary *jsonDict; // 响应内容封装成字典
    @try {
        jsonDict = [responseString JSONValue];
    }
    @catch (NSException *exception) {
        jsonDict = [NSDictionary dictionary];
    }
    
    switch (request.serviceMethodFlag) {
        case APIPassportLogin:
        {
            if (responseStatusCode == 401) {//由于在PC修改密码或其它原因引起的登录失败
                // 退出登录
                [self logout];
            }
        }
            break;
        default:{
            //            [self showErrorTip:@"登录失败，网络连接失败"];
        }
            break;
    }
    
}

#pragma mark alert按钮点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertCount = 0; // 重置计数器
    
    switch (alertView.tag) {
        case Tao800TaoBaoLogin_Flag_HAVE_PARTNER_API_NO_PHONE: {
            if (buttonIndex == 0) {
            }else {
                // 绑定手机
                [[Tao800ForwardSingleton sharedInstance] openTaoBaoAccountMergeWebPage:@{@"url":[NSURL URLWithString:@"http://passport.tuan800.com/account/wap_merge/bind_info"],@"sso":[NSNumber numberWithBool:YES],@"title":@"淘宝账户合并",@"isModel":[NSNumber numberWithBool:YES]}];
            }
        }
            break;
        case Tao800TaoBaoLogin_Flag_NO_PARTNER_API_NO_PHONE: {
            if (buttonIndex == 0) {
            }else {
                // 免费注册
                [[Tao800ForwardSingleton sharedInstance] openUserRegistPage:nil];
            }
        }
            break;
        case Tao800TaoBaoLogin_Flag_NO_PARTNER_API_HAVE_PHONE: {
            if (buttonIndex == 0) {
            }else {
                // 去登录
                Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
                [[Tao800ForwardSingleton sharedInstance] openLoginPage:@{@"phoneNumber": dm.user.phone}];
            }
        }
            break;
        case Tao800TaoBaoLogin_Flag_HAVE_MERGE_PHONE: {
            if (buttonIndex == 0) {
            }else {
                // 去登录
                [[Tao800ForwardSingleton sharedInstance] openLoginPage:@{@"phoneNumber": _mergePhoneNumber}];
            }
        }
            break;
        default:
        {
        }
            break;
    }
}

@end
