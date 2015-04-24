//
//  TBBDealDetailJavascriptBridgeCell.h
//  universalT800
//
//  Created by Rose on 13-9-28.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBUI/TBUI.h"
#import "TBUI/UIColor+Hex.h"
//#import "TBUI/WebViewJavascriptBridge.h"

@interface TBBEmbeddedWapCell : TBTableViewCell<UIWebViewDelegate>
//@property(nonatomic, strong)WebViewJavascriptBridge *javascriptBridge;

@property (strong, nonatomic) IBOutlet UIView *customContent;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *infoWebView;
@end
