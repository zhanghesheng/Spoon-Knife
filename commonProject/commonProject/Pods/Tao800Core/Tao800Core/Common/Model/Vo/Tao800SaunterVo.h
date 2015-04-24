//
//  Tao800SaunterVo.h
//  tao800
//
//  Created by adminName on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"

@interface Tao800SaunterVo : NSObject<NSCoding>
{
    NSString *_name;
    NSString *_urlName;
    NSString *_desc;
    NSString *_tagId;
}

@property(nonatomic, copy) NSString *name;//分类名称
@property(nonatomic, copy) NSString *urlName;//分类关键字
@property(nonatomic, copy) NSString *desc;//分类描述
@property(nonatomic, copy) NSString *tagId;//分类id

@property (nonatomic, assign) Tao800DealDetailFrom dealDetailFrom;

@end

