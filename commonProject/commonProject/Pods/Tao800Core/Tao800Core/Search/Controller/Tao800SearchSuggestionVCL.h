//
//  Tao800SearchSuggestionVCL.h
//  tao800
//
//  Created by enfeng on 14-7-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800TableVCL.h"
#import "Tao800SearchHomeBottomView.h"

@class Tao800SearchSuggestionModel;

typedef void (^Tao800SearchSuggestionTapBgCallBack)(void);

@interface Tao800SearchSuggestionVCL : Tao800TableVCL
@property(nonatomic, strong) Tao800SearchSuggestionModel *suggestionModel;
@property (nonatomic,strong) Tao800SearchHomeBottomView *bottomView;
@property (nonatomic, copy) Tao800SearchSuggestionTapBgCallBack tapBgCallBack;

@property (nonatomic) BOOL enableControlTableViewBG; //是否可以控制tableview的背景透明，默认不可以

- (void)getSearchHistory;

- (void)getSearchSuggestion;

- (void) resetBottomButton;
@end
