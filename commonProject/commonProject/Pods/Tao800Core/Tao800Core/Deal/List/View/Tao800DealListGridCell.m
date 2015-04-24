//
//  Tao800DeaListGridCell.m
//  tao800
//  宫格
//  Created by enfeng on 14-2-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListGridCell.h"
#import "Tao800DealListGridItemView.h"
#import "Tao800DealListGridItem.h"
#import "Tao800DealVo.h"
#import "Tao800StyleSheet.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800TabButton.h"
#import "Tao800DataModelSingleton.h"
#import "Tao800UGCSingleton.h"
#import "TBCore/TBCore.h"

@interface Tao800DealListGridCell ()

@end

@implementation Tao800DealListGridCell

- (void)resetFavoriteButton:(NSNotification *)note {
    Tao800DealListGridItem *item = (Tao800DealListGridItem *) _item;
    if (!item) {
        return;
    }

//    Tao800DealVo *dealVo = [note.userInfo objectForKey:@"deal"];

    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    UIImage *favoriteImage = TBIMAGE(@"bundle://favorite_grid@2x.png");
    UIImage *favoriteImageHighlight = TBIMAGE(@"bundle://favorite_grid_select@2x.png");
    UIImage *noFavoriteImage = TBIMAGE(@"bundle://favorite_grid_never@2x.png");
    UIImage *noFavoriteImageHighlight = TBIMAGE(@"bundle://favorite_grid_never_select@2x.png");
    
    for (Tao800DealListGridItemView *itemView in self.itemViews) {
        Tao800DealVo *dealVo1 = itemView.userData;

        if (dm.favoriteDealIds && [dm.favoriteDealIds containsObject:@(dealVo1.dealId)]) {
            [itemView.favoriteButton setImage:favoriteImage forState:UIControlStateNormal];
            [itemView.favoriteButton setImage:favoriteImageHighlight forState:UIControlStateHighlighted];
        } else {
            [itemView.favoriteButton setImage:noFavoriteImage forState:UIControlStateNormal];
            [itemView.favoriteButton setImage:noFavoriteImageHighlight forState:UIControlStateHighlighted];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(resetFavoriteButton:)
                       name:Tao800FavoriteDealDidChangeNotification
                     object:nil];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    CGFloat defaultHeight = 237;
    
    if (TBIsIPhone6()) {
        return TBGetIphone6HeightByScaleWidth320Height(defaultHeight);
    }else if (TBIsIPhone6Plus()){
        return TBGetIphone6PlusHeightByScaleWidth320Height(defaultHeight);
    }
    return defaultHeight;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    for (Tao800DealListGridItemView *itemView in self.itemViews) {
        [itemView prepareForReuse];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int index =-1;
    for (UIView *itemView in self.itemViews) {
        index ++;
        CGRect rect = itemView.frame;
        if ([itemView isKindOfClass:[Tao800DealListGridItemView class]]) {
            rect.origin.x = ((self.width - rect.size.width*2)/3)*(index+1) + rect.size.width*(index);
            itemView.frame =rect;
            [itemView layoutSubviews];
        }
    }
}

- (void)setObject:(id)object {
    [super setObject:object];
    
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
        self.lineLayer = nil;
    }
    
    self.selectedBackgroundView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = BACKGROUND_COLOR_GRAY1;
    Tao800DealListGridItem *item = (Tao800DealListGridItem *) _item;
    if (!item) {
        return;
    }

    NSArray *subButtons = self.contentView.subviews;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (Tao800DealListGridItemView *itemView in subButtons) {
        if ([itemView isKindOfClass:[Tao800DealListGridItemView class]]) {
            itemView.hidden = YES;
            itemView.favoriteButton.hidden = YES;
            [array addObject:itemView];
        }
    }
    self.itemViews = array;
    
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];

    UIImage *hadFavoriteImage = TBIMAGE(@"bundle://favorite_grid@2x.png");
    UIImage *image2 = TBIMAGE(@"bundle://favorite_grid_never@2x.png");
    int index = -1;
    for (Tao800DealVo *deal in item.items) {
        index++;
        Tao800DealListGridItemView *itemView = self.itemViews[index];
        
        // 设置sortId
        if (index == 0) {
            itemView.maskButton.tag = item.sortId;
        }else {
            itemView.maskButton.tag = item.sortId+1;
        }
        
//        //把删掉的图片加回来
//        if (!itemView.imageView) {
//            TBImageView *imageView = [[TBImageView alloc] initWithFrame:itemView.imageViewRect];
//            itemView.imageView = imageView;
//            [itemView addSubview:itemView.imageView];
//            [itemView.imageView addSubview:itemView.tianMaoImageView];
//            [itemView bringSubviewToFront:itemView.maskButton];
//        }
        
        itemView.imageView.defaultImage = TBIMAGE(@"bundle://common_grid_default@2x.png");
        itemView.hidden = NO;
        itemView.favoriteButton.hidden = NO;
        [self.contentView addSubview:itemView.favoriteButton];

        BOOL hadFavorite = NO;
        for (NSNumber *dealId in dm.favoriteDealIds) {
            if (dealId.intValue == deal.dealId) {
                hadFavorite = YES;
            }
        }
        if (hadFavorite) {
            [itemView.favoriteButton setImage:hadFavoriteImage forState:UIControlStateNormal];
        } else {
            [itemView.favoriteButton setImage:image2 forState:UIControlStateNormal];
        }
        itemView.favoriteButton.backgroundColor = [UIColor clearColor];
        Tao800TabButton *btn = (Tao800TabButton *) itemView.favoriteButton;
        btn.userData = deal;

        itemView.userData = deal;
        
        itemView.maskView2.backgroundColor = [UIColor clearColor];
        itemView.maskView2.titleLabel.text = @"未开始";
        itemView.maskView2.hidden = YES;
        [Tao800DealListBaseCell resetItemView:itemView deal:deal item:item];
        
        NSString *exposureStr = [[Tao800UGCSingleton sharedInstance] getExposureStringByDealId:deal.dealId
                                                                                      index:(int)(itemView.maskButton.tag)
                                                                                      ctype:item.dealDetailFrom
                                                                                        cId:item.cId];
        [itemView.imageView setUrlPath:deal.hd5ImageUrl referrer:exposureStr];
        if (!deal.hd5ImageUrl || (deal.hd5ImageUrl && deal.hd5ImageUrl.length<1)) {
            //仅仅搜索用
            [itemView.imageView setUrlPath:deal.hd2ImageUrl referrer:exposureStr];
        }
        
        itemView.backgroundColor = BACKGROUND_COLOR_GRAY1;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
