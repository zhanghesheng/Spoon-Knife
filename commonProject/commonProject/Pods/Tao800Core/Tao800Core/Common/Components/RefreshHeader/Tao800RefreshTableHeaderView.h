//
//  Tao800RefreshTableHeaderView.h
//  tao800
//
//  Created by enfeng on 14-3-6.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>
#import "Tao800PrdValueView.h"

@interface Tao800RefreshTableHeaderView : RefreshTableHeaderView

@property (nonatomic, weak) TBTableViewCTL *tableViewCTL; //用于兼容老代码
@property(nonatomic,strong) Tao800PrdValueView* prdValueView;

- (id)initWithFrameAndPrdValue:(CGRect)frame;
@end
