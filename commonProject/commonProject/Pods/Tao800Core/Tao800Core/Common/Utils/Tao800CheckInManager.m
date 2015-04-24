//
//  Tao800CheckInManager.m
//  tao800
//
//  Created by tuan800 on 14-3-7.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CheckInManager.h"
#import "Tao800BusinessDataService.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800ScoreVo.h"
#import <TBCore/FMDatabase.h>
#import <TBCore/FMDatabaseAdditions.h>
#import <TBCore/FMResultSet.h>
#import "Tao800CheckInHistoryItem.h"
#import "Tao800NotifycationConstant.h"
#import "TBCore/TBCoreMacros.h"
#import "TBCore/TBCoreCommonFunction.h"

@interface Tao800CheckInManager()

@property (nonatomic, strong) Tao800BusinessDataService * businessService;
@property (atomic, strong) FMDatabase * checkInHistoryDatabase;

@property (nonatomic, strong) NSMutableArray * tempArray;

@property (nonatomic, strong) UILocalNotification * checkInReminderNotification;

@end

const NSString * Tao800UserDidVisitCheckInPageKey = @"userDidVisitCheckInPageKey"; //完整的key是前面的字符串+用户名，值是日期。参考日期就行，一样说明访问过，不一样，说明没访问过，同时替换即可。

NSString * const Tao800WidgetUserDefaultSuitName = @"group.com.zhe800.iphone.TodayExtension";
NSString * const Tao800WidgetLastCheckInDate = @"Tao800WidgetLastCheckInDate";
NSString * const Tao800WidgetCheckInFinish = @"Tao800WidgetCheckInFinish";
NSString * const Tao800UserRebornDatesArrayKey = @"Tao800UserRebornDatesArrayKey";

@implementation Tao800CheckInManager

+(NSString *)checkInNotificationRemindingTimeString{
    int seconds = arc4random()%60;
    
    NSString * timeString = nil;
    if (seconds < 10) {
        timeString = [NSString stringWithFormat:@"20:0%d", seconds];
    }else{
        timeString = [NSString stringWithFormat:@"20:%d", seconds];
    }
    
    return timeString;
    
}

-(void)requestAndRecordCheckInInformation{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (!dm.user.userId) {
        return; //前提需用登录
    }
    
    Tao800BusinessDataService * temBusinessService = [Tao800BusinessDataService new];
    self.businessService = temBusinessService;
    
    __weak Tao800BusinessDataService * serviceInstance = temBusinessService;
    NSDictionary * checkInDic = @{@"checkin": @"0"};
    [serviceInstance checkIn:checkInDic completion:^(NSDictionary * dic) {
        dm.userScoreInfoVo = nil;
        [dm archive];
        Tao800ScoreVo * newScoreVo = [[Tao800ScoreVo alloc]init];
        
        int signIn = [[dic objectForKey:@"signin"]  intValue];
        if (signIn == 0) {
            self.userNeverDidCheckIn = YES; 
        }
        
       // NSLog(@"%@", dic);
        int checkInStatus = [[dic objectForKey:@"status"] intValue];
        if (checkInStatus == 3) {
            //已签
            //保存今天为签到日期
            NSDate * todayDate = [NSDate date];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString * todayDateString =[dateFormatter stringFromDate:todayDate];
            
            newScoreVo.checkInDateString = todayDateString;
            
            newScoreVo.tomorrowScore = [[dic objectForKey:@"tomorrow_score"] intValue];
            newScoreVo.todayScore = 0;
            
            newScoreVo.checkInFinishToday = YES;
            
        }else if (checkInStatus == 4){
            //登录未签
            newScoreVo.checkInDateString = nil;
            newScoreVo.todayScore = [[dic objectForKey:@"current_score"] intValue];
            //不保存日期
            newScoreVo.tomorrowScore = 0;
            
            newScoreVo.checkInFinishToday = NO;
        }
        
        newScoreVo.tomorrowScore = [[dic objectForKey:@"tomorrow_score"] intValue];
        newScoreVo.totalScore = [[dic objectForKey:@"score"] intValue];
        newScoreVo.continuousCheckInDays = [[dic objectForKey:@"day"] intValue];
        
        NSDate * checkInDate = [NSDate date];
        NSDateFormatter * queryDateFormatter = [[NSDateFormatter alloc]init];
        [queryDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * queryCheckInInformationDateString =[queryDateFormatter stringFromDate:checkInDate];
        newScoreVo.queryCheckInInforDateString = queryCheckInInformationDateString;
        dm.userScoreInfoVo = newScoreVo;
        [[NSNotificationCenter defaultCenter] postNotificationName:Tao800QueryCheckInInformationFinishNotification object:newScoreVo];
        [dm archive];
    } failure:^(TBErrorDescription * error) {
        
        TBDPRINT(@"%@", error);
    }];
}

-(void)userFinishCheckIn:(Tao800ScoreVo *)scoreVo{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    dm.userScoreInfoVo = Nil;
    dm.userScoreInfoVo = scoreVo;
    [dm archive];
}

-(void)clearCheckInDateAfterUserLogout{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    dm.userScoreInfoVo = nil;
    //用户是登录状态的时候才有这个Vo。否则没有.
    [dm archive];
}

//查询用户是否完成签到
-(BOOL)checkIfUserFinishCheckInToday{
    
    NSDate * todayDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * todayDateString =[dateFormatter stringFromDate:todayDate];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    NSString * dateStringRecord = dm.userScoreInfoVo.checkInDateString;
    if ([todayDateString isEqualToString:dateStringRecord]) {
        return YES;
    }else{
        return NO;
    }
}

/*
* app 自动查询签到信息
* 每天需要查询一次。
 */
-(BOOL)appAutoQueryCheckInInformationFinishToday{
    NSDate * todayDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * todayDateString =[dateFormatter stringFromDate:todayDate];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    
    NSString * queryCheckInInforString = dm.userScoreInfoVo.queryCheckInInforDateString;
    //NSString * checkInDateString = dm.userScoreInfoVo.checkInDateString;
    if (dm.user.userId) //登录状态下才去查询
    {
        if ([todayDateString isEqualToString:queryCheckInInforString]) {
            return YES;
        }else{
            [self requestAndRecordCheckInInformation];
            return NO;
        }
    }else{
        return NO;
    }
    
}

#pragma mark 设置是否使用签到本地数据库 instance.useCheckInDatabaseOrNot Yes,使用， NO 不使用

+ (Tao800CheckInManager *)sharedInstance {
    static Tao800CheckInManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        [instance createCheckInHistoryDatabase];
        
        instance.useCheckInDatabaseOrNot = YES;
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(toSetUserDefaultsForZhe800Widget:) name:Tao800QueryCheckInInformationFinishNotification object:nil];
    });
    return instance;
}

#pragma mark 给Widget小插件提供数据
-(void)toSetUserDefaultsForZhe800Widget:(NSNotification *)notification{
    //widget需要iOS8以上才能调用
     if (!TBSystemVersionGreaterThanOrEqualTo(_iOS_8_0)) {
         return;
     }
    
    
    Tao800ScoreVo * scoreVo = notification.object;
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.userScoreInfoVo) {
        if (!scoreVo.checkInFinishToday) {
            //未完成签到
            if(TBSystemVersionGreaterThanOrEqualTo(7)){
                NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:Tao800WidgetUserDefaultSuitName];
                [sharedDefaults setBool:NO forKey:Tao800WidgetCheckInFinish];
                [sharedDefaults synchronize];
            }
        }else{
            //完成签到
            if(TBSystemVersionGreaterThanOrEqualTo(7)){
                NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:Tao800WidgetUserDefaultSuitName];
                
                [sharedDefaults setBool:YES forKey:Tao800WidgetCheckInFinish];
                NSDate * currentDate = [[NSDate alloc]init];
                [sharedDefaults setObject:currentDate forKey:Tao800WidgetLastCheckInDate];
                [sharedDefaults synchronize];
            }
        }
    }
    
   
    
}

#pragma mark 签到历史缓存 数据库

-(void)createCheckInHistoryDatabase{
    if (!self.checkInHistoryDatabase) {
        NSString * cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString * dbPath = [cachPath stringByAppendingPathComponent:@"CheckinHistoryDatabase.sqlite"];
        TBDPRINT(@"Checkin Database --------------: %@", dbPath);
        
        // 注意:路径必须是.sqlite结尾的,否则没法创建.
        self.checkInHistoryDatabase = [FMDatabase databaseWithPath:dbPath];
    }
    
    if ([self.checkInHistoryDatabase open]) {
        //创建用户信息表
        if (![self.checkInHistoryDatabase tableExists:@"UserIdTable"])
        {
            [self.checkInHistoryDatabase executeUpdate:@"CREATE TABLE UserIdTable (id INTEGER PRIMARY KEY, userIdString TEXT)"];
        }
        if (![self.checkInHistoryDatabase tableExists:@"DateTable"])
        {
            [self.checkInHistoryDatabase executeUpdate:@"CREATE TABLE DateTable (id INTEGER PRIMARY KEY, dateString TEXT)"];
        }
        if (![self.checkInHistoryDatabase tableExists:@"CheckInLogTable"])
        {
            [self.checkInHistoryDatabase executeUpdate:@"CREATE TABLE CheckInLogTable (id INTEGER PRIMARY KEY, checkInUserString TEXT, checkInDateString TEXT)"];
        }
    }
}

/*
 确定用户签到完成，向数据里添加内容，内容分辨是签到的用户id 和签到的日期，分别放到三个表里面。
 */
-(void)addToCheckInHistoryDatabaseContent:(NSString *)userId andDateString:(NSString *)dateString{
    
    if (!self.tempArray) {
        self.tempArray = [NSMutableArray new];
    }
    
    // user_id_table
    
    [self.checkInHistoryDatabase open];
    [self.tempArray removeAllObjects];
    
    FMResultSet * userIdResult = [self.checkInHistoryDatabase executeQuery:@"select * from UserIdTable"];
    BOOL userIdExist = NO;
    while([userIdResult next]) {
        //[self.tempArray addObject:[userIdResult stringForColumn:@"userIdString"]];
        //NSString  * tempUserIdInDatabase = [userIdResult stringForColumn:@"userIdString"];
        //TBDPRINT(@"---------, UserIdString:   %@", tempUserIdInDatabase);
        if([[userIdResult stringForColumn:@"userIdString"] isEqualToString:[NSString stringWithFormat:@"%@", userId]]){
            userIdExist = YES;
            break;
        }
    }
    
    //问题：userId是NSString 类型，但是运行过程中变成了NSCFNumber, 所以上面比较字符串的时候不得不加上 [NSString stringWithFormat:@"%@", userId]
    
    /*
    for (NSString * userIdString in self.tempArray) {
        if ([userIdString isEqualToString:userId]) {
            userIdExist = YES;
            break;
        }
    }*/
    if(!userIdExist)
    {
        [self.checkInHistoryDatabase executeUpdate:@"INSERT INTO UserIdTable (userIdString) VALUES (?)",[NSString stringWithFormat:@"%@", userId]];
    }
    [self.checkInHistoryDatabase close];
    
    //日期talbe 日期不重复
    [self.checkInHistoryDatabase open];
    [self.tempArray removeAllObjects];
    
    FMResultSet * dateResult = [self.checkInHistoryDatabase executeQuery:@"select * from DateTable"];
    while([dateResult next]) {
        [self.tempArray addObject:[dateResult stringForColumn:@"dateString"]];
    }
    
    BOOL DateStringExist = NO;
    for (NSString * eachDateString in self.tempArray) {
        if ([eachDateString isEqualToString:dateString]) {
            DateStringExist = YES;
            break;
        }
    }
    if(!DateStringExist)
    {
        [self.checkInHistoryDatabase executeUpdate:@"INSERT INTO DateTable (dateString) VALUES (?)",dateString];
    }
    [self.checkInHistoryDatabase close];
    
    //签到记录表
    BOOL CheckInHistoryLogExist = NO;
    
    [self.checkInHistoryDatabase open];
    [self.tempArray removeAllObjects];
    FMResultSet * checkInHistoryResult = [self.checkInHistoryDatabase executeQuery:@"select * from CheckInLogTable"];
    while([checkInHistoryResult next]) {
        NSString * checkInDateLog = [checkInHistoryResult stringForColumn:@"checkInDateString"];
        NSString * userIdLog = [checkInHistoryResult stringForColumn:@"checkInUserString"];
        NSString  * wholeCheckInLogString = [NSString stringWithFormat:@"%@*%@", userIdLog, checkInDateLog];
        [self.tempArray addObject:wholeCheckInLogString];
    }
    
    for (NSString * tempCheckInLogString in self.tempArray) {
        if ([tempCheckInLogString isEqualToString:[NSString stringWithFormat:@"%@*%@", userId, dateString]]) {
            CheckInHistoryLogExist = YES;
        }
    }
    if (CheckInHistoryLogExist == NO) {
        [self.checkInHistoryDatabase executeUpdate:@"INSERT INTO CheckInLogTable (checkInUserString, checkInDateString) VALUES (?, ?)",userId,dateString];
    }
    
    [self.checkInHistoryDatabase close];
    
}


-(NSArray * )requestCheckInHistoryFromLocalDatabase{
    //
    Tao800DataModelSingleton * dm =[Tao800DataModelSingleton sharedInstance];
    NSString * userId = dm.user.userId;
    
    if (!userId) {
        return NULL;
    }
    
    NSMutableArray * checkInLogArray = [NSMutableArray array];
    
    [self.checkInHistoryDatabase open];
    
    int checkInLogIndex = 0;
    
    NSString * userIdInApp = [NSString stringWithFormat:@"%@", dm.user.userId];
    
    FMResultSet * checkInLogResults = [self.checkInHistoryDatabase executeQuery:@"select * from CheckInLogTable"];
    while([checkInLogResults next]) {
        NSString * usersCheckInDateString = [checkInLogResults stringForColumn:@"checkInDateString"];
        
        NSString * userIdInDatebase = [checkInLogResults stringForColumn:@"checkInUserString"];
        NSString * userIdString = [NSString stringWithFormat:@"%@", userIdInDatebase];
        if ([userIdInApp isEqual:userIdString]) {
            Tao800CheckInHistoryItem * item = [Tao800CheckInHistoryItem new];
            item.checkInIndex = checkInLogIndex;
            item.checkInTime = usersCheckInDateString;
            
            [checkInLogArray addObject:item];
            checkInLogIndex++;
        }
    }
    
    [self.checkInHistoryDatabase close];
    
    return checkInLogArray;
}

//前提是用户登录
-(BOOL)userVisitCheckInPageFristTimeToday{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    
    NSString * userVisitCheckInTodayKey = [NSString stringWithFormat:@"%@*%@", dm.user.userId, Tao800UserDidVisitCheckInPageKey];
    
    //value
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * userVisitCheckInTodayValue = [formatter stringFromDate:date];
    
    NSString * dateStringExist = [[NSUserDefaults standardUserDefaults] objectForKey:userVisitCheckInTodayKey];
    if ([dateStringExist isEqualToString:userVisitCheckInTodayValue]) {
        return YES; //用户进入过签到页
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:userVisitCheckInTodayValue forKey:userVisitCheckInTodayKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //记录用户进入过签到页 同时返回
        return NO; //用户没进入过签到页
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)addOneCheckInNotificationAfterUserClickCheckInLocalNotification{
    UIApplication * currentApp = [UIApplication sharedApplication];
    [self deleteLocalCheckInRemindNotification];

    if (!self.checkInReminderNotification) {
        self.checkInReminderNotification = [UILocalNotification new];
        self.checkInReminderNotification.timeZone = [NSTimeZone systemTimeZone];
        self.checkInReminderNotification.repeatInterval = kCFCalendarUnitDay; // repeat everyday
        self.checkInReminderNotification.soundName = UILocalNotificationDefaultSoundName;//default sound
        self.checkInReminderNotification.alertBody = @"亲，今天还没有签到呦。"; //local notification dealContent.不规范 需要修改
        self.checkInReminderNotification.applicationIconBadgeNumber = 1; //? 这个有问题 可能需用修改
        NSDictionary * info = [NSDictionary dictionaryWithObject:Tao800PersonalCheckInReminderNotificationUserInfoKey forKey:Tao800PersonalCheckInReminderNotificationUserInfoKey];
        self.checkInReminderNotification.userInfo = info;
    }

    NSDate * currentDate = [NSDate date];

    currentDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];

    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSString * timeString = [NSString stringWithFormat:@"%@", [Tao800CheckInManager checkInNotificationRemindingTimeString]];
    NSDate * time = [formatter dateFromString:timeString];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:time];
    dateComponents.hour = timeComponents.hour;
    dateComponents.minute = timeComponents.minute;
    NSDate *result = [currentCalendar dateFromComponents:dateComponents];

    [self.checkInReminderNotification setFireDate:result];
    [self.checkInReminderNotification setTimeZone:[NSTimeZone systemTimeZone]];
    [currentApp scheduleLocalNotification:self.checkInReminderNotification];
}


-(void)addCheckInNotificationAfterLoginSuccessfully: (BOOL) userFinishCheckInToday{
    //这部分是拷贝签到里面的签到提醒的
    /*
    Tao800CheckInManager * manager =[Tao800CheckInManager sharedInstance];
    if (manager.userNeverDidCheckIn) {
        return;
    }*/
    /*
     这儿不是设置是否加通知的地方，如果用户设置打开通知，那么这儿下面的代码可以执行，因为是重新设置通知，但是如果用户设置关闭通知，这里下面的代码就不应该被执行了。
     */
    BOOL checkInSwitchIsOn = NO;
   
    UIApplication * currentApp = [UIApplication sharedApplication];
    NSArray *localNotificationArray = [currentApp scheduledLocalNotifications];
    for (UILocalNotification * notification in localNotificationArray) {
        NSDictionary * userDic = notification.userInfo;
        if (userDic) {
            NSString * notificationName = [userDic objectForKey:Tao800PersonalCheckInReminderNotificationUserInfoKey];
            if ([notificationName isEqualToString:Tao800PersonalCheckInReminderNotificationUserInfoKey]) {
                checkInSwitchIsOn = YES;
            }
        }
    }
    
    if (!checkInSwitchIsOn) {
       [self deleteLocalCheckInRemindNotification];
       return; //如果签到提醒开关设置为关，那么不要执行下面的，下面是重新添加提醒
    }
    
    
    [self deleteLocalCheckInRemindNotification];
    
    if (!self.checkInReminderNotification) {
        self.checkInReminderNotification = [UILocalNotification new];
        self.checkInReminderNotification.timeZone = [NSTimeZone systemTimeZone];
        self.checkInReminderNotification.repeatInterval = kCFCalendarUnitDay; // repeat everyday
        self.checkInReminderNotification.soundName = UILocalNotificationDefaultSoundName;//default sound
        self.checkInReminderNotification.alertBody = @"亲，今天还没有签到呦。"; //local notification dealContent.不规范 需要修改
        self.checkInReminderNotification.applicationIconBadgeNumber = 1; //? 这个有问题 可能需用修改
        NSDictionary * info = [NSDictionary dictionaryWithObject:Tao800PersonalCheckInReminderNotificationUserInfoKey forKey:Tao800PersonalCheckInReminderNotificationUserInfoKey];
        self.checkInReminderNotification.userInfo = info;
    }
    
    NSDate * currentDate = [NSDate date];
    
    if (userFinishCheckInToday) {
        currentDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    }
    
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSString * timeString = [NSString stringWithFormat:@"%@", [Tao800CheckInManager checkInNotificationRemindingTimeString]];
    NSDate * time = [formatter dateFromString:timeString];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:time];
    dateComponents.hour = timeComponents.hour;
    dateComponents.minute = timeComponents.minute;
    NSDate *result = [currentCalendar dateFromComponents:dateComponents];
    
    [self.checkInReminderNotification setFireDate:result];
    [self.checkInReminderNotification setTimeZone:[NSTimeZone systemTimeZone]];
    [currentApp scheduleLocalNotification:self.checkInReminderNotification];
}

 
-(void)justAddACheckInNotification{
    UIApplication * currentApp = [UIApplication sharedApplication];
    [self deleteLocalCheckInRemindNotification];
    
    if (!self.checkInReminderNotification) {
        self.checkInReminderNotification = [UILocalNotification new];
        self.checkInReminderNotification.timeZone = [NSTimeZone systemTimeZone];
        self.checkInReminderNotification.repeatInterval = kCFCalendarUnitDay; // repeat everyday
        self.checkInReminderNotification.soundName = UILocalNotificationDefaultSoundName;//default sound
        self.checkInReminderNotification.alertBody = @"亲，今天还没有签到呦。"; //local notification dealContent.不规范 需要修改
        self.checkInReminderNotification.applicationIconBadgeNumber = 1; //? 这个有问题 可能需用修改
        NSDictionary * info = [NSDictionary dictionaryWithObject:Tao800PersonalCheckInReminderNotificationUserInfoKey forKey:Tao800PersonalCheckInReminderNotificationUserInfoKey];
        self.checkInReminderNotification.userInfo = info;
    }
    
    NSDate * currentDate = [NSDate date];
    
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSString * timeString = [NSString stringWithFormat:@"%@", [Tao800CheckInManager checkInNotificationRemindingTimeString]];
    NSDate * time = [formatter dateFromString:timeString];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:time];
    dateComponents.hour = timeComponents.hour;
    dateComponents.minute = timeComponents.minute;
    NSDate *result = [currentCalendar dateFromComponents:dateComponents];
    
    [self.checkInReminderNotification setFireDate:result];
    [self.checkInReminderNotification setTimeZone:[NSTimeZone systemTimeZone]];
    [currentApp scheduleLocalNotification:self.checkInReminderNotification];
}

-(void)deleteLocalCheckInRemindNotification{
    UIApplication * currentApp = [UIApplication sharedApplication];
    NSArray *localNotificationArray = [currentApp scheduledLocalNotifications];
    for (UILocalNotification * notification in localNotificationArray) {
        NSDictionary * userDic = notification.userInfo;
        if (userDic) {
            NSString * notificationName = [userDic objectForKey:Tao800PersonalCheckInReminderNotificationUserInfoKey];
            if ([notificationName isEqualToString:Tao800PersonalCheckInReminderNotificationUserInfoKey]) {
                [currentApp cancelLocalNotification:notification];
            }
        }
    }
}

-(void)settingRebornDays:(NSArray *)array{
    NSUserDefaults * theDefualt = [NSUserDefaults standardUserDefaults];
    [theDefualt setValue:array forKey:Tao800UserRebornDatesArrayKey];
    [theDefualt synchronize];
}

-(NSArray *)getRebornDays{
    NSUserDefaults * theDefualt = [NSUserDefaults standardUserDefaults];
    NSArray * rebornDays = [theDefualt objectForKey:Tao800UserRebornDatesArrayKey];
    return rebornDays;
}

@end
