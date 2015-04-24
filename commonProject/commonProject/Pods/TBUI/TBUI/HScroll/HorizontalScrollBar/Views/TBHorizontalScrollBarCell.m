//
// Created by enfeng on 12-10-26.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBHorizontalScrollBarCell.h"
#import "TBCore/TBCoreMacros.h"

@implementation TBHorizontalScrollBarCell

+ (CGFloat)tableView:(UITableView*)tableView rowWidthForObject:(id)object {
    return 60;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.contentView.frame;
    rect.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.contentView.frame = rect;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {

        CGFloat kRotation =(CGFloat) (M_PI / 180.0) * 90.0f;
        CGAffineTransform transform = CGAffineTransformMakeRotation(kRotation);

        CGRect rect = self.contentView.frame;
        self.contentView.transform = transform;
        self.contentView.frame = rect;

        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView.transform = transform;
    }
    return self;
}

- (void)setObject:(NSObject *)obj {
    _item = obj;
}

- (void)dealloc { 
}

@end