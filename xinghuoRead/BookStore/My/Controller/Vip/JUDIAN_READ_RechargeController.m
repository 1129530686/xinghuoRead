//
//  JUDIAN_READ_VipController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_RechargeController.h"
#import "JUDIAN_READ_SearchColCell.h"
#import "JUDIAN_READ_MyTool.h"
#import "NSUserDefaults+JUDIAN_READ_UserDefaults.h"
#import "JUDIAN_READ_IAPShare.h"
#import "JUDIAN_READ_PayTypeController.h"
#import "JUDIAN_READ_VipModel.h"
#import "JUDIAN_READ_BuyRecordController.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_VipColCell.h"

#define headimageHeight   (Height_NavBar + 60) //头部视图的高度

@interface JUDIAN_READ_RechargeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
@property (nonatomic,strong) JUDIAN_READ_VipModel *info;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) UICollectionView  *colView;
@property (nonatomic,strong) UIButton  *btn;




@end

@implementation JUDIAN_READ_RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    [self.view addSubview:self.colView];
    [self addWarmTipView];
    [self loadData];
}

#pragma mark  网络请求
- (void)loadData{
    [JUDIAN_READ_MyTool getChargeTypeWithParams:@{@"type":@"ios"} completionBlock:^(id result, id error) {
        if (result) {
            self.dataArr = result;
            self.info = self.dataArr.count >= 2 ? self.dataArr[1] : self.dataArr.firstObject;
            self.info.isSelected = YES;
            [self.view addSubview:self.btn];

        }
        [self.colView reloadData];
    }];
}


#pragma mark 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIButton *)btn{
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, Height_Content-50, SCREEN_WIDTH, 50);
        [btn setText:@"提交" titleFontSize:16 titleColot:kColorWhite];
        [btn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay2_sel"] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = NO;
        _btn = btn;
    }
    return _btn;
}


- (UICollectionView *)colView{
    if (!_colView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (SCREEN_WIDTH-15*4)/3;
        layout.itemSize = CGSizeMake(width, 0.69*width);
        layout.minimumLineSpacing = 17;
        layout.minimumInteritemSpacing = 15;
        _colView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.57*width*2+17+16) collectionViewLayout:layout];
        _colView.showsVerticalScrollIndicator = NO;
        _colView.delegate = self;
        _colView.dataSource = self;
        _colView.backgroundColor = kColorWhite;
        [_colView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_VipColCell" bundle:nil] forCellWithReuseIdentifier:@"JUDIAN_READ_VipColCell"];
    }
    return _colView;
}


- (void)addWarmTipView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setText:@"设置我的支付方式" titleFontSize:12 titleColot:kThemeColor];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn addTarget:self action:@selector(payType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    WeakSelf(that);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(15);
        make.right.equalTo(that.view.mas_right).offset(-15);
        make.top.equalTo(that.colView.mas_bottom).offset(22);
        make.height.equalTo(@(14));
    }];
    
    UITextView* warmTipView = [[UITextView alloc]init];
    warmTipView.editable = NO;
    warmTipView.scrollEnabled = NO;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic = @{NSFontAttributeName:kFontSize12,NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:kColor153};
    NSString *str = @"温馨提示：\n1.iOS端购买的点只能在追书宝iOS客户端内使用；\n2.您的历史充值记录，可在充值记录中查看；\n3.如有其他疑问，请加客服QQ群：612489895;\n\n\n";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str attributes:dic];
    NSRange rang1 = [str rangeOfString:@"充值记录" options:NSBackwardsSearch];
    [attributeStr addAttributes:@{NSLinkAttributeName:@"record"} range:rang1];
    warmTipView.linkTextAttributes = @{NSForegroundColorAttributeName:kThemeColor};
    paraStyle.lineSpacing = 5;
    warmTipView.attributedText = attributeStr;
    warmTipView.delegate = self;
    [self.view addSubview:warmTipView];
    
    NSInteger height = 140;
    height = ceil(height);
    
    [warmTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(10);
        make.right.equalTo(that.view.mas_right).offset(-10);
        make.top.equalTo(btn.mas_bottom).offset(22);
        make.height.equalTo(@(height));
    }];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    [self buyRecord];
    return NO;
}

#pragma mark colView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_VipColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_VipColCell" forIndexPath:indexPath];
    [cell setRechageDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    for (JUDIAN_READ_VipModel *info in self.dataArr) {
        info.isSelected = NO;
    }
    self.info = self.dataArr[indexPath.row];
    self.info.isSelected = YES;
    [self.colView reloadData];
//    [self goToPay];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(14, 15, 0, 15);
}

//设置支付方式
- (void)payType{
    JUDIAN_READ_PayTypeController *vc = [JUDIAN_READ_PayTypeController new];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)buyRecord{
    JUDIAN_READ_BuyRecordController *vc = [JUDIAN_READ_BuyRecordController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}



//会员购买
- (void)goToPay{
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{click_pay : @"点击去支付按钮",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    [MobClick event:payRecord attributes:dictionary];
    
    [self charge];

}




#pragma mark 支付
- (void)charge{
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    if (!self.info.title) {
        self.info.title = @"";
    }
    if (!self.info.ID) {
        [MBProgressHUD showMessage:@"产品不能为空"];
        return;
    }
    
    NSDictionary* dictionary = @{click_pay_confirm : @"确认支付按钮",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    [MobClick event:payRecord attributes:dictionary];
    
    if ([JUDIAN_READ_Account currentAccount].token) {
        NSDictionary *dic = @{@"recharge_id":self.info.ID,@"payment_category":@"iap",@"type":@"ios"};
        WeakSelf(that);
        [JUDIAN_READ_MyTool createOrderWithParams:dic completionBlock:^(id result, id error) {
            if (result) {
                [MBProgressHUD showPayLoading];
                [that launchIap:result];
            }
        }];
    }else{
        [MBProgressHUD showPayLoading];
        [self launchIapForAppstore:self.info.ID];
    }
    
    
    
}



#pragma mark appstore验证

- (void)launchIapForAppstore:(NSString*)index {
    
    NSString* productIdentifier = @"";
    
    if ([index isEqualToString:@"1"]) {
        productIdentifier = @"com.szjudian.zhuishubao.viphuangjin";
    }
    else if([index isEqualToString:@"2"]) {
        productIdentifier = @"com.szjudian.zhuishubao.vipbojin";
    }
    else {
        productIdentifier = @"com.szjudian.zhuishubao.vipzuanshi";
    }
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productIdentifier, nil];
    [JUDIAN_READ_IAPShare sharedHelper].iap = [[JUDIAN_READ_IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#if _IS_RELEASE_VERSION_ == 1
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = YES;
#else
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = NO;
#endif
    
    WeakSelf(that);
    [[JUDIAN_READ_IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response && [JUDIAN_READ_IAPShare sharedHelper].iap.products.count > 0) {
             
             SKProduct* product =[[JUDIAN_READ_IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             [[JUDIAN_READ_IAPShare sharedHelper].iap buyProduct:product
                                                    onCompletion:^(SKPaymentTransaction* trans){
                                                        
                                                        if(trans.error)
                                                        {
                                                            [that payFailure];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                            
                                                            NSData* appstoreData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                            [[JUDIAN_READ_IAPShare sharedHelper].iap checkReceipt:appstoreData onCompletion:^(NSString *response, NSError *error) {
                                                                
                                                                //Convert JSON String to NSDictionary
                                                                NSDictionary* rec = [JUDIAN_READ_IAPShare toJSON:response];
                                                                if([rec[@"status"] integerValue] == 0)
                                                                {
                                                                    [[JUDIAN_READ_IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                                                    [that paySuccessForAppstore];
                                                                }
                                                                else if([rec[@"status"] integerValue] == 21007) {
                                                                    [that paySuccessForAppstore];
                                                                }
                                                                else {
                                                                    [that payFailure];
                                                                }
                                                            }];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                            [that payFailure];
                                                        }
                                                    }];
         }
         else {
             [that payFailure];
         }
         
     }];
    
}


- (void)paySuccessForAppstore {
    
    [MBProgressHUD hideHUDForView:kKeyWindow];
    [MBProgressHUD showMessage:@"购买成功"];
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{pay_success : @"支付成功",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    
    [MobClick event:payRecord attributes:dictionary];
    
    
    //KeychainUUID *keychain = [[KeychainUUID alloc]init];
    //id tid = [keychain readUDID];
    //[NSUserDefaults saveUserDefaults:tid value:self.info.ID];
    
    
//    NSString* keyName = @"buyRecords";
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *mutableArray = [[userDefaults objectForKey:keyName] mutableCopy];
//    if (!mutableArray) {
//        mutableArray = [NSMutableArray array];
//    }
    
    
    NSString* vipName = @"";
    NSString* vipPrice = @"";
    NSString* vipTime = [self getNowString];
    NSString *bookCounts = @"0";
    if ([self.info.ID isEqualToString:@"1"]) {
        vipName = @"黄金会员";
        vipPrice = @"8";
        bookCounts = @"30";
    }
    else if ([self.info.ID isEqualToString:@"2"]) {
        vipName = @"白金会员";
        vipPrice = @"40";
        bookCounts = @"200";
    }
    else if ([self.info.ID isEqualToString:@"3"]) {
        vipName = @"钻石会员";
        vipPrice = @"88";
        bookCounts = @"800";
    }
    
    NSDictionary* history = @{
                              @"vip_type_name" : vipName,
                              @"create_time" : vipTime,
                              @"vip_type_price" : vipPrice,
                              };
//    [mutableArray addObject:history];
//    [userDefaults setObject:mutableArray forKey:keyName];
    
    
    //1.1 token为假
    JUDIAN_READ_Account *acc = [JUDIAN_READ_Account currentAccount];
    if (!acc.token) {
        if (!self.info.ID) {
            self.info.ID = @"";
        }
        NSString *type = @"";
        if (acc.vip_type.intValue > self.info.ID.intValue) {
            type = acc.vip_type;
        }else{
            type = self.info.ID;
        }
        NSDictionary *dic = @{@"vip_type":type,@"fiction_num":bookCounts};
        [self requestGuestInfo:dic];
    }
}

- (void)requestGuestInfo:(NSDictionary *)dic{
    
    [JUDIAN_READ_MyTool uploadVipStatusWithParams:dic completionBlock:^(id result, id error) {
    }];
}


-(NSString*) getNowString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}



#pragma mark服务端验证
- (void)launchIap:(NSDictionary*) result {
    
    NSString* productIdentifier = result[@"appstroe_pid"];
    NSString* orderId = result[@"trade_no"];
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productIdentifier, nil];
    [JUDIAN_READ_IAPShare sharedHelper].iap = [[JUDIAN_READ_IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#if _IS_RELEASE_VERSION_ == 1
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = YES;
#else
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = NO;
#endif
    
    WeakSelf(that);
    [[JUDIAN_READ_IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response && [JUDIAN_READ_IAPShare sharedHelper].iap.products.count > 0) {
             
             SKProduct* product =[[JUDIAN_READ_IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             [[JUDIAN_READ_IAPShare sharedHelper].iap buyProduct:product
                                                    onCompletion:^(SKPaymentTransaction* trans){
                                                        
                                                        if(trans.error)
                                                        {
                                                            [that payFailure];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                            
                                                            NSData* appstoreData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                            NSString* receipt = [appstoreData base64EncodedStringWithOptions:0];
                                                            
                                                            NSString* path = [[JUDIAN_READ_IAPShare sharedHelper] getChargeFilePath:orderId];
                                                            [receipt writeToFile:path atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
                                                            
                                                            [JUDIAN_READ_UserReadingModel addChargeHistory:orderId type:@"1"];
                                                            
                                                            [that verifyOrder:orderId receipt:receipt];
                                                            
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                            [that payFailure];
                                                        }
                                                    }];
         }
         else {
             [that payFailure];
         }
         
     }];
    
}



- (void)payFailure {
    [MBProgressHUD hideHUDForView:kKeyWindow];
    [MBProgressHUD showMessage:@"购买失败"];
}



- (void)paySuccess {
    
    [MBProgressHUD hideHUDForView:kKeyWindow];
    [MBProgressHUD showMessage:@"购买成功"];
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{pay_success :  @"支付成功",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    
    [MobClick event:payRecord attributes:dictionary];
    
}



- (void)verifyOrder:(NSString*)orderId receipt:(NSString*)receipt {
    
    if (!orderId || !receipt) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"trade_no" : orderId,
                                 @"type" : @"ios",
                                 @"receipt" : receipt
                                 };
    WeakSelf(that);
    [JUDIAN_READ_MyTool updateAppPayWithParams:dictionary completionBlock:^(id result, id error) {
        
        [[JUDIAN_READ_IAPShare sharedHelper] deleteChargeFile:orderId];
        [JUDIAN_READ_UserReadingModel deleteChargeHistory:orderId];
        
        if (result) {
            [that paySuccess];
        }
        else {
            [that payFailure];
        }
    }];
    
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
