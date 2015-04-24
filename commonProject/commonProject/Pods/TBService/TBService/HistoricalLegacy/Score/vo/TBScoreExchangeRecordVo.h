//
//  TBScoreExchangeRecordVo.h
//  Tuan800API
//
//  Created by Rose Jack on 13-4-22.
//  Copyright (c) 2013年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBScoreExchangeRecordVo : NSObject
{
    NSString *_recordId;//该记录ID
    NSString *_name;//兑换商品名称
    NSString *_exchange_time;//兑换时间 下单时间
    NSString *_send_type;//商品类型，digital代表代金券，physical代表实物
    NSString *_smalllistimage;//列表小图路径
    int _use_status;//使用/领取状态；对于代金券类：0代表未使用，1代表已使用；对于实物类，0代表未领取，1代表已领取
    NSString *_resource_uri;//该记录详情访问链接
    NSString *_source; //来源：积分兑换，积分抽奖
    
    //详情新增返回
    NSString *_draw_time;//开奖时间
    NSString *_consumer_points;//消耗积分值
    NSString *_description;//描述
    NSString *_instructions;//温馨提示
    NSDictionary *_receiver_info;//收件人信息
    
    NSString *_receiver_mobile;
    NSString *_receiver_name;
    NSString *_receiver_address;
    NSString *_receiver_postcode;
    NSString *_delivery_notes;//暂时不用
    NSString *_mobile;
    
    NSString *_voucher_code;//如果是券码类，这是代金券的编码，实物类返回NULL
    NSString *_voucher_expiration_time;//如果是券码类，这是代金券过期时间，实物类返回NULL
    NSString *_card_number;
}

@property(nonatomic,copy) NSString *recordId;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *exchange_time;
@property(nonatomic,copy) NSString *send_type;
@property(nonatomic,copy) NSString *smalllistimage;
@property(nonatomic,assign) int use_status;
@property(nonatomic,copy) NSString *resource_uri;
@property(nonatomic,copy) NSString *source;

@property(nonatomic,copy) NSString *draw_time;
@property(nonatomic,copy) NSString *consumer_points;
@property(nonatomic,copy) NSString *description;
@property(nonatomic,copy) NSString *instructions;
@property(nonatomic,copy) NSString *receiver_mobile;
@property(nonatomic,copy) NSDictionary *receiver_info;
@property(nonatomic,copy) NSString *receiver_name;
@property(nonatomic,copy) NSString *receiver_address;
@property(nonatomic,copy) NSString *receiver_postcode;
@property(nonatomic,copy) NSString *delivery_notes;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *voucher_code;
@property(nonatomic,copy) NSString *voucher_expiration_time;
@property(nonatomic,copy) NSString *card_number;
@property(nonatomic,copy) NSString *createTime;//兑换时间 下单时间,用于兑换与抽奖合并后的接口
@end
