//
//  TBScrollPageTopBarCell.h
//  TBScrollPageDemo
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBScrollPageTopBar;

@interface TBScrollPageTopBarCell : UITableViewCell {
    NSObject *_item;
}
- (void)setObject:(NSObject *)obj;

+ (CGFloat)pageTopBar:(UITableView *)pageTopBar columnWidthForObject:(id)object;
@end
