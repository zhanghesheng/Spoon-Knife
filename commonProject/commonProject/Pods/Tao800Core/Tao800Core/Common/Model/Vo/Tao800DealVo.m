//
//  Tao800DealVo.m
//  tao800
//
//  Created by enfeng yang on 12-4-19.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800DealVo.h"

@implementation Tao800DealVo
@synthesize title = _title;
@synthesize beginTime = _beginTime;
@synthesize expireTime = _expireTime;
@synthesize dealUrl = _dealUrl;
@synthesize recommendReason = _recommendReason;
@synthesize recommendedById = _recommendedById;
@synthesize oos = _oos;
@synthesize listPrice = _listPrice;
@synthesize price = _price;
@synthesize dealId = _dealId;
@synthesize normalImageUrl = _normalImageUrl;
@synthesize smallImageUrl = _smallImageUrl;
@synthesize bigImageUrl = _bigImageUrl;
@synthesize hd1ImageUrl = _hd1ImageUrl;
@synthesize hd2ImageUrl = _hd2ImageUrl;
@synthesize hotLabel = _hotLabel;
@synthesize urlName = _urlName;
@synthesize wapUrl = _wapUrl;
@synthesize productType = _productType;
@synthesize vip = _vip;
@synthesize isTodayDeal = _isTodayDeal;
@synthesize isZhiDeGuangDeal = _isZhiDeGuangDeal;
@synthesize isBaoyou = _isBaoyou;
@synthesize isFanjifen = _isFanjifen;
@synthesize isHuiyuangou = _isHuiyuangou;
@synthesize isZhuanxiang = _isZhuanxiang;
@synthesize shopVo = _shopVo;
@synthesize dealDescTopTip = _dealDescTopTip;
@synthesize isMoreDeal = _isMoreDeal;
@synthesize moreDealImageUrl = _moreDealImageUrl;
@synthesize activityVo = _activityVo;
@synthesize pictureHeight = _pictureHeight;
@synthesize pictureWidth = _pictureWidth;
@synthesize tagID = _tagID;
@synthesize today = _today;
@synthesize mobilePriviliege = _mobilePriviliege;
@synthesize image_share = _image_share;
@synthesize detail_url = _detail_url;
@synthesize scores = _scores;

- (void)encodeWithCoder:(NSCoder *)aCoder {

    //bool
    [aCoder encodeBool:self.isTodayDeal forKey:@"isTodayDeal"];
    [aCoder encodeBool:self.isZhiDeGuangDeal forKey:@"isZhiDeGuangDeal"];
    [aCoder encodeBool:self.isBaoyou forKey:@"isBaoyou"];
    [aCoder encodeBool:self.isFanjifen forKey:@"isFanjifen"];
    [aCoder encodeBool:self.isHuiyuangou forKey:@"isHuiyuangou"];
    [aCoder encodeBool:self.isZhuanxiang forKey:@"isZhuanxiang"];
    [aCoder encodeBool:self.today forKey:@"today"];
    [aCoder encodeBool:self.promotion forKey:@"promotion"];

    //NSString && NSNumber
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.beginTime forKey:@"beginTime"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];
    [aCoder encodeObject:self.normalImageUrl forKey:@"normalImageUrl"];
    [aCoder encodeObject:self.dealUrl forKey:@"dealUrl"];
    [aCoder encodeObject:self.recommendReason forKey:@"recommendReason"];
    [aCoder encodeObject:self.bigImageUrl forKey:@"bigImageUrl"];
    [aCoder encodeObject:self.smallImageUrl forKey:@"smallImageUrl"];
    [aCoder encodeObject:self.hd1ImageUrl forKey:@"hd1ImageUrl"];
    [aCoder encodeObject:self.hd2ImageUrl forKey:@"hd2ImageUrl"];
    [aCoder encodeObject:self.hotLabel forKey:@"hotLabel"];
    [aCoder encodeObject:self.wapUrl forKey:@"wapUrl"];
    [aCoder encodeObject:self.urlName forKey:@"urlName"];
    [aCoder encodeObject:self.vip forKey:@"vip"];
    [aCoder encodeObject:self.shopVo forKey:@"shopVo"];
    [aCoder encodeObject:self.shortTitle forKey:@"shortTitle"];
    [aCoder encodeObject:self.hd3ImageUrl forKey:@"hd3ImageUrl"];
    [aCoder encodeObject:self.hd4ImageUrl forKey:@"hd4ImageUrl"];
    [aCoder encodeObject:self.hd5ImageUrl forKey:@"hd5ImageUrl"];
    [aCoder encodeObject:self.imageShareUrl forKey:@"imageShareUrl"];
    [aCoder encodeObject:self.detailUrl forKey:@"detailUrl"];


    //int
    [aCoder encodeInt:self.dealId forKey:@"dealId"];
    [aCoder encodeInt:self.listPrice forKey:@"listPrice"];
    [aCoder encodeInt:self.price forKey:@"price"];
    [aCoder encodeInt:self.recommendedById forKey:@"recommendedById"];
    [aCoder encodeInt:self.oos forKey:@"oos"];
    [aCoder encodeInt:self.productType forKey:@"productType"];
    [aCoder encodeObject:self.dealDescTopTip forKey:@"dealDescTopTip"];
    [aCoder encodeInt:self.pictureWidth forKey:@"pictureWidth"];
    [aCoder encodeInt:self.pictureHeight forKey:@"pictureHeight"];
    [aCoder encodeInt:self.tagID forKey:@"tagID"];
    
    [aCoder encodeObject:self.image_share forKey:@"image_share"];
    [aCoder encodeObject:self.detail_url forKey:@"detail_url"];
    [aCoder encodeObject:self.scores forKey:@"scores"];
    [aCoder encodeInt:self.sourceType forKey:@"sourceType"];
    [aCoder encodeObject:self.zId forKey:@"zId"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    //bool
    self.isTodayDeal = [aDecoder decodeBoolForKey:@"isTodayDeal"];
    self.isZhiDeGuangDeal = [aDecoder decodeBoolForKey:@"isZhiDeGuangDeal"];
    self.isBaoyou = [aDecoder decodeBoolForKey:@"isBaoyou"];
    self.isFanjifen = [aDecoder decodeBoolForKey:@"isFanjifen"];
    self.isHuiyuangou = [aDecoder decodeBoolForKey:@"isHuiyuangou"];
    self.isZhuanxiang = [aDecoder decodeBoolForKey:@"isZhuanxiang"];
    self.today = [aDecoder decodeBoolForKey:@"today"];
    self.promotion = [aDecoder decodeBoolForKey:@"promotion"];

    //NSString && NSNumber
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.beginTime = [aDecoder decodeObjectForKey:@"beginTime"];
    self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
    self.normalImageUrl = [aDecoder decodeObjectForKey:@"normalImageUrl"];
    self.dealUrl = [aDecoder decodeObjectForKey:@"dealUrl"];
    self.recommendReason = [aDecoder decodeObjectForKey:@"recommendReason"];
    self.bigImageUrl = [aDecoder decodeObjectForKey:@"bigImageUrl"];
    self.smallImageUrl = [aDecoder decodeObjectForKey:@"smallImageUrl"];
    self.hd1ImageUrl = [aDecoder decodeObjectForKey:@"hd1ImageUrl"];
    self.hd2ImageUrl = [aDecoder decodeObjectForKey:@"hd2ImageUrl"];
    self.hotLabel = [aDecoder decodeObjectForKey:@"hotLabel"];
    self.wapUrl = [aDecoder decodeObjectForKey:@"wapUrl"];
    self.urlName = [aDecoder decodeObjectForKey:@"urlName"];
    self.vip = [aDecoder decodeObjectForKey:@"vip"];
    self.shopVo = [aDecoder decodeObjectForKey:@"shopVo"];
    self.shortTitle = [aDecoder decodeObjectForKey:@"shortTitle"];
    self.hd3ImageUrl = [aDecoder decodeObjectForKey:@"hd3ImageUrl"];
    self.hd4ImageUrl = [aDecoder decodeObjectForKey:@"hd4ImageUrl"];
    self.hd5ImageUrl = [aDecoder decodeObjectForKey:@"hd5ImageUrl"];
    self.imageShareUrl = [aDecoder decodeObjectForKey:@"imageShareUrl"];
    self.scores = [aDecoder decodeObjectForKey:@"scores"];
    self.detailUrl = [aDecoder decodeObjectForKey:@"detailUrl"];

    //int
    self.dealId = [aDecoder decodeIntForKey:@"dealId"];
    self.listPrice = [aDecoder decodeIntForKey:@"listPrice"];
    self.price = [aDecoder decodeIntForKey:@"price"];
    self.recommendedById = [aDecoder decodeIntForKey:@"recommendedById"];
    self.oos = [aDecoder decodeIntForKey:@"oos"];
    self.productType = [aDecoder decodeIntForKey:@"productType"];
    self.dealDescTopTip = [aDecoder decodeObjectForKey:@"dealDescTopTip"];
    self.pictureWidth = [aDecoder decodeIntForKey:@"pictureWidth"];
    self.pictureHeight = [aDecoder decodeIntForKey:@"pictureHeight"];
    self.tagID = [aDecoder decodeIntForKey:@"tagID"];
    
    self.scores = [aDecoder decodeObjectForKey:@"scores"];
    self.shareUrl = [aDecoder decodeObjectForKey:@"shareUrl"];
    self.detail_url = [aDecoder decodeObjectForKey:@"detail_url"];
    
    self.sourceType = (Tao800DealSourceType) [aDecoder decodeIntForKey:@"sourceType"];
    self.zId = [aDecoder decodeObjectForKey:@"zId"];
    
    return self;
}

+ (void)convertJSONDict:(NSDictionary *)item toDeal:(Tao800DealVo *)deal {
    if(deal == nil){
        return;
    }

    NSNumber *dealIdNum = [item objectForKey:@"id" convertNSNullToNil:YES];
    if (dealIdNum) {
        deal.dealId = dealIdNum.intValue;
    }
    deal.isZhiDeGuangDeal = NO;
    
    deal.title = [item objectForKey:@"title" convertNSNullToNil:YES];
    id imageUrlObject = [item objectForKey:@"image_url" convertNSNullToNil:YES];
    
    if (imageUrlObject && [imageUrlObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *imageDict = imageUrlObject;
        
        NSString *big = [imageDict objectForKey:@"big" convertNSNullToNil:YES];
        NSString *normal = [imageDict objectForKey:@"normal" convertNSNullToNil:YES];
        NSString *small = [imageDict objectForKey:@"small" convertNSNullToNil:YES];
        NSString *hd1 = [imageDict objectForKey:@"hd1" convertNSNullToNil:YES];
        NSString *hd2 = [imageDict objectForKey:@"hd2" convertNSNullToNil:YES];
        NSString *hd3 = [imageDict objectForKey:@"hd3" convertNSNullToNil:YES];
        NSString *hd4 = [imageDict objectForKey:@"hd4" convertNSNullToNil:YES];
        NSString *hd5 = [imageDict objectForKey:@"hd5" convertNSNullToNil:YES];
        deal.bigImageUrl = big;
        deal.normalImageUrl = normal;
        deal.smallImageUrl = small;
        deal.hd1ImageUrl = hd1;
        deal.hd2ImageUrl = hd2;
        deal.hd3ImageUrl = hd3;
        deal.hd4ImageUrl = hd4;
        deal.hd5ImageUrl = hd5;
        
        if (!deal.hd4ImageUrl) {
            deal.hd4ImageUrl = deal.hd2ImageUrl;
        }
        
        if (!deal.hd5ImageUrl) {
            deal.hd5ImageUrl = deal.hd1ImageUrl;
        }
    } else if ([imageUrlObject isKindOfClass:[NSString class]]) {
        deal.bigImageUrl = imageUrlObject;
        deal.normalImageUrl = deal.bigImageUrl;
        deal.smallImageUrl = deal.bigImageUrl;
        deal.hd1ImageUrl = deal.bigImageUrl;
        deal.hd2ImageUrl = deal.bigImageUrl;
        deal.hd3ImageUrl = deal.bigImageUrl;
        deal.hd4ImageUrl = deal.bigImageUrl;
        deal.hd5ImageUrl = deal.bigImageUrl;
    }
    
    deal.recommendedById = ((NSString *) [item objectForKey:@"recommender_id" convertNSNullToNil:YES]).intValue;
    deal.recommendReason = [item objectForKey:@"recommend_reason" convertNSNullToNil:YES];
    deal.beginTime = [item objectForKey:@"begin_time" convertNSNullToNil:YES];
    deal.scores = [item objectForKey:@"scores" convertNSNullToNil:YES]; //add from v3.1
    deal.detailUrl = [item objectForKey:@"detail_url" convertNSNullToNil:YES]; //add from v3.1
    deal.imageShareUrl = [item objectForKey:@"image_share" convertNSNullToNil:YES];
    deal.shortTitle = [item objectForKey:@"short_title" convertNSNullToNil:YES];
    deal.expireTime = [item objectForKey:@"expire_time" convertNSNullToNil:YES];
    deal.dealUrl = [item objectForKey:@"deal_url" convertNSNullToNil:YES];
    deal.wapUrl = [item objectForKey:@"wap_url" convertNSNullToNil:YES];
    deal.urlName = [item objectForKey:@"url_name" convertNSNullToNil:YES];
    deal.hotLabel = [item objectForKey:@"hot_label" convertNSNullToNil:YES];
    deal.listPrice = ((NSString *) [item objectForKey:@"list_price" convertNSNullToNil:YES]).intValue;
    deal.price = ((NSString *) [item objectForKey:@"price" convertNSNullToNil:YES]).intValue;
    deal.oos = (DealSaleState) ((NSString *) [item objectForKey:@"oos" convertNSNullToNil:YES]).intValue;
    deal.productType = (DealProductType) ((NSString *) [item objectForKey:@"product_type" convertNSNullToNil:YES]).intValue;
    deal.vip = [item objectForKey:@"vip"];
    deal.isBaoyou = [[item objectForKey:@"baoyou" convertNSNullToNil:YES] boolValue];
    deal.isFanjifen = [[item objectForKey:@"fanjifen" convertNSNullToNil:YES] boolValue];
    deal.isHuiyuangou = [[item objectForKey:@"huiyuangou" convertNSNullToNil:YES] boolValue];
    deal.isZhuanxiang = [[item objectForKey:@"zhuanxiang" convertNSNullToNil:YES] boolValue];
    deal.promotion = [[item objectForKey:@"promotion" convertNSNullToNil:YES] boolValue];
    deal.today = [[item objectForKey:@"today" convertNSNullToNil:YES] boolValue];
    deal.dealDescTopTip = [item objectForKey:@"dealDescTopTip" convertNSNullToNil:YES];
    deal.shareUrl = [item objectForKey:@"share_url" convertNSNullToNil:YES];
    deal.pictureWidth = ((NSString *) [item objectForKey:@"pic_width" convertNSNullToNil:YES]).intValue;
    deal.pictureHeight = ((NSString *) [item objectForKey:@"pic_height" convertNSNullToNil:YES]).intValue;
    deal.tagID = ((NSString *) [item objectForKey:@"tao_tag_id" convertNSNullToNil:YES]).intValue;
    deal.soldCount = 0;
    if([item objectForKey:@"sales_count" convertNSNullToNil:YES] != nil){
        deal.soldCount = [[item objectForKey:@"sales_count" convertNSNullToNil:YES] intValue];
    }
    
    NSNumber *shopType = [item objectForKey:@"shop_type" convertNSNullToNil:YES];
    if (shopType) {
        deal.shopType = (ShopType) shopType.intValue;
    }else{
        deal.shopType = ShopTypeDefault;
    }
    
    // 增加店铺信息
    NSDictionary *shopDic = [item objectForKey:@"shop" convertNSNullToNil:YES];
    Tao800ShopVo *shopVo = [Tao800ShopVo convertJSONShop:shopDic];
    deal.shopVo = shopVo;
    
    //商城商品属性
    deal.sourceType = Tao800DealSourceTypeMall;
    NSNumber *sourceTypeNum = [item objectForKey:@"source_type" convertNSNullToNil:YES];
    if (sourceTypeNum != nil) {
        deal.sourceType = (Tao800DealSourceType)[sourceTypeNum intValue];
    }
    deal.zId = [item objectForKey:@"zid" convertNSNullToNil:YES];
}

- (void)dealloc {

}


@end
