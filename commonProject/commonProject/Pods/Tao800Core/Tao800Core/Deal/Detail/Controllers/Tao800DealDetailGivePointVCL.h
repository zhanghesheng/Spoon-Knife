//
//  Tao800DealDetailGivePointVCL.h
//  tao800
//
//  Created by enfeng on 14-4-11.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800VCL.h"

typedef void (^GivePointBlock)(void);

@interface Tao800DealDetailGivePointVCL : Tao800VCL
@property(weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property(weak, nonatomic) IBOutlet UILabel *topTipLabel;
@property(weak, nonatomic) IBOutlet TBImageView *centerImageView;
@property(weak, nonatomic) IBOutlet TBHtmlLabel *pointShowHtml;
@property(weak, nonatomic) IBOutlet UILabel *bottomTipLabel;
@property(weak, nonatomic) IBOutlet UIButton *getPointButon;
@property(weak, nonatomic) IBOutlet Tao800RectangleBorderButton *cancelButton;

@property(copy, nonatomic) GivePointBlock givePointBlock;

- (IBAction)getPointAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

@end
