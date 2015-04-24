//
//  Created by enfeng on 12-4-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Tao800SoftVo.h"
#import "Tao800DataModelSingleton.h"
#import "TBUI/TBUI.h"

@class Tao800DealModel;
@class Tao800DealVo;

enum TBAppUpdateApi_Update_Flag_APP {
    TBAppUpdateApi_Update_Flag_NO_UPDATE_APP = 33333,
    TBAppUpdateApi_Update_Flag_MUST_UPDATE_APP,
    TBAppUpdateApi_Update_Flag_HAVE_UPDATE_APP
};

NSDate *ConvertDealVoBeginTimeToDate(NSString *beginTime, NSString *dateFormat);

/**
* 返回结果最多保留一位小数,　如：1(如果是1.0则取1), 1.1, 2.1
*/
NSString *MoneyFormat(float value);

/**
 * 返回结果最多保留一位小数,　如：1(如果是1.0则取1), 结果四舍五入
 */
NSString *MoneyRoundingFormat(float value);

/**
* 将分格式化为元
*　返回结果最多保留一位小数,　如：1(如果是1.0则取1), 1.1, 2.1
*
*/
NSString *FenToYuanFormat(int fen);

/**
* 计算折扣
* @param marketPrice 市场价
* @param price  当前价格
*/
NSString *ComputeDiscount(float marketPrice, float price);

CGSize GetStringSize(UIFont *font, NSString *text, CGFloat width, NSLineBreakMode lineBreakMode);

/**
* 根据label高度获取label的宽
*/
CGSize GetLabelStringSizeDependOnHeight(UILabel *label);

/**
 *根据label宽度获取label的高
 */
CGSize GetLabelStringSizeDependOnWidth(UILabel *label);

NSTimeInterval TimeRemainFromNow(NSString *endTime, NSDateFormatter *dateFormatter);

NSString *TimeIntervalFormatDate(NSTimeInterval timeInterval, int offsetSecond);

BOOL IsSameDay(NSDate *date1, NSDate *date2);

BOOL NeedRefreshDealModel(Tao800DealModel *dealModel);

/**
* 判断是否包邮
* @param dealVo
* @return YES:包邮 NO:
*/
BOOL IsFreePostage(Tao800DealVo *dealVo);

/**
 *检查版本升级
 *
 **/
NSInteger CheckUpdate(Tao800SoftVo *softVo);

// 获取小时
int GetHour(NSString *time);

// 获取当前时间的小时
int GetHourByCurrentDate();

// 与当前时间的比较
NSComparisonResult CompareNowDate(NSString *time);

// 判断当前时间与传入时间是否在5分钟之内
bool CompareDateIn5Minutes(NSString *time);

// 判断传入日期是否小于等于当前日期
bool CompareDateIsSmall(NSString *time);

// 是否是正确的手机号
BOOL IsCorrectPhone(NSString *str);

// 是否允许访问此schema
BOOL IsPermitAccessSchema(NSString *schema);

// 格式化日期 2013-10-22 09:00:00 转成 10月22日 09:00
NSString *formatTime(NSString *str);

// 获得当前日期字符串 20131031
NSString *currentDateFormatToStr();

CGFloat SuitOnePixelHeight(void);

UIImage* buttonImageWithColor(UIColor *color, CGRect rect);

NSString* FormatHtmlText(NSDictionary *dict);

//获取从当前日期到上次日期的 天数
int getDayFromCurrentDateToPastDate(NSDate *pastDate);

//每个品牌都要显示倒计时，剩余时间的显示逻辑：
//设：剩余时间为x小时
//当x≥24时，显示x÷24的结果取整数
//例如，x=75，75÷24的结果取整，即显示“剩3天”
//当x＜24时，显示具体小时数，向上取整
//例如，13小时18分，显示“剩14小时”
//剩余时间的最小单位是“剩1小时”
NSString* DeadLine(NSString *time);

//个转换成万
NSString *GeToWanFormat(int ge);

