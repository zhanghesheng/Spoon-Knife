//
//  Tao800ScrollPageTopBarCell.m
//  tao800
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800ScrollPageTopBarCell.h" 

@implementation Tao800ScrollPageTopBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.highlightedTextColor = [UIColor redColor];
        self.textLabel.textColor = [UIColor blackColor];
        
        CGRect rect = CGRectZero;
        _bottomLineView = [[UIView alloc] initWithFrame:rect];
        _bottomLineView.backgroundColor = [UIColor orangeColor];
        
        [self.selectedBackgroundView addSubview:_bottomLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.contentView.frame;
    rect.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.contentView.frame = rect;
    
    CGFloat height = rect.size.height;
    CGFloat cellWidth = rect.size.width;
    
    CGRect textRect = self.textLabel.frame;
    textRect.size = [self.textLabel.text sizeWithFont:self.textLabel.font
                                    constrainedToSize:CGSizeMake(height, cellWidth)];
    textRect.origin.x = (self.frame.size.height - textRect.size.width) / 2;
    textRect.origin.y = (self.frame.size.width-textRect.size.height)/2;
    self.textLabel.frame = textRect;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView.frame = rect;
    
    CGFloat w = self.frame.size.height;
    CGFloat h = 1.5;
    CGFloat x = 0;
    CGFloat y = cellWidth - h;
    
    _bottomLineView.frame = CGRectMake(x, y, w, h);
    _bottomLineView.backgroundColor = [UIColor redColor];
}

- (void)setObject:(NSObject *)obj {
    [super setObject:obj];
    
    if (!_item) {
        return;
    }
    
    TBScrollPageTopBarItem *item = (TBScrollPageTopBarItem *) _item;
    self.textLabel.text = item.text;
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textLabel.text = nil;
}

+ (CGFloat)pageTopBar:(UITableView *)pageTopBar columnWidthForObject:(id)object {
    TBScrollPageTopBarItem *item = (TBScrollPageTopBarItem*)object;
    CGSize size = [item.text sizeWithFont:[UIFont systemFontOfSize:14]
                        constrainedToSize:CGSizeMake(300, 20)];
    return size.width+40;
}
@end
