//
//  Tao800StartBannerVCL.h
//  tao800
//
//  Created by enfeng on 14/12/12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800VCL.h"
#import "Tao800StartNewsView.h"

@interface Tao800StartBannerVCL : Tao800VCL <Tao800StartNewsViewDelegate>

@property(nonatomic, weak) IBOutlet Tao800StartNewsView *startNewsView;

- (IBAction)handlerDetailAction:(id)sender;

- (IBAction)handlerSkipAction:(id)sender;

@end
