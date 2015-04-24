//
//  Tao800BlankItem.m
//  tao800
//
//  Created by LeAustinHan on 14-10-22.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BlankItem.h"

@implementation Tao800BlankItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enableDisplayTopLine = YES;
        self.enableDisplayBottomLine = YES;
    }
    return self;
}
@end
