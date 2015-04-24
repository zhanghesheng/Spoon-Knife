//
// Created by enfeng on 12-11-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <objc/runtime.h>
#import "TBTableViewDataSource.h"

#import "TBTableViewCell.h"
#import "TBCore/TBCoreMacros.h"
#import "TBTableFlushViewCell.h"
#import "TBTableViewBorderCell.h"
#import "TBTableFlushViewBorderCell.h"

@implementation TBTableViewDataSource {

}
@synthesize items = _items;
@synthesize loadNibWithClassName = _loadNibWithClassName;


- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _items.count) {
        return [_items objectAtIndex:indexPath.row];

    } else {
        return nil;
    }
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[TBTableViewBorderCell class]]) {
        return [TBTableFlushViewBorderCell class];
    } else if ([object isKindOfClass:[UIView class]]) {
        return [TBTableFlushViewCell class];
    }
    return [TBTableViewCell class];
}

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object {
    return nil;
}

- (void)    tableView:(UITableView *)tableView cell:(UITableViewCell *)cell
willAppearAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark UITableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];

    Class cellClass = [self tableView:tableView cellClassForObject:object];
//    NSString *identifier2 = NSStringFromClass(cellClass);
    
    NSString *identifier = [cellClass tbIdentifier];
    if (!identifier) {
        const char *className = class_getName(cellClass);
        identifier = [[NSString alloc] initWithBytesNoCopy:(char *) className
                                                    length:strlen(className)
                                                  encoding:NSASCIIStringEncoding freeWhenDone:NO];
    }
 
    UITableViewCell *cell =
            (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSString *nibName = nil;
        if ([cellClass isSubclassOfClass:[TBTableViewBaseCell class]]) {
             nibName = [cellClass nibName];
        }

        if (!nibName && self.loadNibWithClassName) {
             nibName = identifier;
        }

        if (nibName) {
            if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
                if (nib && nib.count > 0) {
                    cell = (UITableViewCell *) [nib objectAtIndex:0];
                }
            }
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
//            if (nib && nib.count>0) {
//                cell = (UITableViewCell *)[nib objectAtIndex:0];
//            }
            else {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
            }
        } else {
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        }
    }

    if ([cell isKindOfClass:[TBTableViewCell class]]) {
        [(TBTableViewCell *) cell setObject:object];
    }

    [self tableView:tableView cell:cell willAppearAtIndexPath:indexPath];

    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)sectionIndex {
    if (tableView.tableHeaderView) {
        if (sectionIndex == 0) {
            // This is a hack to get the table header to appear when the user touches the
            // first row in the section index.  By default, it shows the first row, which is
            // not usually what you want.
            [tableView scrollRectToVisible:tableView.tableHeaderView.bounds animated:NO];
            return -1;
        }
    }

    NSString *letter = [title substringToIndex:1];
    NSInteger sectionCount = [tableView numberOfSections];
    for (NSInteger i = 0; i < sectionCount; ++i) {
        NSString *section = [tableView.dataSource tableView:tableView titleForHeaderInSection:i];
        if ([section hasPrefix:letter]) {
            return i;
        }
    }
    if (sectionIndex >= sectionCount) {
        return sectionCount - 1;

    } else {
        return sectionIndex;
    }
}

- (id)initWithItems:(NSArray *)items {
    self = [self init];
    if (self) {
        _items = [items mutableCopy];
    }

    return self;
}

- (void)dealloc { 
}
@end