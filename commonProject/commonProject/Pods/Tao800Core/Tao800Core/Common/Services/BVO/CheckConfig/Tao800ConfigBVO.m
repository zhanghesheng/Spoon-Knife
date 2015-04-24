//
//  Tao800ConfigBVO.m
//  tao800
//
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ConfigBVO.h"
#import "Tao800ConfigTipBVO.h"
#import "Tao800SoftVo.h"
#import "Tao800CheckConfigTaoBaoSwitchBVO.h"

@implementation Tao800ConfigBVO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.softVo forKey:@"softVo"];
    [aCoder encodeObject:self.configTipBVO forKey:@"configTipBVO"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.softVo = [aDecoder decodeObjectForKey:@"softVo"];
        self.configTipBVO = [aDecoder decodeObjectForKey:@"configTipBVO"];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Tao800ConfigBVO *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.softVo = [self.softVo copy];
        copy.configTipBVO = self.configTipBVO;
        copy.taoBaoSwitchBVO = self.taoBaoSwitchBVO;
    }

    return copy;
}


@end
