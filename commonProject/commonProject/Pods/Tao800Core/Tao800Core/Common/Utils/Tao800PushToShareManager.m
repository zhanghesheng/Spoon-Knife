    //
//  Tao800PushToShareManager.m
//  tao800
//
//  Created by tuan800 on 14-9-11.
//  Copyright (c) 2014 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PushToShareManager.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800ConfigBVO.h"
#import "Tao800ConfigTipBVO.h"
#import "Tao800MyGradeService.h"
#import "Tao800BusinessDataService.h"
#import "Tao800DataModelSingleton.h"

int const theTimesUserExistsFromAppForPush = 3;// 每几次用户退出app 推出push
int const pushToUserMaxTimes = 3; // 用户退出app触发push的最大次数
NSString * const userExistTimeString = @"userExistTimeString";
NSString * const pushToShareTimesString = @"pushToShareTimesString";

@interface Tao800PushToShareManager()

@property (nonatomic, strong) UILocalNotification * pushToShareNotification;
@property (nonatomic, assign) BOOL userFinishPushToShare;
@property (nonatomic, assign) BOOL pushToShareSwitch; //push开关是否打开
@property (nonatomic, strong) Tao800BusinessDataService * scoreService;
//@property (nonatomic, assign) BOOL userJustFinishPushToShare; // 用户刚刚加过分 需要的变量
@property (nonatomic, retain) Tao800MyGradeService * gradeService;

@end


@implementation Tao800PushToShareManager

+(Tao800PushToShareManager *)shareInstance{
    static Tao800PushToShareManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Tao800PushToShareManager alloc]init];
        
        // Tao800SettingLoginCTLDidCheckLoginNotifyCation
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(userJustLogin) name:Tao800SettingLoginCTLDidCheckLoginNotifyCation object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(userJustLogout) name:Tao800SettingsViewCTLLogoutSuccessNotifyCation object:nil];
        
    });
    return instance;
}

-(void)userJustLogin{
    [self requestInformationToCheckIfUserFinishPushToShare];
    self.pushToShareTimes = 0;
}

-(void)userJustLogout{
    //用户切换账号 重新开始计算弹或者不弹
    self.userExistTimes = 0;
    self.userFinishPushToShare = NO;
    /*
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    
    @try {
        //dm.configBVO.configTipBVO.pushToShareUrl = nil;
        //dm.configBVO.configTipBVO.pushToShareSwitchIsOnOrOff = NO;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }*/
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark setter getter方法，从userDefault里面得到值
-(int)userExistTimes{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSNumber * userExistTimes = [defaults objectForKey:userExistTimeString];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    int userExistTimes = dm.userExistsFromAppTimes;
    if (userExistTimes) {
        //int theUserExistTimes = [userExistTimes intValue];
        return userExistTimes;
    }else{
        return 0;
    }
}
-(void)setUserExistTimes:(int)userExistTimes{
    //NSNumber * existTimesNumber = [NSNumber numberWithInt:userExistTimes];
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:existTimesNumber forKey:userExistTimeString];
    //[defaults synchronize];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    dm.userExistsFromAppTimes = userExistTimes;
    [dm archive];
}

-(int)pushToShareTimes{
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSNumber * pushToShareTimes = [defaults objectForKey:pushToShareTimesString];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    int pushToShareTimes = dm.userExistsThenPushTimes;
    if (pushToShareTimes) {
        //int thepushToShareTimes = [pushToShareTimes intValue];
        return pushToShareTimes;
    }else{
        return 0;
    }
}
-(void)setPushToShareTimes:(int)pushToShareTimes{
    /*
    NSNumber * pushToShareTimesNumber = [NSNumber numberWithInt:pushToShareTimes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pushToShareTimesNumber forKey:pushToShareTimesString];
    [defaults synchronize];*/
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    dm.userExistsThenPushTimes = pushToShareTimes;
    [dm archive];
    
}

#pragma mark 请求用户是否完成pushToShare
-(void)requestInformationToCheckIfUserFinishPushToShare{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.user && dm.user.userId) {
        
    }else{
        return;
    }
    
    if (!self.scoreService) {
        self.scoreService = [[Tao800BusinessDataService alloc]init];
    }
    
    NSMutableDictionary * requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:dm.user.userId forKey:@"user_id"];
    [requestDic setObject:@"all" forKey:@"query_type"];
    [self.scoreService getPushToExistsHistory:requestDic complation:^(NSDictionary * responseDic) {
        
        if (responseDic) {
            NSArray * scoreArray = [responseDic objectForKey:@"score_histories"];
            if (scoreArray.count > 0) {
                self.userFinishPushToShare = YES;
            }else{
                self.userFinishPushToShare = NO;
            }
        }else{
            self.userFinishPushToShare = NO;
        }
        
    } failure:^(TBErrorDescription * error) {
        
    }];
}

#pragma mark Push 逻辑代码
-(void)takeARecordWhenUserExit{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    
    if (dm.configBVO.configTipBVO.pushToShareSwitchIsOnOrOff) {
        // go
    }else{
        return;
    }
    
    //判断用户是否完成分享
    if (self.userFinishPushToShare) {
        return;
    }else{
    }
    
    self.userExistTimes = self.userExistTimes + 1;
    
    if (dm.user && dm.user.userId && dm.user.userId.length > 0) {
        // go
        if(self.userExistTimes < theTimesUserExistsFromAppForPush){
            return;
        }
    }else{
        if (self.userExistTimes > theTimesUserExistsFromAppForPush){
            self.userExistTimes = theTimesUserExistsFromAppForPush;
        }
        return;
    }
    
    if (self.pushToShareTimes >= pushToUserMaxTimes) {
        return;
    }
    
    self.userExistTimes = 0;
    self.pushToShareTimes = self.pushToShareTimes + 1;
    
    [self addPushToShareNotification];
}

-(void)addPushToShareNotification{
    UIApplication * currentApp = [UIApplication sharedApplication];
    [self deleteLocalCheckInRemindNotification];
    
    if (!self.pushToShareNotification) {
        self.pushToShareNotification = [UILocalNotification new];
        self.pushToShareNotification.timeZone = [NSTimeZone systemTimeZone];
        self.pushToShareNotification.soundName = UILocalNotificationDefaultSoundName;
        self.pushToShareNotification.alertBody = @"感谢使用折800，分享好友还能获得额外奖励哦";
        self.pushToShareNotification.applicationIconBadgeNumber = 1;
        NSDictionary * info = [NSDictionary dictionaryWithObject:Tao800PushToShareLocalNotificationkey forKey:Tao800PushToShareLocalNotificationkey];
        self.pushToShareNotification.userInfo = info;
    }
    
    NSDate * currentDate = [NSDate date];
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
    dateComponents.minute = dateComponents.minute + 1;
    NSDate *result = [currentCalendar dateFromComponents:dateComponents];
    
    [self.pushToShareNotification setFireDate:result];
    [self.pushToShareNotification setTimeZone:[NSTimeZone systemTimeZone]];
    [currentApp scheduleLocalNotification:self.pushToShareNotification];
}

//用户分享完给用户加分
-(void)addScoreForUserAfterPushToShareSuccessful{
    
    if (!self.gradeService) {
        self.gradeService = [[Tao800MyGradeService alloc]init];
    }
    
    NSMutableDictionary * requestDic = [NSMutableDictionary new];
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    if (dm.user.userId && dm.user.userId.length > 0) {
        [requestDic setObject:dm.user.userId forKey:@"user_id"];
    }else{
        return;
    }
    
    NSString * pointKeywords = @"zhe-backpush";
    [requestDic setObject:pointKeywords forKey:@"point_key"];
    
    __weak Tao800PushToShareManager * instance = self;
    [self.gradeService addPoint:requestDic completion:^(NSDictionary * responseDic) {
        if (responseDic) {
            // 成功
            int status = [[responseDic objectForKey:@"status"] intValue];
//            int scoreAdded = [[responseDic objectForKey:@"operation_score"] intValue];
            if (status == 0) {
                //  分享加分成功，加的分数是scoreAdded
                instance.userFinishPushToShare = YES;
            }else{
                //  分享加分失败
            }
        }
    } failure:^(TBErrorDescription * error) {
        // 加分失败
    }];
    
}

-(BOOL)userFinishPushToShare{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    return dm.userFinishPushToShare;
}

-(void)setUserFinishPushToShare:(BOOL)userFinishPushToShare{
    Tao800DataModelSingleton * dm = [Tao800DataModelSingleton sharedInstance];
    dm.userFinishPushToShare = userFinishPushToShare;
    [dm archive];
}

-(void)deleteLocalCheckInRemindNotification{
    UIApplication * currentApp = [UIApplication sharedApplication];
    NSArray *localNotificationArray = [currentApp scheduledLocalNotifications];
    for (UILocalNotification * notification in localNotificationArray) {
        NSDictionary * userDic = notification.userInfo;
        if (userDic) {
            NSString * notificationName = [userDic objectForKey:Tao800PushToShareLocalNotificationkey];
            if ([notificationName isEqualToString:Tao800PushToShareLocalNotificationkey]) {
                [currentApp cancelLocalNotification:notification];
            }
        }
    }
}

@end
