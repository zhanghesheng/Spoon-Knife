//
//  Tao800ShareVo.h
//  tao800
//
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "TBShareKit/TBShareVo.h"
#import "Tao800StaticConstant.h"

@interface Tao800ShareVo : TBShareVo

@property (nonatomic, assign) TBBShareToTag shareToTag;

@property (nonatomic, copy) NSString *messageSuffix;
@end
