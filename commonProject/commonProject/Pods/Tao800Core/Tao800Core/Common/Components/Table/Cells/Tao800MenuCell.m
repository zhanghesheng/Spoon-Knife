//
//  Tao800MenuCell.m
//  tao800
//
//  Created by enfeng on 14-3-3.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800MenuCell.h"
#import "Tao800MenuScrollView.h"
#import "TLSwipeForOptionsCell.h"
#import "Tao800StyleSheet.h"

#define kCatchWidth2 148.0f/2

@interface Tao800MenuCell () <UIScrollViewDelegate>

@property(nonatomic, weak) Tao800MenuScrollView *scrollView;

@property(nonatomic, weak) UIView *scrollViewContentView;    //The cell dealContent (like the label) goes in this view.
@property(nonatomic, weak) UIView *scrollViewButtonView;    //Contains our two buttons

@property(nonatomic, assign) BOOL isShowingMenu;

- (void)resetContentView;

@end

@implementation Tao800MenuCell

- (void) resetMenuButton {
   
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
 
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetContentView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self resetContentView];
    }
    return self;
}

- (UIImage *)buttonImageWithColor:(UIColor *)color {
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)resetContentView {
    __weak Tao800MenuCell *instance = self;
    
    // Set up our contentView hierarchy
    
    self.isShowingMenu = NO;
    
    Tao800MenuScrollView *scrollView = [[Tao800MenuScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth2, CGRectGetHeight(self.bounds));
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BACKGROUND_COLOR_GRAY2;
    scrollView.scrollsToTop = NO;
    scrollView.slideWidth = kCatchWidth2;
    scrollView.touchesBeganCallback = ^(NSSet *touches, UIEvent *event, int flag) {
        
        switch (flag) {
            case MenuScrollViewTouchesBegan: {
                if (instance.scrollView.contentOffset.x > 1) {
                    return;
                }
                self.menuButton1.hidden = YES;
                instance.selected = YES;
            }
                break;
            case MenuScrollViewTouchesMoved: {

            }
                break;
            case MenuScrollViewTouchesEnded: {
                if (instance.selected) {
                    [instance cellDidSelect];
                }
            }
                break;
            default:
                break;
        }
    };
    
    [self.contentView addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    UIView *scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth2, 0.0f, kCatchWidth2, CGRectGetHeight(self.bounds))];
    self.scrollViewButtonView = scrollViewButtonView;
    [self.scrollView addSubview:scrollViewButtonView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(userPressedFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:button];
    button.frame = CGRectMake(0.0f, 0.0f, kCatchWidth2, CGRectGetHeight(self.bounds));
    self.menuButton1 = button;
    [self resetMenuButton];

    self.menuButton1.hidden = YES;
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    NSArray *sViews = self.contentView.subviews;
    for (UIView *itemView in sViews) {
        if (itemView != scrollView) {
            [self.scrollViewContentView addSubview:itemView];
        }
    }
    
    //    UIImage *bgImage = [self buttonImageWithColor:[UIColor colorWithHex:0xEEEEEE alpha:.5]];
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = self.bounds;
    //    [button setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    //    [button setTitle:@"hello" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    //    [self.scrollViewContentView addSubview:button];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(gestureAction:)];
    [recognizer setNumberOfTapsRequired:1];
    scrollView.userInteractionEnabled = YES;
    [scrollView addGestureRecognizer:recognizer];
    
    [self.contentView.layer addSublayer:self.lineLayer];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hideMenuOptions)
     name:TLSwipeForOptionsCellShouldHideMenuNotification
     object:nil];
}
//cell点击事件
- (void)cellDidSelect {
    [self.delegate cellDidSelect:self];
}

- (void)gestureAction:(UITapGestureRecognizer *)sender {
    if (self.scrollView.contentOffset.x > 1) {

        //对于ios5会优先进入该方法，按钮不会被响应，需要判断是否点击的按钮
        CGPoint location = [sender locationOfTouch:0 inView:self.scrollView];
        CGRect rect = [self.scrollViewButtonView convertRect:self.menuButton1.frame toView:self.scrollView];
        
        BOOL touchOnFavorite = CGRectContainsPoint(rect, location);
        if (touchOnFavorite) {
            [self userPressedFavoriteButton:nil];
        } else {
            [self hideMenuOptions];
        }
        return;
    }
    [self cellDidSelect];
}

- (void)hideMenuOptions {
    self.selected = NO;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Private Methods

- (void)userPressedDeleteButton:(id)sender {
    //    [self.delegate cellDidSelectDelete:self];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)userPressedFavoriteButton:(id)sender {
    [self.delegate cellDidSelectFavorite:self];
}

#pragma mark - Overridden Methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth2, CGRectGetHeight(self.bounds));
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.scrollViewButtonView.frame = CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth2, 0.0f, kCatchWidth2, CGRectGetHeight(self.bounds));
    self.scrollViewContentView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    [self resetMenuButton];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.scrollView.scrollEnabled = !self.editing;
    
    // Corrects effect of showing the button labels while selected on editing mode (comment line, build, run, add new items to table, enter edit mode and select an entry)
    self.scrollViewButtonView.hidden = editing;
    
    //	NSLog(@"%d", editing);
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 99;
}

- (void)setObject:(id)object {
    [super setObject:object];
 
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.x > kCatchWidth2) {
        targetContentOffset->x = kCatchWidth2;
    } else {
        *targetContentOffset = CGPointZero;
        self.menuButton1.hidden = YES;
        // Need to call this subsequently to remove flickering. Strange.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }

    self.selected = NO;
    if (scrollView.contentOffset.x>0) {
        self.menuButton1.hidden = NO;
    }
    
    self.scrollViewButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth2), 0.0f, kCatchWidth2, CGRectGetHeight(self.bounds));
    Tao800MenuScrollView *ss = (Tao800MenuScrollView *) scrollView;
    if (scrollView.contentOffset.x >= kCatchWidth2) {
        if (!self.isShowingMenu) {
            self.isShowingMenu = YES;
            ss.menuAppeared = YES;
            [self.delegate cell:self didShowMenu:self.isShowingMenu];
        }
    } else if (scrollView.contentOffset.x == 0.0f) {
        if (self.isShowingMenu) {
            self.menuButton1.hidden = YES;
            self.isShowingMenu = NO;
            ss.menuAppeared = NO;
            [self.delegate cell:self didShowMenu:self.isShowingMenu];
        }
    }
}

@end