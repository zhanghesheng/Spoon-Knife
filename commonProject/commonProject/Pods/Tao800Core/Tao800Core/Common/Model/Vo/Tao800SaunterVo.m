//
//  Tao800SaunterVo.m
//  tao800
//
//  Created by adminName on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SaunterVo.h"

@implementation Tao800SaunterVo
@synthesize name = _name;
@synthesize desc = _desc;
@synthesize urlName = _urlName;
@synthesize tagId = _tagId;

- (void)dealloc {
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_desc forKey:@"desc"];
    [aCoder encodeObject:_tagId forKey:@"tagId"];
    [aCoder encodeObject:_urlName forKey:@"urlName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.desc = [aDecoder decodeObjectForKey:@"desc"];
    self.tagId = [aDecoder decodeObjectForKey:@"tagId"];
    self.urlName = [aDecoder decodeObjectForKey:@"urlName"];
    return self;
}
@end
