//
//  Tao800AnalysisExposureContentVO.h
//  Tao800Core
//
//  Created by enfeng on 15/3/11.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800AnalysisExposureConstant.h"

@interface Tao800AnalysisExposureContentVO : NSObject

@property(nonatomic, copy) NSString *exposureUserId; //用户id
@property(nonatomic, copy) NSString *exposureDeviceId; //设备号
@property(nonatomic, copy) NSString *exposureFromSource; //来源， 取2
@property(nonatomic, copy) NSString *exposurePlatform; //平台
@property(nonatomic, copy) NSString *exposureVersion; //版本
@property(nonatomic, copy) NSString *exposureChannel; //渠道
@property(nonatomic, copy) NSString *exposureUserRole; //身份
@property(nonatomic, copy) NSString *exposureUserType; //新老用户
@property(nonatomic, copy) NSString *exposureSchool; //学生
@property(nonatomic, copy) NSString *exposureChild; //婴儿年龄_性别
@property(nonatomic, copy) NSString *exposureListVersion; //千人千面版本(首页、分类页)
@property(nonatomic) Tao800AnalysisExposurePostType exposurePosType; //页面类型
@property(nonatomic, copy) NSString *exposurePostValue; //页面属性
@property(nonatomic, copy) NSString *exposureRefer; //自定义来源

@property (nonatomic, strong) NSMutableArray *deals; //Tao800AnalysisExposureContentDealVO对象当集合

/**
* 重新设置对象的唯一标识
* md5(所有属性), 如md5(pro1_pro2_pro3_pro4...)
*/
- (void) resetExposureIdentifier;

/**
* 当前对象的唯一标识
* md5(所有属性), 如md5(pro1_pro2_pro3_pro4...)
*/
- (NSString *) exposureIdentifier;
@end
