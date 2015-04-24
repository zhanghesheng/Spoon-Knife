//
//  TBSearchDisplayController.m
//  CustomSearchBarDemo
//
//  Created by enfeng on 13-12-15.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBSearchDisplayController.h"
#import "TBSearchBar.h"

enum {
    TBSearchDisplayControllerLabelTag = 22233
};

@interface TBSearchDisplayController()<TBSearchBarDelegate, UIGestureRecognizerDelegate> {
    
}
@property (nonatomic, strong) UITapGestureRecognizer * hidingKeyboardGesture;
@end

@implementation TBSearchDisplayController

@synthesize searchBar = _searchBar;
@synthesize searchContentsController = _searchContentsController;
@synthesize searchResultsTableView = _searchResultsTableView;
@synthesize backgroundView = _backgroundView;

 
- (void) handleTapBackground:(UIGestureRecognizer*) gestureRecogizer {

    [self.searchBar.searchTextField resignFirstResponder];
    [self tbSearchBarCancelButtonClicked:nil];
}

- (void) addTapGesture {
    [self.backgroundView addGestureRecognizer:self.hidingKeyboardGesture];
    [self.hidingKeyboardGesture addTarget:self action:@selector(handleTapBackground:)];
    self.hidingKeyboardGesture.delegate = self;
}

- (id)initWithSearchBar:(TBSearchBar *)searchBar contentsController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _searchContentsController = viewController;
        _searchBar = searchBar;
        _searchBar.searchDisplayDelegate = self;

        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(searchBar.frame.origin.x,
                searchBar.frame.origin.y+searchBar.frame.size.height, searchBar.frame.size.width,
                viewController.view.frame.size.height-searchBar.frame.size.height-searchBar.frame.origin.y)];
        [viewController.view addSubview:_backgroundView];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.hidden = YES;

        self.hidingKeyboardGesture = [[UITapGestureRecognizer alloc]init];
        [self addTapGesture];
    }
    return self;
}

- (void) showTable:(TBSearchBar *)searchBar {
    if (!(searchBar.searchTextField.text
            && searchBar.searchTextField.text.length>0)) {
        if (_searchResultsTableView) {
            [_searchResultsTableView removeFromSuperview];
            _searchResultsTableView = nil;
        }
        [self addTapGesture];
        return;
    }

    if (_searchResultsTableView == nil) {
        _searchResultsTableView = [[UITableView alloc] initWithFrame:_backgroundView.bounds style:UITableViewStylePlain];
        [_backgroundView addSubview:_searchResultsTableView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, self.backgroundView.frame.size.width, 44)];
        [_searchResultsTableView addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor =[UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
//                                 label.hidden = YES;
        label.tag = TBSearchDisplayControllerLabelTag;

    } else {
        _searchResultsTableView.frame = _backgroundView.bounds;
    }
    _searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                             _searchResultsTableView.delegate = self;
    _searchResultsTableView.delegate = self.searchResultsDelegate;
    _searchResultsTableView.dataSource = self.searchResultsDataSource;
    [self.backgroundView removeGestureRecognizer:self.hidingKeyboardGesture];
}


- (void)tbSearchBarTextDidBeginEditing:(TBSearchBar *)searchBar {
    CGRect viewRect = self.searchContentsController.view.frame;
    CGRect sRect = self.searchBar.frame;
    _backgroundView.frame = CGRectMake(sRect.origin.x,
                                       sRect.origin.y+sRect.size.height,
                                       sRect.size.width,
                                       viewRect.size.height-sRect.size.height-sRect.origin.y);
    [self.searchContentsController.view bringSubviewToFront:_backgroundView];
//    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _backgroundView.hidden = NO;

    [UIView animateWithDuration:.3
                     animations:^{
                         _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
                     }
                     completion:^(BOOL finish) {
                         if (finish) {
                            [self showTable:searchBar];
                         }
                     }];
}

- (void)tbSearchBarCancelButtonClicked:(TBSearchBar *) searchBar {
    if (_searchResultsTableView) {
        _searchResultsTableView.hidden = YES;
    }
    [UIView animateWithDuration:.3
                     animations:^{
                         _backgroundView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finish) {
                    if (finish) {
                        _backgroundView.hidden = YES;

                        if (_searchResultsTableView)  {

                            [_searchResultsTableView removeFromSuperview];
                            _searchResultsTableView = nil;
                        }
                    }
                     }];
}

- (void)tbSearchBar:(TBSearchBar *)searchBar textDidChange:(NSString *)searchText {
    UILabel *label = (UILabel*) [_searchResultsTableView viewWithTag:TBSearchDisplayControllerLabelTag];

    [self showTable:searchBar];

    BOOL shouldRefloadData = YES;
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(tbSearchDisplayController:shouldReloadTableForSearchString:)]) {
        shouldRefloadData = [self.delegate tbSearchDisplayController:self shouldReloadTableForSearchString:searchText];
    }
    if (shouldRefloadData) {
        [_searchResultsTableView reloadData];
    }
    
    NSInteger count = [_searchResultsTableView.dataSource tableView:_searchResultsTableView numberOfRowsInSection:0];
    label.hidden = (count>0 || searchText.length<1);

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if (touch.view == _backgroundView) {
//        return YES;
//    }
    return YES;
}

@end
