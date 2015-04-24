//
//  UILabelAddtions.h
//  NSAttributedStringDemo
//
//  Created by enfeng on 14-1-29.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 * 如:
 * <font face='Helvetica' size='13' color='#E50F3C' line='u' >Hello world</font>
 *  标签属性取值：
 *  
 *  line: u 下划线
 */
- (void) styleAttributedText:(NSString*) styleText NS_AVAILABLE_IOS(6_0);
@end
