//
//  Tao800NoDataViewObject.m
//  tao800
//
//  Created by enfeng on 14/11/25.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800NoDataViewObject.h"
#import "Tao800StyleSheet.h"

@implementation Tao800NoDataViewObject


- (void) loadView {
    NSArray *arr =  [[NSBundle mainBundle] loadNibNamed:@"Tao800NoDataView"
                                                  owner:self
                                                options:nil];
    if (arr.count>0) {
        self.noDataView = arr[0];
    }
}

- (void)dealloc
{
    TBDPRINT(@"release Tao800NoDataViewObject");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadView];
    }
    return self;
}

- (instancetype) initWithTitle:(NSString*) title
                        detail:(NSString*) detail
                   centerImage:(UIImage*) centerImage
                   buttonTitle:(NSString*) buttonTitle {
    self = [super init];
    if (self) {
        [self loadView];
        
        self.noDataView.titleLabel.textColor = TEXT_COLOR_BLACK1;
        self.noDataView.detailLabel.textColor = TEXT_COLOR_BLACK6;
        
        self.noDataView.centerImageView.defaultImage = centerImage;
        self.noDataView.backgroundColor = [UIColor clearColor];
        [self.noDataView.button setTitle:buttonTitle forState:UIControlStateNormal];
        
        self.noDataView.titleLabel.text = title;
        self.noDataView.detailLabel.text = detail;
        
        
        self.noDataView.titleLabel.backgroundColor = [UIColor clearColor];
        self.noDataView.detailLabel.backgroundColor = [UIColor clearColor];
        self.noDataView.tipBackgroundView.backgroundColor = [UIColor clearColor];
        self.noDataView.centerImageView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = TBIMAGE(@"bundle://tip_red_bg_btn@2x.png");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        
        [self.noDataView.button setBackgroundImage:image forState:UIControlStateNormal]; 
        [self.noDataView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}
@end
