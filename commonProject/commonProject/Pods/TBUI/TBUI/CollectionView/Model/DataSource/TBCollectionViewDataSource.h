//
//  TBCollectionViewDataSource.h
//  TBUI
//
//  Created by enfeng on 14-7-17.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *sections;

- (Class)collectionView:(UICollectionView *)collectionView cellClassForObject:(id)object;

- (id)collectionView:(UICollectionView *)collectionView objectForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
