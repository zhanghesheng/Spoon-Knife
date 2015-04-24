//
//  Tao800SearchHomeModel.m
//  tao800
//
//  Created by worker on 14-2-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchHomeModel.h"
#import "Tao800SearchSuggestionVo.h"
#import "Tao800SearchSuggestionItem.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800DealVo.h"
#import "Tao800Util.h"

@interface Tao800SearchHomeModel()

@end

@implementation Tao800SearchHomeModel

@synthesize controller=_controller;

- (id)init{
    self = [super init];
    if (self) {
        self.dealService = [[Tao800DealService alloc] init];
    }
    return self;
}

#pragma mark - 获取搜索建议
- (void)getSearchSuggestion:(NSDictionary *)params
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure {
    
    [self.items removeAllObjects];
    [_dealService removeAllRequestFromArray];
    self.keyword = [params objectForKey:@"keyword"];
    self.cId = self.controller.cId;
    self.dealDetailFrom = self.controller.dealDetailFrom;
    NSDictionary *dict = @{
                           @"q" : self.keyword,
                           @"per_page" : @(_pageSize),
                           @"page" : @"1",
                           };
    [self.dealService getSearchSuggestion:dict
                               completion:^(NSDictionary *retDict) {
                                   [self wrapperSearchSuggestionItems:retDict];
                                   completion(nil);
                               } failure:^(TBErrorDescription *error) {
                                   failure(error);
                               }];
}

#pragma mark 把搜索建议vo封装成表格用的item
- (void)wrapperSearchSuggestionItems:(NSDictionary *)dict
{
    NSArray *dataItems = [dict objectForKey:@"items"];
    for (int i=0; i<dataItems.count; i++) {
        Tao800SearchSuggestionVo *vo = [dataItems objectAtIndex:i];
        Tao800SearchSuggestionItem *item = [[Tao800SearchSuggestionItem alloc] init];
        item.vo = vo;
        [_items addObject:item];
    }
}

#pragma mark - 搜索商品
- (void)getNewSearchDeals:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure {
    
    [_dealService removeAllRequestFromArray];
    
    __weak Tao800SearchHomeModel *instance = self;
    if (_pageNumber < 2) {
        [self.deals removeAllObjects];
        [self.items removeAllObjects];
    }
    
    NSMutableDictionary *paramsExt = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [paramsExt setObject:[NSNumber numberWithInteger:_pageNumber] forKey:@"page"];
    [paramsExt setObject:[NSNumber numberWithInteger:_pageSize] forKey:@"per_page"];
    
    NSString *keyWord = paramsExt[@"q"];
    if (!paramsExt) {
        keyWord = @"";
    }
    self.cId = self.controller.cId;
    self.dealDetailFrom = self.controller.dealDetailFrom;
    [self.dealService getNewSearchDeals:paramsExt
                          completion:^(NSDictionary *retDict) {
                              
                              NSMutableArray *array = retDict[@"items"];
                              NSMutableArray *filterArray = [NSMutableArray arrayWithCapacity:5];
                              for (Tao800DealVo *vo in array) {
                                  //yes: beginTime 大于当前时间，已经开始
                                  if ([Tao800Util isDayuCurrentDate:vo.beginTime format:@"yyyy-MM-dd HH:mm:ss"]) {
                                      [filterArray addObject:vo];
                                  }else{
                                  //未开始;
                                  }
                              }
                              NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:retDict];
                              [dict setObject:array forKey:@"items"];
                              
                              [instance wrapperItems:dict];
                              completion(nil);
                          } failure:^(TBErrorDescription *error) {
                              failure(error);
                          }];
}

#pragma mark 获取推荐商品
- (void)getRecommendDeals:(NSDictionary *)params
                     completion:(void (^)(NSDictionary *))completion
                        failure:(void (^)(TBErrorDescription *))failure {
    
    [_dealService removeAllRequestFromArray];
    
    __weak Tao800SearchHomeModel *instance = self;
    if (_pageNumber < 2) {
        [self.items removeAllObjects];
    }
    
    NSDictionary *dict = @{
                           @"image_type" : @"all",
                           @"page" : @(_pageNumber),
                           @"per_page" : @(_pageSize),
                           };
    
    [self.dealService getRecommendDeals:dict
                          completion:^(NSDictionary *retDict) {
                              [instance wrapperItems:retDict];
                              completion(nil);
                          } failure:^(TBErrorDescription *error) {
                              failure(error);
                          }];
}

@end
