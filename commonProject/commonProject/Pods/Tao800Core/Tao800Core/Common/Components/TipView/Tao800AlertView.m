//
//  Tao800AlertView.m
//  tao800
//
//  Created by Rose on 15/1/4.
//  Copyright (c) 2015年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AlertView.h"
#import <QuartzCore/QuartzCore.h>
#import <TBUI/UIViewAdditions.h>
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"
#import "TBCore/TBCore.h"
#import "Tao800FunctionCommon.h"

#define EFALERT_LINECOLOR_GRAY1 [UIColor colorWithHex:0xE8E8E8]

enum {
    Tao800AlertViewTitleHeight = 30, //顶部标题的高度
    Tao800AlertViewNoTitleTop = 20, //无标题顶部高度
    Tao800AlertViewNoMoreTipButtonHeight = 40, //不再提示按钮所占区域的高度
    Tao800AlertViewNoMoreTipDisappearHeight = 20, //不再提示按钮不显示时所占区域的高度
    Tao800AlertViewBottomButtonHeight = 60, //底部按钮区域的高度
    Tao800AlertViewBottomButtonHeight2 = 120,
    Tao800AlertViewDetailLeftPadding = 10, //详情距离左侧的宽度
    Tao800AlertViewContentWidth = 280, //内容区域的宽度
    Tao800AlertViewDetailTopPadding = 15,//详情距离标题的高度
    Tao800AlertGreetingViewHeight = 61,//GreetingView高度
    Tao800AlertGreetingViewPadding = 43,//显示在contentview上的高度
    Tao800AlertTableViewLeftAndRightPadding = 20,//
    Tao800AlertViewButtonHeight = 45,//按钮高度
    Tao800AlertViewButtonPadding = 25,
    Tao800AlertTableViewPadding = 5,
};


@interface Tao800AlertView () {
    CGFloat _contentViewHeight;
    
    UIView *_contentView;
    UILabel *_titleLabel;
    UIView *_bottomContainer;    //底部button容器
    UIView *_noMoreTipContainer; //不再提示布局容器
}
@property(nonatomic, strong) NSArray *buttonArray;

- (void)disSelf:(BOOL)show animateWithDuration:(CGFloat) animateWithDuration  completion:(void (^)(void))completion;
@end

@implementation Tao800AlertView

@synthesize checkBtn = _checkBtn;
@synthesize detailLabel = _detailLabel;


- (void)layoutSubviews {
    [super layoutSubviews];
}

-(NSArray*)randomsAndStyle:(Tao800GreetingStyle) style{
    // 1 - x 随即数
    int value = 1;
    NSString* path = nil;
    NSString* name = nil;
    NSNumber* number = nil;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:2];
    switch (style) {
        case Tao800GreetingStyleChanPin:
        {
            value = (arc4random() % 3) + 1;
            path = [NSString stringWithFormat:@"bundle://alert_headc_%d@2x.png",value];
            number = [NSNumber numberWithInt:value];
            if (value == 1) {
                name = [NSString stringWithFormat:@"哈喽,我是产品经理suki"];
            }else if (value == 2){
                name = [NSString stringWithFormat:@"哈喽,我是产品经理小莹子"];
            }else if (value == 3){
                name = [NSString stringWithFormat:@"哈喽,我是产品经理珊珊"];
            }
            [array addObject:path];
            [array addObject:name];
        }
            break;
        case Tao800GreetingStyleYanFa:
        {
            value = (arc4random() % 5) + 1;
            //path = [NSString stringWithFormat:@"bundle://alert_headg_%d@2x.png",value];
            number = [NSNumber numberWithInt:value];
            if (value == 1 || value == 2) {
                name = [NSString stringWithFormat:@"哈喽，我是工程师恩峰"];
                path = [NSString stringWithFormat:@"bundle://alert_headg_1@2x.png"];
            }else if (value == 3 || value == 4){
                name = [NSString stringWithFormat:@"哈喽，我是工程师丛哥"];
                path = [NSString stringWithFormat:@"bundle://alert_headg_2@2x.png"];
            }else if (value == 5){
                name = [NSString stringWithFormat:@"哈喽，我是工程师韩韩"];
                path = [NSString stringWithFormat:@"bundle://alert_headg_3@2x.png"];
            }
            [array addObject:path];
            [array addObject:name];
        }
            break;
        default:
            break;
    }
    return array;
}

- (void)greetingStyleSet:(Tao800GreetingStyle) style{
    
    NSArray* array = [self randomsAndStyle:style];
    if (array && array.count>1) {
        self.greetingView.titleLabel.text = [array objectAtIndex:1];
        self.greetingView.greetingImageView.urlPath = [array objectAtIndex:0];
        return;
    }
    //
    switch (style) {
        case Tao800GreetingStyleChanPin:
        {
            self.greetingView.titleLabel.text = @"哈喽,我是产品经理小雯";
            if (TBIsIPhone6Plus()) {
                self.greetingView.greetingImageView.urlPath = @"bundle://alert_headc@3x.png";
            }else{
                self.greetingView.greetingImageView.urlPath = @"bundle://alert_headc@2x.png";
            }
        }
            break;
        case Tao800GreetingStyleYanFa:
        {
            self.greetingView.titleLabel.text = @"哈喽，我是工程师丛哥";
            if (TBIsIPhone6Plus()) {
                self.greetingView.greetingImageView.urlPath = @"bundle://alert_headg@3x.png";
            }else{
                self.greetingView.greetingImageView.urlPath = @"bundle://alert_headg@2x.png";
            }
        }
            break;
        default:
            break;
    }
}

- (void)handleTitleButton:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(Tao800AlertView:clickedButtonAtIndex:)]) {
        [self.delegate Tao800AlertView:self clickedButtonAtIndex:btn.tag];
    }
    
    //由外部控制关闭
    if (self.enableClose) {
        [self disSelf:NO animateWithDuration:0.2 completion:^{}];
    }
}

- (void)handleCheckBtn:(id)sender {
    _checkBtn.selected = !_checkBtn.selected;
}

- (void)layoutButtons:(NSArray *)buttonTitles {
    
    int index = -1;
    //NSMutableArray *bArray = [NSMutableArray arrayWithCapacity:3];
    
    CGFloat x = Tao800AlertViewButtonPadding;
    CGFloat width = Tao800AlertViewContentWidth - (Tao800AlertViewButtonPadding * 2);
    
    //UIImage *image = [Tao800Util imageWithColor:TEXT_COLOR_PINK bounds:CGRectMake(0, 0, 1, 1)];
    CGFloat y = 0;
    for (NSString *string in buttonTitles) {
        index++;
        if (index>=2) {
            break;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = button.frame;
        rect.size.width = width;
        rect.size.height = Tao800AlertViewButtonHeight;
        rect.origin.x = x;
        rect.origin.y = y;
        button.frame = rect;
        button.clipsToBounds = YES;
        
        y = y + Tao800AlertViewButtonHeight + 13;
        button.tag = index;
        [_bottomContainer addSubview:button];
        [button setTitle:string forState:UIControlStateNormal];
        button.layer.cornerRadius = 23;
        if (index == 0) {
            [self pinkButtonStyle:button];
        }else{
            button.layer.borderWidth = SuitOnePixelHeight();
            button.layer.borderColor = [UIColor colorWithHex:0xB4B4B4].CGColor;
            [self normalButtonStyle:button];
        }
    }
}

-(void)pinkButtonStyle:(UIButton*)button{
    UIImage *image = [Tao800Util imageWithColor:TEXT_COLOR_PINK bounds:CGRectMake(0, 0, 1, 1)];
    //[button setImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = V3_26PX_FONT;
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)normalButtonStyle:(UIButton*)button{
    UIImage *image = [Tao800Util imageWithColor:[UIColor colorWithHex:0xE4E4E4] bounds:CGRectMake(0, 0, 1, 1)];
    [button setTitleColor:[UIColor colorWithHex:0xB4B4B4] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(handleTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    //[button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = V3_26PX_FONT;
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
}





- (void)initContent:(NSString *)title
             detail:(NSString *)detail
           delegate:(id <Tao800AlertViewDelegate>)delegate
              style:(Tao800AlertViewStyle)style
       buttonTitles:(NSArray *)buttonTitles {
    self.delegate = delegate;
    
    self.enableClose = YES;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.layer.cornerRadius = 6;
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    Tao800AlertGreetingView* gView = [[Tao800AlertGreetingView alloc] initWithFrame:CGRectMake(0, (Tao800AlertGreetingViewPadding - Tao800AlertGreetingViewHeight), Tao800AlertViewContentWidth, Tao800AlertGreetingViewHeight)];
    _greetingView = gView;
    [self addSubview:_greetingView];
    _contentViewHeight = _contentViewHeight + Tao800AlertGreetingViewPadding;
    
    _titleLabel = [[UILabel alloc] init];
    
    if (title) {
        _titleLabel.textColor = TEXT_COLOR_PINK;
        _titleLabel.font = V3_28PX_FONT;
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //3.1 需求
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_titleLabel];
        _contentViewHeight = _contentViewHeight + Tao800AlertViewTitleHeight/2 + /*Tao800AlertViewBottomButtonHeight +*/ Tao800AlertViewDetailTopPadding + Tao800AlertViewTitleHeight;
    } else {
        _titleLabel.text = @"";
        [_contentView addSubview:_titleLabel];
        _contentViewHeight = _contentViewHeight + /*Tao800AlertViewBottomButtonHeight +*/ Tao800AlertViewNoTitleTop;
    }//Tao800AlertViewBottomButtonHeight 变成动态的了
    
    //加上不再提示按钮区域的高度
    if (style == Tao800AlertViewStyleWithCheckBtn) {
        _checkBtn = [Tao800AlertCheckBox buttonWithType:UIButtonTypeCustom];//[UIButton buttonWithType:UIButtonTypeCustom];
        _contentViewHeight = _contentViewHeight + Tao800AlertViewNoMoreTipButtonHeight;
    } else {
        _contentViewHeight = _contentViewHeight + Tao800AlertViewNoMoreTipDisappearHeight;
    }
    
    
//    UILabel *detailLabel = [[UILabel alloc] init];
//    _detailLabel = detailLabel;
//    _detailLabel.font = V3_22PX_FONT;
//    _detailLabel.textColor = TEXT_COLOR_BLACK4;
//    _detailLabel.text = detail;
//    _detailLabel.numberOfLines = 0;
//    
//    [_contentView addSubview:_detailLabel];
    CGRect topRect = _titleLabel.frame;
    if (title) {
        topRect.size.height = Tao800AlertViewTitleHeight;
        topRect.size.width = Tao800AlertViewContentWidth;
        topRect.origin.y = CGRectGetMaxY(_greetingView.frame) + Tao800AlertViewTitleHeight/2;
    } else {
        topRect.size.height = Tao800AlertViewNoTitleTop;
        topRect.size.width = Tao800AlertViewContentWidth;
        topRect.origin.y = CGRectGetMaxY(_greetingView.frame);
    }
    topRect.origin.x = 0;
    
    _titleLabel.frame = topRect;

    
    CGFloat w = Tao800AlertViewContentWidth-(Tao800AlertTableViewLeftAndRightPadding*2);
    CGSize size = [Tao800AlertTableView dynamicHeight:w font:V3_24PX_FONT text:detail];
    CGFloat h = 0;
    BOOL flag = NO;
    if (size.height>Tao800AlertTableViewMaxHeight) {
        h = Tao800AlertTableViewMaxHeight;
        flag = YES;
    }else{
        h = size.height+1;
    }
    CGFloat x = Tao800AlertTableViewLeftAndRightPadding;
    CGFloat y = CGRectGetMaxY(_titleLabel.frame);
    if (title) {
        y = CGRectGetMaxY(_titleLabel.frame)+Tao800AlertViewDetailTopPadding;
    }
    CGRect rectTab = CGRectMake(x, y, w+Tao800AlertTableViewPadding, h);
    Tao800AlertTableView* alertTable = [[Tao800AlertTableView alloc] initWithFrame:rectTab style:UITableViewStylePlain];
    //alertTable.bounces = NO;
    if (flag) {
        alertTable.showsVerticalScrollIndicator = YES;
        alertTable.scrollEnabled = YES;
    }else{
        alertTable.scrollEnabled = NO;
    }
    alertTable.cellHeight = size.height+1;
    _alertTableView = alertTable;
    [_contentView addSubview:alertTable];
    Tao800AlertTableItem* item = [[Tao800AlertTableItem alloc] init];
    item.textAlignment = NSTextAlignmentLeft;
    item.word = detail;
    NSMutableArray* itemAry = [NSMutableArray arrayWithObject:item];
    [_alertTableView setItemListArray:itemAry];
    
    
    //计算详情的高度
//    CGFloat width = Tao800AlertViewContentWidth - Tao800AlertViewDetailLeftPadding * 2;
//    CGRect detailRect = _detailLabel.frame;
//    detailRect.size = [_detailLabel.text sizeWithFont:_detailLabel.font
//                                    constrainedToSize:CGSizeMake(width, MAXFLOAT)];
//    detailRect.size.width = width;
//    detailRect.origin.x = Tao800AlertViewDetailLeftPadding;
//    if (title) {
//        detailRect.origin.y = topRect.origin.y + topRect.size.height + Tao800AlertViewDetailTopPadding;
//    }else {
//        detailRect.origin.y = topRect.origin.y + topRect.size.height;
//    }
//    
//    _detailLabel.frame = detailRect;
    
    _contentViewHeight = _contentViewHeight + CGRectGetHeight(self.alertTableView.frame);
    
    //计算不再提示按钮的大小
    _noMoreTipContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_noMoreTipContainer];
    
    CGRect checkRect = _noMoreTipContainer.frame;
    checkRect.size.width = Tao800AlertViewContentWidth;
    checkRect.origin.y = CGRectGetMaxY(self.alertTableView.frame);
    if (_checkBtn) {
        checkRect.size.height = Tao800AlertViewNoMoreTipButtonHeight;
        _checkBtn.titleLabel.font = V3_22PX_FONT;
        [_checkBtn setTitle:@"不再提示" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:TEXT_COLOR_BLACK4 forState:UIControlStateNormal];
        [_noMoreTipContainer addSubview:_checkBtn];
        [_checkBtn setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateHighlighted];
        [_checkBtn setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateSelected];
        CGRect rect = _checkBtn.frame;
        rect.size = [_checkBtn.titleLabel.text sizeWithFont:_checkBtn.titleLabel.font
                                          constrainedToSize:CGSizeMake(200, 100)];
        rect.size.height = 20;
        rect.size.width = 100;
        rect.origin.y = 10;
        rect.origin.x = checkRect.size.width - rect.size.width - Tao800AlertViewDetailLeftPadding;
        _checkBtn.frame = rect;
    } else {
        checkRect.size.height = Tao800AlertViewNoMoreTipDisappearHeight;
    }
    _noMoreTipContainer.frame = checkRect;
    
    //布局底部按钮
    _bottomContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_bottomContainer];
    CGRect bottomRect = _bottomContainer.frame;
    if (buttonTitles && buttonTitles.count>1) {
        bottomRect.size.height = Tao800AlertViewBottomButtonHeight2;
        _contentViewHeight = _contentViewHeight + Tao800AlertViewBottomButtonHeight2;
    }else{
        bottomRect.size.height = Tao800AlertViewBottomButtonHeight;
        _contentViewHeight = _contentViewHeight + Tao800AlertViewBottomButtonHeight;
    }
    bottomRect.size.width = Tao800AlertViewContentWidth;
    bottomRect.origin.x = 0;
    bottomRect.origin.y = checkRect.origin.y + checkRect.size.height;
    _bottomContainer.frame = bottomRect;
    
    [self layoutButtons:buttonTitles];
    
    //布局内容区域大小
    CGRect contentRect = _contentView.frame;
    contentRect.size = CGSizeMake(Tao800AlertViewContentWidth, _contentViewHeight);
    _contentView.frame = contentRect;
    
    //CGRect rect = _greetingView.frame;
    //rect.origin.y =
}

- (id)initWithTitle2:(NSString *)title
              detail:(NSString *)detail
            delegate:(id <Tao800AlertViewDelegate>)delegate
               style:(Tao800AlertViewStyle)style
        buttonTitles:(NSArray *)buttonTitles {
    self = [super init];
    if (self) {
        [self initContent:title
                   detail:detail
                 delegate:delegate
                    style:style
             buttonTitles:buttonTitles];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
             detail:(NSString *)detail
           delegate:(id <Tao800AlertViewDelegate>)delegate
              style:(Tao800AlertViewStyle)style
       buttonTitles:(NSString *)buttonTitles, ... {
    self = [super init];
    
    if (self) {
        self.enableClose = YES;
        NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:3];
        
        id eachObject;
        va_list argumentList;
        if (buttonTitles) {
            [arguments addObject:buttonTitles];
            va_start(argumentList, buttonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [arguments addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        [self initContent:title
                   detail:detail
                 delegate:delegate
                    style:style
             buttonTitles:arguments];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.enableClose = YES;
    }
    return self;
}

- (void)disSelf:(BOOL)show animateWithDuration:(CGFloat) animateWithDuration completion:(void (^)(void))completion {
    
    [UIView animateWithDuration:animateWithDuration animations:^{
        if (show) {
            _contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _greetingView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 1;
        } else {
            _contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            _greetingView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.alpha = 0;
        }
    }                completion:^(BOOL finish) {
        if (finish && !show) {
            completion();
            [self removeFromSuperview];
        }
    }];
}

- (void)closeSelf {
    [self disSelf:NO animateWithDuration:.2 completion:^{}];
}

- (void)show {
    UIApplication *application = [UIApplication sharedApplication];
    //    UIWindow *mainWindow = [application keyWindow];
    
    //避免被键盘遮盖
    UIWindow *mainWindow = application.windows.lastObject;
    
    NSArray *arrayViews = mainWindow.subviews;
    for (NSObject *item in arrayViews) {
        if ([item isKindOfClass:[Tao800AlertView class]]) {
            break;
        }
    }
    
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat width = screen.bounds.size.width;
    CGFloat height = screen.bounds.size.height;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    self.frame = rect;
    [mainWindow addSubview:self];
    
    CGRect contentRect = _contentView.frame;
    contentRect.origin.x = (width - contentRect.size.width) / 2;
    contentRect.origin.y = (height - contentRect.size.height) / 2;
    _contentView.frame = contentRect;
    
    CGFloat miny = CGRectGetMinY(_contentView.frame);
    CGRect greetingRect = _greetingView.frame;
    greetingRect.origin.y = greetingRect.origin.y + miny;
    greetingRect.origin.x = contentRect.origin.x;
    _greetingView.frame = greetingRect;
    
    _contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _greetingView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    _contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithWhite:.0 alpha:.7];
    
    self.alpha = 1;
    
    [self disSelf:YES animateWithDuration:.2 completion:^{}];
}

- (void)close {
    [self disSelf:NO animateWithDuration:.2 completion:^{}];
}

- (void) close:(CGFloat)animateWithDuration completion:(void (^)(void))completion {
    [self disSelf:NO animateWithDuration:animateWithDuration completion:completion];
}


@end


//////////////////////////////////////////////////////////////////////////////////////
#pragma  mark  --- Tao800AlertTableView -------
@implementation Tao800AlertTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
    }
    return self;
}

- (void)setListItems:(NSMutableArray *)pItems {
    [self setItemListArray:pItems];
    [self reloadData];
}


-(void)reloadListWord:(NSString*)listWord{
    self.word = listWord;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.itemListArray || self.itemListArray.count<1) {
        return 0;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //这块很重要
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.itemListArray || self.itemListArray.count<1) {
        return 0;
    }
    return self.cellHeight;
}

+ (CGSize)dynamicHeight:(CGFloat)width font:(UIFont*)theFont text:(NSString*)text{
    CGSize textSize = CGSizeMake(width, CGFLOAT_MAX);
    if (text && text.length>0) {
    }else{
        text = @" ";
    }
    CGSize sizeWithFont = [text sizeWithFont:theFont
                           constrainedToSize:textSize
                               lineBreakMode:NSLineBreakByWordWrapping
                           ];
    if (sizeWithFont.height < Tao800AlertTableViewMinHeight){
        sizeWithFont.height = Tao800AlertTableViewMinHeight;
    }
    
    return sizeWithFont;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //子类具体实现
    static NSString *CellIdentifier = @"Tao800AlertTableCell";
    Tao800AlertTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Tao800AlertTableCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:13];
    }
    NSInteger row = indexPath.row;
    if (_itemListArray == nil) { return nil;}
    Tao800AlertTableItem *item = [_itemListArray objectAtIndex:row];
    //item.word = [_word mutableCopy];
    [cell setObject:item];

    //[cell setObjectWord:[_word mutableCopy]];
    return cell;
}
@end

@implementation Tao800AlertTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.textLabel.hidden = YES;
        
        self.itemTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.itemTextLabel.backgroundColor = [UIColor clearColor];
        self.itemTextLabel.textAlignment = NSTextAlignmentLeft;
        self.itemTextLabel.textColor = TEXT_COLOR_BLACK3;
        self.itemTextLabel.font = V3_24PX_FONT;
        self.itemTextLabel.numberOfLines = 0;
        self.itemTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_itemTextLabel];
        
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) setObjectWord:(NSString*)objWord{
    if (_word) {
        _word = nil;
    }
    _word = objWord;
}

- (void)setObject:(NSObject *)obj {
    if (_item) {
        _item = nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _item = obj;
    Tao800AlertTableItem* item = (Tao800AlertTableItem*)_item;
    self.itemTextLabel.textAlignment = item.textAlignment;
    self.itemTextLabel.text = item.word;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_item) {
        return;
    }
    self.textLabel.hidden = YES;
    CGRect rect = self.contentView.frame;
    rect.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.contentView.frame = rect;
    
    CGFloat height = rect.size.height;
    CGFloat cellWidth = rect.size.width-Tao800AlertTableViewPadding;
    self.itemTextLabel.frame = CGRectMake(0, 0, cellWidth, height);
}

@end

@implementation Tao800AlertTableItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}
@end
