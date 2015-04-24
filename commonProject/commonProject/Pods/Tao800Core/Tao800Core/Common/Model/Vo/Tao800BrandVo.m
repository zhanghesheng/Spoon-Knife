//
//  Tao800BrandVo.m
//  tao800
//
//  Created by adminName on 14-6-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BrandVo.h"
 
@implementation Tao800BrandVo

-(id)copyWithZone:(NSZone *)zone{
    Tao800BrandVo *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.dealImageURL1 = self.dealImageURL1;
        copy.dealImageURL2 = self.dealImageURL2;
        copy.price1 = self.price1;
        copy.price2 = self.price2;
        copy.discount1 = self.discount1;
        copy.discount2 = self.discount2;
        copy.iconImageURL = self.iconImageURL;
        copy.title = self.title;
        copy.discountLeft = self.discountLeft;
        copy.limit = self.limit;
        copy.descriString = self.descriString;
        copy.beginTime = self.beginTime;
        copy.name = self.name;
    }
    return copy;
}
-(id)initWithCoder:(NSCoder *)coder{
    
    self = [super init];
    if (self) {
        self.dealImageURL1 = [coder decodeObjectForKey:@"self.dealImageURL1"];
        self.dealImageURL2 = [coder decodeObjectForKey:@"self.dealImageURL2"];
        self.price1 = [coder decodeObjectForKey:@"self.price1"];
        self.price2 = [coder decodeObjectForKey:@"self.price2"];
        self.discount1 = [coder decodeObjectForKey:@"self.discount1"];
        self.discount2 = [coder decodeObjectForKey:@"self.discount2"];
        self.iconImageURL = [coder decodeObjectForKey:@"self.iconImageURL"];
        self.title = [coder decodeObjectForKey:@"self.title"];
        self.discountLeft = [coder decodeObjectForKey:@"self.discountLeft"];
        self.limit = [coder decodeObjectForKey:@"self.limit"];
        self.descriString = [coder decodeObjectForKey:@"self.descriString"];
        self.beginTime = [coder decodeObjectForKey:@"self.beginTime"];
        self.name = [coder decodeObjectForKey:@"self.name"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.dealImageURL1 forKey:@"self.dealImageURL1"];
    [aCoder encodeObject:self.dealImageURL2 forKey:@"self.dealImageURL2"];
    [aCoder encodeObject:self.price1 forKey:@"self.price1"];
    [aCoder encodeObject:self.price2 forKey:@"self.price2"];
    [aCoder encodeObject:self.discount1 forKey:@"self.discount1"];
    [aCoder encodeObject:self.discount2 forKey:@"self.discount2"];
    [aCoder encodeObject:self.iconImageURL forKey:@"self.iconImageURL"];
    [aCoder encodeObject:self.title forKey:@"self.title"];
    [aCoder encodeObject:self.discountLeft forKey:@"self.discountLeft"];
    [aCoder encodeObject:self.limit forKey:@"self.limit"];
    [aCoder encodeObject:self.descriString forKey:@"self.descriString"];
    [aCoder encodeObject:self.beginTime forKey:@"self.beginTime"];
    [aCoder encodeObject:self.name forKey:@"self.name"];
}
@end
