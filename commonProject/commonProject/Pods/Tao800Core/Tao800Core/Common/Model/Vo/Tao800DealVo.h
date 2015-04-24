//
//  Tao800DealVo.h
//  tao800
//
//  Created by enfeng yang on 12-4-19.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800ShopVo.h"
#import "Tao800ActivityVo.h"

typedef enum DealProductType {
    DealProductTypeDealUrl,
    DealProductTypeWapUrl,
    DealProductTypeCategory
} DealProductType;

typedef enum DealSaleState {
    DealSaleStateSelling,       //销售中
    DealSaleStateSellOut     //已卖光
} DealSaleState;

typedef enum ShopType {
    ShopTypeDefault = -1,
    ShopTypeTianMao = 1,
    ShopTypeTaoBao =0
}ShopType;

typedef NS_ENUM(NSInteger , Tao800DealSourceType) {
    Tao800DealSourceTypeMall = 1,
    Tao800DealSourceTypeTaoBao = 0
};

@interface Tao800DealVo : NSObject <NSCoding> {
    int _dealId;                //主键id
    NSString *_title;             //标题
//    int             _expireStatus;      //类型
    NSString *_beginTime;        //开始时间
    NSString *_expireTime;       //过期时间
    NSString *_dealUrl;          //目标链接url
    int _listPrice;         //原价（单位为分）
    int _price;              //现价（单位为分）
    DealSaleState _oos;                //在售状态（oos是out of stock的简称）. 0代表在售，1代表已售完
    int _recommendedById;    //推荐人名称 ID
    NSString *_recommendReason;  //推荐理由

    NSString *_normalImageUrl;         //普通图片url
    NSString *_bigImageUrl;            //大图片url
    NSString *_smallImageUrl;          //小图片url
    NSString *_hd1ImageUrl;            //高清1图片url (用于新大图模式)
    NSString *_hd2ImageUrl;            //高清2图片url (用于新大图模式，网络是2G情况的下)

    NSString *_hotLabel;
    NSString *_wapUrl;
    NSString *_urlName;     //只有product_type=2为商品分类时，该字段返回分类的url_name值，通过其查询分类产品
    DealProductType _productType;   //代表页面的跳转类型  0--dealUrl; 1--wapUrl; 2--商品分类
    NSNumber *_vip; // 是否是淘宝vip商品

    BOOL _isTodayDeal; // 是否是今日精选商品
    BOOL _isZhiDeGuangDeal; // 是否是值得逛商品

    BOOL _isBaoyou; // 是否包邮
    BOOL _isFanjifen; // 是否反积分
    BOOL _isHuiyuangou; // 是否会员购
    BOOL _isZhuanxiang; // 是否手机专享

    Tao800ShopVo *_shopVo; //店铺信息

    NSString *_dealDescTopTip;
    BOOL _isMoreDeal;
    NSString *_moreDealImageUrl; //最后一页的图片地址

    Tao800ActivityVo *_activityVo; // 活动vo
    NSString *_shareUrl;  // 用于分享的url
    
    int _pictureWidth;//瀑布流图片宽度
    int _pictureHeight;//瀑布流图片高度
    int _tagID;//商品分类id
    BOOL _today; //是否今日新单；0--不是；1--是
    BOOL _mobilePriviliege; //是否是手机专享 0--不是；1--是
    
    NSString* _image_share;//分享用图片
    NSString* _detail_url;//详情用到
    NSMutableDictionary *_scores;//显示返积分用到
}

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *beginTime;
@property(nonatomic, strong) NSString *expireTime;
@property(nonatomic, strong) NSString *dealUrl;
@property(nonatomic, strong) NSString *recommendReason;
@property(nonatomic, assign) int recommendedById;
@property(nonatomic, assign) DealSaleState oos;
@property(nonatomic, assign) int listPrice;
@property(nonatomic, assign) int price;
@property(nonatomic, assign) int dealId;
@property(nonatomic, strong) NSString *normalImageUrl;
@property(nonatomic, strong) NSString *smallImageUrl;
@property(nonatomic, strong) NSString *bigImageUrl;
@property(nonatomic, strong) NSString *hd1ImageUrl;
@property(nonatomic, strong) NSString *hd2ImageUrl;
@property(nonatomic, strong) NSString *hd3ImageUrl;
@property(nonatomic, strong) NSString *hd4ImageUrl;
@property(nonatomic, strong) NSString *hd5ImageUrl;
@property(nonatomic, strong) NSString *hotLabel;
@property(nonatomic, strong) NSString *urlName;
@property(nonatomic, strong) NSString *wapUrl;
@property(nonatomic) DealProductType productType;
@property(nonatomic, strong) NSNumber *vip;
@property(nonatomic, assign) BOOL isTodayDeal;
@property(nonatomic, assign) BOOL isZhiDeGuangDeal;
@property(nonatomic, assign) BOOL isBaoyou;
@property(nonatomic, assign) BOOL isFanjifen;
@property(nonatomic, assign) BOOL isHuiyuangou;
@property(nonatomic, assign) BOOL isZhuanxiang;
@property(nonatomic, strong) Tao800ShopVo *shopVo;
@property(nonatomic, strong) NSString *dealDescTopTip;
@property(nonatomic, assign) BOOL isMoreDeal;
@property(nonatomic, strong) NSString *moreDealImageUrl;
@property(nonatomic, strong) Tao800ActivityVo *activityVo;
@property(nonatomic, strong) NSString *shareUrl;
@property(nonatomic, assign) int pictureWidth;
@property(nonatomic, assign) int pictureHeight;
@property(nonatomic, assign) int tagID;
@property (nonatomic, assign) BOOL today;
@property (nonatomic, assign) BOOL promotion; //true--拍下立减, false--不减
@property (nonatomic, copy) NSString * shortTitle;
@property (nonatomic, assign) BOOL mobilePriviliege;
@property (nonatomic, copy) NSString * detailUrl; //我们自己的wap
@property (nonatomic, assign) ShopType shopType;
@property(nonatomic, copy) NSString *imageShareUrl;  //用于分享，该图片为jpg格式，其他图片将会采用webp
//大促用到
@property (nonatomic, strong) NSString *image_share;
@property (nonatomic, strong) NSString *detail_url;
@property (nonatomic, strong) NSMutableDictionary *scores;//商品积分 "scores":{"z0":0,"z1":10,"z2":20,"z3":30,"z4":40}
//商城商品
@property(nonatomic, copy)NSString *zId;//商城商品id
@property(nonatomic, assign)Tao800DealSourceType sourceType; //用于区分商城商品与普通商品
@property(nonatomic, assign)int soldCount; //销量

+ (void)convertJSONDict:(NSDictionary *)item toDeal:(Tao800DealVo *)deal;
@end
