//
//  Tao800ActivityVo.h
//  tao800
//
//  Created by ayvin on 13-4-15.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800ActivityVo : NSObject {
    NSNumber *_bannerType;
    /*
                        (0, 'deal商品'),
                        (1, 'WAP URL'),
                        (2, '商品分类'),
                        (3, '抽奖商品详情页'),
                        (4, '0元换购商品详情页'),
                        (5, '签到页面'),
                        (6, '抽奖商品列表页'),
                        (7, '0元换购商品列表页'),
                        (8, '值得逛分类页'),
                        (9, '值得逛商品列表页'),
                        (10, '活动专题页'),
                        (11, '关键词搜索专题页'),
                        (12, '价格区间专题页'),
                        (13, '更新时间区间专题页')
                        */
    NSNumber *_activityId;
    int status;
    NSString *_dealUrl;
    NSString *_lImageUrl;
    NSString *_mImageUrl;
    NSString *_sImageUrl;
    NSString *_title;
    NSString *_value;
    NSString *_wapUrl;
    

    NSString *__detailString;
    BOOL _show_model;
    NSString *_ext;
    NSString *_urlName;
}

@property(nonatomic, strong) NSNumber *bannerType;
@property(nonatomic, strong) NSNumber *activityId;
@property(nonatomic, assign) int status;
@property(nonatomic, copy) NSString *dealUrl;
@property(nonatomic, copy) NSString *lImageUrl;
@property(nonatomic, copy) NSString *mImageUrl;
@property(nonatomic, copy) NSString *sImageUrl;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *value;
@property(nonatomic, copy) NSString *wapUrl;
@property(nonatomic, copy) NSString *detailString;
@property(nonatomic, copy) NSString *ext;
@property(nonatomic, copy) NSString *urlName;

@property(nonatomic, strong) NSDictionary *dealParams;
@property(nonatomic, assign) BOOL show_model;
@end
