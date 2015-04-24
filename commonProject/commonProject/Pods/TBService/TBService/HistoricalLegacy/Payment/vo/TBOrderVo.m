//
// Created by enfeng on 12-8-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TBOrderVo.h"


@implementation TBOrderVo {

}
@synthesize productName = _productName;
@synthesize payTime = _payTime;
@synthesize mobile = _mobile;
@synthesize createTime = _createTime;
@synthesize supplier = _supplier;
@synthesize msg = _msg;
@synthesize url = _url;
@synthesize code = _code;
@synthesize siteOrderNO = _siteOrderNO;
@synthesize expireTime = _expireTime;
@synthesize payment = _payment;
@synthesize couponPrice = _couponPrice;
@synthesize total = _total;
@synthesize productNum = _productNum;
@synthesize payMethod = _payMethod;
@synthesize productPrice = _productPrice;
@synthesize orderStatus = _orderStatus;
@synthesize orderProcess = _orderProcess;
@synthesize orderType = _orderType;
@synthesize ret = _ret;
@synthesize orderNo = _orderNo;
@synthesize cue = _cue;
@synthesize tel = _tel;
@synthesize orderProcessDesc = _orderProcessDesc;
@synthesize daiGouType = _daiGouType;
@synthesize imageUrl = _imageUrl;
@synthesize productPackageId = _productPackageId;
@synthesize productPackageName = _productPackageName;
@synthesize productPackagePrice = _productPackagePrice;
@synthesize refundDescription = _refundDescription;
@synthesize isRefund = _isRefund;
@synthesize refundUrl = _refundUrl;
@synthesize wpUrl = _wpUrl;
@synthesize clientMarkUsed = _clientMarkUsed;
@synthesize dealId = _dealId;
@synthesize shopId = _shopId;

- (void)dealloc {
 
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.orderNo = [coder decodeObjectForKey:@"orderNo"];
        self.productName = [coder decodeObjectForKey:@"productName"];
        self.payTime = [coder decodeObjectForKey:@"payTime"];
        self.productPrice = [coder decodeDoubleForKey:@"productPrice"];
        self.productNum = [coder decodeIntForKey:@"productNum"];
        self.payMethod = (TBPayMethodFlag) [coder decodeIntForKey:@"payMethod"];
        self.total = [coder decodeDoubleForKey:@"total"];
        self.payment = [coder decodeDoubleForKey:@"payment"];
        self.mobile = [coder decodeObjectForKey:@"mobile"];
        self.couponPrice = [coder decodeDoubleForKey:@"couponPrice"];
        self.createTime = [coder decodeObjectForKey:@"createTime"];
        self.supplier = [coder decodeObjectForKey:@"supplier"];
        self.orderStatus = (TBOrderStatus) [coder decodeIntForKey:@"orderStatus"];
        self.orderProcess = (TBOrderProcess) [coder decodeIntForKey:@"orderProcess"];
        self.ret = (TBOrderResult) [coder decodeIntForKey:@"ret"];
        self.msg = [coder decodeObjectForKey:@"msg"];
        self.orderType = (TBOrderType) [coder decodeIntForKey:@"orderType"];
        self.url = [coder decodeObjectForKey:@"url"];
        self.code = [coder decodeObjectForKey:@"code"];
        self.siteOrderNO = [coder decodeObjectForKey:@"siteOrderNO"];
        self.expireTime = [coder decodeObjectForKey:@"expireTime"];
        self.cue = [coder decodeObjectForKey:@"cue"];
        self.tel = [coder decodeObjectForKey:@"tel"];
        self.orderProcessDesc = [coder decodeObjectForKey:@"orderProcessDesc"];
        self.daiGouType = (TBOrderDaiGouType) [coder decodeIntForKey:@"daiGouType"];
        self.imageUrl = [coder decodeObjectForKey:@"imageUrl"];
        self.productPackageId = [coder decodeObjectForKey:@"productPackageId"];
        self.productPackageName = [coder decodeObjectForKey:@"productPackageName"];
        self.productPackagePrice = [coder decodeObjectForKey:@"productPackagePrice"];
        self.refundDescription = [coder decodeObjectForKey:@"refundDescription"];
        self.isRefund = [coder decodeBoolForKey:@"isRefund"];
        self.refundUrl = [coder decodeObjectForKey:@"refundUrl"];
        self.wpUrl = [coder decodeObjectForKey:@"wpUrl"];
        self.clientMarkUsed = [coder decodeBoolForKey:@"clientMarkUsed"];
        self.dealId = [coder decodeObjectForKey:@"dealId"];
        self.shopId = [coder decodeObjectForKey:@"shopId"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.orderNo forKey:@"orderNo"];
    [coder encodeObject:self.productName forKey:@"productName"];
    [coder encodeObject:self.payTime forKey:@"payTime"];
    [coder encodeDouble:self.productPrice forKey:@"productPrice"];
    [coder encodeInt:self.productNum forKey:@"productNum"];
    [coder encodeInt:self.payMethod forKey:@"payMethod"];
    [coder encodeDouble:self.total forKey:@"total"];
    [coder encodeDouble:self.payment forKey:@"payment"];
    [coder encodeObject:self.mobile forKey:@"mobile"];
    [coder encodeDouble:self.couponPrice forKey:@"couponPrice"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
    [coder encodeObject:self.supplier forKey:@"supplier"];
    [coder encodeInt:self.orderStatus forKey:@"orderStatus"];
    [coder encodeInt:self.orderProcess forKey:@"orderProcess"];
    [coder encodeInt:self.ret forKey:@"ret"];
    [coder encodeObject:self.msg forKey:@"msg"];
    [coder encodeInt:self.orderType forKey:@"orderType"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.code forKey:@"code"];
    [coder encodeObject:self.siteOrderNO forKey:@"siteOrderNO"];
    [coder encodeObject:self.expireTime forKey:@"expireTime"];
    [coder encodeObject:self.cue forKey:@"cue"];
    [coder encodeObject:self.tel forKey:@"tel"];
    [coder encodeObject:self.orderProcessDesc forKey:@"orderProcessDesc"];
    [coder encodeInt:self.daiGouType forKey:@"daiGouType"];
    [coder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [coder encodeObject:self.productPackageId forKey:@"productPackageId"];
    [coder encodeObject:self.productPackageName forKey:@"productPackageName"];
    [coder encodeObject:self.productPackagePrice forKey:@"productPackagePrice"];
    [coder encodeObject:self.refundDescription forKey:@"refundDescription"];
    [coder encodeBool:self.isRefund forKey:@"isRefund"];
    [coder encodeObject:self.refundUrl forKey:@"refundUrl"];
    [coder encodeObject:self.wpUrl forKey:@"wpUrl"];
    [coder encodeBool:self.clientMarkUsed forKey:@"clientMarkUsed"];
    [coder encodeObject:self.dealId forKey:@"dealId"];
    [coder encodeObject:self.shopId forKey:@"shopId"];
}


@end