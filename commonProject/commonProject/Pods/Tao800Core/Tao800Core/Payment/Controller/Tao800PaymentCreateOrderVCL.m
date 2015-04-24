//
//  Tao800PaymentCreateOrderVCL.m
//  tao800
//
//  Created by enfeng on 14-4-28.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import <TBShareKit/WXApi.h>
#import "Tao800PaymentCreateOrderVCL.h"
#import "Tao800PaymentCreateOrderDataSource.h"
#import "Tao800PaymentCreateOrderModel.h"
#import "Tao800PaymentCreateOrderDealCountCell.h"
#import "Tao800KeyboardController.h"
#import "Tao800Util.h"
#import "Tao800FunctionCommon.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800ForwardSegue.h"
#import "Tao800AddressListVo.h"
//#import "Tao800AddressListVCL.h"
//#import "Tao800PersonalAddressViewCTL.h"
#import "EFAlertView.h"
#import "Tao800PaymentProductVo.h"
#import "Tao800PaymentCreateOrderFinishBVO.h"
#import "Tao800PaymentPayFinishWeixinBVO.h"
#import "Tao800PaymentPayFinishBVO.h"

enum {
    PaymentCreateOrderReceiverAlertTag = 3242,
    PaymentCreateOrderWeixinPayAlertTag
};

@interface Tao800PaymentCreateOrderVCL()
- (Tao800PaymentCreateOrderDealCountCell*) getCountCell;
@end

@interface Tao800PaymentCreateOrderVCL () <EFAlertViewDelegate>
@property(nonatomic, strong) Tao800KeyboardController *keyboardController;

/**
* 调用支付客户端
*/
- (void)callAlixPayApp;
@end

@implementation Tao800PaymentCreateOrderVCL

- (void)resetPrice {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    NSString *totalString = FenToYuanFormat([model1.totalPrice intValue]);

    //    self.bottomPriceLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' size=12 color='#E50F3C'>￥</font><font face='Helvetica' size=16 color='#E50F3C'>%@</font>", totalString];
    self.bottomPriceLabel.text = [NSString stringWithFormat:@"%@积分+%@元", model1.totalScore, totalString];
}

- (void) reloadCount {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    Tao800PaymentCreateOrderDealCountCell *cell = [self getCountCell];
    cell.minusButton.enabled = model1.productCount >= 2;
    if (model1.productVo.maxBuyLimit>0) {
        cell.plusButton.enabled = model1.productCount < model1.productVo.maxBuyLimit;
    }
}

- (Tao800PaymentCreateOrderDealCountCell*) getCountCell {
    Tao800PaymentCreateOrderDealCountCell *retCell = nil;
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[Tao800PaymentCreateOrderDealCountCell class]]) {
            retCell = (Tao800PaymentCreateOrderDealCountCell*) cell;
            break;
        }
    }
    return retCell;
}

- (void)setParameters:(NSDictionary *)parameters {
    [super setParameters:parameters];

    Tao800PaymentCreateOrderModel *model1 = [[Tao800PaymentCreateOrderModel alloc] init];
    self.model = model1;
    model1.productVo = parameters[@"productVo"];
    if (model1.productVo.maxBuyLimit<1 || model1.productVo.maxBuyLimit>model1.productVo.stockCount) {
        model1.productVo.maxBuyLimit = model1.productVo.stockCount;
    }
}

- (void)EFAlertView:(EFAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case PaymentCreateOrderReceiverAlertTag: {
            if (buttonIndex == 0) {
                [self receiverAction];
            }
        }
            break;
        default:
            break;
    }
}

/**
* 支付成功：回到“我的订单”列表，并以吐司提示“支付成功”。在“我的订单”再返回，回到所购买商品的详情
* 支付失败：回到该订单的详情页，并以吐司提示“支付失败“，用户在这个详情页可继续进行支付和操作订单。
*          从订单详情返回回到所购买商品的详情
*/
- (void)forwardToPage:(BOOL)paySuccessful {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    if (paySuccessful) {
//        NSDictionary *dict = @{
//                TBBForwardSegueIdentifierKey : @"Tao800OrderListVCL",
//        };
//        [Tao800ForwardSegue ForwardTo:dict sourceController:self];
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithCapacity:2];
        //        [dict2 setValue:@" http://tbuy.m.zhe800.com/orders/h5/get_order_list" forKey:@"url"];
        
        
#ifdef DEBUG
[dict2 setValue:@"http://h5.m.xiongmaoz.com/orders/h5/get_order_list" forKey:@"url"];
#else
[dict2 setValue:@"http://th5.m.zhe800.com/orders/h5/get_order_list" forKey:@"url"];
#endif
        
        
        [dict2 setValue:@"TBBWebViewCTL@Tao800InteractionWapWebVCL" forKey:TBBForwardSegueIdentifierKey];
        [Tao800ForwardSegue ForwardTo:dict2 sourceController:self];
    } else {

//        NSDictionary *dict = @{
//                TBBForwardSegueIdentifierKey : @"Tao800OrderDetailVCL",
//                @"orderNO" : model1.orderFinishBVO.orderNo
//        };
//        [Tao800ForwardSegue ForwardTo:dict sourceController:self];
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithCapacity:2];
//        NSString *url = [NSString stringWithFormat:@"http://tbuy.m.zhe800.com/orders/h5/get_order_detail?order_id=%@",
//                         model1.orderFinishBVO.orderNo];
        
        
#ifdef DEBUG
NSString *url = [NSString stringWithFormat:@"http://h5.m.xiongmaoz.com/orders/h5/get_order_detail?order_id=%@",
                         model1.orderFinishBVO.orderNo];
#else
NSString *url = [NSString stringWithFormat:@"http://th5.m.zhe800.com/orders/h5/get_order_detail?order_id=%@",
                         model1.orderFinishBVO.orderNo];      
#endif
        
        
        
        [dict2 setValue:url forKey:@"url"];
        [dict2 setValue:@"TBBWebViewCTL@Tao800InteractionWapWebVCL" forKey:TBBForwardSegueIdentifierKey];
        [Tao800ForwardSegue ForwardTo:dict2 sourceController:self];
    }
    [self removeFromParentViewController];
}

- (void)showErrorAlert:(NSString *)title message:(NSString *)message {
    EFAlertView *alertView = [[EFAlertView alloc] initWithTitle:title
                                                         detail:message
                                                       delegate:nil
                                                          style:EFAlertViewStyleDefault
                                                   buttonTitles:@"确定", nil];
    alertView.detailLabel.textAlignment = NSTextAlignmentCenter;
    [alertView show];
}

- (void)paySuccessAlert {
    EFAlertView *alertView = [[EFAlertView alloc] initWithTitle:@"付款成功"
                                                         detail:nil
                                                       delegate:nil
                                                          style:EFAlertViewStyleDefault
                                                   buttonTitles:@"确定", nil];
    [alertView show];
}

/**
* 调用支付客户端
*/
- (void)callAlixPayApp {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    __weak Tao800PaymentCreateOrderVCL *instance = self;
    [model1 simpleAlixPay:^{
        //支付成功, 跳到订单列表页面
        [instance paySuccessAlert];
        [instance forwardToPage:YES];
    }             failure:^(TBErrorDescription *error) {
        [instance showTextTip:error.errorMessage];
        [instance forwardToPage:NO];
    }];
}


- (void)callWeixinApp {
    if (![WXApi isWXAppInstalled]) {
        EFAlertView *alertView = [[EFAlertView alloc] initWithTitle:nil
                                                             detail:@"您还没有安装微信的客户端，请先装。"
                                                           delegate:self
                                                              style:EFAlertViewStyleDefault
                                                       buttonTitles:@"确定", nil];
        alertView.tag = PaymentCreateOrderWeixinPayAlertTag;
        alertView.detailLabel.textAlignment = NSTextAlignmentCenter;
        [alertView show];
    } else {
        Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;

        //todo test
//        Tao800PaymentayFinishWeixinBVO *bvo = [[Tao800PaymentPayFinishWeixinBVO alloc] init];
//        bvo.sign = @"7c04037f87013428523c9f8d3b52a8f4ef02cd6b";
//        bvo.timestamp = @"1399440878";
//        bvo.partnerId = @"1217669701";
//        bvo.package = @"Sign=cft";
//        bvo.nonceStr = @"c75b9fd2fbddfe701abd7ad8ef4ee623";
//        bvo.prepayId = @"11010000001405077e2b4d769edf5531";
//        model1.payFinishBVO.weixinBVO = bvo;

        __weak Tao800PaymentCreateOrderVCL *instance = self;
        [model1 weixinPay:^{

            [instance paySuccessAlert];
            [instance forwardToPage:YES];
        }
                  failure:^(TBErrorDescription *error) {
                      [instance showTextTip:error.errorMessage];
                      [instance forwardToPage:NO];
                  }];
    }
}

- (void)callPayApp {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    if ([model1.payChannel isEqualToString:Tao800PaycChannelAlixPay]) {
        [self callAlixPayApp];
    } else if ([model1.payChannel isEqualToString:Tao800PaycChannelWexinPay]) {
        [self callWeixinApp];
    }
}

- (void)resetOrderViews { 
    [self loadItems];

    [self resetPrice];
}

- (IBAction)handleMinusBtnAction {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;

    int count = model1.productCount;
    if (count > 1) {
        count--;
    }
    model1.productCount = count;

    [self resetOrderViews];
}

- (IBAction)handlePlusBtnAction {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    int count = model1.productCount;
    count++;

    model1.productCount = count;
    [self resetOrderViews];
}

- (IBAction)submitAction:(id)sender {
    //todo
    __weak Tao800PaymentCreateOrderVCL *instance = self;

    Tao800PaymentCreateOrderModel *orderModel = (Tao800PaymentCreateOrderModel *) self.model;

    if (!orderModel.receiver) {
        EFAlertView *alertView = [[EFAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"请设置收货人信息，以便将商品邮寄给你"
                                                           delegate:self
                                                              style:EFAlertViewStyleDefault
                                                       buttonTitles:@"确定", @"取消", nil];
        alertView.tag = PaymentCreateOrderReceiverAlertTag;
        alertView.detailLabel.textAlignment = NSTextAlignmentCenter;
        [alertView show];
        return;
    }

    [self showPopupLoadingView:@"正在加载" fullScreen:YES];
    [orderModel createOrder:nil
                 completion:^(NSDictionary *dict) {
                     [instance hidePopupLoadingView];
                     NSString *message = dict[@"errorMessage"];
                     if (message) {
                         [instance showErrorAlert:@"提示" message:message];
                     } else {
                         [instance callPayApp];
                     }
                 } failure:^(TBErrorDescription *error) {
        [instance hidePopupLoadingView];
        [instance dealError:error];
    }];
}

-(void)receiverAction{
    __weak Tao800PaymentCreateOrderVCL *instance = self;
    __weak Tao800PaymentCreateOrderModel *modelInstance = (Tao800PaymentCreateOrderModel *) self.model;

    if (modelInstance.receiver || modelInstance.getAddressError) {

        NSDictionary *dict = nil;
        if (modelInstance.receiver != nil) {
            dict = @{@"addressVo" : modelInstance.receiver};
        } else {
            Tao800AddressListVo *tmpAddress = [[Tao800AddressListVo alloc] init];
            tmpAddress.idStr = @"-1";
            dict = @{@"addressVo" : tmpAddress};
        }

        [[Tao800ForwardSingleton sharedInstance] openAddressPage:dict
                                                   closeCallback:^(NSDictionary *dictX) {
                                                       Tao800AddressListVo *addressListVo = dictX[@"addressListVo"];
                                                       modelInstance.receiver = addressListVo;
                                                       [instance loadItems];
                                                   }];
    } else {

        NSMutableDictionary *dictParam1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @2, @"addressStyle",
                self, @"addressListVCL",
                        nil];

        [[Tao800ForwardSingleton sharedInstance] openAddressDetailPage:dictParam1 closeCallback:^(NSDictionary *dictParam) {

            Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) instance.model;

            [self showPopupLoadingView:@"正在加载" fullScreen:NO];
            [model1 getReceivers:nil
                      completion:^(NSDictionary *dict) {
                          [instance loadItems];
                          [instance hidePopupLoadingView];
                      } failure:^(TBErrorDescription *error) {
                        [instance hidePopupLoadingView];
                        Tao800PaymentCreateOrderDataSource *dc = [[Tao800PaymentCreateOrderDataSource alloc] initWithItems:model1.items];
                        self.dataSource = dc;
                    }];
        }];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.keyboardController.viewOriginY = self.view.frame.origin.y;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboardController = [[Tao800KeyboardController alloc] initWithView:self.tableView scrollOffset:40];
    [self addBackButtonToNavigator];
    Tao800PaymentCreateOrderModel *model12 = (Tao800PaymentCreateOrderModel *) self.model;
    self.model = model12;

    [self resetOrderViews];
    __weak Tao800PaymentCreateOrderVCL *instance = self;

    [self showPopupLoadingView:@"正在加载" fullScreen:NO];
    [model12 getReceivers:nil
              completion:^(NSDictionary *dict) {
                  [instance loadItems];
                  [instance hidePopupLoadingView];
              } failure:^(TBErrorDescription *error) {
                  [instance hidePopupLoadingView];
                  Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;                  
                  Tao800PaymentCreateOrderDataSource *dc = [[Tao800PaymentCreateOrderDataSource alloc] initWithItems:model1.items];
                  self.dataSource = dc;
    }];
    self.view.backgroundColor = [UIColor whiteColor];

    UIImage *image = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];

    self.bottomPriceLabel.backgroundColor = [UIColor clearColor];
    self.bottomPriceLabel.textColor = BACKGROUND_COLOR_RED1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadItems {
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    [model1 wrapperItems];

    Tao800PaymentCreateOrderDataSource *dc = [[Tao800PaymentCreateOrderDataSource alloc] initWithItems:model1.items];
    self.dataSource = dc;
    [self resetPrice];
}

#pragma mark - UITableViewDelegate Methods -
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[Tao800PaymentCreateOrderDealCountCell class]]) {
        Tao800PaymentCreateOrderDealCountCell *cell1 = (Tao800PaymentCreateOrderDealCountCell *) cell;
        cell1.countText.inputAccessoryView = [self.keyboardController getAccessoryView];
    }
    if ([cell isKindOfClass:[Tao800PaymentCreateOrderReceiverTitleCell class]]) {
        Tao800PaymentCreateOrderReceiverTitleCell *cell1 = (Tao800PaymentCreateOrderReceiverTitleCell *) cell;
        cell1.delegate = self;
    }
    if ([cell isKindOfClass:[Tao800PaymentCreateOrderReceiverErrorCell class]]) {
        Tao800PaymentCreateOrderReceiverErrorCell *cell1 = (Tao800PaymentCreateOrderReceiverErrorCell *) cell;
        cell1.delegate = self;
    }
    if ([cell isKindOfClass:[Tao800PaymentCreateOrderReceiverSetCell class]]) {
        Tao800PaymentCreateOrderReceiverSetCell *cell1 = (Tao800PaymentCreateOrderReceiverSetCell *) cell;
        cell1.delegate = self;
    }
}

#pragma mark - UITextFieldDelegate Methods -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)text {
    //    NSUInteger newLength = [textField.text length] + [text length] - range.length;
    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:text];
    NSString *regexString = @"^\\d+$";
    if (searchStr.length < 1) {
//        //    TBAlertNoTitle(@"数量不能小于1");
        //[self resetTotalPrice:@"0"];
        return NO;
    }

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexString
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSUInteger mCount = [regex numberOfMatchesInString:searchStr options:0 range:NSMakeRange(0, [searchStr length])];
    BOOL match = mCount>0;
    
    if (!match) {
        [self showTextTip:@"数量必须为整数"];
        return NO;
    }

    int searchInt = searchStr.intValue;
    if (searchInt<1) {
        [self showTextTip:@"数量不能小于1"];
        return NO;
    }

    //self.dealVo.payInfo.countLimit.intValue;
    Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
    model1.productCount = searchInt;

    if (model1.productVo.maxBuyLimit>0 && model1.productCount > model1.productVo.maxBuyLimit) {
        model1.productCount = model1.productVo.maxBuyLimit;

        NSString *message = [NSString stringWithFormat:@"最多只能买%d件商品", model1.productVo.maxBuyLimit];
        [self showTextTip:message];
    }

    [self resetPrice];
    [self reloadCount];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *searchText = textField.text;
    int searchInt = [searchText intValue];
    if (searchInt<1) {
        NSString *searchStr = textField.text;
        Tao800PaymentCreateOrderModel *model1 = (Tao800PaymentCreateOrderModel *) self.model;
        model1.productCount = searchStr.intValue;
        [self showTextTip:@"数量不能小于1"];
    }
}


#pragma mark - UIScrollViewDelegate Methods -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Tao800PaymentCreateOrderReceiverTitleCellDelegate Methods -
-(void)gotoAdressFromTitle:(Tao800PaymentCreateOrderReceiverTitleCell *)cell{
    [self receiverAction];
}

#pragma mark - Tao800PaymentCreateOrderReceiverErrorCellDelegate Methods -
-(void)gotoAdressFromError:(Tao800PaymentCreateOrderReceiverErrorCell *)cell{
    [self receiverAction];
}

#pragma mark - Tao800PaymentCreateOrderReceiverErrorCellDelegate Methods -
-(void)gotoAdressFromSetting:(Tao800PaymentCreateOrderReceiverSetCell *)cell{
    [self receiverAction];
}

@end
