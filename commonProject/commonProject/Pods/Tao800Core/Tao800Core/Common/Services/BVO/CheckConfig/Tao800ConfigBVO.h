//
//  Tao800ConfigBVO.h
//  tao800
//
//  Created by enfeng on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tao800SoftVo;
@class Tao800ConfigTipBVO;
@class Tao800CheckConfigTaoBaoSwitchBVO;

@interface Tao800ConfigBVO : NSObject<NSCopying>

@property (nonatomic, strong) Tao800SoftVo *softVo;
@property (nonatomic, strong) Tao800ConfigTipBVO *configTipBVO;
@property (nonatomic, strong) Tao800CheckConfigTaoBaoSwitchBVO *taoBaoSwitchBVO;

- (id)copyWithZone:(NSZone *)zone;
@end
