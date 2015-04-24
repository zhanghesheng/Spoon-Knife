//
//  Tao800PersonalBirthdayModel.h
//  tao800
//
//  Created by LeAustinHan on 14-4-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

@interface Tao800PersonalBirthdayModel : TBModel

- (void)saveBirthday:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;

- (void)saveDefaultBirthday;

- (NSString *)userBirthday;

- (void)saveBabySex:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure;

- (void)saveDefaultSex;

- (NSString *)userBabySex;

@end
