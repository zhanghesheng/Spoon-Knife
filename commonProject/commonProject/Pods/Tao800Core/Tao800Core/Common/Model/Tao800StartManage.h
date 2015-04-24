//
//  Tao800StartManage.h
//  tao800
//  维护启动接口, 管理所有启动时需要加载的接口
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800StartManage : NSObject


/**
* 获取启动数据
*/
- (void) loadStartData;

/**
* 获取远程配置
* checkconfig
*/
- (void)loadRemoteConfig;

/**
 * 客户端启动 获取各种开关配置信息
 */
- (void)loadNewRemoteConfig;

@end
