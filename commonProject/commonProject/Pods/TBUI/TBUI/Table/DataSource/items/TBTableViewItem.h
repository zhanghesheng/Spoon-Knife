//
// Created by enfeng on 13-1-24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TBTableItem.h"
@interface TBTableViewItem : TBTableItem {
    NSString* _caption;
    UIView* _view;
}

@property (nonatomic, copy) NSString* caption;
@property (nonatomic, strong) UIView* view;

+ (id)itemWithCaption:(NSString*)caption view:(UIView*)view;

@end
