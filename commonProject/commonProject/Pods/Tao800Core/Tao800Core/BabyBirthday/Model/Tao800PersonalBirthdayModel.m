//
//  Tao800PersonalBirthdayModel.m
//  tao800
//
//  Created by LeAustinHan on 14-4-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PersonalBirthdayModel.h"
#import "Tao800ConfigManage.h"
#import "Tao800BackgroundServiceManage.h"
#import "Tao800NotifycationConstant.h"


@interface Tao800PersonalBirthdayModel ()

@property(nonatomic, strong) Tao800ConfigManage *configManage;

@end

@implementation Tao800PersonalBirthdayModel

- (id)init {
    self = [super init];
    if (self) {
        self.configManage = [[Tao800ConfigManage alloc] init];
    }
    return self;
}

- (void)saveBirthday:(NSDictionary *)params
          completion:(void (^)(NSDictionary *))completion
             failure:(void (^)(TBErrorDescription *))failure
{
    NSString *text = params[@"birthday"];
    [self.configManage saveBabyBirthday:text];
//    Tao800BackgroundServiceManage *bm = [Tao800BackgroundServiceManage sharedInstance];
//    [bm loadTagsOfRecommend];
//    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:Tao800PersonalIdentityDidChangeNotification
//     object:nil];
//    completion(nil);
}
-(void)saveBabySex:(NSDictionary *)params completion:(void (^)(NSDictionary *))completion failure:(void (^)(TBErrorDescription *))failure
{
    NSString *text = params[@"babySex"];
    [self.configManage saveBabySex:text];
}

- (void)saveDefaultBirthday
{
    [self saveBirthday:@{@"birthday":@""}  completion:^(NSDictionary*dd){} failure:^(TBErrorDescription*error){}];
}

-(void)saveDefaultSex
{
    [self saveBabySex:@{@"babySex":@"0"} completion:^(NSDictionary *dd){} failure:^(TBErrorDescription *error){}];
}

- (NSString *)userBirthday
{
   return [self.configManage getBabyBirthday];
}


-(NSString *)userBabySex
{
    return [self.configManage getBabySex];
}
@end
