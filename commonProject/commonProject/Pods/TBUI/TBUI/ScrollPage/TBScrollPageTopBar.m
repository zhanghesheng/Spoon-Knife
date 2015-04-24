//
//  TBScrollPageTopBar.m
//  TBScrollPageDemo
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import "TBScrollPageTopBar.h"
#import "TBScrollPageController.h"
#import "TBScrollPageTopBarCell.h"

@implementation TBScrollPageTopBar

@synthesize selectedIndex = _selectedIndex;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        double dRotation = (M_PI / 180.0) * 90.0f;
        CGFloat fRotation = (CGFloat) dRotation;
        CGAffineTransform transform = CGAffineTransformMakeRotation(-fRotation);
        self.transform = transform;
        self.frame = frame;

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;

        self.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {

    }
    return self;
}

- (void)dealloc {

}

- (void)selectItem:(NSInteger)index {
    self.selectedIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    TBScrollPageController *dc = (TBScrollPageController *) self.dataSource;
    id object = [dc tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dc tableView:tableView cellClassForObject:object];

    return [cls pageTopBar:tableView columnWidthForObject:object];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    self.selectedIndex = row;
    if (_barDelegate && [_barDelegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [_barDelegate didSelectItemAtIndex:indexPath];
    }
}
@end
