//
// Created by enfeng on 12-11-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "TBTableViewBaseCell.h"

@interface TBTableViewCell : TBTableViewBaseCell {
    NSObject *_item;
}
@property(nonatomic, strong) id object;
@property(nonatomic, strong) id item;

/**
 * Measure the height of the row with the object that will be assigned to the cell.
 */
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;
@end