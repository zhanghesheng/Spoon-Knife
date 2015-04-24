//
//  CDACoreDataSingleton.h
//  CoreDataDemo01
//
//  Created by enfeng on 13-9-27.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tao800CoreDataStorage.h"

@interface Tao800CoreDataSingleton : Tao800CoreDataStorage


+ (id)shareInstance;

@end
