//
// Created by enfeng on 13-1-24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBTableFlushViewCell.h"

#import "TBTableViewItem.h"
#import "TBUICommon.h"

@implementation TBTableFlushViewCell

@synthesize item = _item;
@synthesize view = _view;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return TBDefaultRowHeight;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = self.contentView.bounds;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object {
    return _item ? _item : (id) _view;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (object != _view && object != _item) {
        [_view removeFromSuperview]; 

        if ([object isKindOfClass:[UIView class]]) {
            _view = object;

        } else if ([object isKindOfClass:[TBTableViewItem class]]) {
            _item = object;
            _view = _item.view;
        }

        [self.contentView addSubview:_view];
    }
}


@end