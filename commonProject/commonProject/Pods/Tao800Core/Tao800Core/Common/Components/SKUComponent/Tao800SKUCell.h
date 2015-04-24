//
//  Tao800SKUCell.h
//  tao800
//
//  Created by hanyuan on 14-5-5.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBUI/TBUI.h>

@protocol Tao800SKUCellDelegate <NSObject>
@required
-(void)propertyDidSelected:(int)dimensionIndex propertyId:(NSString *)propertyId;
@end

@interface Tao800SKUCell : TBTableViewCell
@property(nonatomic, weak)id<Tao800SKUCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *customContent;
@property (weak, nonatomic) IBOutlet UILabel *skuTitle;
@property (weak, nonatomic) IBOutlet UIView *skuContentView;
@property (weak, nonatomic) IBOutlet UIView *seperateLine;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
