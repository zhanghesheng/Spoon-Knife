//
//  TBBDealDetailJavascriptBridgeCell.m
//  universalT800
//
//  Created by Rose on 13-9-28.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBBEmbeddedWapCell.h"
#import "TBBEmbeddedWapItem.h"
#import "TBCore/TBCore.h"
#import "Tao800FunctionCommon.h"

@interface TBBEmbeddedWapCell ()
@property(nonatomic,weak)UIWebView* tmpWebView;
@end

@implementation TBBEmbeddedWapCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed: @"TBBEmbeddedWapCell" owner: self options: nil];
        [self addSubview: self.customContent];
        
        self.userInteractionEnabled = NO;
//        self.infoWebView.userInteractionEnabled = NO;
//        self.infoWebView.scalesPageToFit = YES;
//        self.infoWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
//        _javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:self.infoWebView
//                                                      webViewDelegate:self
//                                                              handler:^(id data, WVJBResponseCallback responseCallback) {
//                                                                  NSLog(@"ObjC received message from JS: %@", data);
//                                                                  responseCallback(@"Response for message from ObjC");
//                                                              }];
        
        
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    TBBEmbeddedWapItem *item = (TBBEmbeddedWapItem *) object;
    return item.height+44;
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//    int height = [str integerValue];
//
//    //NSString *body =  [webView stringByEvaluatingJavaScriptFromString:@"document"];
//    //NSLog(@"body = %@",body);
//    TBBEmbeddedWapItem *item = (TBBEmbeddedWapItem *) _item;
//    if (item == nil) {
//        return;
//    }
//    //修改服务器页面的meta的值
//
//    if (![item.htmlText isEqualToString:@"暂无数据"]) {
//        NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].dealContent = \"width=%f, initial-scale=1.0, minimum-scale=1.0, user-scalable=yes\"",
//                          self.infoWebView.frame.size.width];
//        [webView stringByEvaluatingJavaScriptFromString:meta];
//        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//        height = [str integerValue];
//    }
//
//    if (height - item.height < 3 || !item.refreshFlag) {
//        //避免页面高度反复变化导致页面的反复刷新
//        return;
//    }
//
//    item.height = height;
//    item.refreshFlag = NO;
//
//    if (![item.htmlText isEqualToString:@"暂无数据"]) {
//        item.refreshFlag = NO;
//    }
//
//    //NSLog(@"-------------document.body.scrollHeight------------");
//    //NSLog(@"height2 = %d",height);
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    TBBEmbeddedWapItem *item = (TBBEmbeddedWapItem *)_item;
    if (item == nil) {
        return;
    }
    
    CGRect webRect = self.infoWebView.frame;
    webRect.size.height = item.height;
    
    
    if (TBIsIPhone6() || TBIsIPhone6Plus()) {
        webRect.size.width = [UIScreen mainScreen].bounds.size.width-12;
    }else{
        webRect.size.width = [UIScreen mainScreen].bounds.size.width-15;
    }
    webRect.origin.x = ([UIScreen mainScreen].bounds.size.width - webRect.size.width)/2;
    self.infoWebView.frame = webRect;
    if(self.tmpWebView){
        webRect.origin.x = 0;
        webRect.origin.y = 0;
        self.tmpWebView.frame = webRect;
    }
    //self.infoWebView.scrollView.scrollsToTop = NO;
    
    CGRect rect = self.customContent.frame;
    rect.size.height = self.titleView.frame.size.height+self.infoWebView.frame.size.height;
    
    self.customContent.frame = rect;
    
//    if (![item.htmlText isEqualToString:@"暂无数据"]) {
//        //self.infoWebView.scalesPageToFit = YES;
//        self.infoWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    } else {
//        //self.infoWebView.scalesPageToFit = NO;
//        self.infoWebView.autoresizingMask = UIViewAutoresizingNone;
//    }
}

- (void)setObject:(id)object {
    if (_item && _item == object) {
        return;
    }
    _item = object;
    if (_item == nil) {
        return;
    }

    TBBEmbeddedWapItem *item = (TBBEmbeddedWapItem *) _item;

    [self.infoWebView removeAllSubviews];
    CGRect rr = item.webView.frame;
    rr.size.width = self.width-20;
    item.webView.frame = rr;
    self.tmpWebView = item.webView;
    [self.infoWebView addSubview:item.webView];
    item.webView.backgroundColor = [UIColor clearColor];
    
    if(item.title.length>0){
        self.titleLabel.text = item.title;
    }
    
//    NSDictionary *dict = @{
//            @"htmlString":item.htmlText,
//            @"fontName":@"系统默认字体名称",
//            @"fontSize":@"14",
//            @"fontColor":@"666666",
//    };
//    NSString *string = [NSString stringWithFormat:@"<div style=\"color:#686868;font-size:35px\">%@</div>", item.htmlText]; //FormatHtmlText(dict);
//    [self.infoWebView loadHTMLString:string baseURL:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
