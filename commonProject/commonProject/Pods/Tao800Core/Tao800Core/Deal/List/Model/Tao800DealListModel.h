//
//  Tao800DealListModel.h
//  tao800
//
//  Created by enfeng on 14-2-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>
#import "Tao800UserModel.h"
#import "Tao800StaticConstant.h"

@class Tao800DealVo;

@interface Tao800DealListModel : Tao800UserModel

//保存原始Vo, 用于列表模式切换
@property(nonatomic, strong) NSMutableArray *deals;
@property(nonatomic, strong) NSMutableArray *dealLogs; //用于曝光打点

@property(nonatomic, assign) BOOL displayAsGrid; //以宫格方式显示

/**
 * 定义详情页来源
 * 子类必须赋值
 */
@property(nonatomic, assign) Tao800DealDetailFrom dealDetailFrom;
@property(nonatomic, copy) NSString *cId;

- (void)wrapperDealItems:(NSArray *)pDeals;

- (void)wrapperGridItems:(NSArray *)pDeals;

- (void)reloadItems;

/**
* 用于列表和宫格的切换
*/
- (void)wrapperItems;

/**
* 用于每次加载完数据后的调用
*/
- (void)wrapperItems:(NSDictionary *)dict;

- (void)wrapperLoadMoreItem;

/**
* 曝光打点，拖拽停止时打点。c_type：频道，0 聚频道，1 逛频道
*/
- (void)writeLogsExposureCtype:(int)exposureCtype;

- (void)sendSaveDealLogs:(NSDictionary *)paramsExt
              completion:(void (^)(NSDictionary *))completion
                 failure:(void (^)(TBErrorDescription *))failure;

- (BOOL) dealAdded:(Tao800DealVo *)dealVo;
@end
