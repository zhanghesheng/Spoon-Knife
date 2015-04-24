//
//  Tao800HomeOperationVo.m
//  tao800
//
//  Created by Rose on 14-7-15.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBCore/NSDictionaryAdditions.h>
#import "Tao800HomeOperationVo.h"
#import "TBCore/NSObjectAdditions.h"

@implementation Tao800HomeOperationVo


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.primaryText forKey:@"primaryText"];
    [aCoder encodeObject:self.minorText forKey:@"minorText"];
    [aCoder encodeObject:self.urlPath forKey:@"imageUrlPath"];
    [aCoder encodeInteger:self.operationHomeKey forKey:@"buttonType"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.homekey forKey:@"homekey"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.primaryText = [aDecoder decodeObjectForKey:@"primaryText"];
    self.minorText = [aDecoder decodeObjectForKey:@"minorText"];
    self.urlPath = [aDecoder decodeObjectForKey:@"imageUrlPath"];
    self.operationHomeKey = (Tao800OperationHomeKey) [aDecoder decodeIntegerForKey:@"buttonType"];
    self.point = [aDecoder decodeObjectForKey:@"point"];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    self.homekey = [aDecoder decodeObjectForKey:@"homekey"];
    return self;
}

+ (Tao800HomeOperationVo *)wrapperOperationVo:(NSDictionary *)dic {
    Tao800HomeOperationVo *vo = [[Tao800HomeOperationVo alloc] init];
    vo.primaryText = [dic objectForKey:@"title" convertNSNullToNil:YES];
    vo.homekey = [dic objectForKey:@"homekey" convertNSNullToNil:YES];

    vo.minorText = [dic objectForKey:@"content" convertNSNullToNil:YES];;//dic[@"content"];
    vo.urlPath = [dic objectForKey:@"pic" convertNSNullToNil:YES];;//dic[@"pic"];
    vo.point = [dic objectForKey:@"point" convertNSNullToNil:YES];//dic[@"point"];
    vo.url = [dic objectForKey:@"url" convertNSNullToNil:YES];//dic[@"url"];
    vo.showNewTip = [[dic objectForKey:@"shownewtip" convertNSNullToNil:YES] boolValue];//[dic[@"shownewtip"] boolValue];

    vo.operationHomeKey = (Tao800OperationHomeKey) (vo.homekey.intValue);

    NSRange rr = [vo.minorText rangeOfString:@"\n"];
    if (rr.length>0) {
        vo.minorText = [vo.minorText stringByReplacingCharactersInRange:rr withString:@""];
    }
    rr = [vo.minorText rangeOfString:@"\r"];
    if (rr.length>0) {
        vo.minorText = [vo.minorText stringByReplacingCharactersInRange:rr withString:@""];
    }


    return vo;
}

@end




