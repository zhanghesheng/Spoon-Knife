//
//  TBCollectionViewCell.h
//  TBUI
//
//  Created by enfeng on 14-7-17.
//  Copyright (c) 2014年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) id item;

- (void)setObject:(id)object;

/**
 * 之前都是通过获取类名作为identifier， swift中的类得到名字并不是真正的名字，如_TtC6tao80018Z8HomeCategoryCell
 * 子类需要重写该方法
 *
 * @return 如果返回nil, 则取类名
 */
+ (NSString *) tbIdentifier;
@end
