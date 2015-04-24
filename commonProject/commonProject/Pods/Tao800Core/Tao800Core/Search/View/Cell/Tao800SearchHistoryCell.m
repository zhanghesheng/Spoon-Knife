//
//  Tao800SearchHistoryCell.m
//  tao800
//
//  Created by worker on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchHistoryCell.h"
#import "Tao800SearchHistoryItem.h"

@implementation Tao800SearchHistoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 44;
}

- (void)setObject:(id)object {
    [super setObject:object];
    
    if (_item == nil) {
        return;
    }
    
    Tao800SearchHistoryItem *item = (Tao800SearchHistoryItem *) _item;
    if (item.isHeader) {
        _keywordLabel.text = @"搜索历史";
        _keywordLabel.textColor = [UIColor grayColor];
    }else {
        _keywordLabel.text = item.keyword;
        _keywordLabel.textColor = [UIColor blackColor];
    }
}
@end
