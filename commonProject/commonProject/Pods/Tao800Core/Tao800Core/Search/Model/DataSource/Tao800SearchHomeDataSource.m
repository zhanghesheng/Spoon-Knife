//
//  Tao800SearchHomeDataSource.m
//  tao800
//
//  Created by worker on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchHomeDataSource.h"
#import "Tao800SearchHistoryItem.h"
#import "Tao800SearchHistoryCell.h"
#import "Tao800SearchSuggestionItem.h"
#import "Tao800SearchSuggestionCell.h"

@implementation Tao800SearchHomeDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    
    if ([object isKindOfClass:[Tao800SearchHistoryItem class]]) {
        return [Tao800SearchHistoryCell class];
    }else if ([object isKindOfClass:[Tao800SearchSuggestionItem class]]) {
        return [Tao800SearchSuggestionCell class];
    }else {
        return [super tableView:tableView cellClassForObject:object];
    }
    
}

@end
