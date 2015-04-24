//
//  Tao800AnalysisExposureContentVO.m
//  Tao800Core
//
//  Created by enfeng on 15/3/11.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <TBCore/NSString+Addition.h>
#import "Tao800AnalysisExposureContentVO.h"

@interface Tao800AnalysisExposureContentVO ()
@property(nonatomic, copy) NSString *exposureIdentifier;
@end

@implementation Tao800AnalysisExposureContentVO

- (instancetype) init {
    self = [super init];
    if (self) {
        self.deals = [NSMutableArray arrayWithCapacity:6];
    }
    return self;
}

- (void)resetExposureIdentifier {
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:255];
    [mutableString appendFormat:@"_%@", self.exposureUserId];
    [mutableString appendFormat:@"_%@", self.exposureDeviceId];
    [mutableString appendFormat:@"_%@", self.exposureFromSource];
    [mutableString appendFormat:@"_%@", self.exposurePlatform];
    [mutableString appendFormat:@"_%@", self.exposureVersion];
    [mutableString appendFormat:@"_%@", self.exposureChannel];
    [mutableString appendFormat:@"_%@", self.exposureUserRole];
    [mutableString appendFormat:@"_%@", self.exposureUserType];
    [mutableString appendFormat:@"_%@", self.exposureSchool];
    [mutableString appendFormat:@"_%@", self.exposureChild];
    [mutableString appendFormat:@"_%@", self.exposureListVersion];
    [mutableString appendFormat:@"_%@", @(self.exposurePosType)];
    [mutableString appendFormat:@"_%@", self.exposurePostValue];
    [mutableString appendFormat:@"_%@", self.exposureRefer];

    self.exposureIdentifier = [mutableString md5];
}

- (NSString *)exposureIdentifier {
    if (!_exposureIdentifier) {
        [self resetExposureIdentifier];
    }
    return _exposureIdentifier;
}


@end
