//
//  Tao800CoreDeal.h
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tao800CoreDeal : NSManagedObject

@property NSString *attribute1;
@property NSString *attribute2;
@property NSData *dealContent;
@property NSString *dealId;
@property NSDate *dealUpdated;

@end
