//
//  Tao800BrandVo.h
//  tao800
//
//  Created by adminName on 14-6-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800BrandVo : NSObject <NSCopying,NSCoding>

//@property(nonatomic, copy) NSString *leftViewImageURL;
@property(nonatomic, copy) NSString *dealImageURL1;     //品牌团列表右上角deal图片地址
@property(nonatomic, copy) NSString *dealImageURL2;     //品牌团列表右下角deal图片地址

@property(nonatomic, copy) NSString *price1;            //品牌团列表右上角deal价格
@property(nonatomic, copy) NSString *price2;            //品牌团列表右下角deal价格
@property(nonatomic, copy) NSString *discount1;         //品牌团列表又上角deal折扣
@property(nonatomic, copy) NSString *discount2;         //品牌团列表右下角deal折扣

@property(nonatomic, assign) BOOL isNewDeal;            //是否为新
@property(nonatomic, copy) NSString *iconImageURL;      //icon图片地址
@property(nonatomic, copy) NSString *name;              //品牌名字
@property(nonatomic, copy) NSString *title;             //标题品牌名
@property(nonatomic, copy) NSString *discountLeft;      //品牌折扣（3.9折起）
@property(nonatomic, copy) NSString *limit;             //限量多少款
@property(nonatomic, copy) NSString *descriString;       //满减信息

@property(nonatomic, copy) NSString *deadline;          //截止时间
@property(nonatomic, copy) NSString *beginTime;         //开始时间

-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
