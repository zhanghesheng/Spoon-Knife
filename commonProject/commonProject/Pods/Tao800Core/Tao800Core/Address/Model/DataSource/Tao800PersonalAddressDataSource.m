//
//  Tao800PersonalAddressDataSource.m
//  tao800
//
//  Created by tuan800 on 14-4-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PersonalAddressDataSource.h"

@implementation Tao800PersonalAddressDataSource


#pragma mark 重写父类方法 只是为了fix bug
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class cellClass = [self tableView:tableView cellClassForObject:object];

    NSString *identifier = @"Tao800PeronsonalAddressCellIdetifer";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        if (self.loadNibWithClassName) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            if (nib && nib.count>0) {
                cell = (UITableViewCell *)[nib objectAtIndex:0];
            } else {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
            }
        } else {
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        }
    }
    
    if ([cell isKindOfClass:[TBTableViewBaseCell class]]) {
        [(TBTableViewCell *) cell setObject:object];
    }
    
    if ([cell isKindOfClass:[TBTableViewBorderCell class]]) {
        NSInteger section = indexPath.section;
        TBCellBackgroundViewPosition position;
        NSArray *arr = [_items objectAtIndex:section];
        NSUInteger count = arr.count;
        if (count>1) {
            NSInteger row = indexPath.row;
            if (row == 0) {
                position = TBCellBackgroundViewPositionTop;
            } else if (row == count-1) {
                position = TBCellBackgroundViewPositionBottom;
            } else {
                position = TBCellBackgroundViewPositionMiddle;
            }
        } else {
            position = TBCellBackgroundViewPositionSingle;
        }
        [(TBTableViewBorderCell *) cell setPosition:position];
    }
    
    [self tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
    
    return cell;
}


@end
