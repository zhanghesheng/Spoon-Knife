//
//  Tao800Util.h
//  tao800
//
//  Created by enfeng on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"
#import <TBService/Tuan800API.h>

@class Tao800DealVo;

@interface Tao800Util : NSObject

/**
* 封装详情url， 用于打点
*/
+ (NSString *)DealDetailURLFormat:(NSString *)urlStr
                           dealId:(NSString *)dealId
                       pageSource:(Tao800DealDetailFrom)pageSource
                       categoryId:(NSString *)cId
                           sortId:(NSString *)sortId;

/**
* 根据给定颜色生成背景色
*
* @param bounds 图片的大小
*/
+ (UIImage *)imageWithColor:(UIColor *)color bounds:(CGRect)bounds;

+ (NSDate *)dateFromString:(NSString *)stringDate dateFormat:(NSString *)dateFormat;

+ (BOOL)isDealExpired:(Tao800DealVo *)dealVo;

+ (BOOL)isBeginStarted:(Tao800DealVo *)dealVo;

+ (BOOL)isBeginStarted2:(Tao800DealVo *)dealVo;

/**
* 获取今日更新状态串，如果用户点击了今日更新，则要保存今日更新状态; 每天更新一次
*
* 状态串规则: 取格式化日期, 如 201400401
*/
+ (NSString *)getHomeTodayState;

/**
* 保存系统每天的启动时间
* 按天保存
*/
+ (void)saveAppStartDate;

/**
* 用拉伸图设置按钮图片样式
*/
+ (void)resetButton:(UIButton *)button withBackgroundImg:(UIImage *)image;

/**
* 判断是否需要显示分享编辑页面
*/
+ (BOOL)needShowShareEditPage:(TBBShareToTag)shareToTag;

/**
* 将价格转换为可支付用的价格, 支付用，实际返回为分
*/
+ (NSDecimalNumber *)convertToPayPrice:(NSString *)price;

+ (TBUserVo *)convertJSONToUser:(NSDictionary *)dict;

/**
* 采用系统函数进行json转换
*/
+ (NSDictionary *)jsonDict:(NSString *)jsonString;

/**
* from v28
* //是否小余当前时间    大余当前时间：no 小余当前日间：yes  格式 如：@"yyyy/MM/dd"
*/
+ (BOOL)isDayuCurrentDate:(NSString *)date format:(NSString *)format;

/**
* from v28
* 判断当前时间距离传入的时间是否在8小时以内
*/
+ (BOOL)time8:(NSString *)time;

/**
* from v28
* 获得当前时间
*/
+ (NSString *)currentDateStr:(NSString *)format;

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)addTaobaoLoginTip:(UIWebView *)webView;

+ (NSDateComponents *)getNSDateComponents:(NSDate *)date;

+ (NSString *)soldOutCal:(Tao800DealVo *)deal;

+ (NSDictionary *)queryParams:(NSURL *)url;

+ (BOOL) enableDisplaySaleCount:(Tao800DealVo*) deal;

+ (void) tempMethodForAppDelegateOpenURL:(NSURL*) url;

+ (NSString *)getDeviceId;

+ (NSString *)outUrlString:(NSString *)urlStr shareType:(TBBShareToTag)shareToTag;
@end
