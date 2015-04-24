//
//  Created by enfeng on 12-4-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800FunctionCommon.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800DealVo.h"
#import "TBCore/TBCore.h"
//#import "TBBMenuController.h"
//#import "Tao800TagListVCL.h"
//#import "TBBFilterListLeftController.h"
//#import "TBBFilterListRightController.h"

NSDate *ConvertDealVoBeginTimeToDate(NSString *beginTime, NSString *dateFormat) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:beginTime];

    return date;
}

NSString *MoneyFormat(float value) {
    return [NSString stringWithFormat:@"%g", value];
}

NSString *MoneyRoundingFormat(float value) {
    NSString *str1 = [NSString stringWithFormat:@"%.0f", value];
    NSString *str2 = [NSString stringWithFormat:@"%.1f", value];

    if ([[NSString stringWithFormat:@"%@.0", str1] isEqualToString:str2]) {
        return str1;
    }
    else {
        return str2;
    }
}

NSString *FenToYuanFormat(int fen) {
    float f = fen / 100.0f;
    return MoneyFormat(f);
}

NSString *GeToWanFormat(int ge) {
    if (ge<10000) {
        return [NSString stringWithFormat:@"%i",ge];
    }else{
        float g = ge / 10000.0f;
        NSMutableString *tempString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.1f",g]];
        NSRange range = [tempString rangeOfString:@".0"];
        
        if (range.length >0) {
            [tempString replaceCharactersInRange:range withString:@""];
        }
        return [NSString stringWithFormat:@"%@万",tempString];
    }
}

NSString *ComputeDiscount(float marketPrice, float price) {

    float discount = (price / marketPrice) * 10;
    NSString *dis = [NSString stringWithFormat:@"%.0f", discount];

    if (marketPrice == 0) {
        return @"10";
    }
    if ([dis isEqualToString:@"nan"]) {
        return @"0";
    } else {
        return MoneyRoundingFormat(discount);
    }
}

CGSize GetStringSize(UIFont *font, NSString *text, CGFloat width, NSLineBreakMode lineBreakMode) {
    CGSize maximumSize = CGSizeMake(width, MAXFLOAT);
    CGSize stringSize = [text sizeWithFont:font
                         constrainedToSize:maximumSize
                             lineBreakMode:lineBreakMode];
    return stringSize;
}

CGSize GetLabelStringSizeDependOnHeight(UILabel *label) {
    CGFloat height = label.frame.size.height;
    NSString *text = label.text;
    UIFont *font = label.font;
    NSLineBreakMode lineBreakMode = label.lineBreakMode;
    CGSize maximumSize = CGSizeMake(MAXFLOAT, height);
    CGSize stringSize = [text sizeWithFont:font
                         constrainedToSize:maximumSize
                             lineBreakMode:lineBreakMode];
    return stringSize;
}

CGSize GetLabelStringSizeDependOnWidth(UILabel *label) {
    CGFloat width = label.frame.size.width;
    NSString *text = label.text;
    UIFont *font = label.font;
    NSLineBreakMode lineBreakMode = label.lineBreakMode;
    CGSize maximumSize = CGSizeMake(width, MAXFLOAT);
    CGSize stringSize = [text sizeWithFont:font
                         constrainedToSize:maximumSize
                             lineBreakMode:lineBreakMode];
    return stringSize;
}

NSTimeInterval TimeRemainFromNow(NSString *endTime, NSDateFormatter *dateFormatter) {
    NSDate *ds = [NSDate date];
    NSTimeInterval dst = [ds timeIntervalSince1970];
    NSDate *de = [dateFormatter dateFromString:endTime];
    NSTimeInterval det = [de timeIntervalSince1970];
    NSTimeInterval difference = det - dst;

    return difference;
}

//  返回偏移值后的时间 格式：hh:mm:ss       timeInterval： 时间间隔 单位：秒    offset：偏移值 单位：秒
NSString *TimeIntervalFormatDate(NSTimeInterval timeInterval, int offsetSecond) {
    timeInterval = timeInterval + offsetSecond;

    int hour = (int) (timeInterval / 3600);
    int minute = (int) timeInterval % 3600 / 60;
    int second = (int) timeInterval % 60;

    NSString *hourStr;
    NSString *minuteStr;
    NSString *secondStr;

    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%d", hour];
    }
    else {
        hourStr = [NSString stringWithFormat:@"%d", hour];
    }

    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%d", minute];
    }
    else {
        minuteStr = [NSString stringWithFormat:@"%d", minute];
    }

    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%d", second];
    }
    else {
        secondStr = [NSString stringWithFormat:@"%d", second];
    }

    return [NSString stringWithFormat:@"%@小时%@分%@秒", hourStr, minuteStr, secondStr];
}

BOOL IsSameDay(NSDate *date1, NSDate *date2) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components1 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date1];
    NSDateComponents *components1 = [calendar components:NSDayCalendarUnit fromDate:date1];
    NSDateComponents *components2 = [calendar components:NSDayCalendarUnit fromDate:date2];

    NSInteger day1 = [components1 day];
    NSInteger day2 = [components2 day];

    return (day1 == day2);
}

BOOL IsFreePostage(Tao800DealVo *dealVo) {
    return ([dealVo.title rangeOfString:@"包邮"].location != NSNotFound);
}

NSInteger CheckUpdate(Tao800SoftVo *softVo) {

    if (nil == softVo) return TBAppUpdateApi_Update_Flag_NO_UPDATE_APP;

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    NSString *version = softVo.version;

    if ([dm.currentVersion isEqualToString:version]) return TBAppUpdateApi_Update_Flag_NO_UPDATE_APP;

    //比较版本
    NSArray *curArr = [dm.currentVersion componentsSeparatedByString:@"."];
    NSArray *versionArr = [version componentsSeparatedByString:@"."];

    int first = [[curArr objectAtIndex:0] intValue];
    int middle = [[curArr objectAtIndex:1] intValue];
    int last = [[curArr objectAtIndex:2] intValue];

    int rfirst = [[versionArr objectAtIndex:0] intValue];
    int rmiddle = [[versionArr objectAtIndex:1] intValue];
    int rlast = [[versionArr objectAtIndex:2] intValue];


    //比较最小版本与当前版本
    BOOL showTip = NO;
    //比较当前版本
    if (rfirst > first) {
        showTip = YES;
    } else if (rfirst == first) {
        if (rmiddle > middle) {
            showTip = YES;
        } else if (rmiddle == middle && rlast > last) {
            showTip = YES;
        }
    }
    BOOL must_upte = softVo.mustUpdate;
    if (showTip && must_upte) {
        return TBAppUpdateApi_Update_Flag_MUST_UPDATE_APP;
    } else if (showTip) {
        return TBAppUpdateApi_Update_Flag_HAVE_UPDATE_APP;
    } else {
        return TBAppUpdateApi_Update_Flag_NO_UPDATE_APP;
    }
}

// 获取小时
int GetHour(NSString *time) {
    NSTimeZone *localzone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];

    NSDate *date = [dateFormatter dateFromString:time];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];

    int result = (int)[comps hour];

    return result;
}

// 获取当前时间的小时
int GetHourByCurrentDate() {
    NSDate *date = [NSDate date];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];

    int result = (int) [comps hour];

    return result;
}

// 与当前时间的比较
NSComparisonResult CompareNowDate(NSString *time) {
    NSTimeZone *localzone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];

    NSDate *date = [dateFormatter dateFromString:time];
    NSDate *nowDate = [NSDate date];

    return [date compare:nowDate];
}

// 判断当前时间与传入时间是否在5分钟之内
bool CompareDateIn5Minutes(NSString *time) {
    NSTimeZone *localzone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];

    NSDate *date = [dateFormatter dateFromString:time];

    NSTimeInterval timeInterval = [date timeIntervalSinceNow];

    //NSLog(@"%f",timeInterval);

    if (timeInterval <= 300) {
        return YES;
    }

    return NO;
}

// 判断传入日期是否小于等于当前日期
bool CompareDateIsSmall(NSString *time) {
    NSTimeZone *localzone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:localzone];

    NSDate *date = [dateFormatter dateFromString:time];
    NSDate *currentDate = [NSDate date];
    NSComparisonResult result = [currentDate compare:date];
    return result == NSOrderedDescending;

//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//
//    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
//
//    int day1 = [comps day];
//    int month1 = [comps month];
//    int year1 = [comps year];
//    int hour1 = [comps hour];
//    int minute1 = [comps minute];
//
//    comps = [calendar components:unitFlags fromDate:[NSDate date]];
//
//    int day2 = [comps day];
//    int month2 = [comps month];
//    int year2 = [comps year];
//    int hour2 = [comps hour];
//    int minute2 = [comps minute];
//
//    if (day1 <= day2 && month1 <= month2 && year1 <= year2 && hour1 <= hour2 && minute1 <= minute2) {
//        return YES;
//    } else {
//        return NO;
//    }
}

// 是否是正确的手机号
BOOL IsCorrectPhone(NSString *str) {
//    NSString *substr = [str substringToIndex:3];
//    if ([substr isEqualToString:@"139"] || [substr isEqualToString:@"138"] || [substr isEqualToString:@"137"] || [substr isEqualToString:@"136"] || [substr isEqualToString:@"135"] || [substr isEqualToString:@"134"] || [substr isEqualToString:@"147"] || [substr isEqualToString:@"150"] || [substr isEqualToString:@"151"] || [substr isEqualToString:@"152"] || [substr isEqualToString:@"157"] || [substr isEqualToString:@"158"] || [substr isEqualToString:@"159"] || [substr isEqualToString:@"182"] || [substr isEqualToString:@"183"] || [substr isEqualToString:@"187"] || [substr isEqualToString:@"188"]) {
//        // 移动
//        return YES;
//    } else if ([substr isEqualToString:@"130"] || [substr isEqualToString:@"131"] || [substr isEqualToString:@"132"] || [substr isEqualToString:@"155"] || [substr isEqualToString:@"156"] || [substr isEqualToString:@"185"] || [substr isEqualToString:@"186"] || [substr isEqualToString:@"145"]) {
//        // 联通
//        return YES;
//    } else if ([substr isEqualToString:@"133"] || [substr isEqualToString:@"153"] || [substr isEqualToString:@"180"] || [substr isEqualToString:@"181"] || [substr isEqualToString:@"189"]) {
//        // 电信
//        return YES;
//    } else {
//        return NO;
//    }
    
    //客户端不需要验证
    return YES;
}

// 是否允许访问此schema
BOOL IsPermitAccessSchema(NSString *schema) {

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    // 判断是否开启白名单功能
    if (dm.tao800OutClose) {
        if (schema != nil && ![schema isEqualToString:@""]) {
            if ([schema isEqualToString:@"about"]) {
                return YES;
            }
            if (dm.tao800OutProtocol != nil) {
                BOOL result = [[dm.tao800OutProtocol objectForKey:schema] boolValue];
                return result;
            }
        }
    }

    return YES;
}

NSString *formatTime(NSString *str) {
    NSString *month = [str substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [str substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [str substringWithRange:NSMakeRange(11, 5)];

    return [NSString stringWithFormat:@"%d月%d日 %@", month.intValue, day.intValue, time];
}

// 获得当前日期字符串 20131031
NSString *currentDateFormatToStr() {

    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    [formatterT setDateFormat:@"yyyyMMdd"];

    NSString *today = [formatterT stringFromDate:[NSDate date]];

    return today;
}

UIImage* buttonImageWithColor(UIColor *color, CGRect rect)
{
    //CGRect rect = self.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


CGFloat SuitOnePixelHeight(void) {
    CGFloat h = 1;
    CGFloat screenWidth = 0;
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        screenWidth = [[UIScreen mainScreen] currentMode].size.width;
    }
    if (!TBIsPad() && screenWidth > 320)
        h = .5;
    else
        h = 1;

    return h;
}

NSString* FormatHtmlText(NSDictionary *dict) {
    NSString *htmlString = dict[@"htmlString"];
    NSString *fontName = dict[@"fontName"];
    NSString *fontSize = dict[@"fontSize"];
    NSString *fontColor = dict[@"fontColor"];
    
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:200];
    [mutableString appendString:@"body{"];
    [mutableString appendString:@"background:#fff;"];
    [mutableString appendString:@"padding:0px 10px 0px;"];
    [mutableString appendString:@"letter-spacing:1px;"];
    [mutableString appendFormat:@"font:%@px \"%@\";", fontSize, fontName];
    [mutableString appendFormat:@" color:#%@}", fontColor];
    
    NSString *regEx = @"body\\{.+\\}";
 
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regEx
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:htmlString
                                                               options:0
                                                                 range:NSMakeRange(0, [htmlString length])
                                                          withTemplate:mutableString];
    if (modifiedString) {
        return modifiedString;
    } else {
        return htmlString;
    }
}
//获取从当前日期到上次日期的 天数
int getDayFromCurrentDateToPastDate(NSDate *pastDate){
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *lastEnterAppDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:pastDate]];
    NSTimeInterval time = [currentDate timeIntervalSinceDate: lastEnterAppDate];
    
    if (time < 0) {
        return 0;
    }else{
        return  time/(3600*24);
    }
}

NSString * DeadLine(NSString *time){
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *deadLineDate = [dateFormatter dateFromString:time];
    
    NSTimeInterval timeInterval = [deadLineDate timeIntervalSinceDate:currentDate];
    int day = timeInterval/(3600*24);
    if (day >= 1) {
        return [NSString stringWithFormat:@"剩%d天",day];
    }else{
        if (timeInterval<=0) {
            return nil;
        }else{
            if ((int)timeInterval%3600 == 0) {
                return [NSString stringWithFormat:@"剩%d小时",(int)timeInterval/3600];
            }else{
                return [NSString stringWithFormat:@"剩%d小时",(int)timeInterval/3600 + 1];
            }
        }
    }
    return [NSString stringWithFormat:@"%lf",timeInterval];
}





