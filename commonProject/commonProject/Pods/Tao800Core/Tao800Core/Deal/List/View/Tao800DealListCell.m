//
//  Tao800DeaListCell.m
//  tao800
//
//  Created by enfeng on 14-2-12.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800DealListCell.h"
#import "Tao800DealListItem.h"
#import "Tao800FunctionCommon.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800UGCSingleton.h"

@interface Tao800DealListCell ()


@end

@implementation Tao800DealListCell

- (void) resetMenuButton {
    Tao800DealListItem *item = (Tao800DealListItem *) _item;
    if (!item) {
        return;
    }
    Tao800DataModelSingleton *dm = [Tao800DataModelSingleton sharedInstance];
    Tao800DealVo *dealVo = item.dealVo;

    self.menuButton1.backgroundColor = [UIColor clearColor];
    UIImage *favoriteImage = TBIMAGE(@"bundle://favorite@2x.png");
    UIImage *noFavoriteImage = TBIMAGE(@"bundle://favorite_never@2x.png");

    if (dm.favoriteDealIds && [dm.favoriteDealIds containsObject:@(dealVo.dealId)]) {
        [self.menuButton1 setImage:favoriteImage forState:UIControlStateNormal];
    } else {
        [self.menuButton1 setImage:noFavoriteImage forState:UIControlStateNormal];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(resetMenuButton)
                       name:Tao800FavoriteDealDidChangeNotification
                     object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Overridden Methods

- (void)layoutSubviews {
    [super layoutSubviews];
    Tao800DealListItem *item = (Tao800DealListItem *) _item;
    if (!item) {
        return;
    }
    [self.itemView layoutSubviews];

    [self resetMenuButton];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.itemView prepareForReuse];
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 99;
}

- (void)setObject:(id)object {
    [super setObject:object];

    Tao800DealListItem *item = (Tao800DealListItem *) _item;
    if (!item) {
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.itemView.imageView.defaultImage = TBIMAGE(@"bundle://common_list_default@2x.png");
    
    NSString *exposureStr = [[Tao800UGCSingleton sharedInstance] getExposureStringByDealId:item.dealVo.dealId
                                                                                     index:item.sortId
                                                                                     ctype:item.dealDetailFrom
                                                                                       cId:item.cId];
    [self.itemView.imageView setUrlPath:item.dealVo.hd4ImageUrl referrer:exposureStr];

    if(!item.dealVo.hd4ImageUrl){
        [self.itemView.imageView setUrlPath:item.dealVo.smallImageUrl referrer:exposureStr];
    }
    
    self.itemView.maskView2.backgroundColor = [UIColor clearColor]; 
    
    [Tao800DealListBaseCell resetItemView:self.itemView deal:item.dealVo item:item];
    [self resetMenuButton];
}
@end
