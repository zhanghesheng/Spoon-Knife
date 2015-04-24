//
//  TBUserCampusVo.m
//  Tuan800API
//
//  Created by worker on 13-11-21.
//  Copyright (c) 2013年 com.tuan800.framework.Tuan800API. All rights reserved.
//

#import "TBUserCampusVo.h"

@implementation TBUserCampusVo

@synthesize name;
@synthesize schoolName;
@synthesize departmentName;
@synthesize admissionDate;
@synthesize education;
@synthesize schoolSepcialCode;
@synthesize wirelessInviteCode;
 
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:schoolName forKey:@"schoolName"];
    [aCoder encodeObject:departmentName forKey:@"departmentName"];
    [aCoder encodeObject:admissionDate forKey:@"admissionDate"];
    [aCoder encodeObject:education forKey:@"education"];
    [aCoder encodeObject:schoolSepcialCode forKey:@"schoolSepcialCode"];
    [aCoder encodeObject:wirelessInviteCode forKey:@"wirelessInviteCode"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
    self.departmentName = [aDecoder decodeObjectForKey:@"departmentName"];
    self.admissionDate = [aDecoder decodeObjectForKey:@"admissionDate"];
    self.education = [aDecoder decodeObjectForKey:@"education"];
    self.schoolSepcialCode = [aDecoder decodeObjectForKey:@"schoolSepcialCode"];
    self.wirelessInviteCode = [aDecoder decodeObjectForKey:@"wirelessInviteCode"];
	return self;
}

@end
