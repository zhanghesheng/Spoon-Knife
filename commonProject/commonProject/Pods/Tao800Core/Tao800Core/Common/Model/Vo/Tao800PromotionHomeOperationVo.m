//
//  Tao800PromotionHomeOperationVo.m
//  Tao800Core
//
//  Created by suminjie on 15-1-30.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800PromotionHomeOperationVo.h"
#import "Tao800PromotionHomeSettingVo.h"
#import "Tao800PromotionHomePictureVo.h"
#import "Tao800PromotionHomePromotionVo.h"
#import "Tao800PromotionHomeIconsVo.h"
#import "TBCore/NSObjectAdditions.h"

@implementation Tao800PromotionHomeOperationVo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.settingArray forKey:@"settingArray"];
    [aCoder encodeObject:self.promotionArray forKey:@"promotionArray"];
    [aCoder encodeObject:self.iconsArray forKey:@"iconsArray"];
    [aCoder encodeObject:self.tip forKey:@"tip"];
    
    [aCoder encodeBool:self.showPromotionHomePage forKey:@"showPromotionHomePage"];
    [aCoder encodeBool:self.showTaobaoTip forKey:@"showTaobaoTip"];
    [aCoder encodeBool:self.showTianmaoTip forKey:@"showTianmaoTip"];
    [aCoder encodeBool:self.showShopTip forKey:@"showShopTip"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.settingArray = [aDecoder decodeObjectForKey:@"settingArray"];
    self.promotionArray = [aDecoder decodeObjectForKey:@"promotionArray"];
    self.iconsArray = [aDecoder decodeObjectForKey:@"iconsArray"];
    self.tip = [aDecoder decodeObjectForKey:@"tip"];
    
    self.showPromotionHomePage = [aDecoder decodeBoolForKey:@"showPromotionHomePage"];
    self.showTaobaoTip = [aDecoder decodeBoolForKey:@"showTaobaoTip"];
    self.showTianmaoTip = [aDecoder decodeBoolForKey:@"showTianmaoTip"];
    self.showShopTip = [aDecoder decodeBoolForKey:@"showShopTip"];
    
    return self;
}

+ (Tao800PromotionHomeOperationVo *)wrapperOperationVo:(NSDictionary *)dic {
    Tao800PromotionHomeOperationVo *operationVo = [[Tao800PromotionHomeOperationVo alloc] init];
    
    //解析是否是大促日，是否展示大促首页
    NSDictionary *meta = [dic objectForKey:@"meta" convertNSNullToNil:YES];
    operationVo.showPromotionHomePage = [[meta objectForKey:@"is_promotion" convertNSNullToNil:YES] boolValue];
    
    if (!operationVo.showPromotionHomePage) {
        return operationVo;//非大促，则不需要继续解析
    }
    
    //大促配置数组
    NSDictionary *layoutDict = [dic objectForKey:@"layout" convertNSNullToNil:YES];
    
    //标题背景图片，底部导航bar背景色
    NSDictionary *backgroundDict = [layoutDict objectForKey:@"background" convertNSNullToNil:YES];
    operationVo.promotionHomePictureVo = [Tao800PromotionHomePictureVo wrapperPictureVo:backgroundDict];
    
    //大促运营位
    NSMutableArray *promotionArray = [NSMutableArray arrayWithCapacity:4];
    NSArray *promotionArr = [layoutDict objectForKey:@"promotion" convertNSNullToNil:YES];
    for (NSDictionary *dict in promotionArr) {
        Tao800PromotionHomePromotionVo *promotionVo = [Tao800PromotionHomePromotionVo wrapperPromotionVo:dict];
        [promotionArray addObject:promotionVo];
    }
    operationVo.promotionArray = promotionArray;
    
    //banner下方8个配置项
    NSMutableArray *settingMuArray = [NSMutableArray arrayWithCapacity:8];
    NSArray *settingArr = [layoutDict objectForKey:@"homesetting" convertNSNullToNil:YES];
    for (NSDictionary *dict in settingArr) {
        Tao800PromotionHomeSettingVo *settingVo = [Tao800PromotionHomeSettingVo wrapperSettingVo:dict];
        [settingMuArray addObject:settingVo];
    }
    operationVo.settingArray = settingMuArray;
    
    //解析icons
    NSArray *iconsArray = [layoutDict objectForKey:@"icons" convertNSNullToNil:YES];
    NSMutableArray *iconsMuArray = [NSMutableArray arrayWithCapacity:5];
    for (NSDictionary *dict in iconsArray) {
        Tao800PromotionHomeIconsVo *iconVo = [Tao800PromotionHomeIconsVo wrapperIconsVo:dict];
        [iconsMuArray addObject:iconVo];
    }
    operationVo.iconsArray = iconsMuArray;
    
    //淘宝、天猫、特卖商城 提示
    NSDictionary *tipDict = [layoutDict objectForKey:@"tip" convertNSNullToNil:YES];
    operationVo.showTianmaoTip = [[tipDict objectForKey:@"tmall" convertNSNullToNil:YES] boolValue];
    operationVo.showShopTip = [[tipDict objectForKey:@"shop" convertNSNullToNil:YES] boolValue];
    operationVo.showTaobaoTip = [[tipDict objectForKey:@"taobao" convertNSNullToNil:YES] boolValue];
    operationVo.tip = [tipDict objectForKey:@"tip" convertNSNullToNil:YES];
    
    return operationVo;
}

@end
