//
//  CDACoreDataSingleton.m
//  CoreDataDemo01
//
//  Created by enfeng on 13-9-27.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800CoreDataSingleton.h"

@interface Tao800CoreDataSingleton ()

@end

@implementation Tao800CoreDataSingleton

#pragma mark Singleton Methods

+ (id)shareInstance {
    static Tao800CoreDataSingleton *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Tao800CoreDataSingleton alloc] initWithDatabaseFilename:@"Tao800CoreData" storeOptions:nil];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

@end
