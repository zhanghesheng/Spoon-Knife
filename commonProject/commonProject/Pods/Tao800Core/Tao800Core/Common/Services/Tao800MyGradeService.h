//
//  Tao800MyGradeService.h
//  tao800
//
//  Created by ayvin on 13-4-22.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@protocol Tao800MyGradeServiceDelegate <TBBaseNetworkDelegate>
@optional

- (void)getMyGradeFinish:(NSDictionary *)params;

@end

@interface Tao800MyGradeService : Tao800BaseService

- (void)getMyGrade:(NSDictionary *)params;

/*
 增加积分接口
 */
- (void)addPoint:(NSDictionary *)params
      completion:(void (^)(NSDictionary *)) completion
         failure:(void (^)(TBErrorDescription *))failure;

@end
