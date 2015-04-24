//
//  Tao800SKUPropertyVo.h
//  tao800
//
//  Created by hanyuan on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    SKUSelectedState_Available,
    SKUSelectedState_Unavailable,
    SKUSelectedState_Selected,
}SKUSelectedState;

//单个属性，比如红色，m号，不锈钢...
//"pId": "177",
//"pName": "颜色",
//"vColor": "#5d762a",
//"vDefault": "",
//"vId": "1001",
//"vName": "军绿色",
//"vPicture": ""
@interface Tao800SKUPropertyVo : NSObject
@property(nonatomic, copy)NSString *pId;
@property(nonatomic, copy)NSString *pName; //属性名
@property(nonatomic, copy)NSString *vName; //值
@property(nonatomic, copy)NSString *vId; //唯一id
@property(assign)int selectState; //单个属性选择状态
@end
