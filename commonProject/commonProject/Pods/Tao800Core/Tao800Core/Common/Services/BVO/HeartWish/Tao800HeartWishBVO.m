//
//  Tao800HeartWishBVO.m
//  tao800
//
//  Created by Rose on 14/11/26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800HeartWishBVO.h"
#import <TBCore/NSObjectAdditions.h>
#import <TBCore/NSDictionaryAdditions.h>

@implementation Tao800HeartWishBVO

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.wishId = [aDecoder decodeObjectForKey:@"wishId"];
        self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.selectFlag = [aDecoder decodeBoolForKey:@"selectFlag"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.wishId forKey:@"wishId"];
    [aCoder encodeObject:self.keyword forKey:@"keyword"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeBool:self.selectFlag forKey:@"selectFlag"];
}

+ (NSArray *)wrapperHeartWishBVOList:(NSDictionary *)dict {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:20];
    NSArray* array = [dict objectForKey:@"response"];
    for(NSDictionary *proDic in array) {
        Tao800HeartWishBVO* orderBvo = [[Tao800HeartWishBVO alloc] init];
        orderBvo.wishId = [proDic objectForKey:@"id"];
        orderBvo.keyword = [proDic objectForKey:@"key_word"];
        orderBvo.count = [proDic objectForKey:@"count"];
        [orderBvo resetNullProperty];
        [arr addObject:orderBvo];
    }
    return arr;
}
@end

@interface Tao800HeartWishReachedBVO ()
@end

@implementation Tao800HeartWishReachedBVO

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.reached = [aDecoder decodeObjectForKey:@"reached"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        if (_reached) {
            self.heartWishStatus = (Tao800HeartWishStatus)[_reached integerValue];
        }else{
            self.heartWishStatus = Tao800HeartWishStatusNone;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.reached forKey:@"reached"];
    [aCoder encodeObject:self.count forKey:@"count"];
}

-(void)setHeartWishStatus:(Tao800HeartWishStatus) wishStatus{
    _heartWishStatus = wishStatus;
    _reached = [NSNumber numberWithInteger:wishStatus];
}

+ (Tao800HeartWishReachedBVO *)wrapperHeartWishReachedBVO:(NSDictionary *)dict{
    NSDictionary *isReachedDict = [dict objectForKey:@"response"];
    Tao800HeartWishReachedBVO *wishReachBvo = [[Tao800HeartWishReachedBVO alloc] init];
    NSNumber* reached = [isReachedDict objectForKey:@"reached" convertNSNullToNil:YES];
    if (reached) {
        wishReachBvo.heartWishStatus = [reached intValue];
    }else{
        wishReachBvo.heartWishStatus = Tao800HeartWishStatusOld;
    }
    
    wishReachBvo.count = [isReachedDict objectForKey:@"count" convertNSNullToNil:YES];
    [wishReachBvo resetNullProperty];
    return wishReachBvo;
}

@end
