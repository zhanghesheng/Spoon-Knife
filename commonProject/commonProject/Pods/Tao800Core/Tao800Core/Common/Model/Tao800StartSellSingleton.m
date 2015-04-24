//
//  Tao800StartSellSingleton.m
//  tao800
//
//  Created by worker on 13-1-21.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800StartSellSingleton.h"
#import "TBCore/TBFileUtil.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBCore.h"
#import "Tao800FunctionCommon.h"
#import "TBCore/TBCoreMacros.h"
#import "Tao800Util.h"

const static NSString *archiveFileName = @"startsell.dat";

static Tao800StartSellSingleton *_instance;

@implementation Tao800StartSellSingleton

@synthesize startSellArray = _startSellArray;

+ (Tao800StartSellSingleton *)sharedInstance {
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

    [aCoder encodeObject:self.startSellArray forKey:@"startSellArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self.startSellArray = [aDecoder decodeObjectForKey:@"startSellArray"];

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

#pragma mark 保存开卖提醒数据
- (void)saveStartSell:(Tao800DealVo *)dealVo {
    if (dealVo == nil) {
        return;
    }

    if ([self getStartSellByDealId:dealVo.dealId]) {
        return;
    }
    
    NSMutableArray *startSellArray = [NSMutableArray array];
    
    [startSellArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:dealVo.dealId], @"dealId",
                               dealVo.beginTime, @"remindTime",
                               dealVo, @"dealVo", nil]];
    
    [startSellArray addObjectsFromArray:[self getStartSellArray]];
    
    self.startSellArray = startSellArray;
    
    [self archive];

    NSString* status = [Tao800Util soldOutCal:dealVo];
    if (status && [status isEqualToString:@"未开始"]) {
        [self createStartSellRemindNotification:dealVo];
    }
}


#pragma mark 新建开卖提醒通知，通过dealVo
- (void)createStartSellRemindNotification:(Tao800DealVo *)dealVo {
    NSString *remindTime = dealVo.beginTime;
//    NSString *dealName = dealVo.title;

    // 获取同一时间提醒的商品总数
    int sameTimeCount = [self getSameTimeRemindCount:remindTime];

    if (sameTimeCount == 0) {
        TBDPRINT(@"没有需要提醒的商品");
        return;
    }

    // 计算提醒日期
    NSDate *remindDate = [self calRemindDate:remindTime];
    if (remindDate != nil) {
        // 建立本地通知
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = remindDate;
        localNotification.soundName = UILocalNotificationDefaultSoundName; // 设置播放声音
        localNotification.applicationIconBadgeNumber = 0; // 设置徽标
//        int hour = GetHour(remindTime);
        //localNotification.alertBody = [NSString stringWithFormat:@"您设置的%d个在%d点开卖的宝贝，将在5分钟后开卖！", sameTimeCount, hour];
        if(sameTimeCount == 1){
            //亲！你关注**5分钟后开抢哦！
            NSString *title = dealVo.shortTitle;
            if (!title || title.trim.length<1) {
                title = @"商品";
            }
            localNotification.alertBody = [NSString stringWithFormat:@"亲！你关注的%@5分钟后开抢哦！", title];
        }else{
            localNotification.alertBody = [NSString stringWithFormat:@"亲！你关注的%d件商品5分钟后开抢哦！", sameTimeCount];
        }
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      remindTime, @"remindTime",
                                      @"startSell", @"type",
                                      nil];
        
        TBDPRINT(@"建立新的开卖提醒，通知时间:%@", remindDate);

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        //localNotification.alertBody = [NSString stringWithFormat:@"分钟后开抢哦！"];
        //[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark 获取同一时间提醒的商品总数
- (int)getSameTimeRemindCount:(NSString *)remindTime {
    int sameTimeCount = 0;

    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"remindTime"] isEqualToString:remindTime]) {
            sameTimeCount++;
        }
    }

    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notifyRemindTime = [notification.userInfo objectForKey:@"remindTime"];
        if ([notifyRemindTime isEqualToString:remindTime]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            TBDPRINT(@"删除通知成功");
        }
    }
    return sameTimeCount;
}

#pragma mark 计算提醒日期
- (NSDate *)calRemindDate:(NSString *)remindTime; {
    if (remindTime == nil || [remindTime isEqualToString:@""]) {
        return nil;
    }

    NSTimeZone *localzone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];

    NSDate *remindDate = [dateFormatter dateFromString:remindTime];

    return [remindDate dateByAddingTimeInterval:-5 * 60]; // 提前5分钟提醒
}

#pragma mark 根据dealId查询对应的开卖提醒数据
- (NSMutableDictionary *)getStartSellByDealId:(int)dealId {
    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"dealId"] intValue] == dealId) {
            return dic;
        }
    }

    return nil;
}

#pragma mark 查找同一时间开卖提醒数据
- (NSMutableArray *)getStartSellByRemindTime:(NSString *)remindTime {
    NSMutableArray *array = [NSMutableArray array];
    
    // 循环把预计删除的数据找出来
    for (int i = 0; i < _startSellArray.count; i++) {
        NSDictionary *dic = [_startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"remindTime"] isEqualToString:remindTime]) {
            [array addObject:dic];
        }
    }
    
    return array;
}

#pragma mark 删除开卖提醒数据
- (void)deleteStartSell:(Tao800DealVo *)dealVo {
    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"dealId"] intValue] == dealVo.dealId) {
            [startSellArray removeObjectAtIndex:i];
            break;
        }
    }

    [self archive];

    [self deleteStartSellRemindNotification:dealVo];
}

#pragma mark 删除开卖提醒通知
- (void)deleteStartSellRemindNotification:(Tao800DealVo *)dealVo {
    
    if(![self whetherRemoveFromMessageCenter:dealVo.beginTime deal:dealVo]){
        return;
    }
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *remindTime = [notification.userInfo objectForKey:@"remindTime"];
        if ([remindTime isEqualToString:dealVo.beginTime]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            TBDPRINT(@"删除通知成功");
            break;
        }
    }

    //[self createStartSellRemindNotificationByRemindTime:dealVo.beginTime];
}


- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(BOOL)whetherRemoveFromMessageCenter:(NSString *)remindTime deal:(Tao800DealVo *)dealVo{
    int sameTimeCount = 0;
    //getSameTimeRemindCount
    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"remindTime"] isEqualToString:remindTime]) {
            sameTimeCount++;
        }
    }
    
    if (sameTimeCount < 1) {
        return YES;
    }else{
//        NSArray* array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString *type = [notification.userInfo objectForKey:@"type"];
            NSString *time =[notification.userInfo objectForKey:@"remindTime"];
            if(time){
                if ([type isEqualToString:@"startSell"] && [remindTime isEqualToString:time]) {
                    //必须先删除通知然后再创建
                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
                    NSDate *remindDate = [self calRemindDate:remindTime];
                    NSDate *nowDate = [NSDate date];
                    NSComparisonResult compareResult = [remindDate compare:nowDate];
                    if (compareResult == NSOrderedDescending) {
                        //再创建
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.fireDate = remindDate;
                        localNotification.soundName = UILocalNotificationDefaultSoundName; // 设置播放声音
                        localNotification.applicationIconBadgeNumber = 0; // 设置徽标
                        //int hour = GetHour(remindTime);
                        if(sameTimeCount == 1){
                            //找到唯一剩下的那个dealVo
                            NSString* title = @"";
                            for (int i = 0; i < startSellArray.count; i++) {
                                NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
                                if ([[dic objectForKey:@"remindTime"] isEqualToString:remindTime]) {
                                    Tao800DealVo* vo = [dic objectForKey:@"dealVo"];
                                    title = vo.shortTitle;
                                    break;
                                }
                            }
                            if (title.length>0) {
                                localNotification.alertBody = [NSString stringWithFormat:@"亲！你关注的%@5分钟后开抢哦！", title];
                            }else{
                                localNotification.alertBody = [NSString stringWithFormat:@"亲！你关注的商品5分钟后开抢哦！"];
                            }
                            
                        }else{
                            localNotification.alertBody = [NSString stringWithFormat:@"亲！你关注的%d件商品5分钟后开抢哦！", sameTimeCount];
                        }
                        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      remindTime, @"remindTime",
                                                      @"startSell", @"type",
                                                      nil];
                        TBDPRINT(@"建立新的提醒，通知时间:%@", remindDate);
                        
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        
                    }else{
                        //不再创建
                    }
                    
                }
            }
        }
    }
    return NO;
}

#pragma mark 新建开卖提醒通知，通过提醒时间
- (void)createStartSellRemindNotificationByRemindTime:(NSString *)remindTime {
//    NSMutableDictionary *remindDic = nil;
    int sameTimeCount = 0;

    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"remindTime"] isEqualToString:remindTime]) {
//            remindDic = dic;
            sameTimeCount++;
        }
    }

    if (sameTimeCount == 0) {
        return;
    }

    // 计算提醒日期
    NSDate *remindDate = [self calRemindDate:remindTime];
    if (remindDate != nil) {
        // 建立当前信用卡本地通知
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = remindDate;
        localNotification.soundName = UILocalNotificationDefaultSoundName; // 设置播放声音
        localNotification.applicationIconBadgeNumber = 0; // 设置徽标
        int hour = GetHour(remindTime);
        localNotification.alertBody = [NSString stringWithFormat:@"您设置的%d个在%d点开卖的宝贝，将在5分钟后开卖！", sameTimeCount, hour];
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      remindTime, @"remindTime",
                                      @"startSell", @"type",
                                      nil];
        TBDPRINT(@"建立新的提醒，通知时间:%@", remindDate);

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark 清空全部开卖提醒数据及通知
- (void)clearAllDataWithNotification {
    NSMutableArray *tempArr = [self getStartSellArray];
    [tempArr removeAllObjects];

    [self archive];

    [self clearAllNotification];
}

#pragma mark 清空全部开卖提醒通知
- (void)clearAllNotification {
    // 删除开卖提醒通知
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *type = [notification.userInfo objectForKey:@"type"];
        if ([type isEqualToString:@"startSell"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            TBDPRINT(@"删除开卖提醒通知成功");
        }
    }
}

#pragma mark 根据remindTime清空开卖提醒数据
- (void)clearByRemindTime:(NSString *)remindTime {

    NSMutableArray *removeArray = [NSMutableArray array];

    // 循环把预计删除的数据找出来
    for (int i = 0; i < _startSellArray.count; i++) {
        NSDictionary *dic = [_startSellArray objectAtIndex:i];
        if ([[dic objectForKey:@"remindTime"] isEqualToString:remindTime]) {
            [removeArray addObject:dic];
        }
    }

    // 执行批量删除操作
    for (int i = 0; i < removeArray.count; i++) {
        [_startSellArray removeObject:[removeArray objectAtIndex:i]];
    }

    [self archive];
}

#pragma mark 建立全部开卖提醒通知
- (void)createAllNotification {
    TBDPRINT(@"建立全部开卖提醒通知开始.....");
    NSMutableArray *startSellArray = [self getStartSellArray];
    for (int i = 0; i < startSellArray.count; i++) {
        NSMutableDictionary *dic = [startSellArray objectAtIndex:i];

        NSString *beginTime = [dic objectForKey:@"remindTime"];
        // 判断宝贝是否已经开卖
        NSComparisonResult compareResult = CompareNowDate(beginTime);
        switch (compareResult) {
            case NSOrderedAscending:
                //[self showTextTip:@"此宝贝已经开卖"];
                break;
            case NSOrderedSame:
                //[self showTextTip:@"此宝贝已经开卖"];
                break;
            case NSOrderedDescending:
                // 判断此宝贝离开卖时间是否在5分钟之内
                if (CompareDateIn5Minutes(beginTime)) {
                    //[self showTextTip:@"此宝贝将要开卖"];
                } else {
                    // 获取vo
                    Tao800DealVo *dealVo = [dic objectForKey:@"dealVo"];
                    [self createStartSellRemindNotification:dealVo];
                }
                break;
            default:
                break;
        }
    }
    TBDPRINT(@"建立全部开卖提醒通知结束！");
}

@end
