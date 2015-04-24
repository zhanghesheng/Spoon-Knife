//
//  Tao800OrderBVO.h
//  tao800
//
//  Created by Rose on 14-5-4.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface Tao800OrderBVO : NSObject<NSCoding>
@property(nonatomic,strong) NSString *orderId;     //订单编号;
@property(nonatomic,strong) NSString *createTime;  //创建订单时间;
@property(nonatomic,strong) NSString *cancelTime;  //取消订单时间;
@property(nonatomic,strong) NSString *orderState;  //订单状态;
@property(nonatomic,strong) NSString *stateDesc;   //状态描述;
@property(nonatomic,strong) NSString *amount;      //总价（单位分）;
@property(nonatomic,strong) NSString *score;       //总积分;
@property(nonatomic,strong) NSString *count;       //购买数;
@property(nonatomic,strong) NSString *curPrice;    //单价（单位分）;
@property(nonatomic,strong) NSString *curScore;    //单位积分;
@property(nonatomic,strong) NSString *productName; //商品名称;
@property(nonatomic,strong) NSString *imagesUrl;   //图片地址;
@property(nonatomic,strong) NSString *receiverName;//收件姓名;
@property(nonatomic,strong) NSString *receiverMobile;//收件人手机号;
@property(nonatomic,strong) NSString *receiverAddress;//收件地址;
@property(nonatomic,strong) NSString *postage;     //邮费单位分;
@property(nonatomic,strong) NSString *sellerQq;    //卖家qq;
@property(nonatomic,strong) NSArray *skuDesc;      //描述;
@property(nonatomic,strong) NSString *expressId;   //快递公司Id
@property(nonatomic,strong) NSString *expressName; //快递公司名称
@property(nonatomic,strong) NSString *expressNo;   //快递公司单号
@property(nonatomic,strong) NSString *productId;   //商品详情查询id

+ (NSArray *)wrapperOrderBVOList:(NSDictionary *)dict;

+ (Tao800OrderBVO*)wrapperOrderDetail:(NSDictionary*)dict;

@end

@interface Tao800OrderSkuDescBVO : NSObject<NSCoding>
@property(nonatomic,strong) NSString *skuDescName;     //商品特征名称;
@property(nonatomic,strong) NSString *skuDescValue;    //商品特征值;
@end


