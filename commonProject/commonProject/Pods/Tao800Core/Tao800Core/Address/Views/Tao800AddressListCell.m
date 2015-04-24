//
//  Tao800AddressListCell.m
//  tao800
//
//  Created by LeAustinHan on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressListCell.h"

#import "Tao800AddressListItems.h"
#import "Tao800AddressListVo.h"
#import "Tao800FunctionCommon.h"
#import "Tao800StyleSheet.h"

@implementation Tao800AddressListCell

@synthesize name = _name;
@synthesize mobile = _mobile;
@synthesize addressDetail = _addressDetail;

CGFloat const Tao800AddressListCellHeight = 72;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _name.font = V3_28PX_FONT;
        _mobile.font = V3_28PX_FONT;
        _addressDetail.font = V3_22PX_FONT;
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
}

-(void)setObject:(id)object{
    [super setObject:object];
    
    Tao800AddressListItems *item = (Tao800AddressListItems *) _item;
    
    _name.text = item.vo.receiverName;
    CGRect rect = _name.frame;
    //获取内容自适应文字长度
    rect.size.width = [_name.text sizeWithFont:_name.font
                             constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].width;
    
    if (rect.size.width >155.0) {
        rect.size.width = 155.0;
    }
    _name.frame = rect;
    CGRect rectAddress = _mobile.frame;
    rectAddress.origin.x = rect.origin.x + rect.size.width +5;
    rectAddress.size.width = self.frame.size.width - rect.origin.x - rect.size.width - 10;
    //    _address.frame = rectAddress;
    _mobile.text = item.vo.mobile;
    _addressArea.text =  [NSString stringWithFormat:@"%@%@%@",item.vo.provinceName,item.vo.cityName,item.vo.countyName];
    _addressDetail.text = item.vo.address;
    _isSelectedTip.hidden = YES;
    if (item.vo.isDefault) {
        _isDefaultTip.hidden = NO;
    }else{
        _isDefaultTip.hidden = YES;
    }
    if (item.vo.isSelected) {
        _isSelectedTip.hidden = NO;
    }else{
        _isSelectedTip.hidden = YES;
    }
    [self setUserInteractionEnabled:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _name.textColor = TEXT_COLOR_BLACK2;
    _addressArea.textColor = TEXT_COLOR_BLACK6;
    _addressDetail.textColor = TEXT_COLOR_BLACK2;
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();
    
    self.lineLayer.frame = CGRectMake(10,
                                      self.height - h,
                                      self.width - 20, h);
    [CATransaction commit];
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    return Tao800AddressListCellHeight;
}

@end

