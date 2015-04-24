 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIToolbar (TBCategory)

- (UIBarButtonItem*)itemWithTag:(NSInteger)tag;

- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item;

@end
