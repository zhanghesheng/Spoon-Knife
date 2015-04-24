//
//  Tao800MobileRecordVo.m
//  tao800
//
//  Created by adminName on 14-3-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MobileRecordVo.h"

@implementation Tao800MobileRecordVo
@synthesize status = _status;
@synthesize number = _number;
@synthesize time = _time;
@synthesize price = _price;

- (void)dealloc {
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_status forKey:@"status"];
    [aCoder encodeObject:_number forKey:@"number"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_price forKey:@"price"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.number = [aDecoder decodeObjectForKey:@"number"];
    self.time = [aDecoder decodeObjectForKey:@"time"];
    self.price = [aDecoder decodeObjectForKey:@"price"];
    return self;
}

@end
