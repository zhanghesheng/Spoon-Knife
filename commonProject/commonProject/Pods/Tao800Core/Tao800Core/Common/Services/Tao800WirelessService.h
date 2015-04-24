//
//  Tao800WirelessService.h
//  universalT800
//  无线后台接口
//  Created by enfeng on 13-10-12.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800WirelessService : Tao800BaseService

/**
* 获取首页banner
* @params
*   key: cityid
*   key: channelid
*   key: url_name
*/
- (void)getBanners:(NSDictionary *)paramsExt
        completion:(void (^)(NSDictionary *))completion
           failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取值得逛分类列表
 * @params  nil
 */
- (void)getSaunterCategory:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failue;

/**
 * 获取热门活动列表
 * @params  nil
 *   key: platform      表示客户端请求的来源平台    iphone
 *   key: channelid     表示渠道ID               all--全部渠道
 *   key: pagetype      表示活动展示类型   0--热门活动，1--签到活动;2--逛分类页面；3--注册引导页面;4--固定专题页面；5--校园特供页面；6--热门活动页面
 *   key: cityid        表示城市ID               0--全国
 *   key: userType      表示新老用户              0--新用户；1--老用户
 *   key: userRole      表示用户身份              1--男；2--有为青年；3--大叔；4--女；5--潮女；6--辣妈
 */
- (void)getHotActivityList:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failue;

/*
 *获取全局配置
 *
 * @params
 *   key: platform  表示客户端请求的来源平台 iPhone
 *   key: product   表示客户端产品类别
 *   key: trackid   表示渠道id
 *   key: cityid
 *   key: mode  mode=1时,top、hottopic、payment、banner的数据不返回，
 *              增加返回今日新单数量：today_order_count；mode不传或为其它值时，
 *              除“今日新单数量”外所有字段数据均返回，
 *   key: imgModel
 *
 *  @link http://wrd.tuan800-inc.com/mywiki/CheckConfig
 */
- (void)getConfigs:(NSDictionary *)paramsExt
       completioin:(void (^)(NSDictionary *))completion
            failue:(void (^)(TBErrorDescription *))failure;

/*
 *获取新的全局配置
 *
 * @params
 *   key: keys      表示配置数据的key,可多个，以","分割   例如：tao800.invitefriends.switch,tao800.im.switch.phone
 *   key: platform  表示客户端请求的来源平台 iPhone
 *   key: product   表示客户端产品类别
 *   key: trackid   表示渠道id
 *   key: version   表示版本号
 *   key: minversion 表示子版本号
 *
 *  @link http://wrd.tuan800-inc.com/mywiki/CheckConfig
 */
- (void)getNewConfigs:(NSDictionary *)paramsExt
       completioin:(void (^)(NSDictionary *))completion
            failue:(void (^)(TBErrorDescription *))failure;

/**
 * 获取淘宝url过滤策略
*/
- (void)getTaoBaoURLFilterStrategy:(NSDictionary *)paramsExt
                       completioin:(void (^)(NSDictionary *))completion
                            failue:(void (^)(TBErrorDescription *))failure;

/**
 *  获取启动页信息,开机启动图和开机滑动大图
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetBannerOfStart
*/
- (void)getBannersOfStart:(NSDictionary *)paramsExt
              completioin:(void (^)(NSDictionary *))completion
                   failue:(void (^)(TBErrorDescription *))failure;


/*
  得到积分规则，传入参数是
 */
- (void)getCheckInRules:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                 failue:(void (^)(TBErrorDescription *))failure;


/*
 获取大促信息
 */
- (void)getPromotionItem:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

/*
 获取首页早9晚8
 */
- (void)getZaoJiuWanBa:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

/*
 上传心愿词
 */
- (void)uploadWishWord:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

-(void)testSSOZhe800:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
                failue:(void (^)(TBErrorDescription *))failure;

-(void)getIpAddress:(NSDictionary *)params
         completion:(void(^)(NSDictionary * resultDic))completion
            failure:(void(^)(TBErrorDescription * error))failure;

/**
* 获取社会化分享内容
*
* @params
*     key: share_type
*
* @link http://wrd.tuan800-inc.com/mywiki/GetSocialShareContent
*/
- (void)getSocialShareContent:(NSDictionary *)params
                   completion:(void (^)(NSDictionary *resultDic))completion
                      failure:(void (^)(TBErrorDescription *error))failure;


//上传错误日志
- (void)uploadErrorInfo:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

//虚拟试衣首页入口 有就显示
-(void)getVirtualFittingEntrance:(NSDictionary *)params
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failue;
@end
