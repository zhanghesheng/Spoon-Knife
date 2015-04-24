//
// Created by enfeng on 12-10-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBHorizontalScrollBar.h"
#import "TBHorizontalScrollBarCell.h"
#import "TBCore/TBCoreMacros.h"
#import "TBUICommon.h"

#define kItemFont [UIFont systemFontOfSize:14]

@implementation TBHorizontalScrollBar {

}
@synthesize items = _items;
@synthesize barDelegate = _barDelegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize cellClass = _cellClass;
@synthesize itemWidth = _itemWidth;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        CGFloat kRotation = (CGFloat) (M_PI / 180.0) * 90.0f;
        CGAffineTransform transform = CGAffineTransformMakeRotation(-kRotation);
        self.transform = transform;

        self.frame = frame;
        self.dataSource = self;
        self.delegate = self;

        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {

    }
    return self;
}

- (void)setItems:(NSArray *)pItems {
    _items = pItems;
    [self reloadData];
}

- (void)selectItem:(int)index {
    self.selectedIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_items == nil) {
        return 0;
    }
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TBHorizontalScrollBarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
        cell.textLabel.font = kItemFont;
    }
    NSInteger row = indexPath.row;
    NSObject *item = [_items objectAtIndex:row];
//    cell.textLabel.text = (NSString *)item;
//    cell.textLabel.backgroundColor = [UIColor clearColor];
    [cell setObject:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //这块很重要
    cell.backgroundColor = [UIColor clearColor];
    self.backgroundColor = RGBCOLOR(233, 233, 233);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSObject *obj = [self.items objectAtIndex:indexPath.row];
//    return [_cellClass tableView:tableView rowWidthForObject:obj];
    
    NSString *str = [self.items objectAtIndex:indexPath.row];
    CGSize size = [self textSizeOfString:str];
    //预留空隙
    if (_itemWidth > 1) {
        return _itemWidth;
    } else {
        return size.width + 20;
    }
}

- (CGSize)textSizeOfString:(NSString *)title {
    UIFont *font = kItemFont;
    CGSize textSize = [title sizeWithFont:font
                        constrainedToSize:CGSizeMake(1000, 99999.0)];
    return textSize;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    self.selectedIndex = row;
    if (_barDelegate && [_barDelegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [_barDelegate didSelectItemAtIndex:row];
    }
    if (_barDelegate && [_barDelegate respondsToSelector:@selector(didSelectItem:)]) {
        NSObject *obj = [self.items objectAtIndex:row];
        [_barDelegate didSelectItem:obj];
    }
}

- (void)dealloc {
    
}

@end