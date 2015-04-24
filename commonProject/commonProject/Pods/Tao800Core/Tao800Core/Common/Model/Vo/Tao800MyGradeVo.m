//
//  Tao800MyGradeVo.m
//  tao800
//
//  Created by ayvin on 13-4-21.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MyGradeVo.h"

@implementation Tao800MyGradeVo
@synthesize grade;
@synthesize price;

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeInt:self.grade forKey:@"grade"];
    [aCoder encodeInt:self.price forKey:@"price"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self.grade = [aDecoder decodeIntForKey:@"grade"];
    self.price = [aDecoder decodeIntForKey:@"price"];

    return self;
}

- (NSString *)getGradeKey {
    int gradeInt = self.grade;
    if (gradeInt>0) {
        //0:代表0级 2:代表1级
        gradeInt = gradeInt-1;
    }
    return [NSString stringWithFormat:@"z%d", gradeInt];
}

- (void)dealloc {

}

@end
