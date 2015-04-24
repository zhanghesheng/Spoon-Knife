//
//  Tao800AnalysisExposureManage.h
//  Tao800Core
//
//  Created by enfeng on 15/3/10.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800AnalysisExposureContentVO;
@class Tao800AnalysisExposureContentDealVO;

@interface Tao800AnalysisExposureManage : NSObject

+ (id)shareInstance;

/**
* 添加曝光打点基础信息
* 在 addExposureDeal 之前调用
*
*/
- (void)addExposureBaseInfo:(Tao800AnalysisExposureContentVO *)exposureContentVO;

/**
* @param exposureDeal
* @param countToUpload 默认取6，当deal达到这个数量时进行上传数据
*/
- (void)addExposureDeal:(Tao800AnalysisExposureContentDealVO *)exposureDeal;

/**
* 当退出商品列表页面时需要调用该方法
*/
- (void)removeExposureBaseInfo:(Tao800AnalysisExposureContentVO *)exposureContentVO;

@end
