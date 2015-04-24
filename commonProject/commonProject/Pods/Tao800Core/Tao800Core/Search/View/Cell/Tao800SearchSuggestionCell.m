//
//  Tao800SearchSuggestionCell.m
//  tao800
//
//  Created by worker on 14-2-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchSuggestionCell.h"
#import "Tao800SearchSuggestionVo.h"
#import "Tao800SearchSuggestionItem.h"

@implementation Tao800SearchSuggestionCell

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
    
    Tao800SearchSuggestionItem *item = (Tao800SearchSuggestionItem *) _item;
    Tao800SearchSuggestionVo *vo = item.vo;
    
    _keywordLabel.textColor = [UIColor blackColor];
    
    int count = [vo.resultCount intValue];
    if (count == 0) {
        _keywordLabel.text = [NSString stringWithFormat:@"查找\"%@\"",vo.word];
        _countLabel.hidden = YES;
    }else {
        _keywordLabel.text = vo.word;
        _countLabel.hidden = YES;
        _countLabel.text = [NSString stringWithFormat:@"共%d条结果",[vo.resultCount intValue]];
        _countLabel.textColor = [UIColor grayColor];
    }
}

@end
