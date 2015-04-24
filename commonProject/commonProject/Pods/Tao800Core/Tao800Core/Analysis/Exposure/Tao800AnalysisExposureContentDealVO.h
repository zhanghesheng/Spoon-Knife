//
//  Tao800AnalysisExposureContentDealVO.h
//  Tao800Core
//
//  Created by enfeng on 15/3/11.
//  Copyright (c) 2015年 tao800. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tao800AnalysisExposureContentDealVO : NSObject

@property(nonatomic, copy) NSString *parentIdentifier; //父级id(Tao800AnalysisExposureContentVO#exposureIdentifier)
@property(nonatomic, copy) NSString *exposureDealId; //商品id
@property(nonatomic, strong) NSNumber *exposureOrderIndex; //顺序号
@property(nonatomic, strong) NSNumber *exposureTime; //客户端曝光时间（unix时间戳）精确到秒


@end
