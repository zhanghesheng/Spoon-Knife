//
//  Tao800ConfigDao.m
//  universalT800
//
//  Created by enfeng on 13-10-8.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "Tao800ConfigDao.h"
#import "Tao800CoreDataSingleton.h"
#import "Tao800CoreConfig.h"

@interface Tao800ConfigDao ()
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation Tao800ConfigDao

- (id)init {
    self = [super init];
    if (self) {
        Tao800CoreDataSingleton *dataSingleton = [Tao800CoreDataSingleton shareInstance];
        self.managedObjectContext = [dataSingleton getNewManagedObjectContext];
    }
    return self;
}

- (NSString *)stringKey:(Tao800ConfigKey)key {
    return [NSString stringWithFormat:@"%i", key];
}

- (BOOL)saveConfig:(Tao800ConfigKey)key value:(NSData *)data {
    NSString *stringKey = [self stringKey:key];

    return [self saveConfigWithKey:stringKey value:data];
}

- (BOOL)saveConfigWithKey:(NSString*)stringKey value:(NSData *)data {
    Tao800CoreConfig *config = [self getConfigWithKey:stringKey];
    if (config) {
        [self.managedObjectContext deleteObject:config];
    }

    config = (Tao800CoreConfig *) [NSEntityDescription
            insertNewObjectForEntityForName:@"Tao800CoreConfig"
                     inManagedObjectContext:self.managedObjectContext];
    config.configKey = stringKey;
    config.configValue = data;

    NSError *error = nil;
    BOOL ret = YES;
    if (![self.managedObjectContext save:&error]) {
        ret = NO;
    }
    return ret;
}

- (Tao800CoreConfig *)getConfig:(Tao800ConfigKey)key {
    NSString *stringKey = [self stringKey:key];
    return  [self getConfigWithKey:stringKey];
}

- (Tao800CoreConfig *)getConfigWithKey:(NSString*)stringKey {
    Tao800CoreConfig *config = nil;
    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tao800CoreConfig"
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"configKey=%@", stringKey];
    fetchRequest.predicate = predicate;
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects && fetchedObjects.count > 0) {
        config = fetchedObjects[0];
    }

    return config;
}

- (void) deleteConfig:(NSString*)key {
    Tao800CoreConfig *historyDeal = [self getConfigWithKey:key];
    if (historyDeal) {
        [self.managedObjectContext deleteObject:historyDeal];
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {

    }
}
@end
