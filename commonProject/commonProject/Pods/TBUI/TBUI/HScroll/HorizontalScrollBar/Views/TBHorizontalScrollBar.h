//
// Created by enfeng on 12-10-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TBHorizontalScrollBarDelegate <NSObject>
@optional
- (void)didSelectItemAtIndex:(NSInteger)index;
@required
- (void)didSelectItem:(NSObject *)item;
@end

@interface TBHorizontalScrollBar : UITableView <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_items; 
    NSInteger _selectedIndex;
    Class _cellClass;
    CGFloat _itemWidth;
}
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, weak) id <TBHorizontalScrollBarDelegate> barDelegate;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic, assign) Class cellClass;
@property(nonatomic) CGFloat itemWidth;

- (void)setItems:(NSArray *)pItems;

- (void)selectItem:(int)index;

@end