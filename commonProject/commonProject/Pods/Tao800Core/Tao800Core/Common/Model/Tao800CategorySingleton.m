//
//  Tao800CategoryModel.m
//  tao800
//
//  Created by worker on 12-10-29.
//  Copyright (c) 2012年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800CategorySingleton.h"
#import "TBCore/TBCore.h"
#import "Tao800StaticConstant.h"
#import "TBCore/TBFileUtil.h"

static Tao800CategorySingleton *_instance;

@implementation Tao800CategorySingleton

@synthesize category = _category;

#pragma mark ---- singleton methods -----------
+ (Tao800CategorySingleton *)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (NSMutableArray *)getCategory {
    if (_category && _category.count != 0 && ![_category isKindOfClass:[NSNull class]]) {
        return _category;
    }

    NSString *jsonPath = [TBFileUtil getDbFilePath:CategoryFileName];

    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:jsonPath];
    NSData *data = [fh readDataToEndOfFile];

    NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *categoryArr = [aStr JSONValue];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[categoryArr count] + 1];

    // 增加全部分类
    Tao800CategoryVo *vo1 = [[Tao800CategoryVo alloc] init];
    vo1.categoryId = 0;
    vo1.categoryName = @"全部";
    vo1.urlName = @"";
    [result addObject:vo1];

    Tao800CategoryVo *vo2 = [[Tao800CategoryVo alloc] init];
    vo2.categoryId = 20;
    vo2.categoryName = @"热门活动";
    vo2.urlName = @"";
    [result addObject:vo2];

    for (NSDictionary *item in categoryArr) {
        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = [[item objectForKey:@"id"] intValue];
        vo.categoryName = [item objectForKey:@"category_name"];
        vo.urlName = [item objectForKey:@"url_name"];
        [result addObject:vo];
    }

    self.category = result;
    return result;
}

// 把分类数据写入文件
- (void)setCategoryByString:(NSString *)categoryStr {
    NSArray *arr =(NSArray*) [categoryStr JSONValue];
    if (arr == nil || arr.count == 0) {
        return;
    }

    NSString *jsonPath = [TBFileUtil getDbFilePath:CategoryFileName];
    //创建数据缓冲
    NSMutableData *writer = [[NSMutableData alloc] init];
    [writer appendData:[categoryStr dataUsingEncoding:NSUTF8StringEncoding]];

    [writer writeToFile:jsonPath atomically:YES];

//    NSData *reader = [NSData dataWithContentsOfFile:jsonPath];
//    NSString *readStr = [[NSString alloc] initWithData:reader
//                                 encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",readStr);

    self.category = [self convertJsonToCategory:arr];
}

//获取分类解析
- (NSMutableArray *)convertJsonToCategory:(NSArray *)categoryArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[categoryArr count] + 2];

    // 增加全部分类
    Tao800CategoryVo *vo1 = [[Tao800CategoryVo alloc] init];
    vo1.categoryId = 0;
    vo1.categoryName = @"全部";
    vo1.urlName = @"";
    [arr addObject:vo1];

    Tao800CategoryVo *vo2 = [[Tao800CategoryVo alloc] init];
    vo2.categoryId = 20;
    vo2.categoryName = @"热门活动";
    vo2.urlName = @"";
    [arr addObject:vo2];

    for (NSDictionary *item in categoryArr) {

        Tao800CategoryVo *vo = [[Tao800CategoryVo alloc] init];
        vo.categoryId = [[item objectForKey:@"id"] intValue];
        vo.categoryName = [item objectForKey:@"category_name"];
        vo.urlName = [item objectForKey:@"url_name"];

        [arr addObject:vo];
    }

    return arr;
}

- (void)dealloc {

}

@end
