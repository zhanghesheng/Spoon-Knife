//
//  Tao800SingleBox.m
//  tao800
//
//  Created by Rose on 14-2-26.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800SingleBox.h"
#import "Tao800FunctionCommon.h"
#import <TBUI/TBUI.h>
#import "Tao800StyleSheet.h"


@implementation Tao800SingleBoxManage
@synthesize singleBoxArray = _singleBoxArray;
@synthesize currentSelected = _currentSelected;

-(id)initWithSingleBoxTotalNumber:(NSInteger)number{
    self = [super init];
    if (self) {
        NSInteger actualNum = ((number<=0)?1:number);
        self.singleBoxArray = [NSMutableArray arrayWithCapacity:5];
        
        for (int i=0; i<actualNum; i++) {
            Tao800SingleBox *btn = [Tao800SingleBox buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self.singleBoxArray addObject:btn];
        }
        
        [self boxLayout];

    }
    return self;
}

-(void)boxLayout{
    int i=0;
    for(Tao800SingleBox *box in self.singleBoxArray){
        if (i == _currentSelected) {
            [box changeSelectedStyle];
        }else{
            [box normalStyle];
        }
        i++;
    }
}


-(void)btnClick:(id)sender{
    Tao800SingleBox *box = (Tao800SingleBox*)sender;
    _currentSelected = box.tag;
    [self boxLayout];
}

-(void)resetBoxSelected:(NSInteger)number{
    NSInteger actualNum = ((number<=0)?0:number);
    actualNum = (actualNum>=[self.singleBoxArray count])?0:actualNum;
    _currentSelected = actualNum;
    [self boxLayout];
}

@end


@interface Tao800SingleBox()


@end

@implementation Tao800SingleBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        UIImage *image_buyButton = TBIMAGE(@"bundle://v6_singlebox@2x.png");
        [self setBackgroundImage:image_buyButton forState:UIControlStateNormal];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)changeSelectedStyle{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = TBIMAGE(@"bundle://v6_singlebox_selected@2x.png");//
        if(image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI线程
                [self setBackgroundImage:image forState:UIControlStateNormal];
            });
        }
    });
}

- (void)normalStyle{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = TBIMAGE(@"bundle://v6_singlebox@2x.png");//
        if(image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI线程
                [self setBackgroundImage:image forState:UIControlStateNormal];
            });
        }
    });
}

@end
