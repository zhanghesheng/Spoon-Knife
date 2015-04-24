//
//  Tao800ScrollPageVCL.h
//  tao800
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

@interface Tao800ScrollPageVCL : TBScrollPageController
{
    __weak CALayer *lineLayer; //topBar和scrollView之间的线条
}
-(void)hiddenLayer:(BOOL)status;
@end
