//
// Created by enfeng on 13-4-24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Tao800BorderItem : NSObject {
    BOOL _canSelect;
    UIColor *_backgroundColor;
}
@property(nonatomic) BOOL canSelect;
@property(nonatomic, strong) UIColor *backgroundColor;


@end