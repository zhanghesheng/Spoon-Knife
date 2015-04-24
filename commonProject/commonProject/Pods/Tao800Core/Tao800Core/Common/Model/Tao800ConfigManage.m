//
//  Tao800ConfigManage.m
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBService/TBUserVo.h>
#import "Tao800ConfigManage.h"
#import "Tao800ConfigDao.h"
#import "Tao800CoreConfig.h"
#import "Tao800ShareSocialBVO.h"

@interface Tao800ConfigManage ()

@property(nonatomic, strong) Tao800ConfigDao *configDao;
@end

@implementation Tao800ConfigManage

- (id)init {
    if (self = [super init]) {
        self.configDao = [[Tao800ConfigDao alloc] init];
    }
    return self;
}

- (NSString *)getStringValue:(Tao800ConfigKey)configKey {
    Tao800CoreConfig *config = [_configDao getConfig:configKey];
    if (config) {
        return [[NSString alloc] initWithData:config.configValue encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)getObjectValue:(Tao800ConfigKey)configKey {
    Tao800CoreConfig *config = [_configDao getConfig:configKey];
    if (config) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:config.configValue];
    }
    return nil;
}

/**
*            @"1" : @"男",
*            @"2" : @"男",
*            @"3" : @"男",
*            @"4" : @"女",
*            @"5" : @"女",
*            @"6" : @"辣妈",
*/
- (NSString *)getUserIdentity {
    NSString *identity = [self getStringValue:Tao800ConfigKeyUserIdentity];
    if (!identity || identity.length < 1) {
        return identity;
    }

    int identityInt = identity.intValue;
    if (identityInt < 4) {
        return @"1";
    } else if (identityInt < 6) {
        return @"4";
    }
    return identity;
}

- (NSString *)getBabyBirthday {
    return [self getStringValue:Tao800ConfigKeyBabyBirthday];
}

- (NSString *)getBabySex {
    return [self getStringValue:Tao800ConfigKeyBabySex];
}

- (NSString *)getUserStudentIdentity {
    return [self getStringValue:Tao800ConfigKeyUserStudentIdentity];
}

-(NSString *)getMYFirstTime{
    return [self getStringValue:Tao800ConfigKeyFirstTimeGoToMYPage];
}

-(NSString *)getMYFirstTimeSet{
    return [self getStringValue:Tao800ConfigKeyFirstTimeShowMYLabelSet];
}

-(NSString *)getMYFirstTimeReset{
    return [self getStringValue:Tao800ConfigKeyFirstTimeShowMYLabelReset];
}

-(void)saveMYFirstTimeSet:(NSString *)set{
    NSData *data = [set dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyFirstTimeShowMYLabelSet value:data];
}

-(void)saveMYFirstTimeReset:(NSString *)reset{
    NSData *data = [reset dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyFirstTimeShowMYLabelReset value:data];
}

-(void)saveMYFirstTime:(NSString *)firstTime{
    NSData *data = [firstTime dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyFirstTimeGoToMYPage value:data];
}

- (void)saveUserIdentity:(NSString *)userIdentity {
    NSData *data = [userIdentity dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyUserIdentity value:data];
}

- (void)saveUserStudentIdentity:(NSString *)userStudentIdentity {
    NSData *data = [userStudentIdentity dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyUserStudentIdentity value:data];
}

- (void)saveBabyBirthday:(NSString *)babyBirthday {
    NSData *data = [babyBirthday dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyBabyBirthday value:data];
}

- (void)saveBabySex:(NSString *)babySex {
    NSData *data = [babySex dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyBabySex value:data];
}

- (NSArray *)getSearchKeywords {
    return [self getObjectValue:Tao800ConfigKeySearchKeywords];
}

- (void)saveSearchKeywords:(NSArray *)keywords {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:keywords];
    [_configDao saveConfig:Tao800ConfigKeySearchKeywords value:data];
}

- (NSArray *)getStartImageDatas {
    return [self getObjectValue:Tao800ConfigKeyStartImageDatas];
}

- (void)saveStartImageDatas:(NSArray *)keywords {
    if (keywords == nil) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:keywords];
    [_configDao saveConfig:Tao800ConfigKeyStartImageDatas value:data];
}

- (NSArray *)getStartBigBannerData {
    return [self getObjectValue:Tao800ConfigKeyStartBigBannerData];
}

- (void)saveStartBigBannerData:(NSArray *)keywords {
    if (keywords == nil) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:keywords];
    [_configDao saveConfig:Tao800ConfigKeyStartBigBannerData value:data];
}

- (NSArray *)getFavoriteDealIdsOfUser:(TBUserVo *)user {
    NSString *key = [NSString stringWithFormat:@"deal_%@", user.userId];
    Tao800CoreConfig *config = [_configDao getConfigWithKey:key];
    if (config) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:config.configValue];
    }
    return nil;
}

- (void)saveFavoriteDealIdsOfUser:(TBUserVo *)user ids:(NSArray *)ids {
    NSString *key = [NSString stringWithFormat:@"deal_%@", user.userId];
    if (ids == nil) {
        [_configDao deleteConfig:key];
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ids];
    [_configDao saveConfigWithKey:key value:data];
}

- (NSArray *)getFavoriteShopIdsOfUser:(TBUserVo *)user {
    NSString *key = [NSString stringWithFormat:@"shop_%@", user.userId];
    Tao800CoreConfig *config = [_configDao getConfigWithKey:key];
    if (config) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:config.configValue];
    }
    return nil;
}

- (void)saveFavoriteShopIdsOfUser:(TBUserVo *)user ids:(NSArray *)ids {

    NSString *key = [NSString stringWithFormat:@"shop_%@", user.userId];
    if (ids == nil) {
        [_configDao deleteConfig:key];
        return;
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ids];
    [_configDao saveConfigWithKey:key value:data];
}

- (NSString *)getUserState {
    return [self getStringValue:Tao800ConfigKeyUserState];
}

- (void)saveUserState:(NSString *)userState {
    NSData *data = [userState dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyUserState value:data];
}

- (NSDate *)getAppInstallUpdateDate {
    return [self getObjectValue:Tao800ConfigKeyAppUpdated];
}

- (void)saveAppInstallUpdateDate:(NSDate *)date {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:date];
    [_configDao saveConfig:Tao800ConfigKeyAppUpdated value:data];
}

- (NSDate *)getAppLastActiveTime {
    return [self getObjectValue:Tao800ConfigKeyAppLastActiveTime];
}

- (void)saveAppLastActiveTime:(NSDate *)date {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:date];
    [_configDao saveConfig:Tao800ConfigKeyAppLastActiveTime value:data];
}


/**
* 获取首页5模块
*/
- (NSArray *)getOperationModel {
    return [self getObjectValue:Tao800ConfigKeyOperationModel];
}

/**
* 保存首页5模块
*/
- (void)saveOperationModel:(NSArray *)array {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [_configDao saveConfig:Tao800ConfigKeyOperationModel value:data];
}

/**
 * 获取大促首页配置
 */
- (NSDictionary *)getPromotionHomeSettingModel{
    return [self getObjectValue:Tao800ConfigKeyPromotionHomeModel];
}

/**
 * 保存大促首页配置
 */
- (void)savePromotionHomeSettingModel:(NSDictionary *)dict{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [_configDao saveConfig:Tao800ConfigKeyPromotionHomeModel value:data];
}


/**
* 获取首页推荐分类
*/
- (NSArray *)getTagsOfRecommend {
    return [self getObjectValue:Tao800ConfigKeyTagsOfRecommend];
}

/**
* 保存首页推荐分类
*/
- (void)saveTagsOfRecommend:(NSArray *)array {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [_configDao saveConfig:Tao800ConfigKeyTagsOfRecommend value:data];
}

- (NSString *)getBubbleStateOfHome {
    return [self getStringValue:Tao800ConfigKeyHomeBubbleState];
}

- (void)saveBubbleStateOfHome:(NSString *)state {
    NSData *data = [state dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfig:Tao800ConfigKeyHomeBubbleState value:data];
}

- (Tao800ConfigManageSignState)getSignStateOfUser:(TBUserVo *)userVo {
    NSString *key = [NSString stringWithFormat:@"__sign_%@", userVo.userId];
    NSString *str = nil;
    Tao800CoreConfig *config = [_configDao getConfigWithKey:key];
    if (config) {
        str = [[NSString alloc] initWithData:config.configValue encoding:NSUTF8StringEncoding];;
    } else {
        return Tao800ConfigManageSignStateNo;
    }
    if (str) {
        Tao800ConfigManageSignState state = (Tao800ConfigManageSignState) str.intValue;
        return state;
    } else {
        return Tao800ConfigManageSignStateNo;
    }
}

- (void)saveSignSate:(Tao800ConfigManageSignState)state user:(TBUserVo *)userVo {
    NSString *key = [NSString stringWithFormat:@"__sign_%@", userVo.userId];
    NSString *string = [NSString stringWithFormat:@"%d", state];

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [_configDao saveConfigWithKey:key value:data];
}

- (void)saveSocialShare:(Tao800ShareSocialBVO *)shareSocialBVO {
    NSString *key = [NSString stringWithFormat:@"socialShareBVO_%d", (int)(shareSocialBVO.socialType)];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shareSocialBVO];
    [_configDao saveConfigWithKey:key value:data];
}

- (Tao800ShareSocialBVO *)getSocialShare:(Tao80ShareSocialType)shareSocialType {
    NSString *key = [NSString stringWithFormat:@"socialShareBVO_%d", (int) shareSocialType];
    Tao800CoreConfig *config = [_configDao getConfigWithKey:key];
    if (config) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:config.configValue];
    }
    return nil;
}

#pragma 获取量化后宝宝信息
-(NSString *)getBabyInfo{
    NSString *returnString = [[NSString alloc]init];
    
    NSString *babySex = [self getBabySex];
    NSString *babyBirthday = [self getBabyBirthday];
    //当本地未存储任何宝宝信息的时候返回“母婴“
    if (([babyBirthday isEqualToString:@""]||babyBirthday == nil)&&([babySex isEqualToString:@"0"]||babySex == nil)) {
        return @"母婴";
    }
    
    //根据本地存储的babysex字段得出宝宝的性别信息
    NSString *sexString = [[NSString alloc]init];
    if ([babySex isEqualToString:@"1"]) {
        sexString = @"男孩";
    }else if([babySex isEqualToString:@"2"]){
        sexString = @"女孩";
    }else{
        sexString = @"孩子";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateNow = [NSDate date];
    NSString *currect = [dateFormatter stringFromDate:dateNow];
    
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
//    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
//    NSDate *birthday = [dateFormatter dateFromString:babyBirthday1];
//    NSString *babyBirthday = [dateFormatter stringFromDate:birthday];

    int nowDay = [[currect substringFromIndex:8]intValue];
    int birthdayDay = [[babyBirthday substringFromIndex:8]intValue];

    int nowMonth = [[currect substringWithRange:NSMakeRange(5, 2)] intValue];
    int birthDayMonth = [[babyBirthday substringWithRange:NSMakeRange(5, 2)] intValue];
    
    int nowYear = [[currect substringWithRange:NSMakeRange(0, 4)] intValue];
    int birthdayYear = [[babyBirthday substringWithRange:NSMakeRange(0, 4)] intValue];
    
    
    int months = (nowYear - birthdayYear)*12 +(nowMonth - birthDayMonth);//计算宝宝出生至今的总月份
    
    //宝宝总月份小于0 未出生宝宝
    if (months < 0) {
        returnString = [[NSString alloc]initWithFormat:@"未出生%@",sexString];
        return returnString;
    }
    
    int yearsAge = months/12;//宝宝岁数
    int monthsAge = months%12;//宝宝月数
    
    NSString *ageString = [[NSString alloc]init];
    //岁数小于0取月数，否则取岁数
    if (yearsAge == 0) {
        //同一月孩子出生情况判断
        if (months == 0) {
            if (nowDay >= birthdayDay) {
                returnString = [[NSString alloc]initWithFormat:@"未满月%@",sexString];
                return returnString;
            }else{
                returnString = [[NSString alloc]initWithFormat:@"未出生%@",sexString];
                return returnString;
            }
        }else{
            ageString = [[NSString alloc]initWithFormat:@"%d个月",monthsAge];
        }
    }else{
        ageString = [[NSString alloc]initWithFormat:@"%d岁",yearsAge];
    }
    
    //字段拼接返回
    returnString = [[NSString alloc]initWithFormat:@"%@%@",ageString,sexString];
    return returnString;    
}

@end
