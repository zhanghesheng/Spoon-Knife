//
// Created by enfeng on 12-11-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TBTableViewDataSourceInterface <UITableViewDataSource>

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object;

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object;

- (void)    tableView:(UITableView *)tableView cell:(UITableViewCell *)cell
willAppearAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface TBTableViewDataSource : NSObject <TBTableViewDataSourceInterface> {
    NSMutableArray *_items;

    //如果为Yes，则根据类名载入nib文件
    BOOL _loadNibWithClassName;
}
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, assign) BOOL loadNibWithClassName;


- (id)initWithItems:(NSArray *)items;

@end