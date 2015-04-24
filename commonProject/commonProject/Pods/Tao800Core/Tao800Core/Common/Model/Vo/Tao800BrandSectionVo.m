//
//  Tao800BrandSectionVo.m
//  tao800
//
//  Created by adminName on 14-4-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BrandSectionVo.h"

@implementation Tao800BrandSectionVo
@synthesize name = _name;
@synthesize discount = _discount;
@synthesize logoImage = _logoImage;

-(void)dealloc{

}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_discount forKey:@"discount"];
    [aCoder encodeObject:_logoImage forKey:@"logoImage"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.discount = [aDecoder decodeObjectForKey:@"discount"];
    self.logoImage = [aDecoder decodeObjectForKey:@"logoImage"];
    return self;
}
@end
