//
//  Tao800HeartWishBVO.h
//  tao800
//
//  Created by Rose on 14/11/26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    Tao800HeartWishStatusNone = -1,
    Tao800HeartWishStatusOld = 0,
    Tao800HeartWishStatusNewComing = 1,
}Tao800HeartWishStatus;

@interface Tao800HeartWishBVO : NSObject<NSCoding>
@property(nonatomic,strong) NSNumber *wishId;     //订单编号;
@property(nonatomic,strong) NSString *keyword;
@property(nonatomic,strong) NSNumber *count;
@property(nonatomic) BOOL selectFlag;
+ (NSArray *)wrapperHeartWishBVOList:(NSDictionary *)dict;
@end


@interface Tao800HeartWishReachedBVO : NSObject<NSCoding>
@property(nonatomic, setter=setHeartWishStatus:) Tao800HeartWishStatus heartWishStatus;
@property(nonatomic,strong)NSNumber* reached;
@property(nonatomic,strong) NSNumber* count;

+ (Tao800HeartWishReachedBVO *)wrapperHeartWishReachedBVO:(NSDictionary *)dict;
@end
