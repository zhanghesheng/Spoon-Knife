//
//  Tao800PostsService.h
//  tao800
//
//  Created by wuzhiguang on 13-4-23.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@protocol Tao800PostsServiceDelegate <TBBaseNetworkDelegate>
@optional

- (void)publishPostsFinish:(NSDictionary *)params;
@end

@interface Tao800PostsService : Tao800BaseService

//发帖接口
/**
 *@params
 **/
- (void)publishPosts:(NSDictionary *)params;

@end
