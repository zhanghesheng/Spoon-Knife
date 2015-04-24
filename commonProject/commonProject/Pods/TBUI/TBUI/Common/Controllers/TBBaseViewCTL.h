//
//  TBBaseViewCTL.h
//  TBUI
//
//  Created by enfeng on 12-9-19.
//  Copyright (c) 2012年 com.tuan800.framework.ui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBNavigatorView.h"
#import "TBCore/TBCoreMacros.h"
#import "TBUIViewController+Tip.h"
#import "TBModel.h"

@class TBBaseViewCTL;


typedef void (^TBBGoBackBlock)(BOOL completion, NSDictionary * pageParams);

@interface TBBaseViewCTL : UIViewController<TBModelDelegate>  {
    NSDictionary *_paramDict;
    BOOL _isModelViewCTL; 
    
    TBModel *_model;
}

@property(nonatomic, strong) NSDictionary *paramDict;
@property(nonatomic, strong) NSMutableDictionary *goBackParams;
@property(nonatomic, strong) TBModel *model;
@property(nonatomic) BOOL isModelViewCTL;
@property(nonatomic, weak) IBOutlet TBNavigatorView *tbNavigatorView;
@property (nonatomic,assign)CGRect viewRectPad;
@property(nonatomic, copy) TBBGoBackBlock goBackBlock;


- (id)initWithParams:(NSDictionary *)params;

/**
* 类似 initWithParams
* prepareForSegue 中用
*/
- (void) setParameters:(NSDictionary *) parameters;

/**
* @return 如果是从modelViewController返回，则返回nil; 否则返回弹出的controller
*/
- (UIViewController*) goBack:(BOOL) animated;

- (UIInterfaceOrientation)currentOrientation;

- (void) preBackBlock;
@end
