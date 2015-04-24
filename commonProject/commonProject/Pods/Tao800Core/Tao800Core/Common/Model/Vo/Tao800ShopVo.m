//
//  Tao800ShopVo.m
//  tao800
//
//  Created by wuzhiguang on 13-4-22.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//
//  店铺vo

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800ShopVo.h"

@implementation Tao800ShopVo

@synthesize clickUrl = _clickUrl;
@synthesize shopCreditName = _shopCreditName;
@synthesize shopCreditOffset = _shopCreditOffset;
@synthesize picUrl = _picUrl;
@synthesize name = _name;
@synthesize rate = _rate;
@synthesize itemsCount = _itemsCount;

- (void)encodeWithCoder:(NSCoder *)aCoder {

    //NSString && NSNumber
    [aCoder encodeObject:self.clickUrl forKey:@"clickUrl"];
    [aCoder encodeObject:self.picUrl forKey:@"picUrl"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.rate forKey:@"rate"];

    //int
    [aCoder encodeInt:self.shopCreditName forKey:@"shopCreditName"];
    [aCoder encodeInt:self.shopCreditOffset forKey:@"shopCreditOffset"];
    [aCoder encodeInt:self.itemsCount forKey:@"itemsCount"];

    [aCoder encodeObject:self.shopId forKey:@"shopId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    //NSString && NSNumber
    self.clickUrl = [aDecoder decodeObjectForKey:@"clickUrl"];
    self.picUrl = [aDecoder decodeObjectForKey:@"picUrl"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.rate = [aDecoder decodeObjectForKey:@"rate"];

    //int
    self.shopCreditName = [aDecoder decodeIntForKey:@"shopCreditName"];
    self.shopCreditOffset = [aDecoder decodeIntForKey:@"shopCreditOffset"];
    self.itemsCount = [aDecoder decodeIntForKey:@"itemsCount"];

    self.shopId = [aDecoder decodeObjectForKey:@"shopId"];

    return self;
}


+ (Tao800ShopVo *)convertJSONShop:(NSDictionary *)shopDic {
    Tao800ShopVo *shopVo = [[Tao800ShopVo alloc] init];

    shopVo.shopId = [shopDic objectForKey:@"id" convertNSNullToNil:YES];
    shopVo.clickUrl = [shopDic objectForKey:@"click_url" convertNSNullToNil:YES];
    shopVo.itemsCount = [[shopDic objectForKey:@"items_count"  convertNSNullToNil:YES] intValue];
    shopVo.name = [shopDic objectForKey:@"name" convertNSNullToNil:YES];
    shopVo.picUrl = [shopDic objectForKey:@"pic_path" convertNSNullToNil:YES];
    shopVo.rate = [shopDic objectForKey:@"rate" convertNSNullToNil:YES];
    NSDictionary *credibilityDic = [shopDic objectForKey:@"credibility" convertNSNullToNil:YES];
    if (credibilityDic != nil) {
        NSString *credibilityName = [credibilityDic objectForKey:@"area_name" convertNSNullToNil:YES];
        if ([credibilityName isEqualToString:@"cap"]) {
            shopVo.shopCreditName = ShopCreditNameCap;
        } else if ([credibilityName isEqualToString:@"red"]) {
            shopVo.shopCreditName = ShopCreditNameRed;
        } else if ([credibilityName isEqualToString:@"blue"]) {
            shopVo.shopCreditName = ShopCreditNameBlue;
        } else if ([credibilityName isEqualToString:@"crown"]) {
            shopVo.shopCreditName = ShopCreditNameCrown;
        }
        shopVo.shopCreditOffset = [[credibilityDic objectForKey:@"offset"  convertNSNullToNil:YES] intValue];
    }

    return shopVo;
}

- (void)dealloc {

}

@end
