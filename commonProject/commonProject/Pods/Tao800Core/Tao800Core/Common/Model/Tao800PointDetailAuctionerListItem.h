//
//  Tao800AuctionerListItem.h
//  tao800
//
//  Created by LeAustinHan on 14-1-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

@interface Tao800PointDetailAuctionerListItem : TBTableViewItem
{
    NSString *_name;
    NSString *_price;
    NSString *_date;
    NSString *_grade;
    BOOL      _getOrNot;
}

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *grade;
@property(nonatomic,assign)BOOL    getOrNot;

@end

