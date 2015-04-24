//
//  TBUserLogApi.m
//  Core
//  记录用户操作日志
//  Created by enfeng yang on 12-1-16.
//  Copyright (c) 2012年 mac. All rights reserved.
//
#import "TBCore/TBFileUtil.h"
#import "TBCore/TBCoreMacros.h"
#import "TBCore/NSString+Addition.h"

#import <Foundation/Foundation.h>

//事件分隔符
//事件标识|时间|参数列表;事件标识|时间|参数列表;事件标识|时间|参数列表
#define kEventSeparator @";"

//事件和参数之间的分隔符，每行的事件会存在数据库中，发送后将其删除
//事件标识|时间|参数列表
#define kEventLineSeparator @"|"

//参数和值之间的分隔符
#define kParamValueSeparator @":"

//参数之间的分隔符(参数列表)
#define kParamSeparator @","

NSString *const URLMobileInfo = @"http://api.tuan800.com/mobilelog/applog/mobileinfo";
NSString *const URLMobileLog = @"http://api.tuan800.com/mobilelog/applog/mobilelog";

#import "TBUserLogApi.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <TBUI/TBUICommon.h>

#import "TBLogDao.h" 
#import "TBConstants.h"

#define kLogSecKey @"testkey_"

@implementation TBUserLogApi
#pragma mark -
#pragma mark Singleton Methods

@synthesize baseHeader;
@synthesize sendImmediately = _sendImmediately;

@synthesize mobileInfoUrl = _mobileInfoUrl;
@synthesize mobileLogUrl = _mobileLogUrl;

- (void)dealloc {
 
}

- (NSString *)getShortDateString {
    NSDate *date = [NSDate date];
//    NSTimeInterval vl = [date timeIntervalSince1970];
//    double tt = (vl*1000);
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];  
//    //    [numberFormatter setNumberStyle:kCFNumberFormatterNoStyle];  
//    [numberFormatter setPositiveFormat:@"#"]; // need to set both the positive and [nf setNegativeFormat:@"($#,##0.00)"];
//    [numberFormatter setNegativeFormat:@"#"];
//    NSNumber *num = [NSNumber numberWithDouble:tt];  
//    NSString *timeStr = [numberFormatter stringFromNumber:num];  
//    timeStr = [timeStr substringToIndex:10];
//    [numberFormatter release];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss zzz"];
    NSString *targetDateString = [dateFormatter stringFromDate:date];

    NSString *timeStr = [targetDateString substringToIndex:12];

    return timeStr;
}

- (void)initData {
    _sendImmediately = NO;
    baseHeader = [[TBLogAnalysisBaseHeader alloc] init];
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    NSString *resolution = [NSString stringWithFormat:@"%d*%d",
                            (int) screen.currentMode.size.width,
                            (int) screen.currentMode.size.height];

    baseHeader.systemName = [device systemName];// e.g. @"iOS" 系统类型
    baseHeader.phoneModel = TBMachine();//e.g. @"iPhone", @"iPod touch"　手机型号
    baseHeader.phoneVersion = [device systemVersion];// e.g. @"4.0"
    baseHeader.resolution = resolution;

    if ([baseHeader.phoneModel hasPrefix:@"iPod"]) {
        baseHeader.phoneModel = @"iPod";
    }

    if ([baseHeader.phoneModel isEqualToString:@"iPhone"]) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = info.subscriberCellularProvider;
        baseHeader.carrier = carrier;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.mobileInfoUrl = URLMobileInfo;
        self.mobileLogUrl = URLMobileLog;
        [self initData];
    }
    return self;
}

- (void)startSend:(NSString *)header {

    NSString *dbPath = [TBFileUtil getDbFilePath:TBStoreDBFileName];
    TBLogDao *td = [[TBLogDao alloc] initWithPath:dbPath];
    NSArray *arr = [td getUlogs:20];
    
    if ([arr count] < 20 && !_sendImmediately) {
        return;
    }
    NSMutableArray *arrValue = [NSMutableArray arrayWithCapacity:20];
    for (TBLogVo *vo in arr) {
        [arrValue addObject:vo.content];
    }

    NSString *data = [arrValue componentsJoinedByString:kEventSeparator];
    NSString *key = [self getKey:[NSString stringWithFormat:@"%@", data]];
    NSURL *url = [NSURL URLWithString:self.mobileLogUrl];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    if (!data) {
        data = @"";
    }
    
    request.delegate = self;
    request.serviceData = arr;
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIUserLogSendLog;
    [request setPostValue:key forKey:@"key"];
    [request setPostValue:header forKey:@"header"];
    [request setPostValue:data forKey:@"data"];
    
    
//    [request addRequestHeader:@"Accept" value:@"application/json"];
//    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
//    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
//    [mArray addObject:@"{"];
//    
//    [mArray addObject:@"\"key\":\""];
//    [mArray addObject:key];
//    [mArray addObject:@"\","];
//    
//    
//    [mArray addObject:@"\"header\":\""];
//    [mArray addObject:header];
//    [mArray addObject:@"\","];
//    
//    
//    [mArray addObject:@"\"data\":\""];
//    [mArray addObject:data];
//    [mArray addObject:@"\""];
//    
//    [mArray addObject:@"}"];
//    
//    [request appendPostData:nil];
//    NSString *paramString = [mArray componentsJoinedByString:@""];
//    
//    [request appendPostData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    TBDPRINT(@"%@", data);
    [self send:request];
}

#pragma mark -
#pragma mark Custom Methods

- (NSString *)getKey:(NSString *)genStr {

    return [[NSString stringWithFormat:@"%@%@", kLogSecKey, genStr] md5];
}

- (void)commitBaseInfoLog {
    //手机型号|系统类型|运营商|分辨率|电话号码|deviceId|渠道id|软件名称|版本号|macAddress
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:8];
    [dataArr addObject:baseHeader.phoneModel];
    [dataArr addObject:baseHeader.systemName];
    if (baseHeader.carrier) {
        [dataArr addObject:baseHeader.carrier.carrierName];
    } else {
        [dataArr addObject:@""];
    }
    [dataArr addObject:baseHeader.resolution];
    if (baseHeader.telNum) {
        [dataArr addObject:baseHeader.telNum];
    } else {
        [dataArr addObject:@""];
    }
    NSString *macAddress = nil;
    if (baseHeader.macAddress == nil) {
        macAddress = @"";
    } else {
        macAddress = baseHeader.macAddress;
    }
    [dataArr addObject:macAddress];
    [dataArr addObject:baseHeader.partner];
    [dataArr addObject:baseHeader.appName];
    [dataArr addObject:baseHeader.appVersion];
    [dataArr addObject:macAddress];

    NSString *data = [dataArr componentsJoinedByString:kEventLineSeparator];
    NSString *key = [self getKey:data];

    NSURL *url = [NSURL URLWithString:self.mobileInfoUrl];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
//    request.serviceData = params; //todo
    [request setRequestMethod:@"POST"];
    request.serviceMethodFlag = APIUserLogCommitBaseInfo;
    [request setPostValue:key forKey:@"key"];
    [request setPostValue:data forKey:@"data"];
    TBDPRINT(@"%@", data);
    [self send:request];
}


/**
 * 记录用户行为
 * @params
 *    key:eventId(NSString*)事件标识(如：kEvent_R) 参见: TN800LogConstant
 *    key:param(NSDictionary*) 参数　参见: TN800LogConstant  key:参数名(如：kEvent_R)  value:(如：kAbout) 代表进入了关于页面
 */
- (void)addUserAction:(NSDictionary *)actions {
    NSDate *date = [NSDate date];

    NSString *timestr = [self getShortDateString];

    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:8];
    NSString *eventId = [actions objectForKey:@"eventId"];
    NSDictionary *paramDict = [actions objectForKey:@"param"];
    NSArray *keys = [paramDict allKeys];
    for (NSString *key in keys) {
        NSString *tmp = [NSString stringWithFormat:@"%@%@%@", key, kParamValueSeparator, [paramDict objectForKey:key]];
        [paramArr addObject:tmp];
    }
    NSString *paramVs = [paramArr componentsJoinedByString:kParamSeparator];

    [dataArr addObject:eventId];
    [dataArr addObject:timestr];
    [dataArr addObject:paramVs];

    NSString *content = [dataArr componentsJoinedByString:kEventLineSeparator];
    //    NSData *bytes = [content dataUsingEncoding:NSUTF8StringEncoding];

    TBLogVo *log = [[TBLogVo alloc] init];
    log.logtime = date;
    log.content = content;

    NSString *dbpath = [TBFileUtil getDbFilePath:TBStoreDBFileName];
    TBLogDao *td = [[TBLogDao alloc] initWithPath:dbpath];
    [td saveUlog:log];
}


/**
 * 获取用户行为基础头信息
 * @params
 *    key:requestKey(NSString*)
 *    key:netType(NSString*) 网络类型wifi,wwan
 *    key:latitude(NSString*) 
 *    key:longitude(NSString*)
 *    key:userid(NSString*) 可以为空字符串
 *    key:userid(NSString*) 可以为空字符串
 *    key:verstion(NSString*) 软件版本
 *    key:appName(NSString*)　软件名称
 *    key:partner(NSString*)　渠道号
 *    key:cityId(NSString*)　城市ID
 *    key:tel(NSString*)　电话
 *    key:macAddress (NSString*)网卡地址 如：e4:ce:8f:02:bb:74
 *    key:
 */
- (NSString *)getActionHeader:(NSDictionary *)params {
    NSString *prequestKey = [params objectForKey:@"requestKey"];
    NSString *netType = [params objectForKey:@"netType"];
    NSString *latitude = [params objectForKey:@"latitude"];
    NSString *longitude = [params objectForKey:@"longitude"];
    NSString *userid = [params objectForKey:@"userid"];
    NSString *verstion = [params objectForKey:@"verstion"];

    NSString *appName = [params objectForKey:@"appName"];
    NSString *partner = [params objectForKey:@"partner"];
    NSString *cityId = [params objectForKey:@"cityId"];
    NSString *tel = [params objectForKey:@"tel"];
    NSString *macAddress = [params objectForKey:@"macAddress"];
    NSString *ipAddress = [params objectForKey:@"ipAddress"];
    NSString *phoneMode = [params objectForKey:@"phoneMode"];
    
    if (!appName) {
        appName = @"";
    }
    
    if (!partner) {
        partner = @"";
    }
    
    if (!cityId) {
        cityId = @"";
    }
    
    if (prequestKey == nil) {
        prequestKey = @"";
    }
    if (latitude == nil) {
        latitude = @"";
    }
    if (longitude == nil) {
        longitude = @"";
    }
    if (userid == nil) {
        userid = @"";
    }
    if (tel == nil) {
        tel = @"";
    }
    if (macAddress == nil) {
        macAddress = @"";
    }
    if (ipAddress == nil) {
        ipAddress = @"";
    }
    if (!phoneMode) {
        phoneMode = @"";
    }
    NSString *timeStr = [self getShortDateString];
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:9];

    //requestKey|日志时间|deviceId|联网方式|软件版本|系统版本|登录用户ID|经度|纬度|软件名称|渠道id|City id|运营商|手机号|网卡|系统类型|手机型号|分辨率
    [dataArr addObject:prequestKey];
    [dataArr addObject:timeStr];
    [dataArr addObject:macAddress];
    [dataArr addObject:netType];
    [dataArr addObject:verstion];
    [dataArr addObject:baseHeader.phoneVersion];
    [dataArr addObject:userid];
    [dataArr addObject:latitude];
    [dataArr addObject:longitude];
    [dataArr addObject:appName];
    [dataArr addObject:partner];
    [dataArr addObject:cityId];

    if (baseHeader.carrier) {
        NSString *str = [NSString stringWithFormat:@"%@%@", baseHeader.carrier.mobileCountryCode, baseHeader.carrier.mobileNetworkCode];
        [dataArr addObject:str];
    } else {
        [dataArr addObject:@""];
    }
    [dataArr addObject:tel];
    [dataArr addObject:macAddress];

    if (baseHeader.systemName)
        [dataArr addObject:baseHeader.systemName];
    if (![phoneMode isEqualToString:@""])
        [dataArr addObject:phoneMode];
    if (baseHeader.resolution)
        [dataArr addObject:baseHeader.resolution];

    [dataArr addObject:ipAddress];

    return [dataArr componentsJoinedByString:kEventLineSeparator];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(TBASIFormDataRequest *)request {

    //    NSString *resStr = [request responseString];
    BOOL isError = [self isResponseDidNetworkError:request];
    if (isError) {
        ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
        [sharedCache removeCachedDataForURL:request.url];
        return;
    }

    switch (request.serviceMethodFlag) {
        case APIUserLogCommitBaseInfo: {
            SEL sel = @selector(didCommitBaseInfo:);
            @try {
                [super requestFinished:request];
                
                if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.delegate performSelector:sel withObject:nil];
#pragma clang diagnostic pop
                }
            }
            @catch (NSException *exception) {

            }
            @finally {

            }
        }
            break;

        case APIUserLogSendLog: {
            NSString *dbpath = [TBFileUtil getDbFilePath:TBStoreDBFileName];
            TBLogDao *td = [[TBLogDao alloc] initWithPath:dbpath];
            NSArray *serviceData = (NSArray *) request.serviceData;

            NSUInteger count = [serviceData count];
            if (count > 0) {
                NSInteger inx = count - 1;
                TBLogVo *logVo = (TBLogVo *) [serviceData objectAtIndex:inx];
                [td deleteUlogsWhereTimeLessThan:logVo.logtime];
            }

            SEL sel = @selector(logSendFinish:);
            @try {
                [super requestFinished:request];
                
                if (self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.delegate performSelector:sel withObject:nil];
#pragma clang diagnostic pop
                }
            }
            @catch (NSException *exception) {

            }
            @finally {

            }
        }
            break;

        default:
            break;
    }
}
@end
