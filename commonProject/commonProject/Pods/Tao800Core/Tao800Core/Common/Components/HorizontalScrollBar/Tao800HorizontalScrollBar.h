//
// Created by enfeng on 12-5-30.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBCore/TBCore.h"
#import "TBUI/TBUI.h"

@interface Tao800HorizontalScrollBarItem : NSObject {
    NSString *_title;
    NSMutableDictionary *_paramDict;
}
@property(nonatomic, strong) NSMutableDictionary *paramDict;
@property(nonatomic, copy) NSString *title;

@end

@interface Tao800HorizontalScrollBarCell : UITableViewCell {
    NSObject *_item;
    UIView *_colorView;
    TBImageView *_sepView;
}
- (void)setObject:(NSObject *)obj;
@property(nonatomic) int width;
@end


@protocol Tao800HorizontalScrollBarDelegate <NSObject>
- (void)didSelectItemAtIndex:(NSInteger)index;
@end

@interface Tao800HorizontalScrollBar : UITableView <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_items;
    id <Tao800HorizontalScrollBarDelegate> __weak _barDelegate;
    CGFloat _itemWidth;
    NSInteger _selectedIndex;
}
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, weak) id <Tao800HorizontalScrollBarDelegate> barDelegate;
@property(nonatomic) CGFloat itemWidth;
@property(nonatomic) NSInteger selectedIndex;


- (void)setItems:(NSArray *)pItems;
- (void)selectItem:(NSInteger)index;
-(void)selectItem:(NSInteger)index animated:(BOOL)animated;
- (CGSize)textSizeOfString:(NSString *)title;
@end