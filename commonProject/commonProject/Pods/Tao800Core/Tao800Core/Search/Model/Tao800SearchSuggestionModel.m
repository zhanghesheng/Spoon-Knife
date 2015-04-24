//
//  Tao800SearchSuggestionModel.m
//  tao800
//
//  Created by enfeng on 14-7-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchSuggestionModel.h"
#import "Tao800ConfigManage.h"
#import "Tao800SearchHistoryItem.h"
#import "Tao800DealService.h"
#import "Tao800SearchSuggestionItem.h"

@interface Tao800SearchSuggestionModel ()
@property(nonatomic, strong) Tao800DealService *dealService;
@end

@implementation Tao800SearchSuggestionModel

- (id)init {
    self = [super init];
    if (self) {
        self.dealService = [[Tao800DealService alloc] init];
    }
    return self;
}

- (NSArray *)getSearchKeywords {
    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    return [configManage getSearchKeywords];
}

- (void)saveSearchKeyword:(NSString *)keyword {

    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSMutableArray *saveKeywords = nil;
    if (keyword) {
        NSArray *keywords = [configManage getSearchKeywords];
        saveKeywords = [NSMutableArray arrayWithCapacity:keywords.count + 1];
        [saveKeywords addObject:keyword];
        for (NSString *temp in keywords) {
            if (![temp isEqualToString:keyword]) {
                [saveKeywords addObject:temp];
            }
        }
    } else {
        [self.items removeAllObjects];
    }

    [configManage saveSearchKeywords:saveKeywords];
}

- (void)loadHistoryItems {
    [self.items removeAllObjects];

    Tao800ConfigManage *configManage = [[Tao800ConfigManage alloc] init];
    NSArray *keywords = [configManage getSearchKeywords];

    if (keywords.count > 0) {
        Tao800SearchHistoryItem *item1 = [[Tao800SearchHistoryItem alloc] init];
        item1.isHeader = YES;
        [self.items addObject:item1];

        for (int i = 0; i < keywords.count; i++) {
            if (i > 19) { // 最多显示20个用户搜索的关键词
                break;
            }
            NSString *temp = [keywords objectAtIndex:i];
            Tao800SearchHistoryItem *item = [[Tao800SearchHistoryItem alloc] init];
            item.keyword = temp;
            [self.items addObject:item];
        }
    }
}

- (void)wrapperSearchSuggestionItems:(NSDictionary *)dict {
    [self.items removeAllObjects];

    NSArray *dataItems = [dict objectForKey:@"items"];
    for (int i = 0; i < dataItems.count; i++) {
        Tao800SearchSuggestionVo *vo = [dataItems objectAtIndex:i];
        Tao800SearchSuggestionItem *item = [[Tao800SearchSuggestionItem alloc] init];
        item.vo = vo;
        [self.items addObject:item];
    }
    if (dataItems.count < 1) {
        Tao800SearchSuggestionItem *item = [[Tao800SearchSuggestionItem alloc] init];
        Tao800SearchSuggestionVo *vo = [[Tao800SearchSuggestionVo alloc] init];
        vo.resultCount = nil;
        vo.word = self.keyword;
        item.vo = vo;
        [self.items addObject:item];
    }
}

- (void)loadItems:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure {

    [_dealService removeAllRequestFromArray];

    __weak Tao800SearchSuggestionModel *instance = self;

    NSDictionary *dict = @{
            @"q" : self.keyword,
            @"per_page" : @(_pageSize),
            @"page" : @"1",
    };
    [self.dealService getSearchSuggestion:dict
                               completion:^(NSDictionary *retDict) {
                                   [instance.items removeAllObjects];
                                   [instance wrapperSearchSuggestionItems:retDict];
                                   completion(nil);
    } failure:^(TBErrorDescription *error) {
        failure(error);
    }];
}
@end
