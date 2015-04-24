//
//  Tao800AddressListVCL.m
//  tao800
//
//  Created by LeAustinHan on 14-4-24.
//  Copyright (c) 2014年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800AddressListVCL.h"
#import "Tao800AddressListModel.h"
#import "Tao800AddressListDataSource.h"
#import "Tao800AddressManageService.h"
#import "Tao800NotifycationConstant.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800AddressListItems.h"
#import "Tao800BubblePopupView.h"
#import "Tao800ForwardSegue.h"
#import "Tao800DealService.h"
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"


const int Tao800BlankAddressTag = 1600;

@interface Tao800AddressListVCL ()
{
    Tao800AddressManageService *_addressService;
    UIButton *button;
    NSNumber *_tipStringStyle;
    Tao800AddressListVo *_addressVo;// 传入地址信息，若有则表示地址管理页面
    BOOL _isH5Page;
}
@property (nonatomic ,strong) Tao800AddressManageService *addressService;
@end

@implementation Tao800AddressListVCL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _addressService = [[Tao800AddressManageService alloc] init];
        _addressVo = [[Tao800AddressListVo alloc] init];
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters{
    [super setParameters:parameters];
    Tao800AddressListVo *tpAddressListVo = [parameters objectForKey:@"addressVo"];
    if (tpAddressListVo) {
        _isH5Page = [[parameters objectForKey:@"isH5Page"] boolValue];
        TBDPRINT(@"收到地址列表页参数 %@",parameters);
        _addressVo = tpAddressListVo;
    }
    //地址列表分为地址管理列表（有选中状态点击cell返回上一级）和地址编辑列表（有默认显示状态、无选中对勾，选中cell进入地址显示页面）
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loadi
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddressListTip:) name:Tao800PersonalAddressViewCTLWillListTipNotification object:nil];
    [self addBackButtonToNavigator];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.model = [[Tao800AddressListModel alloc] init];
    if (_addressVo) {
    Tao800AddressListModel *model1 = (Tao800AddressListModel *)self.model;
        model1.addressVo = _addressVo;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self reloadNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadItems];
}

//设置导航条样式
- (void)reloadNavBar
{
    if (button == nil) {
        //按钮
//        UIImage *btnImg = TBIMAGE(@"bundle://common_button_background@2x.png");
        UIImage *btnImg = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
        button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 108), 0, 108, TBDefaultNavigationBarHeight)];
        
        if (_addressVo == nil) {
            [button setTitle:@"添加地址" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(loadAddressEditPage) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 11;//新添加地址的标签
        }
        else{
            [button setTitle:@"管理地址" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(manageAddressList) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 12;//管理收货地址的标签
        }
        
        [button.titleLabel setTextColor:[UIColor whiteColor]];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];// NSLineBreakByCharWrapping
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];//NSTextAlignmentCenter
        [Tao800Util  resetButton:button withBackgroundImg:btnImg];
        [self.tbNavigatorView addSubview:button];
        button.userInteractionEnabled = NO;
    }
}

- (void)receiveAddressListTip:(NSNotification *)notify
{
    NSNumber *tpString = (NSNumber *)[notify object];
    if (_addressVo == nil && tpString) {
        _tipStringStyle = tpString;
    }
}

- (void)refreshAddressVo{
    //更新地址数据
    Tao800AddressListModel *model1 = (Tao800AddressListModel *)self.model;
    _addressVo = model1.addressVo;

}
- (void)delayShowListSuccessTip
{
        if (_tipStringStyle && [_tipStringStyle intValue]!=0) {
        NSString *tpString = nil;
        switch ([_tipStringStyle intValue]) {
            case TipDefalutAddress:
                tpString = @"操作成功";//设置默认地址成功";
                break;
            case TipDeleteAddress:
                tpString = @"操作成功";//@"删除地址成功";
                break;
            case TipAddAddress:
                tpString = @"新建用户地址成功";
                [self.tableView setContentOffset:CGPointZero animated:NO];
                break;
            case TipUpdateAddress:
                tpString = @"更新地址成功";
                [self.tableView setContentOffset:CGPointZero animated:NO];
                break;
            default:
                break;
        }
        if (tpString &&![tpString isEqualToString:@""]) {
            [self showSuccessTip:tpString];
        }
        _tipStringStyle = @0;
    }
}

-(void)loadMobileAddressListItemsFinish:(NSDictionary *)params{
    [self hidePageTip];
    [self showPageLoading:NO];
    [self hidePopupLoadingView];
    [self resetLoadState];
    
    if (self.model.items.count == 0) {
        [self showblankAddressPageTip:nil detail:nil tipType:Tao800BlankAddressTag];
        if (!_isH5Page) {
//            _addressVo = nil;//空地址，若有回调也返回
            if (self.addressListCallBack){
                self.addressListCallBack (_addressVo);
            }
        }
    }
    else
    {
        UIView *blankView  = (UIView *)[self.view viewWithTag:Tao800BlankAddressTag];
        [blankView removeFromSuperview];
        [self.view bringSubviewToFront:self.tableView];
        
//        if (button.tag == 11) {
//            if (self.model.items.count >=20) {
//                button.hidden = YES;
//            }else{
//                button.hidden = NO;
//            }
//        }
        
        [self.tableView reloadData];

        if (self.addressListCallBack && !_addressVo) {
            Tao800AddressListVo *addressListVo = nil;
            for (Tao800AddressListItems *item in self.model.items) {
                if (item.vo.isDefault) {
                    addressListVo = item.vo;
                    break;
                }
            }
            if (!addressListVo) {
                Tao800AddressListItems *item = self.model.items[0];
                addressListVo = item.vo;
            }
            self.addressListCallBack (addressListVo);
        }
        //有传值地址，许更新地址信息
        if (self.addressListCallBack && _addressVo) {
            Tao800AddressListModel *model1 = (Tao800AddressListModel *)self.model;
//            _addressVo = nil;
            for (Tao800AddressListItems *selectItem in model1.items) {
                if ([selectItem.vo.idStr isEqualToString:_addressVo.idStr]) {
                    _addressVo = selectItem.vo;
                    if (!_isH5Page) {
                        self.addressListCallBack (_addressVo);
                    }
                    break;
                }
            }
            
            if (!_addressVo) {
                Tao800AddressListItems *item = self.model.items[0];
                _addressVo = item.vo;
                if (!_isH5Page) {
                    self.addressListCallBack (_addressVo);
                }
            }
        }
    }
    Tao800AddressListDataSource *dc = [[Tao800AddressListDataSource alloc] initWithItems:self.model.items];
    self.dataSource = dc;
    self.tableView.delegate = self;
    button.userInteractionEnabled = YES;
//    TBDPRINT(@"得到地址列表信息 %@",self.model.items);
}

-(void)loadAddressEditPage
{
    if (self.model.items.count >= 20) {
        [self showTextTip:@"最多只能设置20个地址哦"];
    }
    else{
        TBDPRINT(@"加载新增地址页面");
        //@"addressStyle" 2表示新增地址
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @2,@"addressStyle",
                                    self,@"addressListVCL",
                                    @"Tao800Address@Tao800AddressDetailCTL" ,TBBForwardSegueIdentifierKey,nil];

            [Tao800ForwardSegue ForwardTo:dic sourceController:self];
    }
}


-(void)manageAddressList
{
    NSDictionary *dict = @{
                           TBBForwardSegueIdentifierKey : @"Tao800Address"
                           };
    [Tao800ForwardSegue ForwardTo:dict sourceController:self];
}

-(void)loadItems{
    __weak Tao800AddressListVCL *instance = self;
    if (self.model.items.count < 1) {
        [self showPageLoading:YES];
    }
    else
    {
        [self showPopupLoadingView:@"请求中..." fullScreen:NO];
    }
    __weak UIButton *tpButton = button;
    Tao800AddressListModel *model1 = (Tao800AddressListModel *)self.model;
    [model1 loadAddressListItems:nil completion:^(NSDictionary *dict) {
        [instance refreshAddressVo];
        [instance loadMobileAddressListItemsFinish:dict];
        [instance delayShowListSuccessTip];
        
    } failure:^(TBErrorDescription *error) {
         tpButton.userInteractionEnabled = YES;
        [instance hidePopupLoadingView];
        [instance dealError:error];
        [instance delayShowListSuccessTip];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    Tao800AddressListModel *model1 = (Tao800AddressListModel *)self.model;
    Tao800AddressListItems *selectItem = (Tao800AddressListItems *)[model1.items objectAtIndex:indexPath.row];

    if (self.addressListCallBack) {
         self.addressListCallBack (selectItem.vo);
        [super goBackFromNavigator];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   selectItem.vo,@"addressVo",
                                    @(NO),@"edit",
                                    self,@"addressListVCL",                                 @"Tao800Address@Tao800AddressDetailCTL" ,TBBForwardSegueIdentifierKey,nil];
        
        [Tao800ForwardSegue ForwardTo:dic sourceController:self];
    }
}

-(CGRect)getLoadingRect{
    return self.tableView.frame;
}

//若为有地址数据传入页,即地址选择页面，返回做点选传入地址交互处理
- (void)goBackFromNavigator{
    TBDPRINT(@"传入地址信息 %@",_addressVo.address);
    if (self.addressListCallBack) {
        if (_isH5Page&&_addressVo==nil) {
            Tao800AddressListVo *tpAddressVo = [[Tao800AddressListVo alloc] init];
            tpAddressVo.idStr = @"-1";
            _addressVo = tpAddressVo;
        }
            self.addressListCallBack (_addressVo);
    }
    [super goBackFromNavigator];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数据为空时显示无地址图片
- (void)showblankAddressPageTip:(NSString *)title detail:(NSString *)detail tipType:(int)tipType {
    
    UIView *blankView  = (UIView *)[self.view viewWithTag:tipType];
    if (blankView  == nil) {
        CGRect loadingRect = self.tableView.frame;
        blankView = [[UIView alloc] initWithFrame:loadingRect];
        blankView.backgroundColor = [UIColor whiteColor];
        UIImage *img = TBIMAGE(@"bundle://message_no_address@2x.png");
        UIImageView *centerImgView = [[UIImageView alloc] init];
        centerImgView.image = TBIMAGE(@"bundle://message_no_address@2x.png");
        
        CGRect rectError = centerImgView.frame;
        rectError.origin.x = (loadingRect.size.width - img.size.width)/2;
        rectError.origin.y = (loadingRect.size.height - img.size.height)/2;
        rectError.size.width = img.size.width;
        rectError.size.height = img.size.height;
        centerImgView.frame = rectError;

        blankView.tag = tipType;
        [blankView addSubview:centerImgView];
    }
    else
    {
        [blankView removeFromSuperview];
    }
    button.userInteractionEnabled = YES;
    [self.view insertSubview:blankView aboveSubview:self.tableView];
}

@end
