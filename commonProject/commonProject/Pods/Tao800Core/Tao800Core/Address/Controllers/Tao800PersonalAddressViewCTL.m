//
//  Tao800PersonalAddressViewCTL.m
//  tao800
//
//  Created by wuzhiguang on 13-4-9.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800PersonalAddressViewCTL.h"
#import "Tao800StyleSheet.h"
#import "Tao800Util.h"
#import "Tao800PersonalAddressDataSource.h"
#import <TBService/TBNetworkApiAdapter.h>
#import "TBNetwork/TBNetworkWrapper.h"
#import "Tao800NetworkNotReachableTipView.h"
#import "Tao800ForwardSingleton.h"
#import "Tao800ForwardSegue.h"
#import "Tao800NotifycationConstant.h"
#import "EFAlertView.h"
#import "Tao800UGCSingleton.h"
#import "Tao800LogParams.h"
#import "TBCore/TBCore.h"

#define NAMETAG 100
#define PROVINCETAG 101
#define CITYTAG 102
#define AREATAG 103
#define ADDRESSTAG 104
#define PHONETAG 105
#define TELTAG 106
#define ZIPCODETAG 107

#define PROVINCEPICKERTAG 200
#define CITYPICKERTAG 201
#define AREAPICKERTAG 202

@interface Tao800PersonalAddressViewCTL ()
{
    NSMutableString *_tipString;
    
    Tao800AddressCityVo *_selectedCityVo;
    
    Tao800AddressListVCL *_addressListVCL;
    
    NSInteger defaultProvinceRow;
    
    NSInteger defaultCityRow;
    
    NSInteger defaultAreaRow;
    
    NSInteger pickerDefault;
    
    UIImageView *_areaClickTipImg;
}
@property BOOL needLog;
@end

@implementation Tao800PersonalAddressViewCTL

@synthesize addressCityList = _addressCityList;
@synthesize provinceList = _provinceList;
@synthesize cityList = _cityList;
@synthesize areaList = _areaList;
@synthesize selectProvinceId = _selectProvinceId;
@synthesize selectCityId = _selectCityId;
@synthesize selectAreaId = _selectAreaId;
@synthesize provinceToolBar = _provinceToolBar;

#pragma mark - 生命周期方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters {
    [super setParameters:parameters];
    if (self) {
        _model = [[Tao800AddressDetailModel alloc] init];
        
        _blankAddressVo = [[Tao800AddressCityVo alloc] init];
        
        _addressListVCL = (Tao800AddressListVCL *)[parameters objectForKey:@"addressListVCL"];
        
        _isEdit = [[parameters objectForKey:@"edit"] boolValue];
        
        _addressVo = [parameters objectForKey:@"addressVo"];
        
        _addressStyle = [[parameters objectForKey:@"addressStyle"] intValue];
        self.needLog = [[parameters objectForKey:@"needLog"] boolValue];

        //新增地址无地址数据，且开启编辑状态_isEdit_isEdit = YES;
        if (_addressVo == nil) {
            _addressStyle = AddressEditTypeNew;
            _addressVo = [[Tao800AddressListVo alloc] init];
            _isEdit = YES;
        }
        else if(_addressStyle == AddressEditTypeEdit){
            _isEdit = YES;
        }else{
            _addressStyle  = _addressVo.isDefault;
        }
        _tipString = [[NSMutableString alloc] init];
        
        defaultAreaRow = 0;
        defaultCityRow = 0;
        defaultProvinceRow = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    if ((_addressStyle == AddressEditTypeDefault)||(_addressStyle == AddressEditTypeGeneral)) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddressTip:) name:Tao800GetAddressTipNotification object:nil];
//    }
    float statusBarHeight = 0;
    if (TB_IS_After_iOS7) {
        statusBarHeight += TBDefaultStatusBarHeight;
        self.view.backgroundColor = BACKGROUND_COLOR_RED1;
    }
    self.view.layer.masksToBounds = YES;
    UIViewController *ctl = self.parentViewController;
    CGRect rect = ctl.view.bounds;
    rect.origin.y += statusBarHeight;
    self.view.frame = rect;
    
//    rect = self.tableView.frame;
//    rect.origin.y += statusBarHeight;
    self.tableView.frame = rect;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = BORDER_COLOR_GRAY1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self loadAddressTableCells];
    [self loadAddressInfo];
    [self loadFooterView];
    [self addBackButton];
    [self loadBottomView];
    
    _provincePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.height-216,self.view.width,216)];
    _provincePickerView.delegate = self;
    _provincePickerView.showsSelectionIndicator = YES;
    _provincePickerView.tag = PROVINCEPICKERTAG;
    self.provinceToolBar = [self pickerToolbar:PROVINCEPICKERTAG];
    
    __weak Tao800PersonalAddressViewCTL *instance = self;
    Tao800AddressDetailModel *model = (Tao800AddressDetailModel *)self.model;
    [model.addressManageService getCitiesList:^(NSDictionary *dic) {
        [instance getAddressCityListFinish: dic];
    }];

    [self updateButtonState];
    
    //应对无数据时的空数据
    _blankAddressVo.cityId = @"-1";
    _blankAddressVo.name = @" ";
    _blankAddressVo.parentId = @"-1";
    _blankAddressVo.pinyin = @"";
    
    UIImage *btnImg = TBIMAGE(@"bundle://personal_home_icon_right_arrow.png");
    _areaClickTipImg = [[UIImageView alloc] initWithImage:btnImg];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView.tableFooterView == nil) {
        [self loadFooterView];
    }
    //新增地址和编辑地址页面不会请求地址详情
    if (_addressVo&&_addressStyle != AddressEditTypeEdit&&_addressStyle != AddressEditTypeNew) {
        [self getAddressDetail];
    }
}

- (void)getAddressDetail
{
    if (_addressVo.idStr) {
        __weak Tao800PersonalAddressViewCTL *instance = self;
        Tao800AddressDetailModel *model = (Tao800AddressDetailModel *)self.model;
        [model.addressManageService getAddressDetail:[NSDictionary dictionaryWithObject:_addressVo.idStr forKey:@"id"]
                                     completion:^(NSDictionary *dic) {
                                         [instance reloadAddressInfo:[dic objectForKey:@"items"]];
                                     } failure:^(TBErrorDescription *error) {
                                         [instance dealError:error];
        }];
    }
}

- (void)loadBottomView{
    //按钮
    UIImage *btnImg = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
    _editOrSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 108, 0, 108, TBDefaultNavigationBarHeight)];
    _editOrSaveButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_editOrSaveButton addTarget:self action:@selector(editOrSave) forControlEvents:UIControlEventTouchUpInside];
    [Tao800Util  resetButton:_editOrSaveButton withBackgroundImg:btnImg];
    
    [self.tbNavigatorView addSubview:_editOrSaveButton];
}

- (void)loadFooterView{
    float _heightDiffierence= 0.0;
    float _gapDiffierence= 0.0;
    if ([[UIScreen mainScreen] bounds].size.height>480) {
        _heightDiffierence += 65;
        _gapDiffierence= 10.0;
    }
    UIView *footerView = nil;
    
    if (_addressStyle == 0) {//为一般地址类型，需要显示 设置默认地址、删除 按钮
        footerView = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, self.view.frame.size.width+10, 200+_heightDiffierence)];
        [self resetButton:@"     设为默认收货地址" selector:@selector(defaultCurrentAddressDefault) frame:CGRectMake(0, 14+_heightDiffierence, self.tableView.frame.size.width+10, 44) bottomView:footerView];
        [self resetButton:@"     删除收货地址" selector:@selector(deleteCurrentAddress) frame:CGRectMake(0, 78+_heightDiffierence+_gapDiffierence, self.tableView.frame.size.width+10, 44) bottomView:footerView];
    }else if (_addressStyle == 1){//为默认地址类型，只需要显示 删除 按钮
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        //按钮
        [self resetButton:@"     删除收货地址" selector:@selector(deleteCurrentAddress) frame:CGRectMake(0, 14+_heightDiffierence, self.tableView.frame.size.width+10, 44) bottomView:footerView];
    }else if(_isEdit||_addressStyle == 2){
        [self showSaveButtonFooterView];
        return;
    }

    self.tableView.tableFooterView = footerView;
}

- (void)addBackButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self addBackButtonToNavigator];
    
    CGRect rect = self.tbNavigatorView.frame;
    rect.size.height = TBDefaultRowHeight;
    rect.origin.y = self.view.height - rect.size.height;
    self.tbNavigatorView.frame = rect;
}

- (void)resetButton:(NSString *)title selector:(SEL)action frame:(CGRect)rect bottomView:(UIView *)bottomView
{
    UIImage *btnImg = nil;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIButton alloc] initWithFrame:rect];
    button.frame = rect;
    if (rect.size.width < self.tableView.frame.size.width) {
        btnImg = [Tao800Util imageWithColor:BACKGROUND_COLOR_RED1 bounds:CGRectMake(0, 0, 1, 1)];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setTextColor:[UIColor whiteColor]];
    }else {
//        btnImg = TBIMAGE(@"bundle://common_button_verify.png");
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [button.titleLabel setTextColor:TEXT_COLOR_BLACK1];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if ([title isEqualToString:@"     删除收货地址"]) {
            [button setTitleColor:BACKGROUND_COLOR_RED1 forState:UIControlStateNormal];
        }else{
            [button setTitleColor:TEXT_COLOR_BLACK2 forState:UIControlStateNormal];
        }
        
        // 使用颜色创建UIImage
        CGSize imageSize = CGSizeMake(30, 44);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [BACKGROUND_COLOR_GRAY2 set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        btnImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    button.layer.borderWidth = 0.3;
    button.layer.borderColor = TEXT_COLOR_BLACK5.CGColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setText:title];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [button.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];//NSLineBreakByCharWrapping NSLineBreakByCharWrapping
    [button addSubview:button.titleLabel];
    [Tao800Util  resetButton:button withBackgroundImg:btnImg];
    [bottomView addSubview:button];
}

//删除当前地址
- (void)deleteCurrentAddress
{
    
    EFAlertView *tipsTmp = [[EFAlertView alloc] initWithTitle:nil
                                                       detail:@"确定要删除该地址吗？删除后将不可恢复"
                                                     delegate:(id)self
                                                        style:EFAlertViewStyleDefault
                                                 buttonTitles:@"确定",@"取消", nil];
    
    self.tips = tipsTmp;
    self.tips.tag = TipDeleteAddress;
    [self.tips show];
}

- (void)deleteCurrentAddressRequest
{
    TBDPRINT(@"删除当前地址");
    if (_addressVo.idStr) {
        [self showPopupLoadingView:@"删除当前地址" fullScreen:YES];
        __weak Tao800PersonalAddressViewCTL *instance = self;
        Tao800AddressDetailModel *model = (Tao800AddressDetailModel *)self.model;
        [model.addressManageService getDeleteAddress:[NSDictionary dictionaryWithObject:_addressVo.idStr forKey:@"id"]
                                     completion:^(NSDictionary *dict) {
                                         [instance showTipListNotify:@(TipDeleteAddress)];
                                         [instance dealAddressFinish:dict];
                                     }failure:^(TBErrorDescription *error) {
                                         [instance dealError:error];
                                     }];
    }
}


//当前地址设置为默认地址
- (void)defaultCurrentAddressDefault
{
    TBDPRINT(@"当前地址设为默认地址");
    if (_addressVo.idStr) {
        [self showPopupLoadingView:@"设置默认地址" fullScreen:YES];
        __weak Tao800PersonalAddressViewCTL *instance = self;
        Tao800AddressDetailModel *model = (Tao800AddressDetailModel *)self.model;
        [model.addressManageService getDefaultAddress:[NSDictionary dictionaryWithObject:_addressVo.idStr forKey:@"id"]
                               completion:^(NSDictionary *dict) {
                                [instance showTipListNotify:@(TipDefalutAddress)];
                                [instance dealAddressFinish:dict];
                               }failure:^(TBErrorDescription *error) {
                                [instance dealError:error];
                               }];
    }
}

//编辑或者增加地址
- (void)addOrEditAddress:(NSDictionary *)dic{
    __weak Tao800PersonalAddressViewCTL *instance = self;
    Tao800AddressDetailModel *model = (Tao800AddressDetailModel *)self.model;
    // 判断是否新增收货地址
    if (_addressStyle == 2) {
        if(self.needLog){
            //打点
            Tao800UGCSingleton *ugc = [Tao800UGCSingleton sharedInstance];
            [ugc paramsLog:Event_Save_Address params:nil];
        }
        [model.addressManageService addAddress:dic
                               completion:^(NSDictionary *dict) {
                                   // 成功
                                   [instance showTipListNotify:@(TipAddAddress)];
                                   [instance dealAddressFinish:dict];
                               }failure:^(TBErrorDescription *error) {
                                   [instance dealError:error];
                               }];
    }else {
        [model.addressManageService editAddress:dic
                                completion:^(NSDictionary *dict) {
                                [instance  hidePopupLoadingView];
                                [instance  showPageLoading:NO];
                                    [instance showTipListNotify:@(TipUpdateAddress)];
                                [instance dealAddressFinish:dict];
                                }failure:^(TBErrorDescription *error) {
                                    [instance dealError:error];
                                }];
    }
}

- (void)showTipListNotify:(NSNumber *)tipStyle
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Tao800PersonalAddressViewCTLWillListTipNotification object:tipStyle];
}

- (void)receiveAddressTip:(NSNotification *)notify
{
    [_tipString setString:(NSString *)[notify object]];
}

- (void)delayShowSuccessTip:(NSString *)tipString
{
    if (_tipString && ![_tipString isEqualToString:@""]) {
        [self  performSelector:@selector(showSuccessTip:) withObject:_tipString afterDelay:1];
        _tipString = nil;
    }
}

- (void)reloadAddressInfo:(Tao800AddressListVo*)addressVo
{
    if (addressVo != nil) {
        if ([addressVo.idStr isEqualToString:@"0"]) {
            [self showTextTip:@"地址不存在或已删除"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2.0];
            return;
        }
        _addressVo = addressVo;
        [self loadAddressInfo];
    }
}

//处理地址信息结束
-(void)dealAddressFinish:(NSDictionary *)params
{
    [self hidePopupLoadingView];
    [self showPageLoading:NO];
    if ([params objectForKey:@"ret"]&&[[params objectForKey:@"ret"] intValue] == 0) {
        TBDPRINT(@"成功 = %@",[params objectForKey:@"msg"]);
//        [self.navigationController popViewControllerAnimated:YES];
        if (self.addAddressallBack) {//成功时调用block供上层处理用
            self.addAddressallBack(nil);
        }
        if (_addressListVCL) {
            [self.navigationController popToViewController:_addressListVCL animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)dealError:(TBErrorDescription *)error {
//    [super dealError:error];
    
    NSString *errorMessage = @"当前网络不稳定，请稍后再试";
    
    TBNetworkApiAdapter *serviceAdapter = [TBNetworkApiAdapter sharedInstance];
    if (serviceAdapter.networkStatus == NotReachable) { //无网络
        errorMessage = nil;
        
        //需要显示网络断开的提示
        Tao800NetworkNotReachableTipView *mView = [[Tao800NetworkNotReachableTipView alloc]
                                                   initWithTitle:@"当前处于无网络连接，请检查设置"
                                                   delegate:nil
                                                   style:TBBMessageViewStyleWarning
                                                   position:TBBMessageViewPositionBottom
                                                   containRightButton:YES];
        [mView show];
    }
    
    
    [self showPageLoading:NO];
    [self hidePopupLoadingView];
    [self resetLoadState];
    
    //用于下拉刷新完成状态的判断
    self.netErrorDescription = error;
    
    Tao800PageTipType tipType = Tao800PageTipTypeNetworkError;
    
    if (serviceAdapter.networkStatus == NotReachable) {
        tipType = Tao800PageTipTypeNetworkNotReachable;
    }if (error.errorCode > 10000) {//收货地址服务器异常处理,此处交互和显示需要确认
        errorMessage = error.errorMessage;
        [self showTextTip:errorMessage];
        [self hidePopupLoadingView];
        return;
    }else if (error.errorCode >= 500) {
        errorMessage = @"工程师们正在抢修，请稍后再试";
        tipType = Tao800PageTipTypeNetworkServer500;
    }else if (error.errorCode == 404) {
        tipType = Tao800PageTipTypeNetworkServer404;
        errorMessage = @"工程师们正在抢修，请稍后再试";
    }else if (error.errorCode == 401) {
        //需要用户登录
        [[Tao800ForwardSingleton sharedInstance] openLoginPage:nil];
        return;
    }else{
        errorMessage = @"网络不稳定，请检查网络配置";
        tipType = Tao800PageTipTypeNetworkTimeout;
    }
    
    [self tipShow:@"提示" detail:errorMessage];
}


- (void)initAddressTableCell:(UITableViewCell *)tableCell title:(NSString *)title textField:(UITextField *)textField tag:(int)tag
{
    CGRect rect = CGRectZero;
    UILabel *starLabel = [[UILabel alloc] init] ;
    //    starLabel1.text = @"*";
    starLabel.font = [UIFont systemFontOfSize:14];
    starLabel.textColor = [UIColor redColor];
    starLabel.backgroundColor = [UIColor clearColor];
    rect = CGRectMake(5, 20, 12, 12);
    starLabel.frame = rect;
    
    UILabel *nameLabel = [[UILabel alloc] init] ;
    nameLabel.text = title;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;//NSTextAlignmentLeft;
    nameLabel.textColor = TEXT_COLOR_BLACK3;
    rect = CGRectMake(12, 15, 74, 15);
    nameLabel.frame = rect;
    
   
    textField.frame = CGRectMake(90, 12, self.view.width - 120, 22);
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    textField.placeholder= @"请输入收货人姓名";
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = TEXT_COLOR_BLACK1;
    textField.borderStyle = UITextBorderStyleNone;
    textField.returnKeyType=UIReturnKeyDone;
    textField.keyboardType=UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.inputAccessoryView = [self toolbar];
    textField.enablesReturnKeyAutomatically=YES;
    textField.delegate=self;
    textField.tag = tag;
    
    [tableCell addSubview:starLabel];
    [tableCell addSubview:nameLabel];
    [tableCell addSubview:textField];
}

- (void)loadAddressTableCells
{
    UITableViewCell *nameCell = [[UITableViewCell alloc] init] ;
    _nameTextField = [[UITextField alloc] init];
    [self initAddressTableCell:nameCell title:@"收货人姓名" textField:_nameTextField tag: NAMETAG];
    
    UITableViewCell *provinceCell = [[UITableViewCell alloc] init];
    _provinceTextField = [[UITextField alloc] init];
    if(_isEdit||_addressStyle == 2){
        UIImage *btnImg = TBIMAGE(@"bundle://personal_home_icon_right_arrow.png");
        UIImageView *areaClickTipImg = [[UIImageView alloc] initWithImage:btnImg];
        areaClickTipImg.frame = CGRectMake(self.view.width - 30, 18, 6, 12);
        [provinceCell addSubview:areaClickTipImg];
    }

    [self initAddressTableCell:provinceCell title:@"所在地区" textField:_provinceTextField tag:PROVINCETAG];
    
    
    UITableViewCell *addressCell = [[UITableViewCell alloc] init];
    _addressTextField = [[UITextField alloc] init];
    [self initAddressTableCell:addressCell title:@"街道地址" textField:_addressTextField tag:ADDRESSTAG];
    
    UITableViewCell *phoneCell = [[UITableViewCell alloc] init] ;
    _phoneTextField = [[UITextField alloc] init];
    
    [self initAddressTableCell:phoneCell title:@"手机号码" textField:_phoneTextField tag:PHONETAG];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITableViewCell *zipcodeCell = [[UITableViewCell alloc] init];
    _zipcodeTextField = [[UITextField alloc] init];
    
    [self initAddressTableCell:zipcodeCell title:@"邮政编码" textField:_zipcodeTextField tag:ZIPCODETAG];
    _zipcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.dataSource = [Tao800PersonalAddressDataSource dataSourceWithObjects:
                       @"",
                       nameCell,
                       phoneCell,
                       zipcodeCell,
                       provinceCell,
                       addressCell,
                       nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard
{
    CGRect rect = self.tableView.frame;
    float statusBarHeight = 0.0f;
    if (TB_IS_After_iOS7) {
        statusBarHeight += TBDefaultStatusBarHeight;
    }
    rect.origin.y = statusBarHeight;
    self.tableView.frame = rect;
    
    [_nameTextField resignFirstResponder];
    [_provinceTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_telTextField resignFirstResponder];
    [_zipcodeTextField resignFirstResponder];
    _addressLabel.text = _addressTextField.text;
}

- (UIToolbar *)toolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)] ;
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self action:@selector(hideKeyboard)];
    NSArray *arr = [NSArray arrayWithObjects:barButtonItem, barItem1, nil];
    toolbar.items = arr;
    
    return toolbar;
}

- (void)changeProivce:(Tao800AddressCityVo *)setVo{
    
    BOOL refresh = NO;
    if (defaultProvinceRow != 0) {
        refresh = YES;
    }
    if (setVo!= nil) {
        self.selectProvinceId = setVo.cityId;
        _selectProvinceName = setVo.name;
        [self defaultAllLocation];
        [_provincePickerView selectRow:0 inComponent:1 animated:NO];
        [_provincePickerView selectRow:0 inComponent:2 animated:NO];
    }
    else{
        NSInteger row = defaultProvinceRow;//[_provincePickerView selectedRowInComponent:defaultProvinceRow];
        Tao800AddressCityVo *vo = [_provinceList objectAtIndex:row];
        self.selectProvinceId = vo.cityId;
        _selectProvinceName = vo.name;
//        defaultProvinceRow = 0;
    }
    if (_cityList == nil) {
        _cityList = [NSMutableArray array];
    }else {
        [_cityList removeAllObjects];
    }
    // 获取二级市列表
    for (int i=0; i<_addressCityList.count; i++) {
        Tao800AddressCityVo *vo = [_addressCityList objectAtIndex:i];
        if ([vo.parentId isEqualToString:_selectProvinceId]) {
            [_cityList addObject:vo];
        }
    }
    
    if (!_cityList.count) {
        [_cityList addObject:_blankAddressVo];
    }
    
    [_provincePickerView reloadComponent:1];
    [self getDefaultPickLocationCity];
    
    [self changeCity:nil];
}

- (void)defaultAllLocation
{
    defaultProvinceRow = 0;
    defaultCityRow = 0;
    defaultAreaRow = 0;
}


- (void)changeCity:(Tao800AddressCityVo *)setVo{

    if (setVo!= nil) {
        self.selectCityId = setVo.cityId;
        _selectCityName = setVo.name;
        pickerDefault = 5;
        [self defaultAllLocation];
        [_provincePickerView selectRow:0 inComponent:2 animated:NO];
    }
    else{
        NSInteger row = defaultCityRow;// [_provincePickerView selectedRowInComponent:defaultCityRow];
        Tao800AddressCityVo *vo = [_cityList objectAtIndex:row];
        self.selectCityId = vo.cityId;
        _selectCityName = vo.name;
    }
    
    if (_areaList == nil) {
        self.areaList = [NSMutableArray array];
    }else {
        [_areaList removeAllObjects];
        self.areaList = [NSMutableArray array];
    }
    // 获取三级区列表
    for (int i=0; i<_addressCityList.count; i++) {
        Tao800AddressCityVo *vo = [_addressCityList objectAtIndex:i];
        if ([vo.parentId isEqualToString:_selectCityId]) {
            [_areaList addObject:vo];
        }
    }
    
    if (!_areaList.count) {
        [_areaList addObject:_blankAddressVo];
    }

    [_provincePickerView reloadComponent:2];
    [self getDefaultPickLocationArea];
    [self changeArea:nil];
    
}

- (void)changeArea:(Tao800AddressCityVo *)setVo
{
    
    if (setVo!= nil) {
        self.selectAreaId = setVo.cityId;
        _selectAreaName = setVo.name;
        pickerDefault = 5;
        [self defaultAllLocation];
    }
    else{
        NSInteger row = defaultAreaRow;//[_provincePickerView selectedRowInComponent:defaultAreaRow];
        Tao800AddressCityVo *vo = [_areaList objectAtIndex:row];
        self.selectAreaId = vo.cityId;
        _selectAreaName = vo.name;
//        defaultAreaRow = 0;
    }
    
    UIView *view = [self.view viewWithTag:PROVINCEPICKERTAG];
    if (!view) {
        [self.view addSubview:_provinceToolBar];
        [self.view addSubview:_provincePickerView];
    }
    
    if (pickerDefault <3) {
        [_provincePickerView selectRow:defaultProvinceRow inComponent:0 animated:NO];
        [_provincePickerView selectRow:defaultCityRow inComponent:1 animated:NO];
        [_provincePickerView selectRow:defaultAreaRow inComponent:2 animated:NO];
        pickerDefault = 5;
    }
}

- (void)getDefaultPickLocationProvince
{
    if (pickerDefault >3) {
        return;
    }
    if (_provinceList.count) {
        for (int i = 0; i<_provinceList.count; i++) {
            Tao800AddressCityVo *vo = [_provinceList objectAtIndex:i];
            if ([vo.cityId isEqualToString:_addressVo.provinceId]) {
                defaultProvinceRow = i;
                return;
            }
        }
    }
}

- (void)getDefaultPickLocationCity
{
    if (pickerDefault >3) {
        return;
    }
    if (_cityList.count) {
        for (int i = 0; i<_cityList.count; i++) {
            Tao800AddressCityVo *vo = [_cityList objectAtIndex:i];
            if ([vo.cityId isEqualToString:_addressVo.cityId]) {
                defaultCityRow = i;
                return;
            }
        }
    }
}

- (void)getDefaultPickLocationArea
{
    if (pickerDefault >3) {
        return;
    }
    if (_areaList.count) {
        for (int i = 0; i<_areaList.count; i++) {
            Tao800AddressCityVo *vo = [_areaList objectAtIndex:i];
            if ([vo.cityId isEqualToString:_addressVo.countyId]) {
                defaultAreaRow = i;
                return;
            }
        }
    }
}

- (void)cancelPickerView
{
    [self hideKeyboard];
    [_provinceToolBar removeFromSuperview];
    [_provincePickerView removeFromSuperview];
    pickerDefault = 0;
}

//地区选择确认
- (void)selectProvince
{
    NSInteger row = [_provincePickerView selectedRowInComponent:0];
    Tao800AddressCityVo *vo = [_provinceList objectAtIndex:row];
    self.selectProvinceId = vo.cityId;
    _selectProvinceName = vo.name;
    _addressVo.provinceId = vo.cityId;
    
    NSInteger rowCity = [_provincePickerView selectedRowInComponent:1];
    Tao800AddressCityVo *voCity = [_cityList objectAtIndex:rowCity];
    self.selectCityId = voCity.cityId;
    _selectCityName = voCity.name;
    _addressVo.cityId = voCity.cityId;
    
    
    NSInteger rowArea = [_provincePickerView selectedRowInComponent:2];
    Tao800AddressCityVo *voArea = [_areaList objectAtIndex:rowArea];
    self.selectAreaId = voArea.cityId;
    _selectAreaName = voArea.name;
    _addressVo.countyId = voArea.cityId;
    
    
    _provinceTextField.text = [NSString stringWithFormat:@"%@%@%@",vo.name,voCity.name,voArea.name];
    
    [self cancelPickerView];
}

- (UIToolbar *)pickerToolbar:(int)tag {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height-216-44, self.view.width, 44)] ;
    toolbar.translucent = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 216)] ;
    if (TB_IS_After_iOS7) {
        toolbar.barStyle = UIBarStyleDefault;
        //由于IOS 7 选择器样式改变做的调整
        view.backgroundColor = [UIColor whiteColor];
        barButtonItem.customView = view;
    }
    else
    {
        toolbar.barStyle = UIBarStyleBlack;
    }
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    barItem.title = @"取消";
    barItem.style = UIBarButtonItemStyleDone;
    [barItem setTarget:self];
    [barItem setAction:@selector(cancelPickerView)];
    
    UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] init];
    barItem1.title = @"确定";
    barItem1.style = UIBarButtonItemStyleDone;
    [barItem1 setTarget:self];
    [barItem1 setAction:@selector(selectProvince)];
    
    NSArray *arr = [NSArray arrayWithObjects:barItem,barButtonItem, barItem1, nil];
    toolbar.items = arr;
    
    return toolbar;
}

#pragma mark - 改变cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

//判断是否有偏远地区
- (BOOL)hasRomateArea:(NSString *)province
{
    NSArray *outProvinceArray = @[@"港澳台",@"新疆",@"内蒙",@"西藏",@"甘肃",@"青海"];
    for (int i = 0; i<outProvinceArray.count; i++) {
        NSRange range = [province rangeOfString:[outProvinceArray objectAtIndex:i]];
        if (range.length >0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 获取收货地址城市列表回调方法
- (void)getAddressCityListFinish:(NSDictionary *)params
{
    self.addressCityList = [params objectForKey:@"items"];
    
    if (_provinceList == nil) {
        self.provinceList = [NSMutableArray array];
    }else {
        [_provinceList removeAllObjects];
        self.provinceList = [NSMutableArray array];
    }
    
    // 获取一级省份列表
    for (int i=0; i<_addressCityList.count; i++) {
        Tao800AddressCityVo *vo = [_addressCityList objectAtIndex:i];
        if ([vo.parentId isEqualToString:@"1"]) {
            //            if ([self hasRomateArea:vo.name]) {
            //                continue;
            //            }
            [_provinceList addObject:vo];
        }
    }
    
    [self getDefaultPickLocationProvince];
}

//设置编辑地址信息
- (void)loadAddressInfo
{
    if (_addressVo != nil) {
        if (_addressVo.receiverName) {
            _nameTextField.text = _addressVo.receiverName;
        }
        if (_addressVo.mobile) {
            _phoneTextField.text = _addressVo.mobile;
        }
        if (_addressVo.provinceName) {
            _provinceTextField.text = [NSString stringWithFormat:@"%@%@%@",_addressVo.provinceName,_addressVo.cityName,_addressVo.countyName];
            _selectProvinceName = _addressVo.provinceName;
        }
        if (_addressVo.provinceId) {
            _selectProvinceId= _addressVo.provinceId;
        }
        if (_addressVo.cityName) {
            _selectCityName = _addressVo.cityName;
        }
        if (_addressVo.cityId) {
            _selectCityId = _addressVo.cityId;
        }
        if (_addressVo.countyName) {
            _selectAreaName = _addressVo.countyName;
        }
        if (_addressVo.countyId) {
            _selectAreaId = _addressVo.countyId;
        }
        if (_addressVo.address) {
            _addressTextField.text = _addressVo.address;
        }
        if (_addressVo.postCode) {
            _zipcodeTextField.text = _addressVo.postCode;
        }
        
    }
    [self delayShowSuccessTip:nil];
}

#pragma mark picker Delegate Methods
// 返回选取器包含的滚轮数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回选取器数据的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCEPICKERTAG -200) {
        return [_provinceList count];
    }
    else if (component == CITYPICKERTAG -200)
    {
        return [_cityList count];
    }
    else if (component == AREAPICKERTAG -200)
    {
        return [_areaList count];
    }
    
    return 0;
}


// 实现委托返回当前行的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCEPICKERTAG -200) {
        Tao800AddressCityVo *vo = [_provinceList objectAtIndex:row];
        return vo.name;
    }
    else if (component == CITYPICKERTAG -200)
    {
        Tao800AddressCityVo *vo = [_cityList objectAtIndex:row];
        return vo.name;
    }
    else if (component == AREAPICKERTAG -200)
    {
        Tao800AddressCityVo *vo = [_areaList objectAtIndex:row];
        return vo.name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCEPICKERTAG -200) {
        if (_provinceList&&_provinceList.count >=row) {
            Tao800AddressCityVo *vo = [_provinceList objectAtIndex:row];
            [self changeProivce:vo];
        }
    }
    else if (component == CITYPICKERTAG -200)
    {
        if (_cityList&&_cityList.count >=row) {
            Tao800AddressCityVo *vo = [_cityList objectAtIndex:row];
            [self changeCity:vo];
        }
    }
    else if (component == AREAPICKERTAG -200)
    {
        if (_areaList&&_areaList.count >=row) {
            Tao800AddressCityVo *vo = [_areaList objectAtIndex:row];
            [self changeArea:vo];
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    //    [self cancelPickerView];
    [_provinceToolBar removeFromSuperview];
    [_provincePickerView removeFromSuperview];
    pickerDefault = 0;
    CGRect rect = self.tableView.frame;
    switch (textField.tag) {
        case PHONETAG:
        {
            rect.origin.y = -20;
        }
            break;
        case ZIPCODETAG:
        {
            rect.origin.y = -40;
        }
            break;
        case PROVINCETAG:
        {
            [self hideKeyboard];
            if (_provinceList == nil || _provinceList.count == 0) {
                return NO;
            }
            pickerDefault = 0;
            [self getDefaultPickLocationProvince];
            [self changeProivce:nil];
            //            [self changeCity:nil];
            rect.origin.y = -60;
            if ([UIScreen mainScreen].bounds.size.height <500) {
                self.tableView.frame = rect;
            }
            return NO;
        }
            break;
        case ADDRESSTAG:
        {
            rect.origin.y = -80;
        }
            break;
        default:
        {
            float statusBarHeight = 0.0f;
            rect.origin.y = statusBarHeight;
        }
            break;
    }
    if ([UIScreen mainScreen].bounds.size.height <500) {
        self.tableView.frame = rect;
    }
    
    return YES;
}

//控制详细地址输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == ADDRESSTAG) {
        if (range.location >99) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboard];
	return YES;
}

#pragma mark - 编辑或保存
- (void)editOrSave
{
    if (self.isLoading) {
        return;
    }
    [self hideKeyboard];
    
    if (_isEdit) {
        NSString *name = [_nameTextField.text trim];
        NSString *province = self.selectProvinceId;
        NSString *provinceName = _selectProvinceName;
        NSString *city = self.selectCityId;
        NSString *cityName = _selectCityName;
        NSString *area = self.selectAreaId;
        NSString *areaName = _selectAreaName;
        NSString *address = [_addressTextField.text trim];
        NSString *phone = [_phoneTextField.text trim];
        NSString *zipcode = [_zipcodeTextField.text trim];
        
        // 保存地址
        if (name.length < 1) {
            [self tipShow:@"提示" detail:@"收货人不能为空"];
            return;
        }
        
        if (phone.length < 1) {
            [self tipShow:@"提示" detail: @"手机号码不能为空"];
            return;
        }
        
        if (zipcode == nil || zipcode.length < 1) {
            [self tipShow:@"提示" detail: @"邮政编码不能为空"];
            return;
        }
        
        if (province.length < 1) {
            [self tipShow:@"提示" detail:@"所在地区不能为空"];
            return;
        }
        if (city.length < 1) {
            [self tipShow:@"提示" detail:@"所在地区不能为空"];
            return;
        }
        
        if (area.length < 1) {
            // 判断区信息是否为空，如果为空传一个空字符串
            if (_areaList.count == 0) {
                area = @"";
            }else {
                [self tipShow:@"提示" detail:@"所在地区不能为空"];
                return;
            }
        }
        
        if (address.length < 1) {
            [self tipShow:@"提示" detail:@"街道地址不能为空"];
            return;
        }
        if (name.length <2||name.length > 16) {
            [self tipShow:@"提示" detail:@"收货人长度2-16字符"];
            return;
        }
        if (phone.length!=11) {
            [self tipShow:@"提示" detail: @"请填写11位有效手机号"];
            return;
        }
        if (zipcode != nil && zipcode.length >=1 &&zipcode.length!=6) {
            [self tipShow:@"提示" detail: @"填写6位有效邮政编码"];
            return;
        }
        
        //        if (address.length > 100) {
        //            [self tipShow:@"提示" detail:@"街道地址太长"];
        //            return;
        //        }
        
        NSString *addressId;
        if (_addressVo.idStr) {
            addressId = _addressVo.idStr;
        }
        else
        {
            addressId = @"";
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"receiver_name",
                             province,@"province_id",provinceName,@"province_name",
                             city,@"city_id",cityName,@"city_name",
                             area,@"county_id",areaName,@"county_name",address,@"address",
                             phone,@"mobile",zipcode,@"post_code",addressId,@"Id",@(_addressVo.isDefault),@"isDefault",nil];
        
        [self addOrEditAddress:dic];
        [self showPopupLoadingView:@"正在保存" fullScreen:YES];
    }
    else if(_addressStyle != AddressEditTypeEdit&&_addressStyle != AddressEditTypeNew){ //信息展示页，点击修改转入信息编辑页
        Tao800AddressListVo *editAddressVo = _addressVo;
        //        editAddressVo.provinceName = @"";
        //        editAddressVo.cityName = @"";
        //        editAddressVo.countyName = @"";
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    editAddressVo,@"addressVo",
                                    @(AddressEditTypeEdit),@"addressStyle",
                                    _addressListVCL,@"addressListVCL",
                                    @"Tao800Address@Tao800AddressDetailCTL" ,TBBForwardSegueIdentifierKey,nil];
        
        [Tao800ForwardSegue ForwardTo:dic sourceController:self];
    }
    else{
        _isEdit = !_isEdit;
        [self updateButtonState];
    }
}

- (BOOL)changeAddressData
{
    NSString *addressArea = [NSString stringWithFormat:@"%@%@%@",_addressVo.provinceName,_addressVo.cityName,_addressVo.countyName];
    if (_addressVo&&[_addressVo.receiverName isEqualToString:_nameTextField.text]
        &&[_addressVo.address isEqualToString:_addressTextField.text]
        &&[_addressVo.mobile isEqualToString:_phoneTextField.text]
        &&[_addressVo.postCode isEqualToString:_zipcodeTextField.text]
        &&addressArea&&[addressArea isEqualToString:_provinceTextField.text]) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)showSaveButtonFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    //按钮
    [self resetButton:@"保  存" selector:@selector(editOrSave) frame:CGRectMake((self.view.width - 300)/2, 65, 300, 40) bottomView:footerView];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - 更新按钮状态
- (void)updateButtonState
{
    if (_isEdit||_addressStyle == 2) {
        //        [_editOrSaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_nameTextField setEnabled:YES];
        [_provinceTextField setEnabled:YES];
        [_addressTextField setEnabled:YES];
        [_phoneTextField setEnabled:YES];
        [_telTextField setEnabled:YES];
        [_zipcodeTextField setEnabled:YES];
        [_nameTextField becomeFirstResponder];
        
        _addressTextField.hidden = NO;
        _addressLabel.hidden = YES;
        _editOrSaveButton.hidden = YES;
        //        self.tableView.tableFooterView.hidden = YES;
        
    }else {
        _editOrSaveButton.hidden = NO;
        [_editOrSaveButton setTitle:@"修改" forState:UIControlStateNormal];
        [_nameTextField setEnabled:NO];
        [_provinceTextField setEnabled:NO];
        [_addressTextField setEnabled:NO];
        [_phoneTextField setEnabled:NO];
        [_telTextField setEnabled:NO];
        [_zipcodeTextField setEnabled:NO];
        //        self.tableView.tableFooterView.hidden = NO;
    }
    
    [self.tableView reloadData];
}


- (void)tipShow:(NSString *)title detail:(NSString *)detail
{
    EFAlertView *tipsTmp = [[EFAlertView alloc] initWithTitle:title
                                                       detail:detail
                                                     delegate:(id)self
                                                        style:EFAlertViewStyleDefault
                                                 buttonTitles:@"确认", nil];
    [tipsTmp.checkBtn addTarget:self action:@selector(alertViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    CGRect detailRect = tipsTmp.detailLabel.frame;
    detailRect.size.width = 280 -10*2;//EFAlertViewContentWidth = 280, //内容区域的宽度  EFAlertViewDetailLeftPadding = 10, //详情距离左侧的宽度
    tipsTmp.detailLabel.frame = detailRect;
    tipsTmp.tag = TipInputAlert;
    tipsTmp.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.tips = tipsTmp;
    [self.tips show];
    
}

-(void)cancelAction: (id)sender
{
    [self.tips show];
}

- (void)EFAlertView:(EFAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.tips) {
        switch (self.tips.tag) {
            case TipInputAlert:
                [self EFAlertViewButtonIndex:buttonIndex withfirst:@selector(cancelAction:) andSecond:@selector(cancelAction:)];
                break;
            case TipDeleteAddress:
                [self EFAlertViewButtonIndex:buttonIndex withfirst:@selector(deleteCurrentAddressRequest) andSecond:@selector(cancelAction:)];
                break;
            default:
                break;
        }
    }
}

- (void)EFAlertViewButtonIndex:(NSInteger)buttonIndex withfirst:(SEL)firstBtn andSecond:(SEL)secondBtn
{
    if (buttonIndex == 0) {
        TB_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:firstBtn withObject:nil]);
    }
    else if (buttonIndex == 1)
    {
        TB_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:secondBtn withObject:nil]);
    }
}

@end
