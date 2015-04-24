//
//  Tao800PersonalAddressViewCTL.h
//  tao800
//
//  Created by wuzhiguang on 13-4-9.
//  Copyright (c) 2013年 com.tuan800.tao800iphone. All rights reserved.
//

#import "Tao800TableVCL.h"
#import "Tao800AddressCityVo.h"
#import "Tao800AddressDetailModel.h"
#import "Tao800AddressListVo.h"
#import "Tao800AddressListVCL.h"
#import "EFAlertView.h"

typedef void (^AddAddressCallBack)();

typedef enum AddressEditType {
    AddressEditTypeGeneral = 0,     //地址展示页面，非默认地址
    AddressEditTypeDefault,         //地址展示页面，默认地址
    AddressEditTypeNew,             //地址填写页面，新增地址
    AddressEditTypeEdit,            //地址改写页面，
} AddressEditType;

@interface Tao800PersonalAddressViewCTL : Tao800TableVCL <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,EFAlertViewDelegate>
{
    UITextField *_nameTextField; // 收货人
    UITextField *_provinceTextField; // 省份
    UITextField *_addressTextField; // 详细地址
    UILabel *_addressLabel; // 详细地址
    UITextField *_phoneTextField; // 手机号码
    UITextField *_telTextField; // 电话号码
    UITextField *_zipcodeTextField; // 邮政编码
    
    BOOL _isEdit; // 是否是编辑状态
    UIButton *_editOrSaveButton; // 编辑或保存按钮
    
    AddressEditType _addressStyle; // 编辑种类：0、一般；1、默认地址；2、新增地址
    BOOL isNewAddress; // 是否新增地址
    Tao800AddressListVo *_addressVo;
    Tao800AddressCityVo *_blankAddressVo;
    
    NSMutableArray *_addressCityList;
    NSMutableArray *_provinceList;
    NSMutableArray *_cityList;
    NSMutableArray *_areaList;
    
    NSString *_selectProvinceId;
    NSString *_selectCityId;
    NSString *_selectAreaId;
    NSString *_selectProvinceName;
    NSString *_selectCityName;
    NSString *_selectAreaName;
    
    UIPickerView *_provincePickerView;
    UIToolbar *_provinceToolBar;
    
    EFAlertView *_tips;
}

@property (nonatomic,strong) NSMutableArray *addressCityList;
@property (atomic,strong) NSMutableArray *provinceList;
@property (atomic,strong) NSMutableArray *cityList;
@property (atomic,strong) NSMutableArray *areaList;
@property (nonatomic,strong) NSString *selectProvinceId;
@property (nonatomic,strong) NSString *selectCityId;
@property (nonatomic,strong) NSString *selectAreaId;
@property (nonatomic,strong) UIToolbar *provinceToolBar;
@property (nonatomic,strong) UIToolbar *cityToolBar;
@property (nonatomic,strong) UIToolbar *areaToolBar;
@property (nonatomic,strong) EFAlertView *tips;
@property (nonatomic, copy)  AddAddressCallBack addAddressallBack;

@end
