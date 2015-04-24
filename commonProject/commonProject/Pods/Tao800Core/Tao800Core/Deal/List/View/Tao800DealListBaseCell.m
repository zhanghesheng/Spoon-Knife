//
//  Tao800DealListBaseCell.m
//  tao800
//
//  Created by enfeng on 14-2-21.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListBaseCell.h"
#import "Tao800DealVo.h"
#import "Tao800FunctionCommon.h"
#import "Tao800Util.h"
#import <TBCore/TBCoreCommonFunction.h>
#import "Tao800NotifycationConstant.h"
#import "Tao800PromotionHomeOperationVo.h"
#import "TBUI/UILabelAddtions.h"

@implementation Tao800DealListBaseCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    return self;
}

-(void)customInit{
    TBAddObserver(Tao800PromotionOperationModelDidChangeNotification, self, @selector(promotionOperationDidChange:), nil);
}

- (void)promotionOperationDidChange:(NSNotification *)note {
    
    [self refreshTitleLabel];
}

-(void)refreshTitleLabel{
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    //[_tianMaoImageView unsetImage];
}

+ (void)resetItemView:(Tao800DealListItemBaseView *)itemView deal:(Tao800DealVo *)deal item:(Tao800DealBaseItem *)item{
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    NSDictionary *operationDict = [dm getPromotionHomeOperationModel];

    itemView.item = item;

    //用于曝光打点的判断
    item.appearTime = [[NSDate date] timeIntervalSince1970];
    item.disappearTime = 0;

    Tao800PromotionHomeOperationVo *vo = [Tao800PromotionHomeOperationVo wrapperOperationVo:operationDict];
    BOOL htmlFlag = NO;
    if (vo.showPromotionHomePage) {
        if (deal.sourceType == Tao800DealSourceTypeMall) {
            if (vo.showShopTip) {
                htmlFlag = YES;
            }else{
                htmlFlag = NO;
            }
        }else{
            if (deal.shopType == ShopTypeTianMao && vo.showTianmaoTip) {
                htmlFlag = YES;
            }else if(deal.shopType == ShopTypeTaoBao && vo.showTaobaoTip){
                htmlFlag = YES;
            }
        }
    }
    
    if (htmlFlag && (item.dealDetailFrom == Tao800DealDetailFromNewCategory || item.dealDetailFrom == Tao800DealDetailFromHome)) {
        htmlFlag = YES;
    }else{
        htmlFlag = NO;
    }
    
    [Tao800DealListBaseCell resetItemView:itemView deal:deal];
    
    itemView.htmlFlag = htmlFlag;
    itemView.htmlString = vo.tip;

    NSString* showString = nil;
    //<font face='Helvetica' size='13' color='#E50F3C' line='u' >Hello world</font>
    if (itemView.htmlFlag && itemView.htmlString && itemView.htmlString.length > 0) {
        showString = [NSString stringWithFormat:@"<font size='14' color='#E50F3C' >%@</font><font size='14' color='#333333' >%@</font>", itemView.htmlString, itemView.titleLabel.text];
    }else{
        showString = [NSString stringWithFormat:@"<font size='14' color='#333333' >%@</font>", itemView.titleLabel.text];
    }
    
    [itemView.titleLabel styleAttributedText:showString];
 
}

+ (void)resetItemView:(Tao800DealListItemBaseView *)itemView deal:(Tao800DealVo *)deal {
//    itemView.imageView.imageUrlPath = deal.normalImageUrl;
   
    
    itemView.maskView2.hidden = YES;
    itemView.maskView2.titleLabel.text = nil;
    
    itemView.titleLabel.text = deal.shortTitle;
    itemView.priceLabel.text = [NSString stringWithFormat:@"¥%@", FenToYuanFormat(deal.price)];
    itemView.marketPriceLabel.text = [NSString stringWithFormat:@"¥%@", FenToYuanFormat(deal.listPrice)];
    itemView.marketPriceLabel.textColor = [UIColor lightGrayColor];
    itemView.userData = deal;

    if (!itemView.titleLabel.text || itemView.titleLabel.text.length < 1) {
        itemView.titleLabel.text = deal.title;
    }
    
    // 判断是否包邮
    if (deal.isBaoyou) {
        itemView.postLabel.text = @"包邮";
    } else {
        itemView.postLabel.text = nil;
    }

    // 判断是否反积分
    if (deal.isFanjifen) {
        itemView.pointLabel.text = @"返积分";
        if (deal.scores && deal.scores.count > 0) {
            Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
            NSString *key = [dm.myGradeVo getGradeKey];
            NSNumber *score = deal.scores[key];
            if (score) {
                itemView.pointLabel.text = [NSString stringWithFormat:@"+%@积分", score];
            }
        }
    } else {
        itemView.pointLabel.text = nil;
    }

    // 计算折扣
    NSString *discount = ComputeDiscount(deal.listPrice, deal.price);
    itemView.discountLabel.text = [NSString stringWithFormat:@"%@折", discount];
    //common_ourshop_bg@2x.png
    //判断是否是天猫商品
    
    if (deal.sourceType == Tao800DealSourceTypeMall) {
        UIImage *ourShopImage = TBIMAGE(@"bundle://common_ourshop.png");
        itemView.tianMaoImageView.hidden = NO;
        itemView.tianMaoImageView.defaultImage = ourShopImage;
        itemView.tianMaoImageView.frame = CGRectMake(0, 0, 74/2, 32/2);
    }else{
        UIImage *tianMaoImage = TBIMAGE(@"bundle://common_tiaomao_bg@2x.png");
        itemView.tianMaoImageView.frame = CGRectMake(0, 0, 10, 10);
        switch (deal.shopType) {
            
            case ShopTypeTianMao: {
                itemView.tianMaoImageView.hidden = NO;
                itemView.tianMaoImageView.defaultImage = tianMaoImage;
            }
                break;
            case ShopTypeTaoBao: {
                tianMaoImage = TBImage(@"bundle://common_taobao_bg@2x.png");
                itemView.tianMaoImageView.hidden = NO;
                itemView.tianMaoImageView.defaultImage = tianMaoImage;
            }
                break;
            case ShopTypeDefault: {
                itemView.tianMaoImageView.hidden = YES;
            }
                break;
        }
    }

    itemView.soldOutImageView.hidden = YES;
    itemView.todayImageView.hidden = YES;
    itemView.privilegeImageView.hidden = YES;
    itemView.tipPrivilegeLabel.hidden = YES;
    itemView.soldOutImageView.backgroundColor = [UIColor clearColor];
    itemView.todayImageView.backgroundColor = [UIColor clearColor];
    itemView.privilegeImageView.backgroundColor = [UIColor clearColor];
    itemView.tianMaoImageView.backgroundColor = [UIColor clearColor];
    itemView.tipLabel.text = nil;
    
    if (deal.beginTime && [deal.beginTime length] > 0) {
        BOOL expired = [Tao800Util isBeginStarted:deal];
        if (expired) {
    
            itemView.maskView2.hidden = NO;
            itemView.maskView2.showCircle = YES;
            itemView.maskView2.titleLabel.text = @"未开始";
            
            itemView.soldOutImageView.hidden = YES;
            itemView.tipLabel.text = @"未开始";
            itemView.soldOutImageView.defaultImage = TBIMAGE(@"bundle://common_list_no_start@2x.png");
        } else if (deal.isZhuanxiang) {// 展示手机专享处,优先级高于new，低于未开始
            itemView.privilegeImageView.hidden = NO;
            itemView.tipPrivilegeLabel.hidden = NO;
            itemView.tipPrivilegeLabel.text = @"手机专享";
            itemView.privilegeImageView.defaultImage = TBIMAGE(@"bundle://common_mobile_privilege@2x.png");
            itemView.tipLabel.text = nil;
        } else if (deal.today) {
            itemView.todayImageView.hidden = NO;
            itemView.todayImageView.defaultImage = TBIMAGE(@"bundle://common_new_state_bg@2x.png");
            itemView.tipLabel.text = nil;
        }
    }
    else {//新上架
        if (deal.isZhuanxiang) {
            itemView.privilegeImageView.hidden = NO;
            itemView.tipPrivilegeLabel.hidden = NO;
            itemView.tipPrivilegeLabel.text = @"手机专享";
            itemView.privilegeImageView.defaultImage = TBIMAGE(@"bundle://common_mobile_privilege@2x.png");
        } else if (deal.today) {
            itemView.todayImageView.hidden = NO;
            itemView.todayImageView.defaultImage = TBIMAGE(@"bundle://common_new_state_bg@2x.png");
        }
        itemView.tipLabel.text = nil;
    }
    switch (deal.oos) {

        case DealSaleStateSelling:
            break;
        case DealSaleStateSellOut: {
            itemView.todayImageView.hidden = YES;
            itemView.privilegeImageView.hidden = YES;
            itemView.soldOutImageView.hidden = YES;
            itemView.tipLabel.text = @"已抢光";
            itemView.soldOutImageView.defaultImage = TBIMAGE(@"bundle://common_list_sold_out@2x.png");
            
            itemView.maskView2.hidden = NO;
            itemView.maskView2.showCircle = NO;
            itemView.maskView2.titleLabel.text = @"已抢光";
        }
            break;
    }
    
/*
    itemView.soldOutImageView.hidden = NO;
    itemView.tipLabel.text = @"已抢光";
    itemView.soldOutImageView.defaultImage = TBIMAGE(@"bundle://common_list_sold_out@2x.png");
*/
    if (!itemView.tipLabel.text) {
        //判断是否已经过期
        BOOL expired = [Tao800Util isDealExpired:deal];
        if (expired) {
            itemView.todayImageView.hidden = YES;
            itemView.privilegeImageView.hidden = YES;
            itemView.soldOutImageView.hidden = YES;
            itemView.tipLabel.text = @"已结束";
            itemView.soldOutImageView.defaultImage = TBIMAGE(@"bundle://common_list_sold_out@2x.png");
            
            itemView.maskView2.hidden = NO;
            itemView.maskView2.showCircle = NO;
            itemView.maskView2.titleLabel.text = @"已结束";
        }
    }
    
    if(deal.soldCount >= 0){
        if ([Tao800Util enableDisplaySaleCount:deal]) {
            itemView.soldCountLabel.hidden = NO;
            itemView.soldCountLabel.text = [NSString stringWithFormat:@"已售%d件", deal.soldCount];
        } else {
            itemView.soldCountLabel.hidden = YES;
        }
        
        NSDate * beginDate = [Tao800Util dateFromString:deal.beginTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * dateNow = [NSDate date];
        if ([beginDate compare:dateNow] == NSOrderedDescending) {
            itemView.soldCountLabel.text = nil;
        }
    }else{
        itemView.soldCountLabel.hidden = YES;
    }
    itemView.maskView2.userInteractionEnabled = NO;
    [itemView.maskView2 layoutSubviews];
    [itemView.maskView2 setNeedsDisplay];
}

- (void)setObject:(id)object {
    [super setObject:object];
}

@end
