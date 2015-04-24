//
//  Tao800SearchSuggestionVCL.m
//  tao800
//
//  Created by enfeng on 14-7-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SearchSuggestionVCL.h"
#import "Tao800SearchHistoryItem.h"
#import "Tao800SearchSuggestionItem.h"
#import "Tao800SearchSuggestionModel.h"
#import "Tao800SearchHomeDataSource.h"
#import "Tao800ForwardSegue.h"
#import "Tao800SearchHomeBottomView.h"

@interface Tao800SearchSuggestionVCL ()

@property (nonatomic, weak)  UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation Tao800SearchSuggestionVCL

- (void) dealloc {
 
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.suggestionModel = [[Tao800SearchSuggestionModel alloc] init];
        self.enableControlTableViewBG = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) resetBottomButton {
    self.bottomView = [[Tao800SearchHomeBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    [_bottomView.clearButton addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
}

- (BOOL)needRedrawStatusBar {
    return NO;
}

- (void) tapView:(UIGestureRecognizer *) gestureRecognizer {
     if (self.tapBgCallBack) {
         self.tapBgCallBack();
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetBottomButton];
    
    if (self.enableControlTableViewBG) {
        
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self.view addGestureRecognizer:tapGestureRecognizer1];
        self.tapGestureRecognizer = tapGestureRecognizer1;
        
        NSArray *keywords = [self.suggestionModel getSearchKeywords];
        if (keywords.count > 0) {
            self.view.backgroundColor = [UIColor whiteColor];
        } else {
            self.view.backgroundColor = [UIColor colorWithWhite:.2 alpha:.6];
        }
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
     
}

#pragma mark 清空搜索历史记录
- (void)clearSearchHistory {
    [self.suggestionModel saveSearchKeyword:nil];
    [self loadItems];
    self.tableView.tableFooterView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.view.superview endEditing:YES];
    if (self.tapGestureRecognizer.enabled) {
        [self tapView:nil];
    }
}

- (void)loadItems {
    Tao800SearchHomeDataSource *dc = [[Tao800SearchHomeDataSource alloc] initWithItems:self.suggestionModel.items];
    self.dataSource = dc;

    if (self.enableControlTableViewBG) {
        if (self.suggestionModel.items.count<1) {
            self.tableView.backgroundColor = [UIColor clearColor];
            self.tapGestureRecognizer.enabled = YES;
            
            self.view.backgroundColor = [UIColor colorWithWhite:.2 alpha:.6];
        } else {
            self.tableView.backgroundColor = [UIColor whiteColor];
            self.tapGestureRecognizer.enabled = NO;
            
            self.view.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)getSearchHistory {

    CGPoint offset = self.tableView.contentOffset;
    offset.y = 0;
    self.tableView.contentOffset = offset;

    NSArray *keywords = [self.suggestionModel getSearchKeywords];
    if (keywords.count > 0) {

        [self.suggestionModel loadHistoryItems];

        [self loadItems];
        if (self.suggestionModel.items.count>0) {
            self.tableView.tableFooterView = _bottomView;
        }  else {
            self.tableView.tableFooterView = nil;
        }
    } else {
        [self.suggestionModel.items removeAllObjects];
        [self loadItems];
        self.tableView.tableFooterView = nil;
    }
}

- (void)getSearchSuggestion {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self hidePageTip];

    self.tableView.tableFooterView = nil;

    __weak Tao800SearchSuggestionVCL *instance = self;
    [instance.suggestionModel loadItems:nil
                             completion:^(NSDictionary *dict) {
                                 if (instance.suggestionModel.keyword) {
                                     [instance loadItems];
                                 }

    }
                                failure:^(TBErrorDescription *error) {
                                    
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger index = indexPath.row;
    NSInteger count = self.suggestionModel.items.count;
    if (index>count-1) {
        return;
    }

    NSObject *selectItem = [self.suggestionModel.items objectAtIndex:(uint) index];

    if (selectItem == nil) {
        return;
    }
    NSString *keyword = nil;
    if ([selectItem isKindOfClass:[Tao800SearchHistoryItem class]]) {
        Tao800SearchHistoryItem *item = (Tao800SearchHistoryItem *) selectItem;
        if (item.isHeader) {
            return;
        }
        keyword = item.keyword;
    } else if ([selectItem isKindOfClass:[Tao800SearchSuggestionItem class]]) {
        Tao800SearchSuggestionItem *item = (Tao800SearchSuggestionItem *) selectItem;
        Tao800SearchSuggestionVo *vo = item.vo;
        [self.suggestionModel saveSearchKeyword:vo.word];
        keyword = vo.word;
    }
    if (!keyword) {
        keyword = self.suggestionModel.keyword;
    }

    if (self.goBackBlock) {
        NSDictionary *dict = @{
                @"searchKeyword" : keyword
        };
        self.goBackBlock(YES, dict);
    }
}

@end
