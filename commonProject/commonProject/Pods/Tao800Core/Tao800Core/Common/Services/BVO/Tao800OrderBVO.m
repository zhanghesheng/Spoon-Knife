//
//  Tao800OrderBVO.m
//  tao800
//
//  Created by Rose on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800OrderBVO.h"
#import "TBCore/NSObjectAdditions.h"

@implementation Tao800OrderBVO

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.orderId = [aDecoder decodeObjectForKey:@"orderId"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.cancelTime = [aDecoder decodeObjectForKey:@"cancelTime"];
        self.orderState = [aDecoder decodeObjectForKey:@"orderState"];
        self.stateDesc = [aDecoder decodeObjectForKey:@"stateDesc"];
        self.amount = [aDecoder decodeObjectForKey:@"amount"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.curPrice = [aDecoder decodeObjectForKey:@"curPrice"];
        self.curScore = [aDecoder decodeObjectForKey:@"curScore"];
        self.productName = [aDecoder decodeObjectForKey:@"productName"];
        self.imagesUrl = [aDecoder decodeObjectForKey:@"imagesUrl"];
        self.receiverName = [aDecoder decodeObjectForKey:@"receiverName"];
        self.receiverMobile = [aDecoder decodeObjectForKey:@"receiverMobile"];
        self.receiverAddress = [aDecoder decodeObjectForKey:@"receiverAddress"];
        self.postage = [aDecoder decodeObjectForKey:@"postage"];
        self.sellerQq = [aDecoder decodeObjectForKey:@"sellerQq"];
        self.skuDesc = [aDecoder decodeObjectForKey:@"skuDesc"];
        self.expressId = [aDecoder decodeObjectForKey:@"expressId"];
        self.expressName = [aDecoder decodeObjectForKey:@"expressName"];
        self.expressNo = [aDecoder decodeObjectForKey:@"expressNo"];
        self.productId = [aDecoder decodeObjectForKey:@"productId"];
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.orderId forKey:@"orderId"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.cancelTime forKey:@"cancelTime"];
    [aCoder encodeObject:self.orderState forKey:@"orderState"];
    [aCoder encodeObject:self.stateDesc forKey:@"stateDesc"];
    [aCoder encodeObject:self.amount forKey:@"amount"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeObject:self.curPrice forKey:@"curPrice"];
    [aCoder encodeObject:self.curScore forKey:@"curScore"];
    [aCoder encodeObject:self.productName forKey:@"productName"];
    [aCoder encodeObject:self.imagesUrl forKey:@"imagesUrl"];
    [aCoder encodeObject:self.receiverName forKey:@"receiverName"];
    [aCoder encodeObject:self.receiverMobile forKey:@"receiverMobile"];
    [aCoder encodeObject:self.receiverAddress forKey:@"receiverAddress"];
    [aCoder encodeObject:self.postage forKey:@"postage"];
    [aCoder encodeObject:self.sellerQq forKey:@"sellerQq"];
    [aCoder encodeObject:self.skuDesc forKey:@"skuDesc"];
    [aCoder encodeObject:self.expressId forKey:@"expressId"];
    [aCoder encodeObject:self.expressName forKey:@"expressName"];
    [aCoder encodeObject:self.expressNo forKey:@"expressNo"];
    [aCoder encodeObject:self.productId forKey:@"productId"];
}

+ (NSArray *)wrapperOrderBVOList:(NSDictionary *)dict {
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:2];
    for(NSDictionary *proDic in dict) {
        Tao800OrderBVO* orderBvo = [[Tao800OrderBVO alloc] init];
        orderBvo.orderId = [proDic objectForKey:@"orderId"];
        orderBvo.createTime = [proDic objectForKey:@"createTime"];
        orderBvo.cancelTime = [proDic objectForKey:@"cancelTime"];
        orderBvo.orderState = [proDic objectForKey:@"orderState"];
        orderBvo.stateDesc = [proDic objectForKey:@"stateDesc"];
        orderBvo.amount = [proDic objectForKey:@"amount"];
        orderBvo.score = [proDic objectForKey:@"score"];
        orderBvo.count = [proDic objectForKey:@"count"];
        orderBvo.curPrice = [proDic objectForKey:@"curPrice"];
        orderBvo.curScore = [proDic objectForKey:@"curScore"];
        orderBvo.productName = [proDic objectForKey:@"productName"];
        orderBvo.imagesUrl = [proDic objectForKey:@"imagesUrl"];
        
        [arr addObject:orderBvo];
    }
    return arr;
}



+(Tao800OrderBVO*)wrapperOrderDetail:(NSDictionary*)dict{
    Tao800OrderBVO* orderBvo = [[Tao800OrderBVO alloc] init];
    orderBvo.orderId = [dict objectForKey:@"orderId"];
    orderBvo.createTime = [dict objectForKey:@"createTime"];
    orderBvo.cancelTime = [dict objectForKey:@"cancelTime"];
    orderBvo.orderState = [dict objectForKey:@"orderState"];
    orderBvo.stateDesc = [dict objectForKey:@"stateDesc"];
    orderBvo.amount = [dict objectForKey:@"amount"];
    orderBvo.score = [dict objectForKey:@"score"];
    orderBvo.count = [dict objectForKey:@"count"];
    
    orderBvo.curPrice = [dict objectForKey:@"curPrice"];
    orderBvo.curScore = [dict objectForKey:@"curScore"];
    orderBvo.productName = [dict objectForKey:@"productName"];
    orderBvo.imagesUrl = [dict objectForKey:@"imagesUrl"];
    
    orderBvo.receiverName = [dict objectForKey:@"receiverName"];
    orderBvo.receiverMobile = [dict objectForKey:@"receiverMobile"];
    orderBvo.receiverAddress = [dict objectForKey:@"receiverAddress"];
    orderBvo.postage = [dict objectForKey:@"postage"];
    
    orderBvo.sellerQq = [dict objectForKey:@"sellerQq"];
    orderBvo.expressId = [dict objectForKey:@"expressId"];
    orderBvo.expressName = [dict objectForKey:@"expressName"];
    orderBvo.expressNo = [dict objectForKey:@"expressNo"];
    orderBvo.productId = [dict objectForKey:@"productId"];
    
    //orderBvo.skuDesc = [dict objectForKey:@"skuDesc"];
    NSMutableArray* skuArray = [NSMutableArray arrayWithCapacity:10];
    skuArray = [dict objectForKey:@"skuDesc"];
    [orderBvo resetNullProperty];
    [skuArray resetNullProperty];
    
    NSMutableArray* skuAddArray = [NSMutableArray arrayWithCapacity:10];
    for(NSDictionary *dic in skuArray){
        Tao800OrderSkuDescBVO *skuDescBvo = [[Tao800OrderSkuDescBVO alloc] init];
        skuDescBvo.skuDescName = [dic objectForKey:@"name"];
        skuDescBvo.skuDescValue = [dic objectForKey:@"value"];
        [skuDescBvo resetNullProperty];
        [skuAddArray addObject:skuDescBvo];
    }
    if ([skuAddArray count]>0) {
        orderBvo.skuDesc = [NSArray arrayWithArray:skuAddArray];
    }else{
        orderBvo.skuDesc = nil;
    }
    
    return orderBvo;
}
@end

@implementation Tao800OrderSkuDescBVO

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.skuDescName = [aDecoder decodeObjectForKey:@"skuDescName"];
        self.skuDescValue = [aDecoder decodeObjectForKey:@"skuDescValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.skuDescName forKey:@"skuDescName"];
    [aCoder encodeObject:self.skuDescValue forKey:@"skuDescValue"];
}

@end