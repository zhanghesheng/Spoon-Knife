//
// Created by enfeng on 12-12-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBTableViewBorderCell.h"


@implementation TBTableViewBorderCell {

}

/**
* 适配载入xib文件
*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundView = [[TBUICellBackgroundView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {

        self.backgroundView = [[TBUICellBackgroundView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setPosition:(TBCellBackgroundViewPosition)newPosition {
    [(TBUICellBackgroundView *)self.backgroundView setPosition:newPosition];
}

@end