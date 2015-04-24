//
// Created by enfeng on 12-11-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <objc/runtime.h>
#import "TBSectionedDataSource.h"
#import "TBCore/TBCoreMacros.h"
#import "TBTableViewCell.h"
#import "TBTableViewBorderCell.h"

@implementation TBSectionedDataSource {

}
@synthesize sections  = _sections;

- (void)dealloc
{
}

- (id)initWithItems:(NSArray*)items sections:(NSArray*)sections {
	self = [self init];
    if (self) {
        _items    = [items mutableCopy];
        _sections = [sections mutableCopy];
    }
    
    return self;
}

- (id) initWithItems:(NSArray *)items {
   	self = [self init];
    if (self) { 
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];

    Class cellClass = [self tableView:tableView cellClassForObject:object];
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
            else {
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections ? _sections.count : 1;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sections) {
        NSArray* items = [_items objectAtIndex:section];
        return items.count;
        
    } else {
        return _items.count;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sections.count) {
        return [_sections objectAtIndex:section];
        
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark TBSectionedDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (_sections) {
        NSArray* section = [_items objectAtIndex:indexPath.section];
        return [section objectAtIndex:indexPath.row];
        
    } else {
        return [_items objectAtIndex:indexPath.row];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object {
    if (_sections) {
        for (int i = 0; i < _items.count; ++i) {
            NSMutableArray* section = [_items objectAtIndex:i];
            NSUInteger objectIndex = [section indexOfObject:object];
            if (objectIndex != NSNotFound) {
                return [NSIndexPath indexPathForRow:objectIndex inSection:i];
            }
        }
        
    } else {
        NSUInteger objectIndex = [_items indexOfObject:object];
        if (objectIndex != NSNotFound) {
            return [NSIndexPath indexPathForRow:objectIndex inSection:0];
        }
    }
    
    return nil;
}

- (void)removeItemAtIndexPath:(NSIndexPath*)indexPath {
    [self removeItemAtIndexPath:indexPath andSectionIfEmpty:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)removeItemAtIndexPath:(NSIndexPath*)indexPath andSectionIfEmpty:(BOOL)andSection {
    if (_sections.count) {
        NSMutableArray* items = [_items objectAtIndex:indexPath.section];
        [items removeObjectAtIndex:indexPath.row];
        if (andSection && !items.count) {
            [_sections removeObjectAtIndex:indexPath.section];
            [_items removeObjectAtIndex:indexPath.section];
            return YES;
        }
        
    } else if (!indexPath.section) {
        [_items removeObjectAtIndex:indexPath.row];
    }
    return NO;
}

+ (TBSectionedDataSource *)dataSourceWithObjects:(id)object, ... {
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *section = nil;
    va_list ap;
    va_start(ap, object);
    while (object) {
        if ([object isKindOfClass:[NSString class]]) {
            [sections addObject:object];
            section = [NSMutableArray array];
            [items addObject:section];
            
        } else {
            [section addObject:object];
        }
        object = va_arg(ap, id);
    }
    va_end(ap);
    
    return [[self alloc] initWithItems:items sections:sections];
}


@end