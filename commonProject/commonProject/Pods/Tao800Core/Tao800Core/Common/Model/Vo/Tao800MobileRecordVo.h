//
//  Tao800MobileRecordVo.h
//  tao800
//
//  Created by adminName on 14-3-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800MobileRecordVo : NSObject<NSCoding>{
    NSString *_status;
    NSString *_number;
    NSString *_time;
    NSString *_price;
}
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *number;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *price;

@end
