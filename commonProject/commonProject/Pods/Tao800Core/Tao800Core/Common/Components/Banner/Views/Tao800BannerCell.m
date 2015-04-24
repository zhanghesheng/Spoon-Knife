//
//  Tao800BannerCell.m
//  tao800
//
//  Created by enfeng on 14/12/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800BannerCell.h"
#import "TBCore/TBCore.h"
#import "Tao800Banneritem.h"

@implementation Tao800BannerCell

+ (CGFloat) bannerCellHeight {
    CGFloat height = 122;
    
    if (TBIsIPhone6()) {
        height = 146;
    } else if (TBIsIPhone6Plus()) {
        height = TBGetIphone6PlusHeightByScaleWidth375Height(146);
    }
    return height;
}

- (void) initContent {
    CGRect rect = self.bounds;
    rect.size.height = [Tao800BannerCell bannerCellHeight];
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    Tao800BannerView *bannerView2 = [[Tao800BannerView alloc] initWithFrame:rect];
    [self.contentView addSubview:bannerView2];
    self.bannerView = bannerView2;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self initContent];
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContent];
    }
    return self;
}

+ (NSString*) tbIdentifier {
    return @"Tao800BannerCell";
}

+ (CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return [Tao800BannerCell bannerCellHeight];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.bannerView.frame = self.bounds;
}

- (void) prepareForReuse {
    [super prepareForReuse];
}

- (void) setObject:(id)object {
    [super setObject:object];
    
    Tao800BannerItem *bannerItem = (Tao800BannerItem*)_item;
    if (!bannerItem) {
        return;
    }
    NSInteger currentPage = self.bannerView.currentPage;
    if (self.bannerView.bannerArray.count != bannerItem.bannerArray.count) {
        currentPage = 0;
    }
  
    self.bannerView.bannerArray = bannerItem.bannerArray;
    
    if (currentPage>0) {
        self.bannerView.currentPage = currentPage;
       [self.bannerView reloadData];
    }
}



@end
