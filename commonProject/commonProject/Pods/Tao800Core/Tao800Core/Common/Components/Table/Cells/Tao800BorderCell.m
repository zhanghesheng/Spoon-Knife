//
// Created by enfeng on 13-4-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800BorderCell.h"
#import "Tao800BorderCellBackgroundView.h"
#import "Tao800StyleSheet.h"
#import "Tao800BorderItem.h"

@implementation Tao800BorderCell {

}

- (void) initView {
    UIView *selView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView = selView;
    UIColor *bgColor= [UIColor colorWithHex:0xF9F9F9];
    selView.backgroundColor = bgColor;

    Tao800BorderCellBackgroundView *bgView = [[Tao800BorderCellBackgroundView alloc]
                                             initWithFrame:CGRectZero];
    self.backgroundView = bgView;
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

    Tao800BorderItem *item = (Tao800BorderItem *) _item;
    if (item == nil || ![item isKindOfClass:[Tao800BorderItem class]]) {
        return;
    }

    if (item.backgroundColor) {
        Tao800BorderCellBackgroundView *bgView = (Tao800BorderCellBackgroundView *) self.backgroundView;
        bgView.bgRGBAColor = item.backgroundColor; 
    }

    if (item.canSelect) {
//        TBImageView *accessoryView = [[TBImageView alloc] init];
//        accessoryView.imageUrlPath = @"bundle://v2_right_arrow@2x.png";
//        self.accessoryView = accessoryView;
//        [accessoryView release];

//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 10, 10);
//        UIImage *image1 = TBIMAGE(@"bundle://v2_right_arrow_heighlight@2x.png");
//        UIImage *image2 = TBIMAGE(@"bundle://v2_right_arrow@2x.png");
//        [btn setImage:image1 forState:UIControlStateHighlighted];
//        [btn setImage:image2 forState:UIControlStateNormal];
//        self.accessoryView = btn;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = nil;
    }
}
@end