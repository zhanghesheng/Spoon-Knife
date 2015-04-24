//
//  Tao800MyGiftVo.h
//  tao800
//
//  Created by zhangwenguang on 13-4-9.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tao800RewardOrderVo.h"

@interface Tao800MyPresentVo : NSObject
{
    Tao800RewardOrderVo *_detailVo;

    int _type;

}
@property(nonatomic,strong)Tao800RewardOrderVo *detailVo;
@property(nonatomic,assign)int type;

@end
