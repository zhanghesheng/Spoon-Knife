//
//  TBCityVo.h
//  Core
//
//  Created by enfeng yang on 12-2-7.
//  Copyright (c) 2012年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCityVo : NSObject<NSCoding, NSCopying> {
    NSString* cityId;
    NSString* name;
	NSString* pinyin;
    NSString* shopNextUpdateTime;
    double latitude;
    double longitude;
    int flag;
    int cityOrder;
}
@property (nonatomic, strong) NSString* pinyin;
@property (nonatomic, strong) NSString* cityId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* shopNextUpdateTime;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int flag;
@property(nonatomic) int cityOrder;

- (NSString *)description;
@end
