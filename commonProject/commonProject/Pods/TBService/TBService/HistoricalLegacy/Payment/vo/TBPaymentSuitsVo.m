//
//  TBPaymentSuitsVo.m
//  Core
//
//  Created by 卢 飞 on 13-1-24.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "TBPaymentSuitsVo.h"

@implementation TBPaymentSuitsVo
@synthesize name = _name;
@synthesize price = _price;
@synthesize misSuitId = _misSuitId;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.misSuitId forKey:@"mis_suit_id"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.price = [aDecoder decodeObjectForKey:@"price"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.misSuitId = [aDecoder decodeObjectForKey:@"mis_suit_id"];
    return self;
}

- (void)dealloc {
 
}

@end
