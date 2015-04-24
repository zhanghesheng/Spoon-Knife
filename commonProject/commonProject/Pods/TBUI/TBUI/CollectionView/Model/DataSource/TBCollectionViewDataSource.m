//
//  TBCollectionViewDataSource.m
//  TBUI
//
//  Created by enfeng on 14-7-17.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//
#import "TBCollectionViewCell.h"
#import "TBCollectionViewDataSource.h"
#import "TBCollectionSupplementaryViewItem.h"
#import "TBCollectionViewCellItem.h"

@implementation TBCollectionViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray arrayWithCapacity:10];
        self.sections = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (id)collectionView:(UICollectionView *)collectionView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* xItems = self.items;
    
    if (self.sections.count>0 && indexPath.section<self.items.count) {
        xItems = self.items[indexPath.section];
    }
    
    if (indexPath.row < xItems.count) {
        return xItems[indexPath.row];
    } else {
        return nil;
    }
}

- (Class)collectionView:(UICollectionView *)collectionView cellClassForObject:(id)object {
    return [TBCollectionViewCell class];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if (self.sections.count>0) {
        NSArray *xItems = self.items[section];
        count = xItems.count;
    } else {
        count = self.items.count;
    }
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSUInteger count = self.sections.count;
    if ( count > 1 ) {
        return count;
    } else {
        return 1;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self collectionView:collectionView objectForRowAtIndexPath:indexPath];
    Class cellClass = [self collectionView:collectionView cellClassForObject:object];
    NSString *identifier = [cellClass tbIdentifier];
    
    UICollectionViewCell *cell =
    (UICollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[cellClass alloc] init];
    }
    if ([cell isKindOfClass:[TBCollectionViewCell class]]) {
        [(TBCollectionViewCell *) cell setObject:object];
    }

    return cell;
}
@end
