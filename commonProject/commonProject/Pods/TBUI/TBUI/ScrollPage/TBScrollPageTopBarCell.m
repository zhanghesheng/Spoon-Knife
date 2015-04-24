//
//  TBScrollPageTopBarCell.m
//  TBScrollPageDemo
//
//  Created by enfeng on 14-4-10.
//  Copyright (c) 2014年 enfeng. All rights reserved.
//

#import "TBScrollPageTopBarCell.h"
#import "TBScrollPageTopBar.h"

@implementation TBScrollPageTopBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        double dRotation = (M_PI / 180.0) * 90.0f;
        CGFloat fRotation = (CGFloat) dRotation;
        CGAffineTransform transform = CGAffineTransformMakeRotation(fRotation);

        CGRect rect = self.contentView.frame;
        self.contentView.transform = transform;
        self.contentView.frame = rect;

        UIView *bgView = [[UIView alloc] initWithFrame:
                CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.selectedBackgroundView = bgView;
        self.selectedBackgroundView.transform = transform;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setObject:(NSObject *)obj {
    if (_item) {
        //TB_RELEASE_SAFELY(_item);
        _item = nil;
    }
    _item = obj;//[obj retain];
}

- (void)dealloc {

}

+ (CGFloat)pageTopBar:(UITableView *)pageTopBar columnWidthForObject:(id)object {
    return 60;
}
@end
