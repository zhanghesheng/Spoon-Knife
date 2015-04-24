//
// Created by enfeng on 13-5-8.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Tao800RightArrowButton.h"
#import "TBUI/TBUI.h"

@implementation Tao800RightArrowButton {

}

- (void) resetButtonStyle {
    self.backgroundColor = [UIColor clearColor];

    UIImage *image = TBIMAGE(@"bundle://v6_common_border_button_orange_bg@2x.png");
    UIImage *borderImage = TBIMAGE(@"bundle://v6_common_border_button_bg@2x.png");
    borderImage = [borderImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];

    [self setBackgroundImage:borderImage forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSString *title = self.titleLabel.text;
    UIFont *font = self.titleLabel.font;
    CGFloat height = self.titleLabel.frame.size.height;
    CGSize size = [title sizeWithFont:font
                    constrainedToSize:CGSizeMake(MAXFLOAT, height)
                        lineBreakMode:self.titleLabel.lineBreakMode];

    //文字上下剧中，左对齐
//    CGFloat x = (self.frame.size.width-size.width)/2;
    CGFloat x = 10;
    CGFloat y = (self.frame.size.height-size.height)/2;
    CGRect rect;
    rect.origin = CGPointMake(x, y);
    rect.size = size;
    self.titleLabel.frame = rect;

    CGFloat width = self.imageView.image.size.width;
    height = self.imageView.image.size.height;

    //图片向右对齐
    x = self.width - width - 5;
    y = (self.height-height)/2;

    rect.origin = CGPointMake(x, y);
    rect.size = CGSizeMake(width, height);
    self.imageView.frame = rect;


}
@end