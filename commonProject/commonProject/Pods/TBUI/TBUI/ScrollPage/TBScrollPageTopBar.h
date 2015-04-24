//
//  TBScrollPageTopBar.h
//  TBScrollPageDemo
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TBScrollPageTopBarDelegate <NSObject>
- (void)didSelectItemAtIndex:(NSIndexPath *)indexPath;
@end

@interface TBScrollPageTopBar : UITableView <UITableViewDelegate>{
    NSInteger _selectedIndex;
}
@property(nonatomic, weak) id <TBScrollPageTopBarDelegate> barDelegate;
@property(nonatomic) NSInteger selectedIndex;

- (void)selectItem:(NSInteger)index;
@end
