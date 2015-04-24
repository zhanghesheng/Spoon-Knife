//
//  Tao800CategoryModel.h
//  tao800
//
//  Created by worker on 12-10-29.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800CategoryVo.h"

@interface Tao800CatVoSingleton : NSObject
@property (nonatomic,retain) NSMutableArray *category;

//本地保存用的
@property (nonatomic,retain) NSMutableArray *customCategory;

//本地文件读取保存用的 3.5.4
@property (nonatomic,retain) NSMutableArray *categoryFromFile;

//接口返回的所有分类
@property (nonatomic,retain) NSMutableArray *netCategory;

//存储有序的大分类cat
@property (nonatomic,retain) NSMutableArray *bigCat;

//@property (nonatomic,retain) NSMutableArray *smallCat;

+ (Tao800CatVoSingleton *)sharedInstance;

//

// 获取分类
- (NSMutableArray *)getCategory;

- (NSMutableArray *)getCustomCategory;

- (NSMutableArray *)getCategoryFromFile;

- (NSString*)getStringCategoryFromFile;

// 把分类数据写入文件
- (void)setCategoryByString:(NSString *)categoryStr;

-(NSString *)loadCategoryFromFile;

//- (NSMutableArray *)getReallyLevel1;

//- (NSMutableArray *)getReallyLevel2:(TBBMenuController*)menu;

//- (NSMutableArray *)getLevel1TestAry;

//- (NSMutableArray *)getLevel2TestAry;

//- (NSMutableArray *)getReallyLevel2TestAry:(TBBMenuController*)menu;

//- (NSMutableArray *)getReallyLevel1TestAry;

- (NSString*)fetchButtonUrl:(Tao800CategoryVo*)catVo;

- (NSString*)fetchButtonSelectedUrl:(Tao800CategoryVo*)catVo;

- (NSString*)fetchButtonHomeUrl:(Tao800CategoryVo*)catVo;

- (NSMutableArray*)sortCategoryArray:(NSMutableArray*)localArray remoteArray:(NSArray*)remote;

-(Tao800CategoryVo *)fetchCatVoByUrlName:(NSString*)urlName;

-(Tao800CategoryVo *)fetchCatVoByUrlNameV2:(NSString *)urlName;

-(NSMutableArray*) fetchBigCat:(NSMutableArray*)holeArray;

-(NSMutableArray*) fetchSmallCat:(NSMutableArray*)holeArray bigCat:(Tao800CategoryVo*)cat;
@end
