//
//  Tao800DealDetailGivePointVCL.m
//  tao800
//
//  Created by enfeng on 14-4-11.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealDetailGivePointVCL.h"
#import "Tao800RectangleBorderButton.h"
#import "Tao800StyleSheet.h"
#import "Tao800DealDetailGivePointModel.h"

@interface Tao800DealDetailGivePointVCL ()

@end

@implementation Tao800DealDetailGivePointVCL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters {
    [super setParameters:parameters];
    Tao800DealDetailGivePointModel *pointModel = [[Tao800DealDetailGivePointModel alloc] init];
    self.model = pointModel;

    pointModel.dealVo = parameters[@"deal"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image1 = TBIMAGE(@"bundle://tip_give_point_bg@2x.png");
    UIImage *image2 = TBIMAGE(@"bundle://tip_red_bg_btn@2x.png");
    self.centerImageView.defaultImage = image1;

    self.topBackgroundView.backgroundColor = BACKGROUND_COLOR_RED1;
    self.bottomTipLabel.textColor = TEXT_COLOR_BLACK4;

    [self.cancelButton redBorderButtonStyle];
    [self.getPointButon setBackgroundImage:image2 forState:UIControlStateNormal];

    [self.pointShowHtml setTextAlignment:RTTextAlignmentCenter];

    Tao800DealDetailGivePointModel *pointModel = (Tao800DealDetailGivePointModel *) self.model;
    NSNumber *point = @(0);

    if (pointModel.dealVo.scores) {
        point = pointModel.dealVo.scores[@"z0"];
    }

    NSString *text = [NSString stringWithFormat:@"<font size=40 color='#ffffff'>%@</font><font size=15 color='#ffffff'>积分</font>", point];
    self.pointShowHtml.text = text;

    self.view.backgroundColor = [UIColor whiteColor];
    self.centerImageView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPointAction:(id)sender {
    __weak Tao800DealDetailGivePointVCL *instance = self;
    [self dismissViewControllerAnimated:NO completion:^{
        instance.givePointBlock();
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
