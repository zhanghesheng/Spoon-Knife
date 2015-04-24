//
// Created by enfeng on 12-9-21.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBBaseNetworkApi.h" 
#import "TBScoreApi.h"
#import "TBPaymentApi.h"



@protocol TBScoreApiDelegate <TBBaseNetworkDelegate>

@optional
- (void)getScoreOfUserFinish:(NSDictionary *)params;
- (void)spendScoreFinish:(NSDictionary *)params;
- (void)addUserScoreFinish:(NSDictionary *)params;
- (void)billScoreFinish:(NSDictionary *)params;
- (void)scoreVoucherRedeemFinish:(NSDictionary *)params;
- (void)scoreVoucherAllFinish:(NSDictionary *)params;
- (void)scoreExchangeRecordFinish:(NSDictionary *)params;
- (void)scoreExchangeRecordDetailFinish:(NSDictionary *)params;
- (void)scoreTaskTodayFinish:(NSDictionary *)params;
- (void)AwardExchangeRecordFinish:(NSDictionary *)params;
- (void)AwardExchangeRecordDetailFinish:(NSDictionary *)params;
- (void)awardExchangeRecordAddReceiverInfoFinish:(NSDictionary *)params;
- (void)inviteAwardFinish:(NSDictionary *)params;
//支持积分过期
- (void)getScoreHistoryFinish:(NSDictionary *)params;
- (void)getScoreAccountFinish:(NSDictionary *)params;
@end

typedef enum _TBScorePointKeyEnum{
    ShareSinaWeiBoScore,  //团800-deal新浪微博分享
    ShareQQWeiXinScore,   //团800-deal微信分享
    Tuan800SignInScore,    //团800签到
    Tuan800AppSinaWeiboShaScore,//团800-客户端新浪微博邀请
    Tuan800AppWeiXinShareScore,  //团800-客户端微信邀请 
    Tuan800InvitedRegister,
    
    ShareUgcPicScore,     //惠800-上传图片
    ShareUgcFoodScore,    //惠800-上传优惠 
    ShareEmailScore,      //惠800-deal邮箱分享
    ShareSmsScore,        //惠800-deal短信分享
    CheckInScore,         //惠800-签到
    ShareUgcDealScore,     //惠800-发现菜品
    Hui800AppSmsShareScore, //惠800-客户端短信邀请
    HUI800AppEmailShareScore,    //惠800-客户端邮箱邀请
    InviteScore,          //邀请好友下载自己公司的app
    Tuan800SellWeiXinShare,//购买成功后微信分享送1分，一天上限3条
    Tuan800SellSinaWeiBoShare,//购买成功后微博分享送1分，一天上限3条
    
    Tao800SignInSina, //淘800-签到且新浪微博分享送1分，一天上限1条
    Tao800DealShare,  //淘800-通过微信，新浪微博，腾讯微博分享送1分，一天上限3分
    Tao800InvitedRegister, //淘800-邀请好友注册成功送8分，每月上限80分
    
} TBScorePointKeyEnum;

typedef enum {
    AllScore,
    Reduce,
    Add
} TBScoreSpendEnum;

typedef enum {
    ScoreAll,
    ScoreEarn,
    ScoreSpend,
} TBHistoryScoreType;

typedef enum {
    AccountAll,
    AccountAvailable,
    AccountExpired,
} TBScoreAccountType;

typedef enum {
    ScoreGetScoreRuleMethodFlag,
    ScoreGetScoreOfUserMethodFlag,
    ScoreAddUserScoreMethodFlag,
    ScoreSpendScoreMethodFlag,
    ScoreBillScoreMethodFlag,
    ScoreVoucherRedeemMethodFlag,
    ScoreVoucherAllMethodFlag,
    ScoreExchangeRecordFlag,
    ScoreExchangeRecordDetailFlag,
    AwardExchangeRecordAddReceiverInfo,
    AwardExchangeRecordFlag,
    AwardExchangeRecordDetailFlag,
    AwardInviteRegister,
    ScoreSpendTaskTodayFlag,
    GetScoreOrdersMethodFlag,
    
    //积分过期
    GetScoreHistoryFlag,
    GetScoreAccountFlag
} TN800LogServiceMethodType;

@class TBScoreExchangeRecordVo;

@interface TBScoreApi : TBBaseNetworkApi  {
    NSString *_baseUrl;
}


@property(nonatomic, copy) NSString *baseUrl;

/**
* 获取积分规则　积分攻略
*/
- (void)spendScore:(NSDictionary *)params;

/**
* 获取某个用户的积分
* @params
*   key:userId(NSString*)
*/
- (void)getScoreOfUser:(NSDictionary *)params;

/**
 * 邀请好友注册返积分/代金券
 * @params
 *   key:inviter_uid(NSString*) 邀请人ID
 *   key:invitee_uid(NSString*) 被邀请人ID
 */
- (void)inviteAward:(NSDictionary *)params;

/**
* 得积分
* @params
*   key:userId(NSString*)
*   key:pointKey(NSNumber*) 参照HUI800ScorePointKeyEnum
*/
- (void)addUserScore:(NSDictionary *)params;

/**
* 积分消耗
* @params
*    key:userId(NSString*)
*    key:queryType:(NSNumber*) 参照HUI800ScoreSpendEnum
*    key:startTime:(NSDate*)
*    key:endTime:(NSDate*)
*/
- (void)billScore:(NSDictionary *)params;


/**
* 兑换代金券
* @params
*   key:userId(NSString*)
*   key:num(NSString*)
*   key:mobile(NSString*)
*/
-(void)voucherRedeem:(NSDictionary *)params;

/**
* 代金券列表
*/
- (void)voucherAll:(NSDictionary *)params;

/*
 积分兑换纪录
 @params
 *  key: nextUrl(NSString*)
 */
- (void)scoreExchangeRecord:(NSDictionary *)params;

// 积分兑换纪录详情
- (void)scoreExchangeRecordDetail:(NSDictionary *)params;

/**
* 积分
* 增加收货人信息
*/
- (void)awardExchangeRecordAddReceiverInfo:(NSDictionary *)params;

//抽奖纪录
- (void)AwardExchangeRecord:(NSDictionary *)params;

//抽奖纪录详情
- (void)AwardExchangeRecordDetail:(NSDictionary *)params;

//获取用户今日执行的积分任务
- (void)scoreTaskToday:(NSDictionary *)params;

/**
 * 获取用户历史积分明细
 */
- (void)getScoreHistory:(NSDictionary *)params;

/**
 * 获取用户的积分帐户
 */
- (void)getScoreAccount:(NSDictionary *)params;

- (NSArray *)convertToScoreExchangeVo:(NSArray *)arr;
- (TBScoreExchangeRecordVo *)convertToScoreExchangeVoDetail:(NSDictionary *)item;

@end