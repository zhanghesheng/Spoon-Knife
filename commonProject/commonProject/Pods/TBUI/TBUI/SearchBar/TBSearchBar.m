//
//  TBSeachBar.m
//  CustomSearchBarDemo
//
//  Created by enfeng on 13-12-15.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBSearchBar.h"
#import "TBCore/TBCoreMacros.h"

CGFloat const TBSearchBarVPadding = 8;
CGFloat const TBSearchBarHPadding = 8;
CGFloat const TBSearchBarCancelBtnWidth = 70;

@interface TBSearchBar () {

}
@property(nonatomic) BOOL isAnimating;
@property(nonatomic) BOOL showCancelButton;

- (void)handleCancelAction:(id)sender;

- (void)handleBookmarkAction:(id)sender;

- (void)textFieldTextDidChange:(NSNotification *)note;
@end

@implementation TBSearchBar

- (void) layoutSearchBar {
    CGRect rect = self.searchTextField.frame;
           CGRect r2 = self.cancelButton.frame;

           if (!self.showCancelButton && !self.needShowCancelButton) {
               r2.origin.x = self.frame.size.width;
           } else {
               r2.origin.x = self.frame.size.width - self.cancelButtonWidth - self.horizontalPadding;
           }
           self.cancelButton.frame = r2;
           rect.size.width = r2.origin.x - self.horizontalPadding * 2;
           self.searchTextField.frame = rect;
}

- (void)layoutCancelButton:(BOOL) animated {
    if (animated) {
        [self layoutCancelButton];
    } else {
        [self layoutSearchBar];
    }
}

- (void) animateTextField {
    self.isAnimating = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbResetSubViewSizeByFlag:)]) {
        [self.delegate tbResetSubViewSizeByFlag:self.showCancelButton];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutSearchBar];
    }                completion:^(BOOL finish) {
        
        if (finish) {
            self.isAnimating = NO;
        }
    }];
}

- (void)layoutCancelButton {
    if (self.isAnimating) {
        return;
    }
    if (!self.pNeedLayoutSubviews) {
        return;
    }
    self.isAnimating = YES;
 
    //解决bug
    //0011745: 搜索分类页输入关键字搜索后，关键字又从左上下滑到编辑框，动效多余
    [self performSelector:@selector(animateTextField) withObject:nil afterDelay:.1];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.searchTextField.frame;
    rect.origin.x = self.horizontalPadding;
    rect.origin.y = self.verticalPadding;
    rect.size.height = (self.frame.size.height - self.verticalPadding * 2);
    
    CGRect r2 = self.cancelButton.frame;
    
    if (!self.showCancelButton && !self.needShowCancelButton) {
        r2.origin.x = self.frame.size.width;
    } else {
        r2.origin.x = self.frame.size.width - self.cancelButtonWidth - self.horizontalPadding;
    }
    r2.origin.y = self.verticalPadding;
    r2.size = CGSizeMake(self.cancelButtonWidth, self.frame.size.height - self.verticalPadding * 2);
    self.cancelButton.frame = r2;
    rect.size.width = r2.origin.x - self.horizontalPadding * 2;
    self.searchTextField.frame = rect;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) initData {
    
    
    self.pNeedLayoutSubviews = YES;
    self.isAnimating = NO;
    self.showCancelButton = NO;
    
    self.horizontalPadding = TBSearchBarHPadding;
    self.verticalPadding = TBSearchBarVPadding;
    self.cancelButtonWidth = TBSearchBarCancelBtnWidth;
    
    UITextField *textField = [[UITextField alloc] init];
    self.searchTextField = textField;
    [self addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    self.cancelButton = button;
    
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.delegate = self;
    //        self.cancelButton.backgroundColor = [UIColor grayColor];
    self.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    UIButton *myLeftView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, self.frame.size.height)];
    UIImage *image = TBIMAGE(@"bundle://v6_common_search.png");
    [myLeftView setImage:image forState:UIControlStateNormal];
    [myLeftView addTarget:self action:@selector(handleBookmarkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchTextField.leftView = myLeftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.cancelButton addTarget:self action:@selector(handleCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChange:)
     name:UITextFieldTextDidChangeNotification
     object:self.searchTextField];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarShouldBeginEditing:)]) {
        return [self.delegate tbSearchBarShouldBeginEditing:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarShouldBeginEditing:)]) {
        return [self.searchDisplayDelegate tbSearchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.showCancelButton = YES;
    [self layoutCancelButton];

    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarTextDidBeginEditing:)]) {
        [self.delegate tbSearchBarTextDidBeginEditing:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarTextDidBeginEditing:)]) {
        [self.searchDisplayDelegate tbSearchBarTextDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarShouldEndEditing:)]) {
        return [self.delegate tbSearchBarShouldEndEditing:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarShouldEndEditing:)]) {
        return [self.searchDisplayDelegate tbSearchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.showCancelButton = NO;
//    [self layoutCancelButton]; //
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarTextDidEndEditing:)]) {
        [self.delegate tbSearchBarTextDidEndEditing:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarTextDidEndEditing:)]) {
        [self.searchDisplayDelegate tbSearchBarTextDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBar:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate tbSearchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBar:shouldChangeTextInRange:replacementText:)]) {
        [self.searchDisplayDelegate tbSearchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//
//    return YES;
//}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.pNeedLayoutSubviews = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarSearchButtonClicked:)]) {
        [self.delegate tbSearchBarSearchButtonClicked:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarSearchButtonClicked:)]) {
        [self.searchDisplayDelegate tbSearchBarSearchButtonClicked:self];
    }
    return YES;
}

#pragma mark --- text did change ----
- (void)textFieldTextDidChange:(NSNotification *)note {
    UITextField *textField = [note object];
    if (textField != self.searchTextField) {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBar:textDidChange:)]) {
        [self.delegate tbSearchBar:self textDidChange:textField.text];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBar:textDidChange:)]) {
        [self.searchDisplayDelegate tbSearchBar:self textDidChange:textField.text];
    }
}

- (void)handleCancelAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarCancelButtonClicked:)]) {
        [self.delegate tbSearchBarCancelButtonClicked:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarCancelButtonClicked:)]) {
        [self.searchDisplayDelegate tbSearchBarCancelButtonClicked:self];
    }
    
    self.pNeedLayoutSubviews = YES;
    self.showCancelButton = NO;
    [self layoutCancelButton];
    [self.searchTextField resignFirstResponder];

}

- (void)cancelAction{
    self.pNeedLayoutSubviews = YES;
    self.showCancelButton = NO;
    [self layoutCancelButton];
    [self.searchTextField resignFirstResponder];
}

- (void)handleBookmarkAction:(id)sender {
    self.pNeedLayoutSubviews = YES;
    [self.searchTextField becomeFirstResponder];

    if (self.delegate && [self.delegate respondsToSelector:@selector(tbSearchBarLeftViewButtonClicked:)]) {
        [self.delegate tbSearchBarLeftViewButtonClicked:self];
    }
    if (self.searchDisplayDelegate && [self.searchDisplayDelegate respondsToSelector:@selector(tbSearchBarLeftViewButtonClicked:)]) {
        [self.searchDisplayDelegate tbSearchBarLeftViewButtonClicked:self];
    }
}
@end
