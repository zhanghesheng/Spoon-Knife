//
//  Tao800AddressListDataSource.m
//  tao800
//
//  Created by LeAustinHan on 14-4-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressListDataSource.h"
#import "Tao800AddressListItems.h"
#import "Tao800AddressListCell.h"
#import "Tao800LoadMoreItem.h"
#import "Tao800LoadMoreCell.h"

@implementation Tao800AddressListDataSource

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[Tao800AddressListItems class]]) {
        return [Tao800AddressListCell class];
    }
    else if([object isKindOfClass:[Tao800LoadMoreItem class]]) {
        return [Tao800LoadMoreCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}

@end
