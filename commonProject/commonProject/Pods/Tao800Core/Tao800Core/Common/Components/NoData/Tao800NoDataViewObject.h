//
//  Tao800NoDataViewObject.h
//  tao800
//
//  Created by enfeng on 14/11/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800NoDataView.h"

@interface Tao800NoDataViewObject : NSObject

@property (nonatomic, strong) Tao800NoDataView *noDataView;

/**
 * 无数据时的提示
 *
 * @param title 
 * @param detail 可以为空
 * @param centerImage
 * @param buttonTitle
 */
- (instancetype) initWithTitle:(NSString*) title
                        detail:(NSString*) detail
                   centerImage:(UIImage*) centerImage
                   buttonTitle:(NSString*) buttonTitle;
@end
