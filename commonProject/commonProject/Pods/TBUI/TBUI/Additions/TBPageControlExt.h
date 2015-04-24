//
// Created by enfeng on 13-4-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBPageControlExt : UIPageControl{
    UIImage *_activeImage;
    UIImage *_inactiveImage;
}
@property(nonatomic, strong) UIImage *activeImage;
@property(nonatomic, strong) UIImage *inactiveImage;


@end