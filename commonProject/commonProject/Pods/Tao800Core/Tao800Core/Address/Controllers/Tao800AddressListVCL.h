//
//  Tao800AddressListVCL.h
//  tao800
//
//  Created by LeAustinHan on 14-4-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800TableVCL.h"

#import "Tao800AddressListVo.h"

//获取到列表以及选择地址时调用
typedef void (^AddressListCallBack)(Tao800AddressListVo* addressListVo);

@interface Tao800AddressListVCL : Tao800TableVCL<Tao800ScreenTipViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate>

@property (nonatomic, copy) AddressListCallBack addressListCallBack;

@end
