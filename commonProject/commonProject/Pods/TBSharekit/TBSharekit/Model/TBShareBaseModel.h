//
//  TBShareBaseModel.h
//  universalT800
//
//  Created by enfeng on 13-11-26.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBShareVo.h"

typedef void (^TBShareModelCallback)(NSDictionary *params);

@interface TBShareBaseModel : NSObject

@property(nonatomic, strong) TBShareVo *shareVo;
@property(nonatomic, strong) NSDictionary *sendParams;

@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *appSecretKey;
@property(nonatomic, copy) NSString *callBackUrl;
@property(nonatomic, copy) NSString *appId;

@property(nonatomic, copy) NSString *appIconUrl;
@property(nonatomic, assign) BOOL useToBind; //用于分享绑定

@property(nonatomic, strong) NSMutableDictionary *methodHandlers;

- (id)initWithAppId:(NSString *)appId
             appkey:(NSString *)appKey
       appSecretKey:(NSString *)appSecretKey
        callBackUrl:(NSString *)callBackUrl;

- (void)sendContent:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure;

- (void)callback:(NSString *)handlerName params:(NSDictionary *)params;

- (NSString *)convertImageUrl:(NSString *)imgUrl needDefaultImage:(BOOL)needDefaultImage;

- (void)failureCallBack:(NSDictionary *)params;

- (void)completionCallBack:(NSDictionary *)params;

- (void)popViewCTL:(UIViewController *)controller;


- (void)loginFailureCallBack:(NSDictionary *)params;

- (void)loginCompletionCallBack:(NSDictionary *)params;

- (void)logoutFailureCallBack:(NSDictionary *)params;

- (void)logoutCompletionCallBack:(NSDictionary *)params;


- (void)getUserInfo:(NSDictionary *)params
         completion:(TBShareModelCallback)completion
            failure:(TBShareModelCallback)failure;

/**
* 判断是否已经授权
*/
- (BOOL)authorized;

- (void)login:(NSDictionary *)params
   completion:(TBShareModelCallback)completion
      failure:(TBShareModelCallback)failure;

- (void)logout:(NSDictionary *)params
    completion:(TBShareModelCallback)completion
       failure:(TBShareModelCallback)failure;
@end
