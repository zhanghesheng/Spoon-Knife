//
//  Tao800SearchSuggestionModel.h
//  tao800
//
//  Created by enfeng on 14-7-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

@interface Tao800SearchSuggestionModel : TBModel

@property(nonatomic, copy) NSString *keyword;

- (void)loadHistoryItems;

- (NSArray *)getSearchKeywords;

- (void)saveSearchKeyword:(NSString *)keyword;
@end
