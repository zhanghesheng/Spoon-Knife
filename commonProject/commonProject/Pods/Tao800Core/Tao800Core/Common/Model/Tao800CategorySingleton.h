//
//  Tao800CategoryModel.h
//  tao800
//
//  Created by worker on 12-10-29.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800CategoryVo.h"

@interface Tao800CategorySingleton : NSObject {
    NSMutableArray *_category;
}

@property(nonatomic, retain) NSMutableArray *category;

+ (Tao800CategorySingleton *)sharedInstance;

// 获取分类
- (NSMutableArray *)getCategory;

// 把分类数据写入文件
- (void)setCategoryByString:(NSString *)categoryStr;

@end
