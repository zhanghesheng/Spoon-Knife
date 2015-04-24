//
//  Tao800HomeOperationVo.h
//  tao800
//
//  Created by Rose on 14-7-15.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800StaticConstant.h"



typedef  NS_ENUM(NSInteger, Tao800OperationHomeKey) {
    Tao800OperationHomeKeyToday = 1,    //今日更新
    Tao800OperationHomeKeyDailyTen = 2, //每日10件
    Tao800OperationHomeKeyNotice = 3, //精品预告
    Tao800OperationHomeKeyMobile = 4, //手机周边
    Tao800OperationHomeKeyNinePointNine = 5, //9.9
    Tao800OperationHomeKeySaunter = 6, //值得逛
    Tao800OperationHomeKeyLottery = 7, //0元抽奖
};

@interface Tao800HomeOperationVo : NSObject<NSCoding>

@property (nonatomic,strong) NSString* primaryText; //title
@property (nonatomic,strong) NSString* minorText;   //dealContent
@property (nonatomic,strong) NSString* urlPath;     //pic
@property (nonatomic,strong) NSNumber* homekey;     //homekey
@property (nonatomic,assign) Tao800OperationHomeKey operationHomeKey;
@property (nonatomic,assign) BOOL showNewTip;//是否显示new的标签

//命中类型，0：接口数据，1：wap页；当命中为接口数据时和之前状态一样，调用相应接口获取商品数据进行展现；当命中为WAP页时，根据URL字段内容跳转到相应WAP页
@property (nonatomic,strong) NSNumber* point;       //point
@property (nonatomic,strong) NSString* url;         //url      WAP页地址

+(Tao800HomeOperationVo*) wrapperOperationVo:(NSDictionary*)dic;
@end
