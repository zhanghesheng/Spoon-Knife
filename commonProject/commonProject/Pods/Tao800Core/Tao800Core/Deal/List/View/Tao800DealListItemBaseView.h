//
//  Tao800DealListItemBaseView.h
//  tao800
//
//  Created by enfeng on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBUI/TBUI.h"
#import "Tao800DeleteLineLabel.h"
#import "Tao800DealListItemMaskView.h"

@class Tao800DealBaseItem;

@interface Tao800DealListItemBaseView : UIView

@property (weak, nonatomic) IBOutlet TBImageView *tianMaoImageView;
@property (weak, nonatomic) IBOutlet TBImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet TBImageView *todayImageView;
@property (weak, nonatomic) IBOutlet TBImageView *privilegeImageView;
@property (weak, nonatomic) IBOutlet TBImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldCountLabel;
@property (weak, nonatomic) IBOutlet Tao800DeleteLineLabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipPrivilegeLabel;

@property (strong, nonatomic) id userData;

@property (weak, nonatomic) IBOutlet Tao800DealListItemMaskView *maskView2;

@property (nonatomic) BOOL htmlFlag;
@property (nonatomic, copy) NSString* htmlString;

@property (nonatomic, strong) Tao800DealBaseItem *item;

- (void)prepareForReuse;
@end
