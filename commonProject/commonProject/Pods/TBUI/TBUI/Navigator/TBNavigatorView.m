//
// Created by enfeng on 13-2-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <sys/ucred.h>
#import <objc/runtime.h>
#import "TBNavigatorView.h"
#import "TBCore/TBCoreCommonFunction.h"
#import "TBUI.h"
#import <QuartzCore/QuartzCore.h>

enum {
    TBNavigatorViewTitleTag = 433322
};

@implementation TBNavigatorItem
@synthesize leftBarButtonItems = _leftBarButtonItems;
@synthesize rightBarButtonItems = _rightBarButtonItems;
@synthesize titleView = _titleView;
@synthesize title = _title;
@synthesize leftBarButtonItem = _leftBarButtonItem;
@synthesize rightBarButtonItem = _rightBarButtonItem;

static CGFloat const TBNavigatorButtonWidth = 44;

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
}
@end

@interface TBNavigatorView ()

- (CGRect)titleRect;
@end;

@implementation TBNavigatorView {

}
@synthesize navigatorItem = _navigatorItem;
@synthesize leftPadding = _leftPadding;
@synthesize rightPadding = _rightPadding;
@synthesize displayShadow = _displayShadow;
@synthesize titleFont = _titleFont;
@synthesize buttonFont = _buttonFont;

- (UIButton *)createButton:(UIBarButtonItem *)buttonItem buttonX:(CGFloat)buttonX {
    CGFloat width = buttonItem.width;
    if (width == 0) {
        width = TBNavigatorButtonWidth;
    }
    CGFloat height = self.frame.size.height;
    if (buttonItem.image && buttonItem.image.size.height < height) {
        height = buttonItem.image.size.height;
    }
    CGFloat y = (self.height - height) / 2;
    BOOL isFromIos7 = NeedResetUIStyleLikeIOS7() ;
    if (isFromIos7) { //需要减去statusBar的高度
        y = (self.height - height-TBDefaultStatusBarHeight) / 2+TBDefaultStatusBarHeight;
    }
    CGRect rect = CGRectMake(buttonX, y, width, height);
    UIImage *image = buttonItem.image;
    NSString *title = buttonItem.title;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        if (title) {
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            if (_buttonFont) {
                button.titleLabel.font = _buttonFont;
            } else {
                button.titleLabel.font = [UIFont systemFontOfSize:14];
            } 
        } else {
            [button setImage:image forState:UIControlStateNormal];
        }
    } else {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.frame = rect;
    [button addTarget:buttonItem.target
               action:buttonItem.action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)createLeftButton:(UIBarButtonItem *)buttonItem index:(int)index {
    CGFloat leftX = 0;
    CGFloat width = buttonItem.width;
    if (width == 0) {
        width = TBNavigatorButtonWidth;
    }
    leftX = leftX + (width + _leftPadding) * index;
    leftX = leftX + _leftPadding;
    UIButton *button = [self createButton:buttonItem buttonX:leftX];

    [_leftView addSubview:button];
    CGRect rect = _leftView.frame;
    rect.size.height = self.frame.size.height;
    rect.size.width = leftX + width;
    _leftView.frame = rect;
}

- (void)createRightButton:(UIBarButtonItem *)buttonItem index:(int)index {
    CGFloat rightX = 0;
    CGFloat buttonX = 0;
    CGFloat width = buttonItem.width;
    if (width == 0) {
        width = TBNavigatorButtonWidth;
    }
    if (index > 0) {
        buttonX = (width + _rightPadding) * index;
    }

    rightX = self.frame.size.width - (width + _rightPadding) * (index + 1);

    UIButton *button = [self createButton:buttonItem buttonX:buttonX];
    [_rightView addSubview:button];
    CGRect rect = _rightView.frame;
    rect.size.height = self.frame.size.height;
    rect.size.width = self.frame.size.width - rightX;
    rect.origin.x = self.frame.size.width - rect.size.width;
    _rightView.frame = rect;
}

- (CGRect)titleRect {
    CGFloat leftX = 0;
    CGFloat width = self.frame.size.width;
    CGFloat y= 0;
    CGFloat height = self.frame.size.height;

   // BOOL isFromIos7 = NeedResetUIStyleLikeIOS7();
   // if (isFromIos7) { //需要减去statusBar的高度
    //    y = TBDefaultStatusBarHeight;
    //    height = height - TBDefaultStatusBarHeight;
  //  }

    CGRect rect = CGRectMake(leftX, y, width, height);
    return rect;
}

- (void)addTitleView {
    CGRect rect = [self titleRect];
    _titleView.frame = rect;
    rect.origin.x = 0;
    _navigatorItem.titleView.frame = rect;
    [_titleView addSubview:_navigatorItem.titleView];
}

- (void)createTitle {

    CGRect rect = [self titleRect];
    _titleView.frame = rect;
    rect.origin.x = 0;
    rect.origin.y=0;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    if (self.titleColor) {
        label.textColor = self.titleColor;
    } else {
        label.textColor = [UIColor whiteColor];
    }
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    label.text = _navigatorItem.title;
    label.textAlignment = NSTextAlignmentCenter;
    if (_titleFont) {
        label.font = _titleFont;
    } else {
        label.font = [UIFont boldSystemFontOfSize:18];
    }

    [_titleView addSubview:label];

    label.tag = TBNavigatorViewTitleTag;
    if (_displayShadow) {
        self.displayShadow = YES;
    }

}

- (void)createLeftButtons {
    int i = -1;
    for (UIBarButtonItem *item in _navigatorItem.leftBarButtonItems) {
        i++;
        [self createLeftButton:item index:i];
    }
}

- (void)createRightButtons {
    int i = -1;
    for (UIBarButtonItem *item in _navigatorItem.rightBarButtonItems) {
        i++;
        [self createRightButton:item index:i];
    }
}

- (void)addNavigatorItemPropertyObserver {
    for (NSString *propertyName in _navigatorItemPropertyNames) {
        [_navigatorItem addObserver:self
                         forKeyPath:propertyName
                            options:NSKeyValueObservingOptionNew
                            context:NULL];
    }
}

- (void)removeNavigatorItemObserver {
    for (NSString *propertyName in _navigatorItemPropertyNames) {
        [_navigatorItem removeObserver:self forKeyPath:propertyName];
    }
}

- (void)setNavigatorItem:(TBNavigatorItem *)navigatorItem {
    if (_navigatorItem) {
        [self removeNavigatorItemObserver];
    }
    _navigatorItem = navigatorItem;

    if (_navigatorItem == nil) {
        return;
    }

    [self addNavigatorItemPropertyObserver];
    [_leftView removeAllSubviews];
    [_rightView removeAllSubviews];
    [_leftView removeAllSubviews];

    if (_navigatorItem.leftBarButtonItem) {
        [self createLeftButton:_navigatorItem.leftBarButtonItem index:0];
    } else if (_navigatorItem.leftBarButtonItems) {
        [self createLeftButtons];
    }
    if (_navigatorItem.rightBarButtonItem) {
        [self createRightButton:_navigatorItem.rightBarButtonItem index:0];
    } else if (_navigatorItem.rightBarButtonItems) {
        [self createRightButtons];
    }
    if (_navigatorItem.titleView) {
        [self addTitleView];
    }
    if (_navigatorItem.title) {
        [self createTitle];
    }
}

- (void)setTitleFont:(UIFont *)font {
    _titleFont = font;
    if (_titleView) {
        UILabel *label = (UILabel *) [_titleView viewWithTag:TBNavigatorViewTitleTag];
        label.font = font;
    }
}

- (void) setBtnFont :(UIView *) btnSuperView {
    if (btnSuperView == nil) {
        return;
    }
    
    NSArray *views = [btnSuperView subviews];
    for (NSObject *obj in views) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*) obj;
            btn.titleLabel.font = _buttonFont;
        }
    }
}

- (void) setButtonFont:(UIFont *)font {
   
    _buttonFont = font;
    [self setBtnFont:_leftView];
    [self setBtnFont:_rightView];
}

- (void)setDisplayShadow:(BOOL)displayShadow{
    _displayShadow = displayShadow;
    UILabel *label = (UILabel *) [_titleView viewWithTag:TBNavigatorViewTitleTag];
    if (displayShadow) {
        label.layer.shadowColor = [UIColor blackColor].CGColor;
        label.layer.shadowOffset = CGSizeMake(0, 1);
        label.layer.shadowOpacity = 1;
        label.layer.shadowRadius = 1.0;
    } else {
        label.layer.shadowOffset = CGSizeMake(0, 0);
        label.layer.shadowOpacity = 0;
        label.layer.shadowRadius = 0;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"leftBarButtonItems"]) {
        [_leftView removeAllSubviews];
        [self createLeftButtons];
    } else if ([keyPath isEqualToString:@"rightBarButtonItems"]) {
        [_rightView removeAllSubviews];
        [self createRightButtons];
    } else if ([keyPath isEqualToString:@"titleView"]) {
        [_titleView removeAllSubviews];
        [self addTitleView];
    } else if ([keyPath isEqualToString:@"title"]) {
        [_titleView removeAllSubviews];
        [self createTitle];
    } else if ([keyPath isEqualToString:@"leftBarButtonItem"]) {
        [_leftView removeAllSubviews];
        [self createLeftButton:_navigatorItem.leftBarButtonItem index:0];
    } else if ([keyPath isEqualToString:@"rightBarButtonItem"]) {
        [_rightView removeAllSubviews];
        [self createRightButton:_navigatorItem.rightBarButtonItem index:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _titleView.frame = [self titleRect];
}

- (void) initContent {
    _displayShadow = YES;
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([TBNavigatorItem class], &propertyCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:6];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    _navigatorItemPropertyNames = propertyNames;
    
    _leftView = [[UIView alloc] initWithFrame:CGRectZero];
    _rightView = [[UIView alloc] initWithFrame:CGRectZero];
    _titleView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:_titleView];
    [self addSubview:_leftView];
    [self addSubview:_rightView];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self initContent];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initContent];
    }
    return self;
}

- (void)dealloc {
    if (_navigatorItem) {
        [self removeNavigatorItemObserver];
    } 
}

@end