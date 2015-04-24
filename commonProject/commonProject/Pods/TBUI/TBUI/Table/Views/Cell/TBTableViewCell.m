//
// Created by enfeng on 12-11-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBTableViewCell.h"
#import "TBUICommon.h"
#import "TBCore/TBCoreMacros.h"

@implementation TBTableViewCell {

}

@synthesize item = _item;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return TBDefaultRowHeight;
}

- (void)dealloc {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object {
    return _item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        _item = object;
    }
}

@end