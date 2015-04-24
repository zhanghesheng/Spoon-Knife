//
// Created by enfeng on 12-10-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TBHorizontalScrollBarCell : UITableViewCell {
    NSObject *_item;
}
- (void)setObject:(NSObject *)obj;

+ (CGFloat)tableView:(UITableView *)tableView rowWidthForObject:(id)object;

@end