//
//  Tao800CheckInManager.h
//  tao800
//
//  Created by tuan800 on 14-3-7.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tao800ScoreVo;

@interface Tao800CheckInManager : NSObject

@property (nonatomic, assign) BOOL userNeverDidCheckIn;

@property (nonatomic, assign) BOOL useCheckInDatabaseOrNot;//使用使用签到历史本地数据库

// 返回签到时间
+(NSString *)checkInNotificationRemindingTimeString;


/*
 判断用户是否完成签到,返回值YES是完成，NO是没有完成
 */
-(BOOL)checkIfUserFinishCheckInToday;

/*
 签到完成后传入参数 是当前的日期
 */
-(void)userFinishCheckIn:(Tao800ScoreVo *)scoreVo;

//加入签到通知，没有任何判断，晚上8点提醒
-(void)justAddACheckInNotification;

/*
 登录成功后查询签到状态
 */
-(void)requestAndRecordCheckInInformation;

/*
 登录退出后清除日期
 */
-(void)clearCheckInDateAfterUserLogout;

//app 自动查询签到信息 一天需用查询一次
-(BOOL)appAutoQueryCheckInInformationFinishToday;

+ (Tao800CheckInManager *)sharedInstance;

//签到缓存数据库
//注意：用户签到成功后输入的字符串需要是@"yyyy-MM-dd HH:mm:ss"这种形式 包括签到成功和查询签到历史成功。
-(void)addToCheckInHistoryDatabaseContent:(NSString *)userId andDateString:(NSString *)dateString;

//从签到数据库中获取登录用户的签到信息。
-(NSArray * )requestCheckInHistoryFromLocalDatabase;


//检验用户是不是第一次访问签到界面
-(BOOL)userVisitCheckInPageFristTimeToday;

//登录成功后添加签到提醒通知 晚上8点
-(void)addCheckInNotificationAfterLoginSuccessfully: (BOOL) userFinishCheckInToday;


//用户点击签到提醒后添加一个签到提醒，注意 添加24小时之后的。
-(void)addOneCheckInNotificationAfterUserClickCheckInLocalNotification;


/*
 *设置和获得复活的日期
 */
-(void)settingRebornDays:(NSArray *)array;
-(NSArray *)getRebornDays;

@end
