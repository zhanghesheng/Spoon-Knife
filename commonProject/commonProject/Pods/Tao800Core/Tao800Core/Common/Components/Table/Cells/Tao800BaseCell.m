//
// Created by enfeng on 13-4-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800BaseCell.h"
#import "Tao800FunctionCommon.h"
#import "Tao800StyleSheet.h"

@interface Tao800BaseCell () {

}
@end

@implementation Tao800BaseCell

- (void)initView {
    UIView *selView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView = selView;
    UIColor *bgColor = BACKGROUND_COLOR_GRAY1;
    selView.backgroundColor = bgColor;

    CALayer *layer1 = [CALayer layer];
    [self.contentView.layer addSublayer:layer1];
    layer1.backgroundColor = BORDERLINE_COLOR_GRAY1.CGColor;
    self.lineLayer = layer1;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    if (self) {

        [self initView];

    }
    return self;
}

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];

    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();

    self.lineLayer.frame = CGRectMake(0,
            self.height - h,
            self.width, h);
    [CATransaction commit];
}
@end