//
//  Tao800LotteryNoticeSingleton.m
//  Tao800Core
//
//  Created by Rose on 15/3/23.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import "Tao800LotteryNoticeSingleton.h"
#import "TBCore/TBFileUtil.h"
#import "Tao800StaticConstant.h"
#import "Tao800FunctionCommon.h"
#import "TBCore/TBCoreMacros.h"
#import "Tao800Util.h"
#import "Tao800NotifycationConstant.h"

const static NSString *archiveFileName = @"lotteryNoticeData.dat";

static Tao800LotteryNoticeSingleton *_instance;

@implementation Tao800LotteryNoticeSingleton


+ (Tao800LotteryNoticeSingleton *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            // 获取基础目录
            NSString *documentDirectory = [TBFileUtil getDocumentBaseDir];
            // 获取基础文件
            NSString *documentArchivePath = [documentDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            // 获取缓存目录
            NSString *cacheDirectory = [TBFileUtil getCacheDir:NO];
            // 获取缓存文件
            NSString *cacheArchivePath = [cacheDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            
            // 判断缓存文件是否存在
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:cacheArchivePath]) {
                // 存在
                //剪切文件
                BOOL moveResult = [TBFileUtil moveFile:cacheArchivePath ToFile:documentArchivePath forceMove:YES];
                if (moveResult) {
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];
                }
            } else {
                // 不存在
                
                @try {
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:documentArchivePath];
                } @catch ( NSException *ex ) {
                    _instance = [[self alloc] init];
                } @finally {
                    
                }
            }
        }
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (BOOL)archive {
    NSString *documentDirectory = [TBFileUtil getBaseDir];
    return [NSKeyedArchiver archiveRootObject:self
                                       toFile:[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.startSellArray forKey:@"lotteryNoticeArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    //lotteryNoticeArray
    self.startSellArray = [aDecoder decodeObjectForKey:@"lotteryNoticeArray"];
    
    return self;
}


#pragma mark - 获取开卖提醒列表
- (NSMutableArray *)getStartSellArray {
    if (_startSellArray) {
        return _startSellArray;
    }
    
    self.startSellArray = [[NSMutableArray alloc] init];
    return _startSellArray;
}

- (NSMutableDictionary *)getLotteryByDealId:(NSString*)dealId {
    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
        id saveId = [dic objectForKey:@"dealId"];
        if ([saveId isKindOfClass:[NSString class]]) {
            
        }else{
            
        }
        if ([dealId isKindOfClass:[NSNumber class]] && [saveId isKindOfClass:[NSNumber class]]) {
            NSNumber* numId = (NSNumber*)saveId;
            NSNumber* dealNumberId = (NSNumber*)dealId;
            if ([numId isEqualToNumber:dealNumberId]) {
                return dic;
            }
        }
        if ([dealId isKindOfClass:[NSNumber class]] && [saveId isKindOfClass:[NSString class]]) {
            return nil;
        }
        
        if ([dealId isKindOfClass:[NSString class]] && [saveId isKindOfClass:[NSString class]]){
            if ([dealId isEqualToString:saveId]) {
                return dic;
            }
        }
        if ([dealId isKindOfClass:[NSString class]] && [saveId isKindOfClass:[NSNumber class]]){
            if ([dealId isEqualToString:[saveId stringValue]]) {
                return dic;
            }
        }
        
    }
    return nil;
}

- (NSString*)saveNoticeTest:(Tao800LotteryDetailBVO *)dealVo {
    if (dealVo == nil) {
        return nil;
    }
    NSMutableArray *startSellArray = [NSMutableArray array];
    [startSellArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               dealVo.dealId, @"dealId",
                               dealVo.begunAt, @"remindTimeLottery", nil]];
    
    [startSellArray addObjectsFromArray:[self getStartSellArray]];
    
    self.startSellArray = startSellArray;
    
    [self archive];
    
    //NSString* status = [Tao800Util soldOutCal:dealVo];
    //if (status && [status isEqualToString:@"未开始"]) {
    
    return  [self createStartSellRemindNotificationTest:dealVo];
}

- (NSString*)saveNotice:(Tao800LotteryDetailBVO *)dealVo {
    if (dealVo == nil) {
        return nil;
    }
    
    //如果相同返回
    //    if ([self getLotteryByDealId:dealVo.dealId]) {
    //        return;
    //    }
    //如果不同先删除
    //if () {
    
    //}
    NSMutableArray *startSellArray = [NSMutableArray array];
    [startSellArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               dealVo.dealId, @"dealId",
                               dealVo.begunAt, @"remindTimeLottery", nil]];
    
    [startSellArray addObjectsFromArray:[self getStartSellArray]];
    
    self.startSellArray = startSellArray;
    
    [self archive];
    
    //NSString* status = [Tao800Util soldOutCal:dealVo];
    //if (status && [status isEqualToString:@"未开始"]) {
    
    return  [self createStartSellRemindNotification:dealVo];
    
    //}
}

//wan10以后返回YES(包括10点)
-(BOOL)isAfterWan10:(NSString*)wan10 begin:(NSString*)beginDateString{
    BOOL flag = NO;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *beginDate;
    if (beginDateString&&beginDateString.length>0) {
        beginDate = [formater dateFromString: beginDateString];
    }else{
        beginDate = [NSDate date];
    }
    
    NSDate *endDate = [formater dateFromString:wan10];
    int totalSeconds = [endDate timeIntervalSinceDate:beginDate];
    
    if (totalSeconds>0) {
        //在wan10前
        return NO;
    }else{
        return YES;
    }
    return flag;
}


//zao8之后返回YES
-(BOOL)isAfterZao8:(NSString*)zao8 begin:(NSString*)beginDateString{
    BOOL flag = NO;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *beginDate;
    if (beginDateString&&beginDateString.length>0) {
        beginDate = [formater dateFromString: beginDateString];
    }else{
        beginDate = [NSDate date];
    }
    
    NSDate *endDate = [formater dateFromString:zao8];
    int totalSeconds = [endDate timeIntervalSinceDate:beginDate];
    
    if (totalSeconds>0) {
        //在zao8前
        return NO;
    }else{
        return YES;
    }
    return flag;
}

//2015-03-25 15:00:00
-(BOOL)isInZao8Wan10Zone:(Tao800LotteryDetailBVO* )dealVo{
    BOOL flag = NO;
    NSString* zao8 = nil;
    NSString* wan10 = nil;
    BOOL isAfterZao8 = NO;
    BOOL isAfterWan10 = NO;
    if (dealVo.begunAt) {
        zao8 = [NSString stringWithFormat:@"%@08:00:00",[dealVo.begunAt substringWithRange:NSMakeRange(0, 11)]];
        wan10 = [NSString stringWithFormat:@"%@21:00:00",[dealVo.begunAt substringWithRange:NSMakeRange(0, 11)]];
        
        isAfterZao8 = [self isAfterZao8:zao8 begin:dealVo.begunAt];
        isAfterWan10 = [self isAfterWan10:wan10 begin:dealVo.begunAt];
    }
    
    if (isAfterZao8 && !isAfterWan10) {
        flag = YES;
    }
    return flag;
}

-(NSString*) radomMiniutes{
    int value = (arc4random() % 6) * 10;//0 10 20 30 40 50
    if (value < 1) {
        return [NSString stringWithFormat:@"00"];
    }
    return [NSString stringWithFormat:@"%d",value];
}

//2015-03-25 15:00:00
-(NSString*)replaceMiniutes:(NSString*)replaceString{
    NSString* backString = replaceString;
    NSString* front = nil;
    NSString* mid = nil;
    NSString* rear = nil;
    if (replaceString) {
        front = [replaceString substringWithRange:NSMakeRange(0, 14)];
        rear = [replaceString substringWithRange:NSMakeRange(16, 3)];
        mid = [self radomMiniutes];
        backString = [NSString stringWithFormat:@"%@%@%@",front,mid,rear];
    }
    return backString;
}

//2015-03-25 15:00:00
-(NSString*)createBeforeZao9TimeString:(NSString*)string{
    NSString* modify = [NSString stringWithFormat:@"%@",string];
    NSString* font = [modify substringWithRange:NSMakeRange(0, 11)];
    NSString* rear = [modify substringWithRange:NSMakeRange(13, 6)];
    return [NSString stringWithFormat:@"%@10%@",font, rear];
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//2015-03-26 15:00:00 返回明天的10点
-(NSString*)createAfterWan10TimeString:(NSString*)string{
    NSString* modify = [NSString stringWithFormat:@"%@",string];
    NSDate* wan10Data = [self calRemindDate:modify];
    int oneday = 60*60*24;
    NSDate* tomorrow = [[NSDate alloc] initWithTimeInterval:oneday sinceDate:wan10Data];
    NSString* tomorrowString = [self stringFromDate:tomorrow];
    NSString* font = [tomorrowString substringWithRange:NSMakeRange(0, 11)];
    NSString* rear = [tomorrowString substringWithRange:NSMakeRange(13, 6)];
    return [NSString stringWithFormat:@"%@10%@",font, rear];
}

#pragma mark 新建开卖提醒通知，通过dealVo

- (NSString*)createStartSellRemindNotification:(Tao800LotteryDetailBVO *)dealVo {
    NSString* zao8 = nil;
    NSString* wan10 = nil;
    BOOL isAfterZao8 = NO;
    BOOL isAfterWan10 = NO;
    zao8 = [NSString stringWithFormat:@"%@08:00:00",[dealVo.begunAt substringWithRange:NSMakeRange(0, 11)]];
    wan10 = [NSString stringWithFormat:@"%@21:00:00",[dealVo.begunAt substringWithRange:NSMakeRange(0, 11)]];
    isAfterZao8 = [self isAfterZao8:zao8 begin:dealVo.begunAt];
    isAfterWan10 = [self isAfterWan10:wan10 begin:dealVo.begunAt];
    
    NSString *remindTime = dealVo.begunAt;
    // 计算提醒日期
    NSDate *remindDate = nil;
    if([self isInZao8Wan10Zone:dealVo]){
        //
        remindTime = [self replaceMiniutes:dealVo.begunAt];
        remindDate = [self calRemindDate:remindTime];
        remindDate = [self calRemindDateAfterOneHour:remindDate];
    }else if(!isAfterZao8){
        remindTime = [self createBeforeZao9TimeString:dealVo.begunAt];
        //分钟随机
        remindTime = [self replaceMiniutes:remindTime];
        remindDate = [self calRemindDate:remindTime];
    }else if(isAfterWan10){
        remindTime = [self createAfterWan10TimeString:dealVo.begunAt];
        remindTime = [self replaceMiniutes:remindTime];
        remindDate = [self calRemindDate:remindTime];
    }
    NSString* showString = nil;
    if (remindDate != nil) {
        // 建立本地通知
        showString = [self stringFromDate:remindDate];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = remindDate;
        localNotification.soundName = UILocalNotificationDefaultSoundName; // 设置播放声音
        localNotification.applicationIconBadgeNumber = 0; // 设置徽标
        localNotification.alertBody = @"你设置的0元抽奖活动开始了，大奖等你拿~";
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      remindTime, @"remindTimeLottery",
                                      dealVo.dealId,@"remindLotteryId",
                                      Tao800LotteryNoticeLocalNotificationUserInfoKey, Tao800LotteryNoticeLocalNotificationUserInfoKey,
                                      nil];
        TBDPRINT(@"建立新的开卖提醒，通知时间:%@", remindDate);
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        //localNotification.alertBody = [NSString stringWithFormat:@"分钟后开抢哦！"];
        //[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    return showString;
}

- (NSString*)createStartSellRemindNotificationTest:(Tao800LotteryDetailBVO *)dealVo {
    NSDate* remindDate = [NSDate dateWithTimeIntervalSinceNow:6];
    NSString* showString = nil;
    if (remindDate != nil) {
        // 建立本地通知
        showString = [self stringFromDate:remindDate];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = remindDate;
        localNotification.soundName = UILocalNotificationDefaultSoundName; // 设置播放声音
        localNotification.applicationIconBadgeNumber = 0; // 设置徽标
        localNotification.alertBody = @"你设置的0元抽奖活动开始了，大奖等你拿~";
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      showString, @"remindTimeLottery",
                                      dealVo.dealId,@"remindLotteryId",
                                      Tao800LotteryNoticeLocalNotificationUserInfoKey, Tao800LotteryNoticeLocalNotificationUserInfoKey,
                                      nil];
        TBDPRINT(@"建立新的开卖提醒，通知时间:%@", remindDate);
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        //localNotification.alertBody = [NSString stringWithFormat:@"分钟后开抢哦！"];
        //[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    return showString;
}

//[remindDate dateByAddingTimeInterval:-5 * 60]; // 提前5分钟提醒

-(NSDate *)calRemindDateAfterOneHour:(NSDate*) date{
    return [date dateByAddingTimeInterval:60 * 60];
}

- (NSDate *)calRemindDate:(NSString *)remindTime; {
    if (remindTime == nil || [remindTime isEqualToString:@""]) {
        return nil;
    }
    NSTimeZone *localzone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];
    NSDate *remindDate = [dateFormatter dateFromString:remindTime];
    return remindDate;
}


- (void)clearAllDataWithNotification {
    NSMutableArray *tempArr = [self getStartSellArray];
    [tempArr removeAllObjects];
    [self archive];
    [self clearAllNotification];
}

- (void)clearAllNotification {
    // 删除开卖提醒通知
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *type = [notification.userInfo objectForKey:Tao800LotteryNoticeLocalNotificationUserInfoKey];
        if ([type isEqualToString:Tao800LotteryNoticeLocalNotificationUserInfoKey]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            TBDPRINT(@"删除开卖提醒通知成功");
        }
    }
}

@end
