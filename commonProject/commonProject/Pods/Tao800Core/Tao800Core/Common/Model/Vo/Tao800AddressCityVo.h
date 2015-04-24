//
//  Tao800AddressCityVo.h
//  tao800
//
//  Created by wuzhiguang on 13-4-11.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800AddressCityVo : NSObject
{
    NSString *_cityId;
    NSString *_name;
    NSString *_parentId;
    NSString *_pinyin;
}

@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *parentId;
@property (nonatomic,strong) NSString *pinyin;

@end
