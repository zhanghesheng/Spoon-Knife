//
// Created by enfeng on 12-5-30.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "Tao800HorizontalScrollBar.h"
#import "TBCore/TBCoreMacros.h"

//#import "TBBGlobalConstant.h"
#import "Tao800StaticConstant.h"
//#import "TBBStyle.h"
#import "Tao800StyleSheet.h"

//#import "TBBStaticFunction.h"
#import "Tao800FunctionCommon.h"
#import <QuartzCore/QuartzCore.h>


#define kItemFont [UIFont systemFontOfSize:14]
#define kLayerName @"layername"

@implementation Tao800HorizontalScrollBarItem
@synthesize paramDict = _paramDict;
@synthesize title = _title;


- (void)dealloc {

}


@end

@implementation Tao800HorizontalScrollBarCell
@synthesize width =_width;
- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.contentView.frame;
    rect.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.contentView.frame = rect;

    CGFloat height = rect.size.height;
    CGFloat cellWidth = rect.size.width;

    CGRect textRect = self.textLabel.frame;
    textRect.origin = CGPointMake(0, textRect.origin.y);
    textRect.size = CGSizeMake(height, cellWidth);
    self.textLabel.frame = textRect;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView.frame = rect;
//    CGFloat w = 30;
//    CGFloat h = 4;itemWidth
//    CGFloat x = (height - w)/2;
//    CGFloat y = cellWidth - h;

    CGFloat w = _width ;
    if ( w  <= 80) {
        w = 80;
    }
    CGFloat h = 3;
    CGFloat x = 0;
    CGFloat y = cellWidth - h ;

    
    _colorView.frame = CGRectMake(x, y, w, h);
//    _colorView.backgroundColor = [UIColor colorWithHex:0xFB5C0D];
    
    _colorView.backgroundColor = [UIColor redColor];
    
    //TBDPRINT(@"_colorView.frame = %@",NSStringFromCGRect( _colorView.frame));
     //_colorView.frame = CGRectMake(5, 10, 30, 30);
    w = SuitOnePixelHeight();
    h = 17;
    x = 0;
    y = (cellWidth - h)/2;
    _sepView.frame = CGRectMake(x, y, w, h);
    _sepView.urlPath = @"bundle://v6_category_filter_gap_icon@2x.png";
//    NSArray *arr = [self.selectedBackgroundView.layer sublayers];
//    for (CALayer *layer in arr) {
//        if ([layer.name isEqualToString:kLayerName]) {
//            height = 3;
//            CGFloat y = rect.size.width - height;
//            //layer的宽度等于cell的高度
//            layer.frame = CGRectMake(0, y, rect.size.height, height);
//            layer.backgroundColor = [ColorNavBtn CGColor];//[UIColor grayColor].CGColor;
//            break;
//        }
//    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];

        CGFloat kRotation = (M_PI / 180.0) * 90.0f;
        CGAffineTransform transform = CGAffineTransformMakeRotation(kRotation);

        CGRect rect = self.contentView.frame;
        self.contentView.transform = transform;
        self.contentView.frame = rect;
        
        //添加cell分割线
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, self.contentView.frame.size.height)];
//        _sepView = [[TBImageView alloc] initWithFrame:CGRectZero];
//        _sepView.imageUrlPath = @"bundle://v6_category_filter_gap_icon@2x.png";
//        [lineView addSubview:_sepView];
//        lineView.backgroundColor = [UIColor clearColor];//CELL_LINE_COLOR;
//        [self.contentView addSubview:lineView];

        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        //self.textLabel.highlightedTextColor = [UIColor colorWithHex:0xFB5C0D];//[UIColor orangeColor];
        self.textLabel.highlightedTextColor = [UIColor redColor];
        self.textLabel.textColor = [UIColor blackColor];

//        CALayer *layer = [CALayer layer];
//        CGFloat height = 3;
//        CGFloat y = rect.size.height - height;
//        layer.frame = CGRectMake(y, 0, rect.size.height, height);
//        layer.name = kLayerName;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        CGFloat x = (self.contentView.frame.size.height - 30)/2;
        //CGFloat y = (self.contentView.frame.size.width - 2);
        //rect = CGRectMake(self.contentView.frame.size.height - 3, y, 30, 3);
        rect = CGRectMake(x, 35-3, 30, 3);
        _colorView = [[UIView alloc] initWithFrame:rect];
        _colorView.backgroundColor = [UIColor colorWithHex:0xFB5C0D];//[UIColor orangeColor];
//        _colorView.backgroundColor = [UIColor blackColor];
        [bgView addSubview:_colorView];
        self.selectedBackgroundView = bgView;
        self.selectedBackgroundView.transform = transform;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];//[UIColor colorWithHex:0xd7d7d7]; //[UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setObject:(NSObject *)obj {
    if (_item) {
        //TB_RELEASE_SAFELY(_item);
        _item = nil;
    }
    _item = obj;//[obj retain];
}

- (void)dealloc {
//    TB_RELEASE_SAFELY(_item);
//    [super dealloc];
}

@end

@interface Tao800HorizontalScrollBar(){
    CALayer *_lineLayer;
}
@property(nonatomic, strong) CALayer *lineLayer;
@end

@implementation Tao800HorizontalScrollBar {

}

- (CALayer *)lineLayer {
    if (_lineLayer == nil) {
        _lineLayer = [CALayer layer];
        UIColor *color = CELL_LINE_COLOR;
        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        _lineLayer.backgroundColor = color.CGColor;
        TBAddSublayerWithoutAnimation(self.layer, _lineLayer);
        [CATransaction commit];
    }
    return _lineLayer;
}

@synthesize items = _items;
@synthesize barDelegate = _barDelegate;
@synthesize itemWidth = _itemWidth;
@synthesize selectedIndex = _selectedIndex;
@synthesize lineLayer = _lineLayer;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        CGFloat kRotation = (M_PI / 180.0) * 90.0f;
        CGAffineTransform transform = CGAffineTransformMakeRotation(-kRotation);
        self.transform = transform;

        self.frame = frame;
        self.dataSource = self;
        self.delegate = self;

        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.layer.borderColor = V600BackgroundDarkColor.CGColor; //CELL_LINE_COLOR.CGColor;
        self.layer.borderWidth = 1;
        //[self lineLayer];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {

    }
    return self;
}

- (void)setItems:(NSArray *)pItems {
    if (_items) {
        _items = nil;//TB_RELEASE_SAFELY(_items);
    }
    _items = pItems;//[pItems retain];
    [self reloadData];
}

- (void)selectItem:(NSInteger)index {
    [self selectItem:index animated:NO];
}

-(void)selectItem:(NSInteger)index animated:(BOOL)animated{
    self.selectedIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_items == nil) {
        return 0;
    }
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    Tao800HorizontalScrollBarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Tao800HorizontalScrollBarCell alloc]
                initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:CellIdentifier];
        cell.width = _itemWidth;
        cell.textLabel.font = kItemFont;
    }
    NSInteger row = indexPath.row;
    NSString *item = [_items objectAtIndex:row];
    cell.textLabel.text = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //这块很重要
    cell.backgroundColor = [UIColor clearColor];
}

- (CGSize)textSizeOfString:(NSString *)title {
    UIFont *font = kItemFont;
    CGSize textSize = [title sizeWithFont:font
                        constrainedToSize:CGSizeMake(1000, 99999.0)
                            lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [self.items objectAtIndex:indexPath.row];
    CGSize size = [self textSizeOfString:str];
    //预留空隙
    if (_itemWidth > 1) {
        return _itemWidth;
    } else {
        return size.width + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    self.selectedIndex = row;
    if (_barDelegate && [_barDelegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [_barDelegate didSelectItemAtIndex:row];
    }
}


- (void)dealloc {
//    TB_RELEASE_SAFELY(_items);
//    [super dealloc];
}


@end