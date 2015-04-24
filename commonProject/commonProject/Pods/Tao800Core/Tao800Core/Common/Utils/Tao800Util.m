//
//  Tao800Util.m
//  tao800
//
//  Created by enfeng on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBCore/SSKeychain.h>
#import <TBCore/OpenUDID.h>
#import "Tao800Util.h"
#import "Tao800DealVo.h"
#import "Tao800StartLogDao.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800StartLogVo.h"
#import "Tao800ConfigBVO.h"
#import "Tao800ConfigTipBVO.h"
#import "Tao800BannerVo.h"
#import "Tao800ForwardSegue.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800UGCSingleton.h"
#import "TBCore/TBCore.h"
#import "TBCore/NSString+Addition.h"

@implementation Tao800Util

+ (NSString *)DealDetailURLFormat:(NSString *)urlStr
                           dealId:(NSString *)dealId
                       pageSource:(Tao800DealDetailFrom)pageSource
                       categoryId:(NSString *)cId
                           sortId:(NSString *)sortId {

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"ttid" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:urlStr options:0 range:NSMakeRange(0, [urlStr length]) withTemplate:@"__temp__"];

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    //NSString *ttid = [NSString stringWithFormat:@"400000_21428298@zbbwx_iPhone_%@", dm.currentVersion];
    NSString *sid = [NSString stringWithFormat:@"t%@", dm.macAddress];

    NSString *firstSep = nil;
    if ([modifiedString rangeOfString:@"?"].length > 0) {
        firstSep = @"&";
    } else {
        firstSep = @"?";
    }

    NSMutableString *mString = [NSMutableString stringWithString:@""];
    [mString appendFormat:@"%@type=web&sjs=1&platform=iPhone&source=tao800_app", firstSep];
    [mString appendFormat:@"&version=%@", dm.currentVersion];
    [mString appendFormat:@"&channelId=%@", dm.partner];
    [mString appendFormat:@"&deviceId=%@", dm.macAddress];
    [mString appendFormat:@"&dealId=%@", dealId];
    [mString appendFormat:@"&sid=%@", sid];

    if (dm.user.inviteCode != nil) {
        [mString appendFormat:@"&mId=%@", dm.user.inviteCode]; // 邀请码
    }

    [mString appendFormat:@"&sche=%@", @"zhe800"]; //增加此参数用于淘宝客户端回跳

    if (dm.city.cityId && dm.city.cityId > 0) {
        [mString appendFormat:@"&cityId=%@", dm.city.cityId]; // 城市id
    }

    if (pageSource == Tao800DealDetailFromMuYingSingleDealsList || pageSource == Tao800DealDetailFromMuYingBrandDealList) {
        [mString appendFormat:@"&cType=%d", Tao800DealDetailFromMuYingDealsList]; // 页面分类类型
    }else{
        [mString appendFormat:@"&cType=%d", pageSource]; // 页面分类类型
    }

    if (cId && cId.length > 0) {
        [mString appendFormat:@"&cId=%@", cId]; // 页面分类类型id
        
    }else{
        if (pageSource == Tao800DealDetailFromHome) {
            [mString appendFormat:@"&cId=%@", @(0)];
        }
    }
    
    

    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;

    //2、获得scale：
    CGFloat scale_screen = [UIScreen mainScreen].scale;

    // 增加分辨率参数 resolution 宽X高
    [mString appendFormat:@"&resolution=%gX%g", size_screen.width * scale_screen, size_screen.height * scale_screen];

    [mString appendFormat:@"&return=tao800_app"];

    if (sortId.length > 0) {
        [mString appendFormat:@"&sortId=%@", sortId];
    }

    if (dm.listVersion) {
        [mString appendFormat:@"&listVersion=%@",dm.listVersion];
    }
    if (dm.user.campusCode&& dm.user.campusCode.length) {
        [mString appendFormat:@"&schoolCode=%@",dm.user.campusCode];
    }
    [mString appendFormat:@"&utype=%@",[[Tao800UGCSingleton sharedInstance] getUserTypeUserRoleStudentString]];

    //[mString appendFormat:@"&ttid=%@", ttid];
    NSString *urlString = mString;
    urlString = [urlString urlEncoded];
    urlString = [NSString stringWithFormat:@"%@%@", modifiedString, urlString];
    return urlString;
}

+ (UIImage *)imageWithColor:(UIColor *)color bounds:(CGRect)bounds {
    CGRect rect = bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (NSDate *)dateFromString:(NSString *)stringDate dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:stringDate];

    return date;
}

+ (BOOL)isDealExpired:(Tao800DealVo *)dealVo {
    NSString *expireDateString = dealVo.expireTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [formatter dateFromString:expireDateString];
    NSDate *currentDate = [NSDate date];
    NSComparisonResult result = [currentDate compare:expireDate];
    return (result == NSOrderedDescending);
}

+ (BOOL)isBeginStarted:(Tao800DealVo *)dealVo {
    NSString *expireDateString = dealVo.beginTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [formatter dateFromString:expireDateString];
    NSDate *currentDate = [NSDate date];
    NSComparisonResult result = [currentDate compare:expireDate];
    return (result == NSOrderedAscending);
}

+ (BOOL)isBeginStarted2:(Tao800DealVo *)dealVo {
    NSString *expireDateString = dealVo.beginTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [formatter dateFromString:expireDateString];
    NSDate *currentDate = [NSDate date];
    NSComparisonResult result = [currentDate compare:expireDate];
    return (result == NSOrderedAscending || result == NSOrderedSame);
}

+ (NSString *)getHomeTodayState {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [NSDate date];
    return [formatter stringFromDate:date];
}

+ (void)saveAppStartDate {
    NSString *dbPath = [TBFileUtil getDbFilePath:TBStoreDBFileName];
    if (!dbPath) {
        return;
    }
    Tao800StartLogDao *logDao = [[Tao800StartLogDao alloc] initWithPath:dbPath];
    Tao800StartLogVo *logVo = [[Tao800StartLogVo alloc] init];
    logVo.startCount = 1;
    logVo.date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    logVo.startId = [formatter stringFromDate:logVo.date];
    Tao800StartLogVo *logVo1 = [logDao getLogById:logVo.startId];
    if (!logVo1) {
        [logDao saveUlog:logVo];
    }
}

+ (void)resetButton:(UIButton *)button withBackgroundImg:(UIImage *)image {
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    UIImage *loginImg = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [button setBackgroundImage:loginImg forState:UIControlStateNormal];
    [button setBackgroundImage:loginImg forState:UIControlStateSelected];
}

+ (BOOL)needShowShareEditPage:(TBBShareToTag)shareToTag {
 
    return NO;
}

+ (NSDecimalNumber *)convertToPayPrice:(NSString *)price {
    NSDecimalNumber *priceDecimalNumber = [[NSDecimalNumber alloc] initWithString:price];
//    NSDecimalNumber *fen = [[NSDecimalNumber alloc] initWithString:@"100"];
//    NSDecimalNumber *priceFen = [priceDecimalNumber decimalNumberByMultiplyingBy:fen];
//    return priceFen;
    return priceDecimalNumber;
}

+ (TBUserVo *)convertJSONToUser:(NSDictionary *)params {
    TBUserVo *userVo = [[TBUserVo alloc] init];

    NSObject *userId = [params objectForKey:@"id" convertNSNullToNil:YES];
    NSString *userIdString = nil;
    if ([userId isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *) userId;
        userIdString = [num stringValue];
    } else {
        userIdString = (NSString *) userId;
    }

    userVo.userId = userIdString;
    userVo.phone = [params objectForKey:@"phone_number"];
    userVo.token = [params objectForKey:@"access_token"];
    userVo.name = [params objectForKey:@"user_name"];
    userVo.inviteCode = [params objectForKey:@"invite_code"];
    
    @try {
        id obj1 = [params objectForKey:@"has_school_spread_info"];
        BOOL hasCampusInformation = [obj1 boolValue];
        if (hasCampusInformation) {
            userVo.hasCampusInformation = YES;
            NSDictionary * userCampusInformation = [params objectForKey:@"school_spread_info"];
            if (userCampusInformation) {
                NSString * campusCodeString = [userCampusInformation objectForKey:@"school_special_code"];
                if (campusCodeString && campusCodeString.length > 0) {
                    userVo.campusCode = campusCodeString;
                }
                
                // NSString * education = [userCampusInformation objectForKey:@"education"];
                // TBDPRINT(@"%@",education);
            }
        }else{
            userVo.hasCampusInformation = NO;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    if ([[params objectForKey:@"active_status"] intValue] == 0) {
        // 未激活
        userVo.userStatus = TN800UserStatusUnActivate;
    } else {
        // 已激活
        userVo.userStatus = TN800UserStatusActivated;
    }

    userVo.lastLoginTime = [NSDate date];
    return userVo;
}

+ (NSDictionary *)jsonDict:(NSString *)jsonString {

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = nil;
    @try {
        dict = [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                 error:&error];
    }
    @catch (NSException *e) {
        dict = [NSDictionary dictionary];
    }

    return dict;
}


//是否小余当前时间    大余当前时间：no 小余当前日间：yes  格式 如：@"yyyy/MM/dd"
+(BOOL)isDayuCurrentDate:(NSString*)date format:(NSString*)format
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone : [NSTimeZone timeZoneForSecondsFromGMT : 8]];
    [formatter setDateFormat : format];
    NSDate *aimDate = [formatter dateFromString : date]  ;  //字nsstring 转 nsdate

    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    //[formatterT setTimeZone : [NSTimeZone timeZoneForSecondsFromGMT : 8]];
    [formatterT setDateFormat :  format];

    NSString *today = [formatterT stringFromDate:[NSDate date]];

    NSDate *todayDate = [formatterT dateFromString : today]  ;  //字nsstring 转 nsdate

    NSComparisonResult result = [todayDate compare : aimDate];

    if(result == NSOrderedDescending)    //小余当前日期
    {
        return YES;
    }

    return NO;

}

// 判断当前时间距离传入的时间是否在8小时以内
+(BOOL)time8:(NSString *)time
{
    NSDateFormatter *datestart= [[NSDateFormatter alloc] init];
    [datestart setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *ds=[datestart dateFromString:time];
    NSTimeInterval dst=[ds timeIntervalSince1970] * 1;


    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];

    NSTimeInterval difference = dst - currentTimeInterval;

    if (difference < 60*60*8) {
        NSLog(@"%f,<",difference);
        return YES;
    }else {
        NSLog(@"%f,>",difference);
        return NO;
    }
}

+(NSString*)currentDateStr:(NSString*)format
{
    if(!format)
    {
        format = @"yyyy-MM-dd HH:mm:ss";
    }

    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    //[formatterT setTimeZone : [NSTimeZone timeZoneForSecondsFromGMT : 8]];
    [formatterT setDateFormat :  format];

    NSString *today = [formatterT stringFromDate:[NSDate date]];

    return today;

}

+ (NSString*) addTaobaoLoginTip :(UIWebView*) webView {
    //J_wrapper
    //J_M_login(淘宝) J_Login(天猫)
    //typeof WebViewJavascriptBridge == 'object'
    [webView stringByEvaluatingJavaScriptFromString:@"var __temp_muu_1_ = document.getElementById('J_M_login');"];
    [webView stringByEvaluatingJavaScriptFromString:@"var __temp_muu_2_ = document.getElementById('J_Login');"];
    return [webView stringByEvaluatingJavaScriptFromString:@"__temp_muu_1_ != null || __temp_muu_2_ != null"];
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDateComponents*) getNSDateComponents:(NSDate *) date {
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit
            | NSMonthCalendarUnit
            | NSDayCalendarUnit
            | NSHourCalendarUnit
            | NSMinuteCalendarUnit
            | NSSecondCalendarUnit
            | NSWeekCalendarUnit
            | NSWeekdayCalendarUnit
            | NSWeekOfMonthCalendarUnit
            | NSWeekOfYearCalendarUnit fromDate:date];

    return dateComponents;
}

+(NSString*)soldOutCal:(Tao800DealVo*)deal{
    NSString *tipLabel = nil;
    if (deal.beginTime && [deal.beginTime length] > 0) {
        Tao800DealVo* vo = [[Tao800DealVo alloc] init];
        vo.beginTime = deal.beginTime;
        BOOL expired = [Tao800Util isBeginStarted:vo];
        if (expired) {
            tipLabel = @"未开始";
        }
    }
    
    switch (deal.oos) {
        case DealSaleStateSelling:
            break;
        case DealSaleStateSellOut: {
            tipLabel = @"已抢光";
        }
            break;
    }
    
    if (!tipLabel) {
        //判断是否已经过期
        Tao800DealVo* vo = [[Tao800DealVo alloc] init];
        vo.expireTime = deal.expireTime;
        BOOL expired = [Tao800Util isDealExpired:vo];
        if (expired) {
            tipLabel = @"已结束";
        }
    }
    return tipLabel;
}

+ (NSDictionary *)queryParams:(NSURL *)schemeUrl {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString *queryString = [schemeUrl query];

    NSArray *queryParams = [queryString componentsSeparatedByString:@"&"];
    for (NSString *param in queryParams) {
        NSArray *paramArray = [param componentsSeparatedByString:@"="];
        if ([paramArray count] < 2) continue;
        params[paramArray[0]] = paramArray[1];
    }
    return params;
}

+ (BOOL) enableDisplaySaleCount:(Tao800DealVo*) deal {
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    
    if (deal.sourceType == Tao800DealSourceTypeMall) {
        return YES;
    }
    
    //淘宝、天猫
    if (dm.configBVO && dm.configBVO.configTipBVO && dm.configBVO.configTipBVO.enableDisplayTaobaoSaleCount) {
        return deal.soldCount>0;
    } else {
        return NO;//默认不显示
    }
}

+ (void) tempMethodForAppDelegateOpenURL:(NSURL*) url {
    NSString *host = [url host];
    NSString *urlStr = [url scheme];
    urlStr = urlStr.lowercaseString;
    
    if (![urlStr isEqualToString:@"zhe800"]) {
        return;
    }
    
    if ([host isEqualToString:@"special_deal"]) {
        NSDictionary *schemeParams = [Tao800Util queryParams:url];
        NSString *dealId = schemeParams[@"dealid"];
        if (!dealId) {
            return;
        }
        Tao800BannerVo *vo = [[Tao800BannerVo alloc] init];
        vo.bannerType = @22;
        vo.value = dealId;
        vo.exposureRefer = Tao800ExposureReferHomeBanner;
        vo.dealDetailFrom = Tao800DealDetailFromHome;
        [[Tao800ForwardSingleton sharedInstance] bannerForward:vo openByModel:YES bannerAtIndex:-1];
    } else if ([host isEqualToString:@"goto_home"]) {
        UIViewController *ctl = [Tao800ForwardSingleton sharedInstance].navigationController.topViewController;
        if (ctl) { 
            [ctl dismissViewControllerAnimated:NO completion:^{}];
        }
        if ([[Tao800ForwardSingleton sharedInstance].navigationController isKindOfClass:[UINavigationController class]]) {
            [[Tao800ForwardSingleton sharedInstance].navigationController popToRootViewControllerAnimated:NO];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Tao800AppHandlerSelfWillGoHomeNotification object:nil];
    } else if ([host isEqualToString:@"webpage"]) {
        NSDictionary *schemeParams = [Tao800Util queryParams:url];
        NSString *urlString = schemeParams[@"url"];
        if (!urlString) {
            return;
        }
        
        NSDictionary *dict = @{
                               TBBForwardSegueIdentifierKey : @"TBBWebViewCTL@Tao800WebVCL",
                               TBNavigationCTLIsModelKey : @"YES",
                               @"url" : urlString
                               };
        [Tao800ForwardSegue ForwardTo:dict sourceController:[Tao800ForwardSingleton sharedInstance].navigationController];
    }
    
    
}

+ (NSString *)getDeviceId {

    NSString *password = [SSKeychain passwordForService:@"com.tuan800.tao800iphone.tao800"
                                                account:@"openUIID"];
    NSString *s1 = nil;
    if (!password) {
        if (RequireSysVerGreaterOrEqual(@"7.0")) {
            s1 = [OpenUDID value];
        } else {
            s1 = GetWifiMacAddress();
        }
        [SSKeychain setPassword:s1
                     forService:@"com.tuan800.tao800iphone.tao800" account:@"openUIID"];
    } else {
        s1 = password;
    }

    return s1;
}

+ (NSString *)outUrlString:(NSString *)urlStr shareType:(TBBShareToTag)shareToTag {
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSMutableString *mString = [NSMutableString stringWithString:urlStr];
    
    [mString appendFormat:@"source=%@", @"tao800_app"];
    
    switch (shareToTag) {
            
        case TBBShareToNothing:
            break;
        case TBBShareToSMS:
            [mString appendFormat:@"&share_Type=5"];
            break;
        case TBBShareToWeixin:
            [mString appendFormat:@"&share_Type=0"];
            break;
        case TBBShareToWeixinFriends:
            [mString appendFormat:@"&share_Type=10"];
            break;
    }
    
    if (dm.user.inviteCode != nil) {
        [mString appendFormat:@"&mId=%@", dm.user.inviteCode]; // 邀请码
    }
    
    return mString;
}
@end
