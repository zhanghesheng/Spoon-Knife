//
//  Tao800MyGradeVo.h
//  tao800
//
//  Created by ayvin on 13-4-21.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800MyGradeVo : NSObject <NSCoding> {
    int grade;
    int price;
}

@property(nonatomic, assign) int grade;
@property(nonatomic, assign) int price;

/**
* 用于商品列表加积分
*/
- (NSString *) getGradeKey;

@end
