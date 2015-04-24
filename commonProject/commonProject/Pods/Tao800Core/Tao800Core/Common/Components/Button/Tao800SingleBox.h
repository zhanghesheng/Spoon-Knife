//
//  Tao800SingleBox.h
//  tao800
//
//  Created by Rose on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum __Tao800SingleBoxSelected{
    Tao800SingleBoxSelectedAll = 0,
    Tao800SingleBoxSelectedCat = 1,
    Tao800SingleBoxSelectedTao = 2,
    Tao800SingleBoxSelectedShop = 4//特卖商城
}Tao800SingleBoxSelected;

@interface Tao800SingleBoxManage : NSObject
{
    NSMutableArray *_singleBoxArray;
    NSInteger _currentSelected;
}
@property(nonatomic,strong) NSMutableArray *singleBoxArray;
@property(nonatomic,readonly) NSInteger currentSelected;

-(id)initWithSingleBoxTotalNumber:(NSInteger)number;

-(void)resetBoxSelected:(NSInteger)number;
@end

@interface Tao800SingleBox : UIButton
{
    Tao800SingleBoxManage __weak *_boxManage;
}
@property(nonatomic,weak)Tao800SingleBoxManage *boxManage;

- (void)changeSelectedStyle;
- (void)normalStyle;
@end
