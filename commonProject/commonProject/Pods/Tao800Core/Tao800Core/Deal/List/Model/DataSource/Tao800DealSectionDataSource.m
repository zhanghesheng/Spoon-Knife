//
//  Tao800DealSectionDataSource.m
//  tao800
//
//  Created by worker on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealSectionDataSource.h"

#import "Tao800DealListItem.h"
#import "Tao800DealListCell.h"

#import "Tao800DealListGridCell.h"
#import "Tao800DealListGridItem.h"
#import "Tao800LoadMoreCell.h"
#import "Tao800LoadMoreItem.h"

@implementation Tao800DealSectionDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    
    if ([object isKindOfClass:[Tao800DealListItem class]]) {
        return [Tao800DealListCell class];
    } else if ([object isKindOfClass:[Tao800DealListGridItem class]]) {
        return [Tao800DealListGridCell class];
    } else if ([object isKindOfClass:[Tao800LoadMoreItem class]]) {
        return [Tao800LoadMoreCell class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
    
}
@end
