//
//  Tao800RewardOrderVo.m
//  tao800
//
//  Created by zhangwenguang on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800RewardOrderVo.h"
#import "TBCore/TBCoreMacros.h"


@implementation Tao800RewardOrderVo

@synthesize consignee_name = _consignee_name;
@synthesize info = _info;
@synthesize phone_number = _phone_number;
@synthesize telephone = _telephone;
@synthesize created_at = _created_at;
@synthesize image_small = _image_small;
@synthesize image_normal = _image_normal;
@synthesize image_big = _image_big;
@synthesize price = _price;
@synthesize title = _title;

@synthesize memo = _memo;
@synthesize no = _no;
@synthesize sku_attr = _sku_attr;
@synthesize updated_at = _updated_at;
@synthesize user_name = _user_name;
@synthesize url_name = _url_name;
@synthesize courier_no = _courier_no;
@synthesize courier_name = _courier_name;
@synthesize create_url = _create_url;
@synthesize url = _url;

@synthesize oversold = _oversold;
@synthesize score  = _score;
@synthesize shipped_status = _shipped_status;
@synthesize showed_status = _showed_status;
@synthesize tao_jifen_deal_id = _tao_jifen_deal_id;
@synthesize user_id = _user_id;
@synthesize topic_id = _topic_id;
@synthesize count = _count;


/*

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    //bool
    [aCoder encodeBool:self.shipped_status forKey:@"shipped_status"];
    [aCoder encodeBool:self.showed_status forKey:@"showed_status"];
    [aCoder encodeBool:self.oversold forKey:@"oversold"];

    
    //NSString && NSNumber
    [aCoder encodeObject:self.consignee_name forKey:@"consignee_name"];
    [aCoder encodeObject:self.info forKey:@"info"];
    [aCoder encodeObject:self.phone_number forKey:@"phone_number"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.created_at forKey:@"created_at"];
    [aCoder encodeObject:self.image_big forKey:@"big"];
    [aCoder encodeObject:self.image_normal forKey:@"normal"];
    [aCoder encodeObject:self.image_small forKey:@"small"];
    [aCoder encodeObject:self.url_name forKey:@"url_name"];
    [aCoder encodeObject:self.memo forKey:@"memo"];
    [aCoder encodeObject:self.no forKey:@"no"];
    [aCoder encodeObject:self.sku_attr forKey:@"sku_attr"];
    [aCoder encodeObject:self.updated_at forKey:@"updated_at"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.courier_no forKey:@"courier_no"];
    [aCoder encodeObject:self.courier_name forKey:@"courier_name"];
    [aCoder encodeObject:self.create_url forKey:@"create_url"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.price forKey:@"price"];
    
    //int
    [aCoder encodeInt:self.score forKey:@"score"];
    [aCoder encodeInt:self.tao_jifen_deal_id forKey:@"tao_jifen_deal_id"];
    [aCoder encodeInt:self.user_id forKey:@"user_id"];
    [aCoder encodeInt:self.topic_id forKey:@"topic_id"];
    [aCoder encodeInt:self.count forKey:@"count"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    //bool
    self.shipped_status = [aDecoder decodeBoolForKey:@"shipped_status"];
    self.showed_status = [aDecoder decodeBoolForKey:@"showed_status"];
    self.oversold = [aDecoder decodeBoolForKey:@"oversold"];
    
    //NSString && NSNumber
    self.consignee_name = [aDecoder decodeObjectForKey:@"consignee_name"];
    self.info = [aDecoder decodeObjectForKey:@"info"];
    self.phone_number = [aDecoder decodeObjectForKey:@"phone_number"];
    self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
    self.created_at = [aDecoder decodeObjectForKey:@"created_at"];
    self.url_name = [aDecoder decodeObjectForKey:@"url_name"];
    self.image_big = [aDecoder decodeObjectForKey:@"big"];
    self.image_normal = [aDecoder decodeObjectForKey:@"normal"];
    self.image_small = [aDecoder decodeObjectForKey:@"small"];
    self.memo = [aDecoder decodeObjectForKey:@"memo"];
    self.no = [aDecoder decodeObjectForKey:@"no"];
    self.sku_attr = [aDecoder decodeObjectForKey:@"sku_attr"];
    self.updated_at = [aDecoder decodeObjectForKey:@"updated_at"];
    self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.price = [aDecoder decodeObjectForKey:@"price"];
    self.courier_name = [aDecoder decodeObjectForKey:@"courier_name"];
    self.courier_no = [aDecoder decodeObjectForKey:@"courier_no"];
    self.create_url = [aDecoder decodeObjectForKey:@"create_url"];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    //int
    self.score = [aDecoder decodeIntForKey:@"score"];
    self.tao_jifen_deal_id = [aDecoder decodeIntForKey:@"tao_jifen_deal_id"];
    self.user_id = [aDecoder decodeIntForKey:@"user_id"];
    self.topic_id = [aDecoder decodeIntForKey:@"topic_id"];
    self.count = [aDecoder decodeObjectForKey:@"count"];
    return self;
}

 */



@end
