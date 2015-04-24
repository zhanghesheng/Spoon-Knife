//
// Created by enfeng on 13-4-17.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBTableFlushViewBorderCell.h"


@implementation TBTableFlushViewBorderCell {

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {

        self.backgroundView = [[TBUICellBackgroundView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setPosition:(TBCellBackgroundViewPosition)newPosition {
    [(TBUICellBackgroundView *) self.backgroundView setPosition:newPosition];
}
@end