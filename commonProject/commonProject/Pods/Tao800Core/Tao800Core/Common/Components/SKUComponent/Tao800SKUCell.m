//
//  Tao800SKUCell.m
//  tao800
//
//  Created by hanyuan on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SKUCell.h"
#import "Tao800SKUItem.h"
#import "Tao800SKUPropertyVo.h"

const int HMargin = 20;
const int VMargin = 10;
const int PropertyFontSize = 17;
const int widthDelta = 10;

@implementation Tao800SKUCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed: @"Tao800SKUCell" owner: self options: nil];
        [self addSubview: self.customContent];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    UIScreen *sc = [UIScreen mainScreen];
    CGFloat width1 = sc.bounds.size.width;
    
    Tao800SKUItem *item = (Tao800SKUItem*)object;
    CGFloat width = width1-2*HMargin;
    UIFont *font = [UIFont systemFontOfSize:PropertyFontSize];
    CGFloat leftWidth = width1-2*HMargin;
    CGFloat contentHeight = 0;
    
    NSArray *propertyList = item.propertyList;
    for(Tao800SKUPropertyVo *vo in propertyList){
        NSString *value = vo.vName;
        CGSize size = [value sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat propertyWidth = size.width + widthDelta;
        if(leftWidth-propertyWidth>0){
            leftWidth -= propertyWidth+HMargin;
            if(contentHeight==0){
                contentHeight += size.height+VMargin;
            }
        }else{
            contentHeight += size.height+VMargin;
            leftWidth = width1-2*HMargin-propertyWidth-HMargin;
        }
    }
    return 44+contentHeight+1;
}

- (void)setObject:(id)object {
    [super setObject:object];
    if (_item == nil) {
        return;
    }
    
    Tao800SKUItem *item = (Tao800SKUItem*)_item;
    if (item == nil) {
        return;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    Tao800SKUItem *item = (Tao800SKUItem*)_item;
    if (item == nil) {
        return;
    }
    
    if(item.lastSKU){
        self.seperateLine.hidden = NO;
    }else{
        self.seperateLine.hidden = YES;
    }
    
    [self.skuContentView removeAllSubviews];
    UIScreen *sc = [UIScreen mainScreen];
    CGFloat width1 = sc.bounds.size.width;
    
    CGFloat width = width1-2*HMargin;
    UIFont *font = [UIFont systemFontOfSize:PropertyFontSize];
    CGFloat leftWidth = width1-2*HMargin;
    CGFloat contentHeight = 0;
    CGFloat posX = HMargin;
    CGFloat posY = 0;
    
    NSArray *propertyList = item.propertyList;
    for(int i=0; i<propertyList.count; ++i){
        Tao800SKUPropertyVo *vo = [propertyList objectAtIndex:i];
        
        if(i == 0){
            self.skuTitle.text = [NSString stringWithFormat:@"%@:", vo.pName];
        }
        
        NSString *value = vo.vName;
        CGSize size = [value sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat propertyWidth = size.width + widthDelta;
        
        if(leftWidth-propertyWidth >= 0){
            posX = width1-HMargin-leftWidth;
            posY = contentHeight==0?0:contentHeight-size.height-VMargin;
            
            leftWidth -= propertyWidth+HMargin;
            if(contentHeight==0){
                contentHeight += size.height+VMargin;
            }
        }else{
            contentHeight += size.height+VMargin;
            posX = HMargin;
            posY = contentHeight-size.height-VMargin;
            leftWidth = width1-2*HMargin-propertyWidth-HMargin;
        }
        
        CGRect rect = CGRectMake(posX, posY, propertyWidth, size.height);
        UILabel *propertyLabel = [[UILabel alloc] initWithFrame: rect];
        propertyLabel.tag = i;
        propertyLabel.font = [UIFont systemFontOfSize:PropertyFontSize];
        propertyLabel.textAlignment = NSTextAlignmentCenter;
        propertyLabel.numberOfLines = 0;
        propertyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(propertyTapped:)];
        [propertyLabel addGestureRecognizer:tapGestureRecognizer];
        propertyLabel.text = value;
        
        switch (vo.selectState) {
            case SKUSelectedState_Available:{
                propertyLabel.backgroundColor = RGBCOLOR(236, 236, 236);
                propertyLabel.textColor = RGBCOLOR(113, 113, 113);
                propertyLabel.layer.borderWidth = 1;
                propertyLabel.layer.borderColor = RGBCOLOR(217, 217, 217).CGColor;
                propertyLabel.userInteractionEnabled = YES;
            }
                break;
            case SKUSelectedState_Selected:{
                propertyLabel.backgroundColor = RGBCOLOR(232, 74, 106);
                propertyLabel.textColor = [UIColor whiteColor];
                propertyLabel.userInteractionEnabled = YES;
            }
                break;
            default:{
                propertyLabel.backgroundColor = RGBCOLOR(247, 247, 247);
                propertyLabel.textColor = RGBCOLOR(213, 213, 213);
                propertyLabel.layer.borderWidth = 1;
                propertyLabel.layer.borderColor = RGBCOLOR(240, 240, 240).CGColor;
                propertyLabel.userInteractionEnabled = NO;
            }
                break;
        }
        [self.skuContentView addSubview:propertyLabel];
    }
    CGRect skuContentRect = self.skuContentView.frame;
    skuContentRect.size.height = contentHeight;
    self.skuContentView.frame = skuContentRect;
    
    CGRect seperateRect = self.seperateLine.frame;
    seperateRect.origin.y = self.skuContentView.frame.origin.y+self.skuContentView.frame.size.height;
    self.seperateLine.frame = seperateRect;
    
    CGRect contentRect = self.customContent.frame;
    contentRect.size.height = 44+self.skuContentView.frame.size.height+1;
    contentRect.size.width = self.width-20;
    self.customContent.frame = contentRect;
    
    CGRect lRect = self.lineView.frame;
    lRect.size.width = self.width - 20;
    self.lineView.frame = lRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)propertyTapped:(id)sender{
    Tao800SKUItem *item = (Tao800SKUItem*)_item;
    if (item == nil) {
        return;
    }
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UILabel *propertyLabel = (UILabel *)tap.view;
    NSInteger index = propertyLabel.tag;
    
    NSArray *propertyList = item.propertyList;
    Tao800SKUPropertyVo *vo = [propertyList objectAtIndex:index];
    NSString *vId = vo.vId;
    
    int dimensionIndex = item.dimensionIndex;
    if([self.delegate respondsToSelector:@selector(propertyDidSelected:propertyId:)]){
        [self.delegate propertyDidSelected:dimensionIndex propertyId:vId];
    }
}

@end
