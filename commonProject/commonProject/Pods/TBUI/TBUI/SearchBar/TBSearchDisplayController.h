//
//  TBtbSearchDisplayController.h
//  CustomSearchBarDemo
//
//  Created by enfeng on 13-12-15.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TBSearchDisplayDelegate;
@class UIViewController;
@class TBSearchBar;

@interface TBSearchDisplayController : NSObject<UITableViewDelegate> {
 
    UITableView *_searchResultsTableView;
    TBSearchBar *_searchBar;
    UIView *_backgroundView;
}
@property(nonatomic, readonly) UIViewController *searchContentsController;
@property(nonatomic, readonly) UITableView *searchResultsTableView;
@property(nonatomic, readonly) TBSearchBar *searchBar;
@property(nonatomic, weak) id <UITableViewDataSource> searchResultsDataSource;
@property(nonatomic, weak) id <UITableViewDelegate> searchResultsDelegate;
@property(nonatomic, readonly) UIView *backgroundView;
@property(nonatomic, weak) id<TBSearchDisplayDelegate> delegate;

- (id)initWithSearchBar:(TBSearchBar *)searchBar contentsController:(UIViewController *)viewController;

@end

@protocol TBSearchDisplayDelegate <NSObject>
@optional

- (void) tbSearchDisplayControllerWillBeginSearch:(TBSearchDisplayController *)controller;
- (void) tbSearchDisplayControllerDidBeginSearch:(TBSearchDisplayController *)controller;
- (void) tbSearchDisplayControllerWillEndSearch:(TBSearchDisplayController *)controller;
- (void) tbSearchDisplayControllerDidEndSearch:(TBSearchDisplayController *)controller;

// called when the table is created destroyed, shown or hidden. configure as necessary.
- (void)tbSearchDisplayController:(TBSearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView;
- (void)tbSearchDisplayController:(TBSearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;

// called when table is shown/hidden
- (void)tbSearchDisplayController:(TBSearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView;
- (void)tbSearchDisplayController:(TBSearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView;
- (void)tbSearchDisplayController:(TBSearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView;
- (void)tbSearchDisplayController:(TBSearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView;

// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
- (BOOL)tbSearchDisplayController:(TBSearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
- (BOOL)tbSearchDisplayController:(TBSearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption;


@end
