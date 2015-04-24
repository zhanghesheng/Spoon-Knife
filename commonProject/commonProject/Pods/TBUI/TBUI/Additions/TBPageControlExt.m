//
// Created by enfeng on 13-4-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBPageControlExt.h"
#import <QuartzCore/QuartzCore.h>

@implementation TBPageControlExt {

}
@synthesize activeImage = _activeImage;
@synthesize inactiveImage = _inactiveImage;


- (void)updateDots {
    if (_activeImage == nil) {
        return;
    }
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        if ([dot isKindOfClass:[UIImageView class]]) {
            if (i == self.currentPage) dot.image = _activeImage;
            else dot.image = _inactiveImage;
        } else { 
            if (i == self.currentPage) {
                dot.layer.contents = (id)_activeImage.CGImage;
            } else {
                dot.layer.contents = (id)_inactiveImage.CGImage;
            } 
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)dealloc { 
}
@end