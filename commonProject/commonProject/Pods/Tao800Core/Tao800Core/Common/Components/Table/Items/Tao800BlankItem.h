//
//  Tao800BlankItem.h
//  tao800
//
//  Created by LeAustinHan on 14-10-22.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Tao800BlankItemTypeFiveBusiness = 100,
    Tao800BlankItemTypeVirtualFitting = 111,
    Tao800BlankItemTypeDealCounts = 122,
    Tao800BlankItemTypePromotionBusiness = 123
} Tao800BlankItemType;

@interface Tao800BlankItem : NSObject

@property (nonatomic) BOOL enableDisplayTopLine;
@property (nonatomic) BOOL enableDisplayBottomLine;
@property (nonatomic) Tao800BlankItemType blankItemType;
@property (nonatomic) CGFloat lineHeight;
@property (nonatomic,strong) UIColor* backgroundColor;
@end
