//
//  Tao800SearchHomeModel.h
//  tao800
//
//  Created by worker on 14-2-25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListModel.h"
#import "Tao800DealService.h"
#import "Tao800SearchHomeVCL.h"

@interface Tao800SearchHomeModel : Tao800DealListModel

@property(nonatomic, copy) NSString *keyword;
@property(nonatomic, strong) Tao800DealService *dealService;

@property(nonatomic, weak) Tao800SearchHomeVCL *controller;

- (void)getSearchSuggestion:(NSDictionary *)params
       completion:(void (^)(NSDictionary *))completion
          failure:(void (^)(TBErrorDescription *))failure;

- (void)getNewSearchDeals:(NSDictionary *)params
                 completion:(void (^)(NSDictionary *))completion
                    failure:(void (^)(TBErrorDescription *))failure;

- (void)getRecommendDeals:(NSDictionary *)params
            completion:(void (^)(NSDictionary *))completion
               failure:(void (^)(TBErrorDescription *))failure;

@end
