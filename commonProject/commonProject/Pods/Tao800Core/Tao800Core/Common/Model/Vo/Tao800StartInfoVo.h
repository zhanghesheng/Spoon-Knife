//
//  Tao800StartInfoVo.h
//  tao800
//
//  Created by worker on 12-11-1.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800StartInfoVo : NSObject <NSCoding, NSCopying> {
    NSNumber *_startInfoId;
    NSNumber *_type;
    NSString *_title;
    NSString *_dealUrl;
    NSString *_wapUrl;
    NSString *_value; // 分类值
    NSString *_bigImageUrl; //大图片
    NSString *_normalImageUrl; //中图片url
    NSString *_smallImageUrl; //小图片
    NSString *_updateTime; // 最后更新时间
    NSString *_detail; // 详情

    BOOL _show_model;
}

@property(nonatomic, strong) NSNumber *bannerId;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *dealUrl;
@property(nonatomic, copy) NSString *wapUrl;
@property(nonatomic, copy) NSString *value; // 分类值
@property(nonatomic, copy) NSString *bigImageUrl; //大图片
@property(nonatomic, copy) NSString *normalImageUrl; //中图片url
@property(nonatomic, copy) NSString *smallImageUrl; //小图片
@property(nonatomic, copy) NSString *updateTime;
@property(nonatomic, copy) NSString *detail;

@property(nonatomic, copy) NSString *beginTime;
@property(nonatomic, copy) NSString *expireTime;

@property(nonatomic, assign) BOOL show_model;

- (id)copyWithZone:(NSZone *)zone;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

@end
