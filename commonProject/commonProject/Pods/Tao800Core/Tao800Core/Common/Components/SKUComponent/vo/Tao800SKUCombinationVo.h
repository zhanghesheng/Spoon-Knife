//
//  Tao800SKUCombinationVo.h
//  tao800
//
//  Created by hanyuan on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

//组合属性，比如（红色，m号）组合
//"activeProductCount": "0",
//"curPrice": "1",
//"orgPrice": "101",
//"sellerClassNum": "",
//"shelf": ""
@interface Tao800SKUCombinationVo : NSObject
@property(nonatomic, assign)int availableCount;
@property(nonatomic, copy)NSString *curPrice;
@property(nonatomic, copy)NSString *orgPrice;
@end
