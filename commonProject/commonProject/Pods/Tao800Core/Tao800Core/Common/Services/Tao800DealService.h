//
//  Tao800DealService.h
//  universalT800
//
//  Created by enfeng on 13-10-12.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800DealService : Tao800BaseService

@property (nonatomic) BOOL enableExecuteInBackground;

/**
 * 精品预告
 * @params
 *   key: page
 *   key: per_page
 *   key: image_type
 */
- (void)getForenotices:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;


/**
 * 获取首页列表数据
 *
 * @params
 *   key: page
 *   key: per_page
 *   key: url_name todo
 *   key: cids  todo
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetDealsV2
 */
- (void)getDeals:(NSDictionary *)paramsExt
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure;

/**
 * cpc 运营专题
 * @params
 *   key: ids , 传入以逗号分隔的id  如 34423,423424,23423
 */
- (void)guangIdsDeals:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;

/*
 获取大促商品列表
 */
- (void)GetDealsOfPromotion:(NSDictionary *)paramsExt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure;


/**
 * 获取品牌团分类
 *
 * @params
 *   key: user_type  必填
 *   key: user_role  必填
 *
 * @link
 *
 */
- (void)getBrandTags:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;
/**
 * 获取品牌团商品列表
 *
 * @params
 *   key: page
 *   key: per_page
 *   key: brand_id
 *   key: url_name
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetDealsOfBrand
 *
 */
- (void)getBrandDeals:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取品牌团品牌列表
 *
 * @params
 *   key: page
 *   key: per_page
 *
 * @link
 *
 */
//最新上线
- (void)getTodayBrand:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;
//昨日上新
- (void)getYesterdayBrand:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;
//最后疯抢
- (void)getLastBrand:(NSDictionary *)paramsExt
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;
//分类
- (void)getBrand:(NSDictionary *)paramsExt
      completion:(void (^)(NSDictionary *))completion
         failure:(void (^)(TBErrorDescription *))failure;


/**
 * 获取手机周边数据
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetDealsOfMobile
 */
- (void)getMobileDeals:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

/**
 * 收藏Deal
 *
 *
 * @link http://wrd.tuan800-inc.com/mywiki/AddFavorites
 */
- (void)addFavoriteDeal:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

/**
 * 删除deal收藏
 *
 * @link http://wrd.tuan800-inc.com/mywiki/RemoveFavorites
 */
- (void)deleteFavoriteDeal:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取deal收藏
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetFavoritesList
 */
- (void)getFavoriteDeals:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取deal收藏
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetFavoritesList
 */
- (void)getFavoriteDealIds:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 * 收藏Deal
 *
 * @link http://wrd.tuan800-inc.com/mywiki/AddConcernsShop
 */
- (void)addFavoriteShop:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

/**
 * 删除shop收藏
 *
 * @link http://wrd.tuan800-inc.com/mywiki/RemoveConcernsShop
 */
- (void)deleteFavoriteShop:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取shop收藏
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetConcernsShopList
 */
- (void)getFavoriteShops:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取shop收藏
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetConcernsShopList
 */
- (void)getFavoriteShopIds:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 *获取我的抽奖
 *
 *@link http://wrd.tuan800-inc.com/mywiki/GetMyLotteryList
 */
- (void)getMyLuckyDrawList:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;


/**
 *获取我的抽奖详情页面
 *
 *@link http://wrd.tuan800-inc.com/mywiki/GetMyLotteryDetail
 */
- (void)getMyLuckyDrawDetail:(NSDictionary *)paramsExt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure;

/**
 *获取我的抽奖详情页查看我的抽奖码
 *
 *@link http://wiki.tuan800-inc.com/pages/viewpage.action?pageId=2636421
 */
- (void)getMyLuckyDrawDetailMyCode:(NSDictionary *)paramsExt
                  completion:(void (^)(NSDictionary *))completion
                     failure:(void (^)(TBErrorDescription *))failure;

/**
 *获取我的抽奖详情页晒单页
 *
 *@link http://wiki.tuan800-inc.com/pages/viewpage.action?pageId=2636421
 */
- (void)getMyLuckyDrawDetailShowPage:(NSDictionary *)paramsExt
                        completion:(void (^)(NSDictionary *))completion
                           failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取搜索建议
 */
- (void)getSearchSuggestion:(NSDictionary *)paramsExt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取值得逛商品列表
 * @params
 *   key: image_type 表示图片类型(all--所有图片类型，big--大图,normal--标准图，small--小图)
 *   key: page 表示页码 (默认1)
 *   key: per_page 表示每页显示数量 (默认20)
 *   key: tag_url 分类关键字 （值得逛分类列表传入）
 * @link http://wrd.tuan800-inc.com/mywiki/GetProductOfZhiV2
 */
- (void)getSaunterList:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failue;

/**
 * 获取搜索商品列表。
 */
- (void)getSearchDeals:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

- (void)getNewSearchDeals:(NSDictionary *)params
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取推荐商品列表。
 */
- (void)getRecommendDeals:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取商品详情列表。
 */
- (void)getDealDetails:(NSDictionary *)paramsExt
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;


/**
 * 获取折800商品的分类信息列表。(仅仅排序用)
 
 user_type
 必填
 表示新老用户类型
 取值范围：0--新用户；1--老用户
 
 user_role
 可选
 表示用户身份类型
 取值范围：1--男；2--有为青年；3--大叔；4--女；5--潮女；6--辣妈
 
 */
- (void)getCategoryTags:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取首页推荐分类
 * @params
 *   key: user_role 1--男；2--有为青年；3--大叔；4--女；5--潮女；6--辣妈
 *   key: device_id 表示设备号
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetTagsOfRecommend
 */
- (void)getTagsOfRecommend:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

/**
 *
 * @link http://wrd.tuan800-inc.com/mywiki/GetCid
 */
- (void)getCid:(NSDictionary *)paramsExt
    completion:(void (^)(NSDictionary *))completion
       failure:(void (^)(TBErrorDescription *))failure;

/**
 * 开卖提醒订阅统计。
 */
- (void)addDealSubscribe:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

/**
 * 充值手机纪录查询。
 * @params
 *   key: userId        用户id
 *   key: access_token  passport的access_token
 *   key: page          第几页, 默认为1
 *   key: pageSize      每页记录数, 默认为10
 *   key: mobile        wap无登陆时使用
 *   key: verifyCode    用户收到的验证码
 *
 */
- (void)getMobileRecordList:(NSDictionary *)paramsExt
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure;
/**
 * 获取手机充值面额列表。
 */
- (void)getMobileRechargeDeals:(NSDictionary *)paramsExt
                    completion:(void (^)(NSDictionary *))completion
                       failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取手机充值面额详情。
 */
- (void)getMobileRechargeDetail:(NSDictionary *)paramsExt
                     completion:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure;


/**
 * 获取首页5模块信息。
 */
- (void)getHomePageOperationInfo:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取大促首页大促商品专场信息。
 * @params
 *   key: user_type         0--新用户；1--老用户                                   必传
 *   key: user_role         1--男；2--有为青年；3--大叔；4--女；5--潮女；6--辣妈      必传
 *   key: student           表示学生身份 1--是；0--否；不传则默认为0                  非必传
 *  @link http://wiki.tuan800-inc.com/pages/viewpage.action?pageId=2632282
 */
- (void)getPromotionHomePageOperationInfo:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure;


/*
 *获取每日10件列表
 */
- (void)getDailyTen:(NSDictionary *)paramsExt
         completion:(void (^)(NSDictionary *))completion
            failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取值得逛分类列表
 * @params  nil
 */
- (void)getSaunterAllCategory:(NSDictionary *)paramsExt
                   completion:(void (^)(NSDictionary *))completion
                      failure:(void (^)(TBErrorDescription *))failue;

/**
 * 获取值得逛分类列表
 * @params  nil
 * @link http://wrd.tuan800-inc.com/mywiki/GetGuangRecommendCategory
 */
-(void)getSaunterDisplayCategory:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure;

/**
 * 获取校园专区商品列表
 */
-(void)getCampusProducts:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;


//心愿单保存
-(void)getHeartWishCreate:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;

//心愿单删除
-(void)getHeartWishDelete:(NSDictionary *)paramsExt
               completion:(void (^)(NSDictionary *))completion
                  failure:(void (^)(TBErrorDescription *))failure;

//心愿单列表
-(void)getHeartWishList:(NSDictionary *)paramsExt
             completion:(void (^)(NSDictionary *))completion
                failure:(void (^)(TBErrorDescription *))failure;

//查询是否有心愿单达成
-(void)getHeartWishReached:(NSDictionary *)paramsExt
                completion:(void (^)(NSDictionary *))completion
                   failure:(void (^)(TBErrorDescription *))failure;

//心愿单保存
-(void)getHeartWishCreateAllWish:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure;

-(void)getHeartWishDeleteAllWish:(NSDictionary *)paramsExt
                      completion:(void (^)(NSDictionary *))completion
                         failure:(void (^)(TBErrorDescription *))failure;
/**
 *封装deal
 **/
- (NSMutableArray *)wrapperDeals:(NSDictionary *)dict;

/**
 *封装tag
 **/
- (NSArray *)wrapperTags:(NSArray *)tags;

/**
 * @params
 *   key: ids 用","将deal id连接起来
 *   key: 不传则为1；取值范围：1--显示已卖光商品，0--不显示已卖光商品
 */
- (void)getDealsByIds:(NSDictionary *)paramsExt
           completion:(void (^)(NSDictionary *))completion
              failure:(void (^)(TBErrorDescription *))failure;

@end
