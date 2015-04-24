//
//  Tao800SKUManager.h
//  tao800
//
//  Created by hanyuan on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800SKUManager : NSObject
-(id)initWithSKUInfo:(NSDictionary *)info;
-(void)updateSKUInfo:(NSDictionary *)info;
-(NSArray *)queryPropertyList:(int)dimensionIndex;
-(void)updatePropertySelectState:(int)dimensionIndex propertyId:(NSString *)propertyId;
-(NSArray *)querySKUCombinationList;
-(int)queryDimensionCount;
-(NSArray *)querySelectedPropertyList;
@end
