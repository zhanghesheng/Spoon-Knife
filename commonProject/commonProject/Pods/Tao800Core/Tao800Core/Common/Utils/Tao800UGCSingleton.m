//
//  Tao800UGCSingleton.m
//  TBUIDemo
//
//  Created by enfeng on 12-10-12.
//  Copyright (c) 2012年 com.tuan800.ios.framework.uidemo. All rights reserved.
//

#import "Tao800UGCSingleton.h"
#import "TBUI/TBUI.h"
#import "TBService/TBUserLogApi.h"
#import "Tao800DataModelSingleton.h"
#import "TBCore/TBCoreMacros.h"
#import "Tao800StaticConstant.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
#import "Tao800DealListModel.h"
#import "Tao800FunctionCommon.h"
#import "Tao800ExposureService.h"
#import <TBService/TBGpsManagerV2.h>
#import "Tao800ConfigBVO.h"
#import "Tao800ConfigTipBVO.h"
#import <AdSupport/ASIdentifierManager.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <Security/SecItem.h>
#import "TBCore/OpenUDID.h"
//#import <Core/SSKeychain.h>
#import "TBCore/SSKeychain.h"
#import "Tao800ConfigManage.h"
#import "Tao800RC4.h"


static Tao800UGCSingleton *_instance;

NSString *const Zhe800URLMobileInfo = @"http://api.tuan800.com/mobilelog/applog/mobileinfo";
NSString *const Zhe800URLMobileLog = @"http://api.tuan800.com/mobilelog/applog/mobilelog";

@interface Tao800UGCSingleton ()
@property (nonatomic,strong) Tao800DealListModel *model;
@property (nonatomic,strong) Tao800ExposureService *upInitLogService;
@property (nonatomic,assign) int outNumber;//out次数
@property (nonatomic,assign) BOOL enableToUploadAppActiveLog;//激活接口一个版本只允许调用一次
/**
 * cpa out数达到 dm.configBVO.configTipBVO.cpaOutNumber 次数时，上传参数
 */

-(void)countOutNumbers;
@end
@implementation Tao800UGCSingleton


@synthesize nsTimer = _nsTimer;

- (id)init {
    self = [super init];
    if (self) {

        _logService = [[TBUserLogApi alloc] init];
        _logService.delegate = self;
        _logService.mobileInfoUrl = Zhe800URLMobileInfo;
        _logService.mobileLogUrl = Zhe800URLMobileLog;
        _sendingNow = NO;
        _model = [[Tao800DealListModel alloc] init];
        self.outNumber = 0;
        self.upInitLogService = [[Tao800ExposureService alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewDidAppearFromNotification:)
                                                     name:TBBaseViewCTLDidAppearNotifyCation
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewDidDisappearFromNotification:)
                                                     name:TBBaseViewCTLDidDisappearNotifyCation
                                                   object:nil];
        //定位地址获取成功
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(locationSuccess)
                                                     name:TBGpsManagerDidSuccessNotification
                                                   object:nil];
        //定位失败
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationError) name:TBGpsManagerDidErrorNotification object:nil];
    }
    return self;
}

- (void)StartLogTimer {
    self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
}

- (void)inValidLogTimer {
    if (_nsTimer) {
        [_nsTimer invalidate];
    }
}

- (void)fireTimer:(NSTimer *)theTimer {
    [self commitLog:NO];
}

-(NSDictionary *)getCpaOutParams{
    NSString *idfv = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    NSString *ip = [self getIPAddress];
    NSString *bssid = [self getBSSId];

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSString *mac = dm.headerVo.macAddress;
    NSString *openudid = [OpenUDID value];
    NSString *fdid = @"";
    NSString *version = dm.version;
    NSString *channelId = dm.partner;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            fdid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
    }
    
    if (mac == nil) {
        mac = @"";
    }
    
    if (openudid == nil) {
        openudid = @"";
    }
    
    if (fdid == nil) {
        fdid = @"";
    }
    if (!version) {
        version = @"";
    }
    if (!channelId) {
        channelId = @"";
    }
    
    if (!idfv) {
        idfv = @"";
    }
    if (!ip) {
        ip = @"";
    }
    if (!bssid) {
        bssid = @"";
    }

    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.tuan800.tao800iphone.tao800"account:@"user"];
    if (!retrieveuuid) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveuuid=[NSString stringWithFormat:@"%@", uuidStr];
        [SSKeychain setPassword:retrieveuuid
         
                     forService:@"com.tuan800.tao800iphone.tao800"account:@"user"];
    }
    
    NSDictionary *dict = @{@"idfv":idfv,
                           @"ip":ip,
                           @"bssid":bssid,
                           @"keychain":retrieveuuid,
                           @"version" : version,
                           @"channelid" : channelId,
                           @"deviceid" : mac,
                           @"fdid" : fdid
                           };
    
    return dict;
}

-(NSString *)getBSSId{
    NSArray* interfaces = (__bridge NSArray*) CNCopySupportedInterfaces();
    NSString *bssid = nil;
    for (NSString* interface in interfaces)
    {
        CFDictionaryRef networkDetails = CNCopyCurrentNetworkInfo((__bridge CFStringRef) interface);
        if (networkDetails)
        {
            NSString*  BSSID1 = (NSString *)CFDictionaryGetValue (networkDetails, kCNNetworkInfoKeyBSSID);
            bssid = [[BSSID1 stringByReplacingOccurrencesOfString:@":"
                                                       withString:@""] uppercaseString];
            
            CFRelease(networkDetails);
        }
    }
    return bssid;
}
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;

}

-(void)uploadCpaOutParams{
    
    NSDictionary *dict = [self getCpaOutParams];
    
    [self.upInitLogService sendCpaOutLogs:dict
                                        completion:^(NSDictionary *dic) {
                                        } failure:^(TBErrorDescription *error) {
                                            
                                        }
     ];
    
}


-(void)countOutNumbers{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (self.outNumber < dm.configBVO.configTipBVO.cpaOutNumber) {
        self.outNumber++;
    }
    if (self.outNumber == dm.configBVO.configTipBVO.cpaOutNumber) {
        [self uploadCpaOutParams];
    }
}

//v3.2运营需求，协同过滤，记录访问日期 90天内 update smj
-(void)updateVisitDate:(NSString *)key{
    
    BOOL isSameDay;
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSDate *currentDate = [NSDate date];
    if ([key isEqualToString:UserDefaultKeyUGCSingletonNoteVisitZhe800Date]) {
        if (dm.lastEnterAppDate == nil) {
            isSameDay = YES;
        }else {
            isSameDay = IsSameDay(currentDate, dm.lastEnterAppDate);
        }
        if (!isSameDay) {
            // 不是同一天
            [dm.saveDealLogs removeAllObjects];
            [self noteVisitDate:key];
        }
    }else if ([key isEqualToString:UserDefaultKeyUGCSingletonNoteVisitSaunterDate]){
        if (dm.lastEnterSaunterDate == nil) {
            isSameDay = YES;
            dm.lastEnterSaunterDate = currentDate;
            [dm archive];
        }else {
            isSameDay = IsSameDay(currentDate, dm.lastEnterSaunterDate);
        }
        if (!isSameDay) {
            // 不是同一天
            [dm.saveDealLogs removeAllObjects];
            [self noteVisitDate:key];
        }
    }
}

-(void)noteVisitDate:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *noteVisitStr = [NSMutableString stringWithCapacity:90];
    NSString *timeStr = [defaults objectForKey:key];
    
    if (!timeStr) {
        return;
    }

    noteVisitStr = [NSMutableString stringWithString:timeStr];
    
    //右移n 天，n 天未登陆
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    if (!dm.lastEnterAppDate) {
        //第一次启动
        return;
    }
    int  day = 0;
    if ([key isEqualToString:UserDefaultKeyUGCSingletonNoteVisitZhe800Date]) {
        day = getDayFromCurrentDateToPastDate(dm.lastEnterAppDate);
    }else if([key isEqualToString:UserDefaultKeyUGCSingletonNoteVisitSaunterDate]){
        NSDate *currentDate = [NSDate date];
        day = getDayFromCurrentDateToPastDate(dm.lastEnterSaunterDate);
        dm.lastEnterSaunterDate = currentDate;
        [dm archive];
    }
    
    if (day>=90){//1个 1，89个0
        noteVisitStr = [NSMutableString stringWithFormat:@"100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"];
        [defaults setObject:noteVisitStr forKey:key];
        [defaults synchronize];
    }
    else {
        [self updateVisitDate:noteVisitStr day:day noteZhe800OrSaunter:key];
    }
}

-(void)updateVisitDate:(NSMutableString *)noteVisitStr day:(int)day noteZhe800OrSaunter:(NSString *)key{
    //n为几 就做几个“0”的字符串 和 str2 拼接起来
    NSMutableString *str1 = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < day; i ++) {
        [str1 appendString:[NSString stringWithFormat:@"0"]];
    }
    
    //前 90 - day 位
    NSString *str2 = [noteVisitStr substringToIndex:90 - day];
    NSMutableString *str3 = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    //首字符设成 @“1”代表今天访问过客户端
    [str3 replaceCharactersInRange:NSMakeRange(0, 1) withString:@"1"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str3 forKey:key];
    [defaults synchronize];
}




#pragma 记录30天内，各个天内的 out 数

-(void)countEachDayOut{
    [self countOutNumbers];
    
    //30个0
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *noteVisitStr = [NSMutableString stringWithCapacity:30];
    NSString *timeStr = [defaults objectForKey:Tao800DealListVCLCountEachDayOut];
    if (!timeStr) {
        noteVisitStr = [NSMutableString stringWithFormat:@"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"];
    }else {
        noteVisitStr = [NSMutableString stringWithString:timeStr];
    }
    NSDate *currentDate = [NSDate date];
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.lastEnterDetailDate) {
        dm.lastEnterDetailDate = currentDate;
    }
    int day = getDayFromCurrentDateToPastDate(dm.lastEnterDetailDate);
    dm.lastEnterDetailDate = currentDate;
    [dm archive];
    if (day == 0) {
        [self updateTheSameDayOut:noteVisitStr];
    }
    else if (day >= 30){
        noteVisitStr = [NSMutableString stringWithFormat:@"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"];
        [self updateTheSameDayOut:noteVisitStr];
    }
    else{
        [self updateEachDayOut:noteVisitStr day:day];
    }
}
//同一天 （字符串不需要右移）
-(void)updateTheSameDayOut:(NSMutableString *)noteVisitStr {
    NSArray *array = [noteVisitStr componentsSeparatedByString:@","];
    NSString *firstStr = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
    int  count = [firstStr intValue];
    count ++;
    NSMutableString *uploadingStr = [NSMutableString stringWithCapacity:60];
    for (int i = 1; i<[array count]; i++) {
        [uploadingStr appendString:[NSString stringWithFormat:@"%@,",[array objectAtIndex:i]]];
    }
    [uploadingStr deleteCharactersInRange:NSMakeRange([uploadingStr length]-1, 1)];//去掉最后一个逗号
    uploadingStr = [NSMutableString stringWithFormat:@"%d,%@",count,uploadingStr];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uploadingStr forKey:Tao800DealListVCLCountEachDayOut];
    [defaults synchronize];
}
//不同天 （需要右移字符串）
-(void)updateEachDayOut:(NSMutableString *)noteVisitStr day:(int)day{
    NSArray *array = [noteVisitStr componentsSeparatedByString:@","];
    //从0到[array count] - day -1 的字符串
    NSMutableString *endStr = [NSMutableString stringWithCapacity:60];
    for (int i = 0; i < [array count] - day ; i++) {
        [endStr appendString:[NSString stringWithFormat:@"%@,",[array objectAtIndex:i]]];
    }
    [endStr deleteCharactersInRange:NSMakeRange([endStr length]-1, 1)];//去掉最后一个逗号
    
    NSMutableString *headStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"1,"]];
    for (int i = 1; i < day; i++) {
        [headStr appendString:@"0,"];
    }
    NSMutableString *uploadingStr = [NSMutableString stringWithFormat:@"%@%@",headStr,endStr];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uploadingStr forKey:Tao800DealListVCLCountEachDayOut];
    [defaults synchronize];
}
/**
 * UGC 统计
 *
 * @param isExitPage YES:退出页面 NO:进入页面
 * @param pageParams 进入页面的参数
 *
 */
- (void)writeLogOfExit:(BOOL)isExitPage pageParams:(NSDictionary *)params {
    NSNumber *tag = [params objectForKey:TBNavigationCTLPageTagKey];
    Tao800PageTag pageTag = (Tao800PageTag) ([tag intValue]);
    switch (pageTag) {
        case TodayBigStatePageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出今日精选大图页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_P params:[NSDictionary dictionaryWithObject:kUI_Today forKey:kEvent_P_PARAM_N]];
            } else {
                TBDPRINT(@"进入今日精选大图页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_R params:[NSDictionary dictionaryWithObject:kUI_Today forKey:kEvent_R_PARAM_N]];
            }
        }
            break;
        case TomorrowStatePageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出明日预告大图页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_P params:[NSDictionary dictionaryWithObject:kUI_Tomorrow forKey:kEvent_P_PARAM_N]];
            } else {
                TBDPRINT(@"进入明日预告大图页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_R params:[NSDictionary dictionaryWithObject:kUI_Tomorrow forKey:kEvent_R_PARAM_N]];
            }
        }
            break;
        case TodayListStatePageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出今日精选列表页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_P params:[NSDictionary dictionaryWithObject:kUI_Today forKey:kEvent_P_PARAM_N]];
            } else {
                TBDPRINT(@"进入今日精选列表页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_R params:[NSDictionary dictionaryWithObject:kUI_Today forKey:kEvent_R_PARAM_N]];
            }
        }
            break;
        case TomorrowListStatePageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出明日预告列表页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_P params:[NSDictionary dictionaryWithObject:kUI_Tomorrow forKey:kEvent_P_PARAM_N]];
            } else {
                TBDPRINT(@"进入明日预告列表页面");
                //[[Tao800UGCSingleton sharedInstance] paramsLog:kEvent_R params:[NSDictionary dictionaryWithObject:kUI_Tomorrow forKey:kEvent_R_PARAM_N]];
            }
        }
            break;
        case SettingsPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出设置页面");
            } else {
                TBDPRINT(@"进入设置页面");
            }
        }
            break;
        case TaoBaoWapPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出商品详情页面");
            } else {
                TBDPRINT(@"进入商品详情页面");
            }
        }
            break;
        case TomrrowAdvertWapPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出优质商品（明日预告）页面");
            } else {
                TBDPRINT(@"进入优质商品（明日预告）页面");
            }
        }
            break;
        case WorthBuyingWebPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出值得买页面");
                [[Tao800UGCSingleton sharedInstance] paramsLog:Event_P params:[NSDictionary dictionaryWithObject:UI_Zhi forKey:Event_P_PARAM_N]];
            } else {
                TBDPRINT(@"进入值得买页面");
                [[Tao800UGCSingleton sharedInstance] paramsLog:Event_R params:[NSDictionary dictionaryWithObject:UI_Zhi forKey:Event_P_PARAM_N]];
            }
        }
            break;
        case FeedbackPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出意见反馈页面");
            } else {
                TBDPRINT(@"进入意见反馈页面");
            }
        }
            break;
        case AboutPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出关于页面");
            } else {
                TBDPRINT(@"进入关于页面");
            }
        }
            break;
        case WebCommonPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出web公共页面");
            } else {
                TBDPRINT(@"进入web公共页面");
            }
        }
            break;
        case SharePageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出分享页面");
            } else {
                TBDPRINT(@"进入分享页面");
            }
        }
            break;
        case LaunchPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出新手引导页面");
            } else {
                TBDPRINT(@"进入新手引导页面");
            }
        }
            break;
        case SettingLoginPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出账号登录页面");
            } else {
                TBDPRINT(@"进入账号登录页面");
            }
        }
        case SettingRegistPageTag: {
            if (isExitPage) {
                TBDPRINT(@"退出账号注册页面");
            } else {
                TBDPRINT(@"进入账号注册页面");
            }
        }
        default:
            break;
    }
}

- (void)paramsLog:(NSString *)eventid params:(NSDictionary *)params {
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:eventid, @"eventId", params, @"param", nil];
    TBUserLogApi *logServ = [[TBUserLogApi alloc] init];
    logServ.mobileInfoUrl = Zhe800URLMobileInfo;
    logServ.mobileLogUrl = Zhe800URLMobileLog;
    [logServ addUserAction:dictParam];

}

// 提交打点
- (void)commitLog:(BOOL)startNow {

    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
    if (da.macAddress == nil) {
        return;
    }
    NSString *prequestKey = @"";//da.requestKey;
    NSString *pnettype = @"";
    if (da.networkStatus == NotReachable)
        pnettype = @"";
    else if (da.networkStatus == ReachableViaWWAN)
        pnettype = @"waan";
    else if (da.networkStatus == ReachableViaWiFi)
        pnettype = @"wifi";

    if (prequestKey == nil) {
        prequestKey = @"";
    }

    if (pnettype == nil) {
        pnettype = @"";
    }

    NSString *version = da.currentVersion;
    NSString *macAddress = da.macAddress;
    NSString *appName = da.headerVo.appName;
    NSString *partner = da.partner;
    NSString *tel = @"";
    NSString *cityId = da.city.cityId;
    double lat = da.lbsModel.coordinate2D.latitude;
    double lng = da.lbsModel.coordinate2D.longitude;
    NSString *latitude = @"";
    NSString *longitude = @"";
    NSString *userid = da.user.userId;
    NSString *phoneMode = da.headerVo.phoneModel;
    
    if (!phoneMode) {
        phoneMode = @"";
    }
    if (!da.user.userId) {
        userid = @"";
    }

    if (lat != 0) {
        latitude = [NSString stringWithFormat:@"%f", lat];
    }

    if (lng != 0) {
        longitude = [NSString stringWithFormat:@"%f", lng];
    }

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
            pnettype, @"netType",
            prequestKey, @"prequestKey",
            version, @"verstion",
            appName, @"appName",
            partner, @"partner",
            tel, @"tel",
            macAddress, @"macAddress",
            cityId, @"cityId",
            latitude, @"latitude",
            longitude, @"longitude",
            userid, @"userid",
            phoneMode,@"phoneMode",
            nil];


    _logService.sendImmediately = startNow;
    NSString *header = [_logService getActionHeader:params];

    if (!_sendingNow) {
        [_logService startSend:header];

        if (startNow)
            _sendingNow = YES;
    }
}

-(NSDictionary *)getAppActiveDictionary{
    
    Tao800DataModelSingleton *da = [Tao800DataModelSingleton sharedInstance];
    NSString *prequestKey = @"";//da.requestKey;
    NSString *pnettype = @"";
    if (da.networkStatus == NotReachable)
        pnettype = @"";
    else if (da.networkStatus == ReachableViaWWAN)
        pnettype = @"waan";
    else if (da.networkStatus == ReachableViaWiFi)
        pnettype = @"wifi";
    
    if (prequestKey == nil) {
        prequestKey = @"";
    }
    
    if (pnettype == nil) {
        pnettype = @"";
    }
    
    NSString *version = da.currentVersion;
    NSString *macAddress = da.macAddress;
    NSString *appName = da.headerVo.appName;
    NSString *partner = da.partner;
    NSString *cityId = da.city.cityId;
    double lat = da.lbsModel.coordinate2D.latitude;
    double lng = da.lbsModel.coordinate2D.longitude;
    NSString *latitude = @"";
    NSString *longitude = @"";
    NSString *userid = da.user.userId;
    NSString *phoneMode = da.headerVo.phoneModel;
    NSString *coverInstall = @"";
    
    if (da.tao800AppState == Tao800AppStateUpdateApp) {
        coverInstall = @"1";
    }else{
        coverInstall = @"0";
    }
    
    if (!phoneMode) {
        phoneMode = @"";
    }
    if (!da.user.userId) {
        userid = @"";
    }
    
    if (lat != 0) {
        latitude = [NSString stringWithFormat:@"%f", lat];
    }
    
    if (lng != 0) {
        longitude = [NSString stringWithFormat:@"%f", lng];
    }
    
    NSMutableDictionary *activeInfoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  macAddress,@"deviceid",
                                  pnettype,@"network",
                                  version,@"version",
                                  _logService.baseHeader.phoneVersion,@"sysversion",
                                  userid,@"userid",
                                  longitude,@"lot",
                                  latitude,@"lat",
                                  appName,@"source",
                                  partner,@"channel",
                                  cityId,@"city",
                                  macAddress,@"mac",
                                  @"iPhone",@"platform",
                                  phoneMode,@"mobilemodel",
                                  _logService.baseHeader.resolution,@"resolution",
                                  coverInstall,@"coverinstall"
                                  ,nil];
    [activeInfoDict setValue:userInfoDict forKey:@"userinfo"];
    
    NSString *idfv = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    NSString *ip = [self getIPAddress];
    NSString *bssid = [self getBSSId];
    NSString *idfa = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
    }
    if (!ip) {
        ip = @"";
    }
    if (!bssid) {
        bssid = @"";
    }
    
    NSDictionary *safeInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  ip,@"ipaddress",
                                  bssid,@"routerid",
                                  idfa,@"idfa",
                                  idfv,@"idfv"
                                  , nil];
    [activeInfoDict setValue:safeInfoDict forKey:@"safeinfo"];
    
    NSString *jsonString = nil;
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:activeInfoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError];
    if (! jsonData) {
        TBDPRINT(@"Got an error: %@", jsonError);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    Tao800RC4 *rc4 = [[Tao800RC4 alloc] init];
    rc4.key = @"Zhe8moBile";
    NSString *encryptStr = [rc4 encryptString:jsonString];
    if (!encryptStr) {
        encryptStr = @"";
    }
    NSDictionary *dict = @{@"param":encryptStr};
    return dict;
}

-(void)locationSuccess{
    [self uploadAppActiveLog2];
}

-(void)locationError{
    [self uploadAppActiveLog2];
}

-(void)uploadAppActiveLog2{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.tao800AppState != Tao800AppStateNothing && !self.enableToUploadAppActiveLog) {
        //全新安装 和 覆盖安装调用激活接口,且只调一次
        self.enableToUploadAppActiveLog = YES;
        NSDictionary *dict = [self getAppActiveDictionary];
        [self.upInitLogService sendAppActiveLogs:dict
                                      completion:^(NSDictionary *dic) {
                                          
                                      } failure:^(TBErrorDescription *error) {
                                          
                                      }];

    }

}

// 上传曝光打点
-(void)uploadingExposureLog:(NSString *)str ctype:(int)ctype{
    __weak Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    if (dm.uploadingDealLogs.count) {
       NSDictionary *dict = @{@"c_type": @(ctype),
                              @"params": dm.uploadingDealLogs};
        
        [_model sendSaveDealLogs:dict
                      completion:^(NSDictionary *dic) {
                      } failure:^(TBErrorDescription *error) {
                        
                      }
         ];
         
    }
}

// 上传init 打点
-(void)uploadIntlog:(NSDictionary *)dict{
    [self.upInitLogService sendInitLogs:dict
                           completion:^(NSDictionary *dic) {
                           } failure:^(TBErrorDescription *error) {
                           }
     ];
}


-(void)uploadIntThreeMinuteLog:(NSTimer *)incomingTimer{
    
    NSDictionary *dict = nil;
    if ([incomingTimer userInfo]) {
        dict = (NSDictionary *)[incomingTimer userInfo];
    }
    [self.upInitLogService sendInitThreeMinuteLogs:dict
                             completion:^(NSDictionary *dic) {
                             } failure:^(TBErrorDescription *error) {
                                 
                             }
     ];
}
// 3分钟后上传init 打点
- (void)delayThreeMinuteUpInitLog:(NSDictionary *)dict
{
    // 过180秒钟自动上传
    [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(uploadIntThreeMinuteLog:) userInfo:dict repeats:NO];
}
- (void)uploadRegisterLog{
    NSDictionary *dict = [self getCpaOutParams];
    [self.upInitLogService sendRegisterLogs:dict
                                 completion:^(NSDictionary *dic) {
    
                                 } failure:^(TBErrorDescription *error) {
    
                                 }];
}

- (void)viewDidAppearFromNotification:(NSNotification *)note {
    [self writeLogOfExit:NO pageParams:note.userInfo];
}

- (void)viewDidDisappearFromNotification:(NSNotification *)note {
    [self writeLogOfExit:YES pageParams:note.userInfo];
}

#pragma mark ---- singleton methods -----------
+ (Tao800UGCSingleton *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }

    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self) {

        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)dealloc {

}

#pragma mark -
#pragma mark TBUserLogApiDelegate Methods

///////////

- (void)didNetworkError:(NSDictionary *)params {
    _sendingNow = NO;
}

- (void)logSendFinish:(NSDictionary *)params {
    _sendingNow = NO;
}

- (void)didCommitBaseInfo:(NSDictionary *)params {

}

#pragma mark -获取曝光打点公共字符串 zbb|dealid|deviceid|userid|cType|cId|version|index
-(NSString *)getExposureStringByDealId:(int)dealId index:(int)index ctype:(int)ctype cId:(NSString *)cId{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSMutableString *baoGuanStr = [NSMutableString stringWithCapacity:5];
    [baoGuanStr appendString:@"zbb|"];
    [baoGuanStr appendFormat:@"%d|", dealId];
    [baoGuanStr appendFormat:@"%@|", dm.macAddress];
    
    if (dm.user && dm.user.userId && dm.user.userId.length) {
        [baoGuanStr appendFormat:@"%@|", dm.user.userId];
    }else{
        [baoGuanStr appendString:@"|"];
    }
    
    [baoGuanStr appendFormat:@"%d|", ctype];
    
    if ([cId isKindOfClass:[NSNull class]]) {
        cId = nil;
    }
    if (cId) {
//        BOOL hasChinese = NO;
//        for (int i = 0; i < [cId length]; i++) {
//            NSRange range = NSMakeRange(i, 1);
//            NSString *subString = [cId substringWithRange:range];
//            const char *cString = [subString UTF8String];
//            //UTF8编码：汉字占3个字节，英文字符占1个字节 判断有没有中文
//            if (strlen(cString) == 3) {
//                hasChinese = YES;
//                break;
//            }
//        }
//        if (hasChinese) {
//            NSString *str = [cId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [baoGuanStr appendFormat:@"%@|",str];
//        }
        [baoGuanStr appendFormat:@"%@|", [cId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        [baoGuanStr appendString:@"|"];
    }
    
    if (dm.listVersion) {
        [baoGuanStr appendFormat:@"%@|", dm.listVersion];
    }else{
        [baoGuanStr appendString:@"|"];
    }
    
    [baoGuanStr appendFormat:@"%d", index];
    return baoGuanStr;
}

-(NSString *)getUserTypeUserRoleStudentString{

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSString *userIdentity = [configManage getUserIdentity];
    if (!userIdentity||[userIdentity isEqualToString:@""]) {
        userIdentity = @"0";
    }
    NSString *isStudent = [configManage getUserStudentIdentity];
    
    NSString *str = [NSString stringWithFormat:@"%d_%@_%d",dm.userType,userIdentity,[isStudent boolValue]];
    return str;
}
@end
