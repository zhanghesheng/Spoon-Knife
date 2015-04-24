//
//  Tao800BrandSectionVo.h
//  tao800
//
//  Created by adminName on 14-4-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800BrandSectionVo : NSObject <NSCoding>
{
    NSString *_logoImage;
    NSString *_name;
    NSString *_discount;
    
}
@property(nonatomic, copy) NSString *logoImage;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *discount;

@end
