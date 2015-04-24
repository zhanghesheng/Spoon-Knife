//
//  Tao800ConfigManage.h
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800ShareSocialBVO.h"

typedef enum _Tao800ConfigManageSignState{
    Tao800ConfigManageSignStateDid = 1,  //签到过
    Tao800ConfigManageSignStateNo = 0,    //未签到过
    Tao800ConfigManageSignStateNothing = -1    //未签到过
} Tao800ConfigManageSignState;

@class TBUserVo;
@class Tao800ShareSocialBVO;

@interface Tao800ConfigManage : NSObject


/**
* 获取存储在本地的用户身份
*
* @return 如 宅男、潮男
*/
- (NSString *)getUserIdentity;

/**
* 保存用户身份
*/
- (void)saveUserIdentity:(NSString *)userIdentity;

/**
 * 保存用户是否是学生的身份
 */
- (void)saveUserStudentIdentity:(NSString *)userStudentIdentity;

/**
 * 获取用户学生身份 结果是 字符串 YES 或者 NO
 */
-(NSString *)getUserStudentIdentity;

/**
 * 获取存储在本地的用户孩子生日
 *
 */
- (NSString *)getBabyBirthday;
/**
 * 保存用户宝贝生日
 *
 */

- (void)saveBabyBirthday:(NSString *)babyBirthday;

/**
 * 获取存储在本地的用户孩子性别
 *
 */
- (NSString *)getBabySex;
/**
 * 保存用户宝贝性别
 *
 */
- (void)saveMYFirstTime:(NSString *)babySex;

/**
 * 保存第一次进入母婴页面
 *
 */
- (NSString *)getMYFirstTime;
/**
 *获取存储第一次进入母婴页面
 *
 */

-(void)saveMYFirstTimeSet:(NSString *)set;
/**
 * 设置进入母婴页面，只显示一次set提示
 *
 */

-(NSString *)getMYFirstTimeSet;
/**
 * 获取进入母婴页面，只显示一次set提示
 *
 */
-(void)saveMYFirstTimeReset:(NSString *)reset;
/**
 * 设置进入母婴页面，只显示一次set提示
 *
 */

-(NSString *)getMYFirstTimeReset;
/**
 * 获取进入母婴页面，只显示一次set提示
 *
 */

- (void)saveBabySex:(NSString *)firstTime;
/**
 * 获取量化后孩子信息
 *
 */
-(NSString *)getBabyInfo;

/**
* 获取搜索历史
*
* @return 返回字符串的集合
*/
- (NSArray *)getSearchKeywords;

/**
* 保存搜索历史
*
* @param keywords
*
*/
- (void)saveSearchKeywords:(NSArray *)keywords;

/**
* 获取启动图数据
*
*/
- (NSArray *)getStartImageDatas;

- (void)saveStartImageDatas:(NSArray *)keywords;

- (NSArray *)getStartBigBannerData;

- (void)saveStartBigBannerData:(NSArray *)keywords;

- (NSArray *)getFavoriteDealIdsOfUser:(TBUserVo *)user;

- (void)saveFavoriteDealIdsOfUser:(TBUserVo *)user ids:(NSArray *)ids;

- (NSArray *)getFavoriteShopIdsOfUser:(TBUserVo *)user;

- (void)saveFavoriteShopIdsOfUser:(TBUserVo *)user ids:(NSArray *)ids;

/**
* 获取用户状态
*
* 如果是nil或者0代表新用户
*
*/
- (NSString *)getUserState;

/**
* 保存用户状态
*
* @param userType 如果是nil或者0代表新用户
*/
- (void)saveUserState:(NSString *)userState;

/**
* 获取应用的更新时间
*/
- (NSDate *)getAppInstallUpdateDate;

/**
* 保存新安装应用每天的更新时间
*/
- (void)saveAppInstallUpdateDate:(NSDate *) date;


/**
* 用户上一次启动或者从后台切换到前台的时间
*/
- (NSDate *)getAppLastActiveTime;


/**
 * 获取首页5模块
 */
- (NSArray *)getOperationModel;

/**
 * 保存首页5模块
 */
- (void)saveOperationModel:(NSArray *)array;

/**
 * 获取大促首页配置
 */
- (NSDictionary *)getPromotionHomeSettingModel;

/**
 * 保存大促首页配置
 */
- (void)savePromotionHomeSettingModel:(NSDictionary *)dict;


/**
* 保存用户切换到前台的时间
*/
- (void)saveAppLastActiveTime:(NSDate *)date;

/**
* 获取首页推荐分类
*/
- (NSArray *)getTagsOfRecommend;

/**
* 保存首页推荐分类
*/
- (void)saveTagsOfRecommend:(NSArray *) array;

/**
* 首页bubble提示，是否提示过
*
*
* @return nil代表未显示过
*/
- (NSString *)getBubbleStateOfHome;

/**
* 保存首页bubble提示过的状态
* @param state 非空字符串
*/
- (void)saveBubbleStateOfHome:(NSString *)state;


- (Tao800ConfigManageSignState)getSignStateOfUser:(TBUserVo *) userVo;

- (void)saveSignSate:(Tao800ConfigManageSignState)state user:(TBUserVo *) userVo;

/**
* 保存社会化分享
*/
- (void)saveSocialShare:(Tao800ShareSocialBVO *)shareSocialBVO;

- (Tao800ShareSocialBVO *)getSocialShare:(Tao80ShareSocialType)shareSocialType;


@end
