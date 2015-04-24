//
//  Tao800ConfigDao.h
//  universalT800
//
//  Created by enfeng on 13-10-8.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800ConfigKey.h"

@class Tao800CoreConfig;

@interface Tao800ConfigDao : NSObject

/**
* 添加配置
* @param key
* @param value
* @return YES:保存成功 NO:保存失败
*/
- (BOOL)saveConfig:(Tao800ConfigKey)key value:(NSData *)data;

- (BOOL)saveConfigWithKey:(NSString *)stringKey value:(NSData *)data;

- (Tao800CoreConfig *)getConfig:(Tao800ConfigKey)key;

- (Tao800CoreConfig *)getConfigWithKey:(NSString *)stringKey;

- (void) deleteConfig:(NSString*)key;
@end
