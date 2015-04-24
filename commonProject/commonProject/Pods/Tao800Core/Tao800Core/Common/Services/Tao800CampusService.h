//
//  Tao800CampusService.h
//  tao800
//
//  Created by tuan800 on 14-8-15.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BaseService.h"

@interface Tao800CampusService : Tao800BaseService


/**
 * 参数是一个字典 key: @"campusSpreadCode"
 * 值 对应的是用户填写的校园码
 */
-(void)checkCampusPromotionCode:(NSDictionary *)params andCompletion:(void(^)(NSDictionary * resultDic))completion andFail:(void(^)(NSError * error))Failure;


@end
