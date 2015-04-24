//
//  Tao800StartBannerCPT.h
//  tao800
//
//  Created by enfeng on 14/12/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TBUI/TBBaseViewCTL.h>

@interface Tao800StartBannerCPT : NSObject

+  (void)displayOn:(TBBaseViewCTL *)targetController closeCallback:(TBBGoBackBlock)closeCallback;

@end
