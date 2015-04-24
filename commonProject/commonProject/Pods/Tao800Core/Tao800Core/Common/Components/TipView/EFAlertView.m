//
//  EFAlertView.m
//  testImageAnimate
//
//  Created by enfeng on 13-12-2.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "EFAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import <TBUI/UIViewAdditions.h>
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"
#import "Tao800FunctionCommon.h"

#define EFALERT_LINECOLOR_GRAY1 [UIColor colorWithHex:0xE8E8E8]

enum {
    EFAlertViewTitleHeight = 45, //顶部标题的高度
    EFAlertViewNoTitleTop = 20, //无标题顶部高度
    EFAlertViewNoMoreTipButtonHeight = 40, //不再提示按钮所占区域的高度
    EFAlertViewNoMoreTipDisappearHeight = 20, //不再提示按钮不显示时所占区域的高度
    EFAlertViewBottomButtonHeight = 47, //底部按钮区域的高度
    EFAlertViewDetailLeftPadding = 10, //详情距离左侧的宽度
    EFAlertViewContentWidth = 280, //内容区域的宽度
    EFAlertViewDetailTopPadding = 15,//详情距离标题的高度
};


@interface EFAlertView () {
    CGFloat _contentViewHeight;
    
    UIView *_contentView;
    UILabel *_titleLabel;
    UIView *_bottomContainer;    //底部button容器
    UIView *_noMoreTipContainer; //不再提示布局容器
}
@property(nonatomic, strong) NSArray *buttonArray;

- (void)disSelf:(BOOL)show animateWithDuration:(CGFloat) animateWithDuration  completion:(void (^)(void))completion;
@end

@implementation EFAlertView

@synthesize checkBtn = _checkBtn;
@synthesize detailLabel = _detailLabel;


- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)handleTitleButton:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(EFAlertView:clickedButtonAtIndex:)]) {
        [self.delegate EFAlertView:self clickedButtonAtIndex:btn.tag];
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
    NSMutableArray *bArray = [NSMutableArray arrayWithCapacity:3];
    
    CGFloat x = 0;
    CGFloat width = EFAlertViewContentWidth / (buttonTitles.count) + 1;
    
    UIImage *image = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
    
    for (NSString *string in buttonTitles) {
        index++;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = button.frame;
        rect.size.width = width;
        rect.size.height = EFAlertViewBottomButtonHeight;
        rect.origin.x = x;
        button.frame = rect;
        
        button.tag = index;
        [_bottomContainer addSubview:button];
        [button setTitle:string forState:UIControlStateNormal];
        if ([string isEqualToString:@"取消"]) {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateNormal];
        }
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(handleTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [bArray addObject:button];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        
        button.titleLabel.font = V3_26PX_FONT;
        
        x = x + width;
        
        //添加垂直线条
        CALayer *layer1 = [CALayer layer];
        [_bottomContainer.layer addSublayer:layer1];
        layer1.backgroundColor = EFALERT_LINECOLOR_GRAY1.CGColor;
        
        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        CGFloat h = SuitOnePixelHeight();
        layer1.frame = CGRectMake(x, 0, h, EFAlertViewBottomButtonHeight);
        [CATransaction commit];
    }
}


- (void)initContent:(NSString *)title
             detail:(NSString *)detail
           delegate:(id <EFAlertViewDelegate>)delegate
              style:(EFAlertViewStyle)style
       buttonTitles:(NSArray *)buttonTitles {
    self.delegate = delegate;
    
    self.enableClose = YES;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.layer.cornerRadius = 3;
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] init];
    
    if (title) {
        _titleLabel.textColor = TEXT_COLOR_BLACK2;
        _titleLabel.font = V3_28PX_FONT;
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //3.1 需求
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_titleLabel];
        _contentViewHeight = EFAlertViewTitleHeight + EFAlertViewBottomButtonHeight + EFAlertViewDetailTopPadding;
    } else {
        _contentViewHeight = EFAlertViewBottomButtonHeight + EFAlertViewNoTitleTop;
    }
    
    //加上不再提示按钮区域的高度
    if (style == EFAlertViewStyleWithCheckBtn) {
        _contentViewHeight = _contentViewHeight + EFAlertViewNoMoreTipButtonHeight;
    } else {
        _contentViewHeight = _contentViewHeight + EFAlertViewNoMoreTipDisappearHeight;
    }
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    _detailLabel = detailLabel;
    _detailLabel.font = V3_22PX_FONT;
    _detailLabel.textColor = TEXT_COLOR_BLACK4;
    _detailLabel.text = detail;
    _detailLabel.numberOfLines = 0;
    
    [_contentView addSubview:_detailLabel];
    
    CGRect topRect = _titleLabel.frame;
    if (title) {
        topRect.size.height = EFAlertViewTitleHeight;
        topRect.size.width = EFAlertViewContentWidth;
    } else {
        topRect.size.height = EFAlertViewNoTitleTop;
    }
    _titleLabel.frame = topRect;
    
    //计算详情的高度
    CGFloat width = EFAlertViewContentWidth - EFAlertViewDetailLeftPadding * 2;
    CGRect detailRect = _detailLabel.frame;
    detailRect.size = [_detailLabel.text sizeWithFont:_detailLabel.font
                                    constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    detailRect.size.width = width;
    detailRect.origin.x = EFAlertViewDetailLeftPadding;
    if (title) {
        detailRect.origin.y = topRect.origin.y + topRect.size.height + EFAlertViewDetailTopPadding;
    }else {
        detailRect.origin.y = topRect.origin.y + topRect.size.height;
    }
    
    _detailLabel.frame = detailRect;
    
    _contentViewHeight = _contentViewHeight + detailRect.size.height;
    
    //计算不再提示按钮的大小
    _noMoreTipContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_noMoreTipContainer];
    
    CGRect checkRect = _noMoreTipContainer.frame;
    checkRect.size.width = EFAlertViewContentWidth;
    checkRect.origin.y = detailRect.origin.y + detailRect.size.height;
    if (style == EFAlertViewStyleWithCheckBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noMoreTipContainer addSubview:btn];
        _checkBtn = btn;
        checkRect.size.height = EFAlertViewNoMoreTipButtonHeight;
        _checkBtn.titleLabel.font = V3_22PX_FONT;
        [_checkBtn setTitle:@"不再提示" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:TEXT_COLOR_BLACK4 forState:UIControlStateNormal];
        
        [_checkBtn setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateHighlighted];
        CGRect rect = _checkBtn.frame;
        rect.size = [_checkBtn.titleLabel.text sizeWithFont:_checkBtn.titleLabel.font
                                          constrainedToSize:CGSizeMake(200, 100)];
        rect.origin.y = 10;
        rect.origin.x = checkRect.size.width - rect.size.width - EFAlertViewDetailLeftPadding;
        _checkBtn.frame = rect;
    } else {
        checkRect.size.height = EFAlertViewNoMoreTipDisappearHeight;
    }
    _noMoreTipContainer.frame = checkRect;
    
    //布局底部按钮
    _bottomContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_bottomContainer];
    CGRect bottomRect = _bottomContainer.frame;
    bottomRect.size.height = EFAlertViewBottomButtonHeight;
    bottomRect.size.width = EFAlertViewContentWidth;
    bottomRect.origin.x = 0;
    bottomRect.origin.y = checkRect.origin.y + checkRect.size.height;
    _bottomContainer.frame = bottomRect;
    
    [self layoutButtons:buttonTitles];
    
    //添加底部线条
    CALayer *layer1 = [CALayer layer];
    [_bottomContainer.layer addSublayer:layer1];
    layer1.backgroundColor = EFALERT_LINECOLOR_GRAY1.CGColor;
    
    [CATransaction begin];
    [CATransaction setValue:(id) kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    CGFloat h = SuitOnePixelHeight();
    layer1.frame = CGRectMake(0, 0, bottomRect.size.width, h);
    [CATransaction commit];
    
    //布局内容区域大小
    CGRect contentRect = _contentView.frame;
    contentRect.size = CGSizeMake(EFAlertViewContentWidth, _contentViewHeight);
    _contentView.frame = contentRect;
}

- (id)initWithTitle2:(NSString *)title
              detail:(NSString *)detail
            delegate:(id <EFAlertViewDelegate>)delegate
               style:(EFAlertViewStyle)style
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
           delegate:(id <EFAlertViewDelegate>)delegate
              style:(EFAlertViewStyle)style
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
            self.alpha = 1;
        } else {
            _contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
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
        if ([item isKindOfClass:[EFAlertView class]]) {
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
    
    _contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
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


//根据传入的color和font设置alert的title样式
-(void)resetTitleWithColor:(UIColor *)color withFont:(UIFont *)font{
    _titleLabel.textColor = color;
    _titleLabel.font = font;
}

@end
