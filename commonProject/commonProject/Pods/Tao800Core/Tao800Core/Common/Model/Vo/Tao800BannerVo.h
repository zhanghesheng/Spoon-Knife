//
//  Tao800BannerVo.h
//  tao800
//
//  Created by worker on 12-11-1.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"
#import "Tao800AnalysisExposureConstant.h"

@interface Tao800BannerVo : NSObject {
    NSNumber *_bannerId;
    NSNumber *_bannerType;
    NSString *_title;
    NSString *_dealUrl;
    NSString *_wapUrl;
    NSString *_value; // 分类值
    NSString *_bigImageUrl; //大图片
    NSString *_normalImageUrl; //中图片url
    NSString *_smallImageUrl; //小图片
    NSString *_detailString;
    BOOL _show_model;

    // v2.7.0新增
    NSMutableArray *_childTopics; // 子专题
}

@property(nonatomic, strong) NSNumber *bannerId;
@property(nonatomic, strong) NSNumber *bannerType;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *dealUrl;
@property(nonatomic, copy) NSString *wapUrl;
@property(nonatomic, copy) NSString *value; // 分类值
@property(nonatomic, copy) NSString *bigImageUrl; //大图片
@property(nonatomic, copy) NSString *imageBigUrl; //大图片  image_big_ios_url
@property(nonatomic, copy) NSString *normalImageUrl; //中图片url
@property(nonatomic, copy) NSString *smallImageUrl; //小图片
@property(nonatomic, copy) NSString *checkInPageImageUrl; //签到页Banner图

@property(nonatomic, copy) NSString *detailString;
@property(nonatomic, assign) BOOL show_model;
@property(nonatomic, assign) Tao800DealDetailFrom dealDetailFrom;

@property(nonatomic, strong) NSMutableArray *childTopics; // 子专题

@property(nonatomic, strong) NSDictionary *dealParams;
@property(nonatomic, copy) NSString *pushId;
@property(nonatomic, strong) NSString *parentUrlName;

@property (nonatomic) Tao800ExposureRefer exposureRefer; //标记来源，用于曝光打点
@end
