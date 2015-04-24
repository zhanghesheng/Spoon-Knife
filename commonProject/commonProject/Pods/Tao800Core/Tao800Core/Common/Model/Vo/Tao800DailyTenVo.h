//
//  Tao800DailyTenVo.h
//  tao800
//
//  Created by Rose on 14-7-18.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800DealVo.h"

typedef enum __RelatedType {
    RelatedTypeNone = -1,
    RelatedTypeSearch = 0,
    RelatedTypeCat =1
}RelatedType;

@interface Tao800DailyTenVo : NSObject
@property(nonatomic, assign) int dealId;
//@property (nonatomic,strong) NSNumber* recordId;
@property (nonatomic,strong) NSString* title;
@property(nonatomic, assign) DealSaleState oos;
@property(nonatomic, assign) int price;
@property(nonatomic, strong) NSString *beginTime;
@property(nonatomic, strong) NSString *expireTime;
@property(nonatomic, strong) NSString *wapUrl;
@property(nonatomic, assign) Boolean isBaoyou;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *recommendReason;
@property(nonatomic, strong) NSMutableArray *relatedRecommend;
@property(nonatomic, assign) RelatedType type;
@end
