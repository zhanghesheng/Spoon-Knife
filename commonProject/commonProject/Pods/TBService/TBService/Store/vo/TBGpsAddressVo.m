//
//  TBGpsAddressVo.m
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import "TBGpsAddressVo.h"

@implementation TBGpsAddressVo
@synthesize name, latitude, longitude, cityName, gpsLocation, created, address, description, quotations;
@synthesize addressState = _addressState;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder { 
    [aCoder encodeObject:cityName forKey:@"cityName"];
    [aCoder encodeObject:name forKey:@"name"]; 
    [aCoder encodeObject:address forKey:@"address"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeObject:created forKey:@"created"];
    [aCoder encodeBool:gpsLocation forKey:@"gpsLocation"];
    [aCoder encodeDouble:longitude forKey:@"longitude"];
    [aCoder encodeDouble:latitude forKey:@"latitude"];
    [aCoder encodeObject:quotations forKey:@"quotations"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
    self.name = [aDecoder decodeObjectForKey:@"name"]; 
    self.address = [aDecoder decodeObjectForKey:@"address"];
    self.description = [aDecoder decodeObjectForKey:@"description"];
    self.created = [aDecoder decodeObjectForKey:@"created"];
    self.quotations = [aDecoder decodeObjectForKey:@"quotations"];
    self.gpsLocation = [aDecoder decodeBoolForKey:@"gpsLocation"];
    self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
	return self;
}

-(void)dealloc {
  
}

- (id)copyWithZone:(NSZone *)zone {
    TBGpsAddressVo *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.name = self.name;
        copy.description = self.description;
        copy.cityName = self.cityName;
        copy.created = self.created;
        copy.latitude = self.latitude;
        copy.longitude = self.longitude;
        copy.gpsLocation = self.gpsLocation;
        copy.quotations = self.quotations;
        copy.address = self.address;
        copy.addressState = self.addressState;
    }

    return copy;
}

@end
