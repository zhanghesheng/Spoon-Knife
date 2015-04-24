//
// Created by enfeng on 13-1-24.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBTableViewBaseCell : UITableViewCell {
}
@property(nonatomic, strong) id object;

/**
 * Measure the height of the row with the object that will be assigned to the cell.
 */
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;

/**
* 如果cell从nib载入，则返回nib的名称，否则返回nil
* nibName 和 identifier 需要用同一个名称
*/
+ (NSString *) nibName;

/**
 * 之前都是通过获取类名作为identifier， swift中的类得到名字并不是真正的名字，如_TtC6tao80018Z8HomeCategoryCell
 * 子类需要重写该方法
 *
 * @return 如果返回nil, 则取类名
 */
+ (NSString *) tbIdentifier;
@end