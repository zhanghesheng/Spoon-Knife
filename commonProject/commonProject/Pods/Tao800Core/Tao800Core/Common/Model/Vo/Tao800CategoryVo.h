//
//  Tao800CategoryVo.h
//  tao800
//
//  Created by worker on 12-10-25.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"

@interface Tao800CategoryVo : NSObject<NSCoding> {
    int _categoryId;         //id
    NSString *_categoryName; //分类名称
    NSString *_urlName;      //分类查询id
    
    NSString *_catId;
    NSString *_parentId;
    BOOL _isHaveNextLevel;//just build for TBBFilterList isHaveNextLevelListStatusAry using
    NSString *_another;//如果有在filterbar上显示改名字
    NSString *_pic;
}

@property(nonatomic, assign) int categoryId;

@property(nonatomic, assign) int buttonTag; //todo temp 暂时用于首页控制打点

@property(nonatomic, copy) NSString *categoryName;
@property(nonatomic, copy) NSString *urlName;
@property(nonatomic, copy) NSString *imagePath;
@property(nonatomic, copy) NSString *imagePathWhite;
@property(nonatomic, copy) NSString *pic;


@property(nonatomic, strong) NSString *catId;
@property(nonatomic, strong) NSString *parentId;
@property(nonatomic, strong) NSString *parentUrlName;
@property(nonatomic, assign) BOOL isHaveNextLevel;
@property(nonatomic, strong) NSString *another;
//3.5.4新增
@property(nonatomic, strong) NSString *remoteUrl;
@property(nonatomic, strong) NSString *queryUrl;


//用于首页区分选中按钮
@property(nonatomic, assign) int tag;
@property (nonatomic, assign) Tao800DealDetailFrom dealDetailFrom;

+ (NSArray *)wrapperTags:(NSArray *)tags;
@end
