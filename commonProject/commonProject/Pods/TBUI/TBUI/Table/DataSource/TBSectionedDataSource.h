//
// Created by enfeng on 12-11-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBTableViewDataSource.h"

@interface TBSectionedDataSource : TBTableViewDataSource {
    NSMutableArray* _sections;
}
@property (nonatomic, strong) NSMutableArray* sections;

- (id)initWithItems:(NSArray*)items sections:(NSArray*)sections;

- (void)removeItemAtIndexPath:(NSIndexPath*)indexPath;

- (BOOL)removeItemAtIndexPath:(NSIndexPath*)indexPath andSectionIfEmpty:(BOOL)andSection;

+ (TBSectionedDataSource *)dataSourceWithObjects:(id)object, ...;
@end