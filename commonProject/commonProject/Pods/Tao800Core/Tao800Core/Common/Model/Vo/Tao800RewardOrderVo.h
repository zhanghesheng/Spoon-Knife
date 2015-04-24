//
//  Tao800RewardOrderVo.h
//  tao800
//
//  Created by zhangwenguang on 13-4-16.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800RewardOrderVo : NSObject //<NSCoding>
{
    //adds:
    NSString *_consignee_name; //地址信息
    NSString *_info;            //收货人地址
    NSString *_phone_number;//收货人手机
    NSString *_telephone;//收货人电话

    NSString *_created_at;//成交时间
    //deal:礼品信息
    NSString *_image_big;//图片
    NSString *_image_normal;
    NSString *_image_small;
    NSString *_url_name;//礼品 url_name
    NSString *_title;
    NSString *_price;
    
    int _orderId;
    NSString *_memo; //用户备注
    NSString *_no; //订单号
    BOOL _oversold; //是否超卖 1表示超卖，0表示没有超卖
    int _score;//花费积分
    int _shipped_status;//商品状态 －1待支付 0 待发货 1已发货 3交易成功 4 交易取消 5交易关闭
    BOOL _showed_status; //是否晒单 1 表示是 0 表示否
    NSString *_sku_attr; //商品属性
    int _tao_jifen_deal_id;
    int _topic_id;
    NSString *_create_url;
    NSString *_url;
    NSString *_updated_at;
    int _user_id;
    NSString *_user_name;

    NSString *_courier_no;//物流单号
    NSString *_courier_name;//物流公司名字
    
    
    int _count ;//抽奖兑换总数 或者 积分兑换总数
}

@property(nonatomic, strong) NSString *consignee_name;
@property(nonatomic, strong) NSString *info;
@property(nonatomic, strong) NSString *phone_number;
@property(nonatomic, strong) NSString *telephone;
@property(nonatomic, strong) NSString *created_at;
@property(nonatomic, strong) NSString *image_big;
@property(nonatomic, strong) NSString *image_normal;
@property(nonatomic, strong) NSString *image_small;

@property(nonatomic, strong) NSString *url_name;
@property(nonatomic, strong) NSString *memo;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *create_url;
@property(nonatomic, strong) NSString *url;

@property(nonatomic, strong) NSString *no;
@property(nonatomic, strong) NSString *sku_attr;
@property(nonatomic, strong) NSString *updated_at;
@property(nonatomic, strong) NSString *user_name;
@property(nonatomic, strong) NSString *courier_no;
@property(nonatomic, strong) NSString *courier_name;


@property(nonatomic, assign)int orderId;
@property(nonatomic, assign)BOOL oversold;
@property(nonatomic, assign)int score;
@property(nonatomic, assign)int shipped_status;
@property(nonatomic, assign)BOOL showed_status;
@property(nonatomic, assign)int tao_jifen_deal_id;
@property(nonatomic, assign)int user_id;
@property(nonatomic, assign)int topic_id;

@property(nonatomic ,assign)int count;

@end
