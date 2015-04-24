//
// Created by enfeng on 12-9-21.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBScoreApi.h"
#import "TBNetwork/ASIDownloadCache.h"
#import "TBCore/NSDictionaryAdditions.h"
#import "TBCore/NSString+Addition.h"
#import "TBCore/TBFileUtil.h"
#import "TBScoreConsume.h"
#import "TBVoucherVo.h"
#import "TBScoreExchangeRecordVo.h"

#ifdef DEBUG
NSString *const ScoreUrlBase = @"http://m.api.tuan800.com"; //@"http://110.173.1.12:8004";
NSString *const ScoreUrlBaseV3 = @"http://api.tuan800.com";
#else
NSString *const ScoreUrlBase = @"http://m.api.tuan800.com";
NSString *const ScoreUrlBaseV3 = @"http://m.api.tuan800.com";
#endif

@implementation TBScoreApi {

}

@synthesize baseUrl = _baseUrl;

- (id) init {
    self = [super init];
    if (self) {
        self.baseUrl = ScoreUrlBase;
    }
    return self;
}

NSObject *TBConvertNSNullClass(NSObject *obj);
//NSObject *ConvertNSNullClass(NSObject *obj) {
//    if ( [obj isKindOfClass:[NSNull class]]) {
//        return nil;
//    }
//    return obj;
//}

- (NSArray *)convertToSpendScoreVo:(NSDictionary *)dict {
    NSArray *arr = (NSArray *) dict;//[dict objectForKey:@""];
    NSMutableArray *retArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *item in arr) {
        TBScoreConsume *vo = [[TBScoreConsume alloc] init];
        vo.userId = [item objectForKey:@"user_id"];
        vo.spendDescription = [item objectForKey:@"description"];
        vo.createAt = [item objectForKey:@"create_at"];
        vo.ruleId = [item objectForKey:@"rule_id"];
        vo.score = [item objectForKey:@"score"];
        vo.spendId = [item objectForKey:@"id"];
        vo.title = [item objectForKey:@"title"];
        vo.todayTaskKey = (NSString *) TBConvertNSNullClass([item objectForKey:@"key"]);
        [retArr addObject:vo];

    }
    return retArr;
}

- (NSArray *)convertToScoreExchangeVo:(NSArray *)arr {
    NSMutableArray *retArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *item in arr) {
        TBScoreExchangeRecordVo *vo = [[TBScoreExchangeRecordVo alloc] init];
        NSNumber *numberId = (NSNumber *) TBConvertNSNullClass([item objectForKey:@"id"]);
        if (numberId) {
            vo.recordId = [numberId stringValue];
        } else
            vo.recordId = nil;
        //vo.recordId = [item objectForKey:@"id"];
        vo.name = (NSString *) TBConvertNSNullClass([item objectForKey:@"name"]);
        vo.smalllistimage = (NSString *) TBConvertNSNullClass([item objectForKey:@"smalllistimage"]);
        vo.exchange_time = (NSString *) TBConvertNSNullClass([item objectForKey:@"exchange_time"]);
        vo.send_type = (NSString *) TBConvertNSNullClass([item objectForKey:@"send_type"]);
        vo.source = (NSString *) TBConvertNSNullClass([item objectForKey:@"source"]);
        vo.consumer_points = [NSString stringWithFormat:@"%@",[item objectForKey:@"consumer_points" convertNSNullToNil:YES]];
        NSNumber *usestatus = (NSNumber *) TBConvertNSNullClass([item objectForKey:@"use_status"]);
        if (usestatus)
            vo.use_status = [usestatus intValue];
        vo.draw_time = (NSString *) TBConvertNSNullClass([item objectForKey:@"draw_time"]);
        vo.createTime = [item objectForKey:@"create_time" convertNSNullToNil:YES];
        vo.resource_uri = [item objectForKey:@"resource_uri" convertNSNullToNil:YES];
        [retArr addObject:vo];

    }
    return retArr;
}

- (TBScoreExchangeRecordVo *)convertToScoreExchangeVoDetail:(NSDictionary *)item {
    TBScoreExchangeRecordVo *vo = [[TBScoreExchangeRecordVo alloc] init];
    NSNumber *numberId = (NSNumber *) TBConvertNSNullClass([item objectForKey:@"id"]);
    if (numberId) {
        vo.recordId = [numberId stringValue];
    } else
        vo.recordId = nil;
    //vo.recordId = [item objectForKey:@"id"];
    vo.name = (NSString *) TBConvertNSNullClass([item objectForKey:@"name"]);
    vo.smalllistimage = (NSString *) TBConvertNSNullClass([item objectForKey:@"smalllistimage"]);
    vo.exchange_time = (NSString *) TBConvertNSNullClass([item objectForKey:@"exchange_time"]);
    vo.send_type = (NSString *) TBConvertNSNullClass([item objectForKey:@"send_type"]);
    NSNumber *usestatus = (NSNumber *) TBConvertNSNullClass([item objectForKey:@"use_status"]);
    if (usestatus)
        vo.use_status = [usestatus intValue];
    vo.draw_time = (NSString *) TBConvertNSNullClass([item objectForKey:@"draw_time"]);

    vo.card_number = (NSString *) TBConvertNSNullClass([item objectForKey:@"card_number"]);
    vo.consumer_points = (NSString *) TBConvertNSNullClass([item objectForKey:@"consumer_points"]);
    vo.description = (NSString *) TBConvertNSNullClass([item objectForKey:@"description"]);
    vo.instructions = (NSString *) TBConvertNSNullClass([item objectForKey:@"instructions"]);
    vo.receiver_info = (NSDictionary *) TBConvertNSNullClass([item objectForKey:@"receiver_info"]);
/*
    if (vo.receiver_info && [vo.receiver_info length] > 0) {
        NSArray *array = [vo.receiver_info componentsSeparatedByString:@";"];
        for (NSString *string in array) {
            NSArray *subAry = [string componentsSeparatedByString:@":"];
            NSString *keyString = [subAry objectAtIndex:0];
            if (keyString && [keyString isEqualToString:@"receiver_name"]) {
                vo.receiver_name = (NSString *) TBConvertNSNullClass([subAry objectAtIndex:1]);
            } else if (keyString && [keyString isEqualToString:@"receiver_address"]) {
                vo.receiver_address = (NSString *) TBConvertNSNullClass([subAry objectAtIndex:1]);
            } else if (keyString && [keyString isEqualToString:@"receiver_postcode"]) {
                vo.receiver_postcode = (NSString *) TBConvertNSNullClass([subAry objectAtIndex:1]);
            } else if (keyString && [keyString isEqualToString:@"delivery_notes"]) {
                vo.delivery_notes = (NSString *) TBConvertNSNullClass([subAry objectAtIndex:1]);
            } else if (keyString && [keyString isEqualToString:@"mobile"]) {
                vo.receiver_mobile = (NSString *) TBConvertNSNullClass([subAry objectAtIndex:1]);
            }
        }
    }
*/
    
    if (vo.receiver_info && [vo.receiver_info count] > 0){
       
        
            vo.receiver_name = (NSString *) TBConvertNSNullClass([vo.receiver_info objectForKey:@"receiver_name"]);
            vo.receiver_address = (NSString *) TBConvertNSNullClass([vo.receiver_info objectForKey:@"receiver_address"]);
            vo.receiver_postcode = (NSString *) TBConvertNSNullClass([vo.receiver_info objectForKey:@"receiver_postcode"]);
            vo.delivery_notes = (NSString *) TBConvertNSNullClass([vo.receiver_info objectForKey:@"delivery_notes"]);
            vo.receiver_mobile = (NSString *) TBConvertNSNullClass([vo.receiver_info objectForKey:@"mobile"]);
    }
    
    
    vo.mobile = (NSString *) TBConvertNSNullClass([item objectForKey:@"mobile"]);
    vo.voucher_code = (NSString *) TBConvertNSNullClass([item objectForKey:@"voucher_code"]);
    vo.voucher_expiration_time = (NSString *) TBConvertNSNullClass([item objectForKey:@"voucher_expiration_time"]);
    return vo;
}

- (NSArray *)convertToVoucherVo:(NSDictionary *)dict {
    NSArray *arr = (NSArray *) dict;//[dict objectForKey:@""];
    NSMutableArray *retArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *item in arr) {
        TBVoucherVo *vo = [[TBVoucherVo alloc] init];
        vo.voucher_value = [item objectForKey:@"voucher_value"];
        vo.voucher_expiration_time = [item objectForKey:@"voucher_expiration_time"];
        vo.description = [item objectForKey:@"description"];
        vo.title = [item objectForKey:@"title"];
        vo.image = [item objectForKey:@"image"];
        vo.max_count = [item objectForKey:@"max_count"];
        vo.vid = [item objectForKey:@"id"];
        vo.voucher_effective_time = [item objectForKey:@"voucher_effective_time"];
        vo.point_count = [item objectForKey:@"point_count"];
        [retArr addObject:vo];

    }
    return retArr;
}

NSString *ScoreShortDateString(NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd zzz"];
    NSString *targetDateString = [dateFormatter stringFromDate:date];

    NSString *timeStr = [targetDateString substringToIndex:10];

    return timeStr;
}

-(NSArray *)convertToScoreHistoory:(NSDictionary *)dict
{
    NSMutableArray *returnValue = [NSMutableArray arrayWithCapacity:10];
    NSArray *historyList = [dict objectForKey:@"score_histories"];
    for(NSDictionary *history in historyList)
    {
        TBScoreConsume *vo = [[TBScoreConsume alloc] init];
        vo.spendDescription = [history objectForKey:@"description"];
        vo.createAt = [history objectForKey:@"create_time"];
        vo.ruleId = [history objectForKey:@"rule_id"];
        vo.score = [history objectForKey:@"score"];
        vo.spendId = [history objectForKey:@"id"];
        [returnValue addObject:vo];

    }
    return returnValue;
}

-(NSArray *)convertToScoreAccount:(NSDictionary *)dict
{
    NSMutableArray *returnValue =  [NSMutableArray arrayWithCapacity:10];
    NSArray *accountList = [dict objectForKey:@"score_accounts"];
    for(NSDictionary *account in accountList)
    {
        TBScoreConsume *vo = [[TBScoreConsume alloc] init];
        vo.spendDescription = [account objectForKey:@"description"];
        vo.score = [account objectForKey:@"score"];
        vo.income = [account objectForKey:@"income"];
        NSString *expireTime = [account objectForKey:@"expire_time"];
        NSArray *expireInfo = [expireTime componentsSeparatedByString:@" "];
        if(expireInfo!=nil && expireInfo.count>0)
        {
            vo.expireDate = [expireInfo objectAtIndex:0];
        }
        else
        {
            vo.expireDate = @"";
        }
        [returnValue addObject:vo];

    }
    return returnValue;
}

- (void)voucherRedeem:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *_id = [params objectForKey:@"id"];
    NSString *num = [params objectForKey:@"num"];
    NSString *mobile = [params objectForKey:@"mobile"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/voucher/redeem?user_id=%@&id=%@&num=%@&mobile=%@", self.baseUrl, userId, _id, num, mobile];
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreVoucherRedeemMethodFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}


/**
 * 代金券列表
 */
- (void)voucherAll:(NSDictionary *)params {
    NSString *urlStr = [NSString stringWithFormat:@"%@/voucher/all", self.baseUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreVoucherAllMethodFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

/**
* 获取某个用户的积分
* @params
*   key:userId(NSString*)
*/
- (void)getScoreOfUser:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/integral/user?user_id=%@", self.baseUrl, userId];
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreGetScoreOfUserMethodFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

/**
 * 邀请好友注册返积分/代金券
 * @params
 *   key:inviter_uid(NSString*) 邀请人ID
 *   key:invitee_uid(NSString*) 被邀请人ID
 */
- (void)inviteAward:(NSDictionary *)params {
    NSString *format = [params objectForKey:@"format"];
    NSString *inviterId = [params objectForKey:@"inviterId"];
    NSString *inviteeId = [params objectForKey:@"inviteeId"];
    NSString *cityId = [params objectForKey:@"cityId"];
    NSString *trackId = [params objectForKey:@"trackId"];
    NSString *platform = [params objectForKey:@"platform"];
    NSString *product = [params objectForKey:@"product"];
    NSString *deviceId = [params objectForKey:@"deviceId"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/integral/invite_award?format=%@&platform=%@&product=%@&cityid=%@&trackid=%@&inviter_uid=%@&invitee_uid=%@&device_id=%@",
                        ScoreUrlBaseV3,format,platform, product, cityId, trackId, inviterId, inviteeId, deviceId];
    NSURL *url = [NSURL URLWithString:urlStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = AwardInviteRegister;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

/**
* 得积分
* @params
*   key:userId(NSString*)
*   key:pointKey(NSNumber*) 参照HUI800ScorePointKey
*/
- (void)addUserScore:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSNumber *pointKeyNum = [params objectForKey:@"pointKey"];
    TBScorePointKeyEnum pointKeyEnum = (TBScorePointKeyEnum) [pointKeyNum intValue];
    NSString *pointKey = nil;

    switch (pointKeyEnum) {
        case ShareSinaWeiBoScore:{}break;
        case Tuan800AppWeiXinShareScore:{}break;
        case ShareQQWeiXinScore:{
        } break;

//        case ShareSinaWeiBoScore://团800-deal新浪微博分享     tuan800-deal_sina_weibo_share
//            pointKey = @"tuan800-deal_sina_weibo_share";//@"share.sinaweibo";
//            break;
        case ShareUgcPicScore://惠800-上传图片              hui800-upload_image
            pointKey = @"hui800-upload_image";//@"share.ugc.pic";
            break;
//        case ShareQQWeiXinScore://团800-deal微信分享     tuan800-deal_weixin_share
//            pointKey = @"tuan800-deal_weixin_share";//@"share.qqweixin";
//            break;
        case ShareUgcFoodScore://惠800-上传优惠              hui800-find_preferential
            pointKey = @"hui800-find_preferential";//@"share.ugc.food";
            break;
        case ShareEmailScore://惠800-deal邮箱分享     hui800.share.email        
            pointKey = @"hui800.share.email";//@"share.email";
            break;
        case ShareSmsScore://惠800-deal短信分享     hui800-deal_sms_share  
            pointKey = @"hui800-deal_sms_share";//@"share.sms";
            break;
        case CheckInScore://惠800-签到              hui800-sign_in
            pointKey = @"hui800-sign_in";//@"checkin";
            break;
        case InviteScore:
            pointKey = @"invite";
            break;
        case ShareUgcDealScore://惠800-发现菜品              hui800-find_food
            pointKey = @"hui800-find_food";//@"share.ugc.deal";
            break;
        case Tuan800SignInScore:
            pointKey = @"tuan800-sign_in_days";
            break;
        case Tuan800AppSinaWeiboShaScore:
            pointKey = @"tuan800-app_sina_weibo_share";
            break;
        case Hui800AppSmsShareScore:
            pointKey = @"hui800-app_sms_share";
            break;
//        case Tuan800AppWeiXinShareScore:
//            pointKey = @"tuan800-app_weixin_share";
//            break;
        case Tuan800InvitedRegister:
            pointKey = @"tuan800-recommend";
            break;
        case HUI800AppEmailShareScore:
            pointKey = @"hui800-app_email_share";
            break;
        case Tuan800SellWeiXinShare:
            pointKey = @"tuan800-sell_weixin_share";
            break;
        case Tuan800SellSinaWeiBoShare:
            pointKey = @"tuan800-sell_sina_weibo_share";
            break;
        case Tao800SignInSina:
            pointKey = @"tao800-sign_in_sina";
            break;
        case Tao800DealShare:
            pointKey = @"tao800-deal_share";
            break;
        case Tao800InvitedRegister:
            pointKey = @"tao800-Invited_register";
            break;
    }
    if (pointKey) {
        NSString *idString = [params objectForKey:@"appId"];
        NSString *deviceId = [params objectForKey:@"deviceId"];
        NSString *macAddress = [params objectForKey:@"macAddress"];
        NSString *idfa = [params objectForKey:@"fdid"];
        NSString *openudid = [params objectForKey:@"openudid"];
        NSString *cityid = [params objectForKey:@"cityId"];
        NSString *osversion = [params objectForKey:@"osversion"];
        NSString *trackid = [params objectForKey:@"partner"];
        NSString *plarform = [params objectForKey:@"plarform"];
        NSString *product = [params objectForKey:@"product"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/recommendv2/downloadApp?id=%@&user_id=%@&deviceid=%@&mac=%@&idfa=%@&openudid=%@&platform=%@&product=%@&cityid=%@&osversion=%@&trackid=%@",
                            self.baseUrl,idString,userId,deviceId,macAddress,idfa,openudid,plarform,product,cityid,osversion,trackid];
        NSURL *url = [NSURL URLWithString:urlStr];
        TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
        request.delegate = self;
        request.serviceMethodFlag = ScoreAddUserScoreMethodFlag;
        request.allowCompressedResponse = YES;
        request.requestMethod = @"GET";
        request.serviceData = params;
        [self send:request];
    }
}

/**
 * 积分消耗
 * @params
 *    key:userId(NSString*)
 *    key:queryType:(NSNumber*) 参照HUI800ScoreSpendQueryType
 *    key:startTime:(NSDate*) 可选
 *    key:endTime:(NSDate*)　可选
 */
- (void)billScore:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSNumber *queryTypeNum = [params objectForKey:@"queryType"];
    NSDate *startDate = [params objectForKey:@"startTime"];
    NSDate *endDate = [params objectForKey:@"endTime"];
    NSString *pageNum = [params objectForKey:@"pageNum"];
    NSString *pageSize = [params objectForKey:@"pageSize"];
    TBScoreSpendEnum spendEnum = (TBScoreSpendEnum) [queryTypeNum intValue];
    NSString *queryType = nil;
    switch (spendEnum) {

        case AllScore:
            queryType = @"all";
            break;
        case Reduce:
            queryType = @"reduce";
            break;
        case Add:
            queryType = @"add";
            break;
    }

    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/integral/bill?", self.baseUrl];
    [paramStr appendFormat:@"&user_id=%@", userId];
    [paramStr appendFormat:@"&query_type=%@", queryType];

    if (pageNum) {
        [paramStr appendFormat:@"&page=%@", pageNum];
    }
    if (pageSize) {
        [paramStr appendFormat:@"&per_page=%@", pageSize];
    }
    if (startDate) {
        NSString *start = ScoreShortDateString(startDate);
        [paramStr appendFormat:@"&start_time=%@", start];
    }
    if (endDate) {
        NSString *end = ScoreShortDateString(endDate);
        [paramStr appendFormat:@"&end_time=%@", end];
    }
    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreBillScoreMethodFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

- (void)scoreExchangeRecord:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *nextUrl = [params objectForKey:@"nextUrl"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];

    if (nextUrl) {
        [paramStr appendFormat:@"%@%@", self.baseUrl, nextUrl];
    } else {
        [paramStr appendFormat:@"%@/integral/api/pointmall/PointMallExchangeRecord/?format=json", self.baseUrl];
        [paramStr appendFormat:@"&user_id=%@", userId];
    }

    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreExchangeRecordFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];

}

- (void)scoreExchangeRecordDetail:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *recordId = [params objectForKey:@"recordId"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/integral/api/pointmall/PointMallExchangeRecord/%@/?format=json", self.baseUrl, recordId];
    [paramStr appendFormat:@"&user_id=%@", userId];

    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreExchangeRecordDetailFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];

}

- (void)awardExchangeRecordAddReceiverInfo:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *enable = [params objectForKey:@"enable"];
    NSString *recordId = [params objectForKey:@"recordId"];
    NSString *mobile = [params objectForKey:@"mobile"];
    NSString *postcode = [params objectForKey:@"receiver_postcode"];
    NSString *address = [params objectForKey:@"receiver_address"];
    NSString *receiver_name = [params objectForKey:@"receiver_name"];

    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/integral/api/lottery/LotteryWinRecord/%@/?format=json", self.baseUrl, recordId];
    [paramStr appendFormat:@"&user_id=%@", userId];

    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = AwardExchangeRecordAddReceiverInfo;
    request.allowCompressedResponse = YES;
    request.serviceData = params;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSDictionary *dict1 = nil;
    if (enable) {
        dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                               enable, @"enable", nil];
        [dict setObject:dict1 forKey:@"enable"];
    }else{
        dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                               mobile, @"mobile",
                               postcode, @"receiver_postcode",
                               address, @"receiver_address",
                               receiver_name, @"receiver_name", nil];
        [dict setObject:dict1 forKey:@"receiver_info"];
    }
    [request setRequestMethod:@"PUT"];
//    [request addRequestHeader:@"Accept" value:@"application/json"];
//    [request addRequestHeader:@"content-type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    NSString *jsonStr = [dict JSONString:NO];
    NSData *dataA = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *data = [NSMutableData dataWithData:dataA];
    [request setPostBody:data];

    [self send:request];

}


//抽奖纪录
- (void)AwardExchangeRecord:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *nextUrl = [params objectForKey:@"nextUrl"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];

    if (nextUrl) {
        [paramStr appendFormat:@"%@%@", self.baseUrl, nextUrl];
    } else {
        [paramStr appendFormat:@"%@/integral/api/lottery/LotteryWinRecord/?format=json", self.baseUrl];
        [paramStr appendFormat:@"&user_id=%@", userId];
    }

    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = AwardExchangeRecordFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];

}

//抽奖纪录详情
- (void)AwardExchangeRecordDetail:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSString *recordId = [params objectForKey:@"recordId"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/integral/api/lottery/LotteryWinRecord/%@/?format=json", self.baseUrl, recordId];
    [paramStr appendFormat:@"&user_id=%@", userId];

    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = AwardExchangeRecordDetailFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}


/**积分攻略
 * @params
 *    key:product(NSString*)
 */
- (void)spendScore:(NSDictionary *)params {
    NSString *product = [params objectForKey:@"product"];
    NSString *version = [params objectForKey:@"version"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/integral/rule?product=%@", self.baseUrl, product];
    if (version && [version length]>0) {
       [paramStr appendFormat:@"&version=%@",version];
    }
    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreSpendScoreMethodFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

//获取用户今日执行的积分任务
- (void)scoreTaskToday:(NSDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/integral/today?user_id=%@", self.baseUrl, userId];
    NSURL *url = [NSURL URLWithString:paramStr];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = ScoreSpendTaskTodayFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

/**
 * 获取用户历史积分明细
 */
- (void)getScoreHistory:(NSDictionary *)params;
{
    NSString *pageNum = [params objectForKey:@"pageNum"];
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *type = [params objectForKey:@"type"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/mobile_api/v3/score_histories?page=%@&per_page=%@&type=%@", ScoreUrlBaseV3, pageNum, pageSize, type];
    
    //判断是否是sso跳转方式
    NSMutableString *urlString = [NSMutableString stringWithCapacity:255];
    NSString *ssoUrl = [params objectForKey:@"ssoUrl"];
    if (ssoUrl && ![ssoUrl isEqualToString:@""]) {
        NSString *temp = [paramStr encoded]; // URL编码转码
        [urlString appendFormat:@"%@?return_to=%@",ssoUrl,temp];
    }else {
        [urlString appendString:paramStr];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.serviceMethodFlag = GetScoreHistoryFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

/**
 * 获取用户的积分帐户
 */
- (void)getScoreAccount:(NSDictionary *)params
{
    NSString *pageNum = [params objectForKey:@"pageNum"];
    NSString *pageSize = [params objectForKey:@"pageSize"];
    NSString *type = [params objectForKey:@"type"];
    NSMutableString *paramStr = [NSMutableString stringWithCapacity:100];
    [paramStr appendFormat:@"%@/mobile_api/v3/score_accounts?page=%@&per_page=%@&type=%@", @"http://api.tuan800.com", pageNum, pageSize, type];
    
    //判断是否是sso跳转方式
    NSMutableString *urlString = [NSMutableString stringWithCapacity:255];
    NSString *ssoUrl = [params objectForKey:@"ssoUrl"];
    if (ssoUrl && ![ssoUrl isEqualToString:@""]) {
        NSString *temp = [paramStr encoded]; // URL编码转码
        [urlString appendFormat:@"%@?return_to=%@",ssoUrl,temp];
    }else {
        [urlString appendString:paramStr];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    TBASIFormDataRequest *request = [TBASIFormDataRequest requestWithURL:url];

    if ([urlString hasPrefix:@"https"]) {
        NSData *cerFile1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pass" ofType:@"cer"]];
        NSData *cerFile2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sso" ofType:@"cer"]];

        SecCertificateRef cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile1);
        SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile2);

        NSArray *array;
        array = @[(__bridge id) cert1,
                    (__bridge id) cert2];

        CFRelease(cert1);
        CFRelease(cert2);

        [request setClientCertificates:array];
        [request setValidatesSecureCertificate:YES];
    }

    request.delegate = self;
    request.serviceMethodFlag = GetScoreAccountFlag;
    request.allowCompressedResponse = YES;
    request.requestMethod = @"GET";
    request.serviceData = params;
    [self send:request];
}

- (void)requestFinished:(TBASIFormDataRequest *)request {
    BOOL isResponseNetworkError = [self isResponseDidNetworkError:request];
    if (isResponseNetworkError) {
        //不做处理，由 viewController捕获处理, 不再执行后续解析代码
        ASIDownloadCache *sharedCache = [ASIDownloadCache sharedCache];
        [sharedCache removeCachedDataForURL:request.url];
        return;
    }
    NSString *dataStr = [request responseString];

    dataStr = [dataStr trim];
    NSDictionary *dict = nil;
    @try {
        dict = [dataStr JSONValue];
    }
    @catch (NSException *exception) {
        dict = [NSDictionary dictionary];
    }
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }

    SEL sel = nil;
    NSObject *finishObj = dict;

    switch (request.serviceMethodFlag) {

        case ScoreGetScoreOfUserMethodFlag: {
            sel = @selector(getScoreOfUserFinish:);

        }
            break;
        case ScoreAddUserScoreMethodFlag: {
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:dict, @"result", request.serviceData, @"params", nil];
            sel = @selector(addUserScoreFinish:);

        }
            break;
        case AwardInviteRegister: {
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:dict, @"result", request.serviceData, @"params", nil];
            sel = @selector(inviteAwardFinish:);
            
        }
            break;
        case ScoreSpendScoreMethodFlag: {
            NSArray *items = [self convertToSpendScoreVo:dict];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:items, @"items", nil];
            sel = @selector(spendScoreFinish:);

        }
            break;
        case ScoreBillScoreMethodFlag: {
            NSDictionary *scoreHistories = [dict objectForKey:@"score_histories"];
            NSArray *items = [self convertToSpendScoreVo:scoreHistories];
            NSString *status = [dict objectForKey:@"status"];
            NSString *totalScoreHistories = [dict objectForKey:@"total_score_histories"];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:items, @"items", status, @"status", totalScoreHistories, @"total_score_histories", nil];
            sel = @selector(billScoreFinish:);
        }
            break;
        case ScoreVoucherRedeemMethodFlag: {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSArray *codeArr = [data objectForKey:@"code"];
            NSString *status = [dict objectForKey:@"status"];
            NSString *endTime = [dict objectForKey:@"endTime"];
            NSString *result = [dict objectForKey:@"result"];
            NSMutableDictionary *finishDic = [NSMutableDictionary dictionaryWithCapacity:2]; //[NSDictionary dictionaryWithObjectsAndKeys:codeArr, @"code",status,@"status",endTime,@"endTime",result,@"result", nil];
            if (codeArr) {
                [finishDic setObject:codeArr forKey:@"code"];
            }
            if (status) {
                [finishDic setObject:status forKey:@"status"];
            }
            if (endTime) {
                [finishDic setObject:endTime forKey:@"endTime"];
            }
            if (result) {
                [finishDic setObject:result forKey:@"result"];
            }

            finishObj = finishDic;
            sel = @selector(scoreVoucherRedeemFinish:);
        }
            break;

        case ScoreExchangeRecordFlag: {
            NSDictionary *meta = [dict objectForKey:@"meta"];
            NSArray *objArr = [dict objectForKey:@"objects"];
            NSArray *items = [self convertToScoreExchangeVo:objArr];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:
                         items, @"items",
                         meta, @"meta",
                         nil];
            sel = @selector(scoreExchangeRecordFinish:);
        }
            break;
        case ScoreExchangeRecordDetailFlag: {
            TBScoreExchangeRecordVo *vo = nil;
            //finishObj = vo;
            if (dict && [dict count] > 0) {
                vo = [self convertToScoreExchangeVoDetail:dict];
                finishObj = [NSDictionary dictionaryWithObjectsAndKeys:vo, @"items", nil];
            }
            sel = @selector(scoreExchangeRecordDetailFinish:);
        }
            break;
        case AwardExchangeRecordAddReceiverInfo: {
            TBScoreExchangeRecordVo *vo = nil;
            //finishObj = vo;
            if (dict && [dict count] > 0) {
                vo = [self convertToScoreExchangeVoDetail:dict];
                finishObj = [NSDictionary dictionaryWithObjectsAndKeys:vo, @"items", nil];
            }
            sel = @selector(awardExchangeRecordAddReceiverInfoFinish:);
            break;
        }

        case AwardExchangeRecordFlag: {
            NSDictionary *meta = [dict objectForKey:@"meta"];
            NSArray *objArr = [dict objectForKey:@"objects"];
            NSArray *items = [self convertToScoreExchangeVo:objArr];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:
                    items, @"items",
                    meta, @"meta",
                    nil];
            sel = @selector(AwardExchangeRecordFinish:);
        }
            break;

        case AwardExchangeRecordDetailFlag: {
            TBScoreExchangeRecordVo *vo = nil;
            //finishObj = vo;
            if (dict && [dict count] > 0) {
                vo = [self convertToScoreExchangeVoDetail:dict];
                finishObj = [NSDictionary dictionaryWithObjectsAndKeys:vo, @"items", nil];
            }
            sel = @selector(AwardExchangeRecordDetailFinish:);
        }
            break;

        case ScoreVoucherAllMethodFlag: {
            NSArray *items = [self convertToVoucherVo:dict];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:items, @"items", nil];
            sel = @selector(scoreVoucherAllFinish:);
        }
            break;

        case ScoreSpendTaskTodayFlag: {
            sel = @selector(scoreTaskTodayFinish:);
        }
            break;
        case GetScoreHistoryFlag: {
            NSArray *items = [self convertToScoreHistoory: dict];
            NSNumber *score = [dict objectForKey:@"score"];
            NSNumber *hasNext = [dict objectForKey:@"has_next"];
            finishObj = [NSDictionary dictionaryWithObjectsAndKeys:items, @"items", score, @"score", hasNext, @"hasNext", nil];
            sel = @selector(getScoreHistoryFinish:);
        }
            break;
        case GetScoreAccountFlag: {
            NSMutableDictionary *finishDic = [NSMutableDictionary dictionaryWithCapacity:2];
            
            NSArray *items = [self convertToScoreAccount: dict];
            NSNumber *score = [dict objectForKey:@"score"];
            NSString *expiringTime = [dict objectForKey:@"expiring_time"];
            NSString *expiringScore = [dict objectForKey:@"expiring_score"];
            
            [finishDic setObject:items forKey:@"items"];
            
            if (score!=nil && ![score isKindOfClass:[NSNull class]]) {
                [finishDic setObject:score forKey:@"score"];
            }else {
                [finishDic setObject:@"" forKey:@"score"];
            }
            
            
            NSArray *infos = [expiringTime componentsSeparatedByString: @" "];
            if(infos!=nil && infos.count>0)
            {
                [finishDic setObject:[infos objectAtIndex:0] forKey:@"expiringTime"];
            }
            else
            {
                [finishDic setObject:@"" forKey:@"expiringTime"];
            }
            
            if (expiringTime!=nil && ![expiringTime isKindOfClass:[NSNull class]])
            {
                [finishDic setObject:expiringTime forKey:@"expiringWholeInfo"];
            }
            else
            {
                [finishDic setObject:@"" forKey:@"expiringWholeInfo"];
            }
            
            if (expiringScore!=nil && ![expiringScore isKindOfClass:[NSNull class]]) {
                [finishDic setObject:expiringScore forKey:@"expiringScore"];
            }else {
                [finishDic setObject:@"" forKey:@"expiringScore"];
            }
            
            finishObj = finishDic;
            sel = @selector(getScoreAccountFinish:);
            
        }
            break;
        default:
            break;
    }
    [super requestFinished:request];

    if (sel && self.delegate && [self.delegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:sel withObject:finishObj];
#pragma clang diagnostic pop
    }
}

- (void)dealloc {
 
}
@end