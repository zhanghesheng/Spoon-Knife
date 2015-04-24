//
//  Tao800SearchHomeVCL.h
//  tao800
//
//  Created by worker on 14-2-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListVCL.h"
#import "TBUI/TBSearchBar.h"
#import "Tao800SearchHomeBottomView.h"
#import "Tao800ConfigManage.h"
#import "Tao800SearchNoDealHeaderView.h"

@class Tao800SearchSuggestionVCL;
typedef enum RequestType {
    RequsetTypeSearchSuggestion = 0,
    RequsetTypeSearchHistory = 1,
    RequsetTypeSearchDeals = 2,
    RequsetTypeRecommendDeals = 3,
}RequestType;

typedef void (^SearchHomeBackBlock)(void);

@interface Tao800SearchHomeVCL : Tao800DealListVCL <TBSearchBarDelegate, Tao800SearchNoDealHeaderViewDelegate>

@property (nonatomic,strong) Tao800ConfigManage *configManage;
@property (nonatomic,weak) IBOutlet TBSearchBar *searchBar;
@property (nonatomic,strong) Tao800SearchNoDealHeaderView *noDealHeaderView;
@property (nonatomic,assign) RequestType requestType;
@property (nonatomic, strong) UIButton *searchSwitchButton;
@property(nonatomic, copy)NSString *wishWord;
@property(nonatomic, copy)SearchHomeBackBlock backBlock;
@property (nonatomic, strong) Tao800SearchSuggestionVCL *suggestionVCL;
@property(nonatomic) NSString *cId;

-(void)tbSearchBar:(TBSearchBar *)searchBar textDidChange:(NSString *)searchText;
-(void)tbSearchBarSearchButtonClicked:(TBSearchBar *)searchBar;
-(void)tbSearchBarTextDidBeginEditing:(TBSearchBar *)searchBar;
@end
