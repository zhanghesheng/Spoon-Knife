//
//  Tao800CoreConfig.h
//  tao800
//
//  Created by enfeng on 14-2-20.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tao800CoreConfig : NSManagedObject

@property NSString *configKey;
@property NSData *configValue;

@end
