//
//  JUDIAN_READ_UserShippingAddressEditorController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserShippingAddressEditorController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserAddressEditorCell.h"
#import "JUDIAN_READ_UserAreaListController.h"
#import "JUDIAN_READ_UserBriefEmptyCell.h"

#define UserAddressEditorCell @"UserAddressEditorCell"
#define UserAddressChoiceCell @"UserAddressChoiceCell"
#define UserAddressDetailCell @"UserAddressDetailCell"
#define UserAddressDefaultCell @"UserAddressDefaultCell"
#define UserBriefEmptyCell @"UserBriefEmptyCell"


@interface JUDIAN_READ_UserShippingAddressEditorController ()
<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSString* selectedAddress;
@property(nonatomic, strong)JUDIAN_READ_UserDeliveryAddressModel* addressModel;
@property(nonatomic, assign)BOOL isEditState;
@property(nonatomic, weak)JUDIAN_READ_UserAddressEditorCell* userNameCell;
@property(nonatomic, weak)JUDIAN_READ_UserAddressEditorCell* userPhoneCell;
@property(nonatomic, weak)JUDIAN_READ_UserAddressDetailCell* detailCell;
@property(nonatomic, weak)JUDIAN_READ_UserAddressDefaultCell* defaultAddressSwitchCell;
@property(nonatomic, copy)modelBlock block;
@end

@implementation JUDIAN_READ_UserShippingAddressEditorController

+ (void)enterShippingAddresssEditor:(UINavigationController*)navigationController model:(JUDIAN_READ_UserDeliveryAddressModel*)model block:(_Nullable modelBlock)block{
    
    JUDIAN_READ_UserShippingAddressEditorController* viewController = [[JUDIAN_READ_UserShippingAddressEditorController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.addressModel = model;
    viewController.block = block;
    [navigationController pushViewController:viewController animated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAddressModel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectArea:) name:@"addressHandler" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self updateAddressModel];
}



- (void)addNavigationView {
    
    NSString* title = @"添加收货地址";
    if (_isEditState) {
        title = @"编辑收货地址";
    }
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:title rightTitle:@"保存"];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            [that saveAddress];
        }
    };
    
    CGFloat height = 64;
    if (iPhoneX) {
        height = 88;
    }
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.height.equalTo(@(height));
    }];
#endif
    self.title = title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveAddress)];
}



- (void)addTableView {
    
    NSInteger navigationHeight = [self getNavigationHeight];
    NSInteger yPosition = 0;
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger height = SCREEN_HEIGHT - navigationHeight - bottomOffset;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_UserAddressDetailCell class] forCellReuseIdentifier:UserAddressDetailCell];
    [tableView registerClass:[JUDIAN_READ_UserAddressChoiceCell class] forCellReuseIdentifier:UserAddressChoiceCell];
    [tableView registerClass:[JUDIAN_READ_UserAddressEditorCell class] forCellReuseIdentifier:UserAddressEditorCell];
    [tableView registerClass:[JUDIAN_READ_UserAddressDefaultCell class] forCellReuseIdentifier:UserAddressDefaultCell];
    [tableView registerClass:[JUDIAN_READ_UserBriefEmptyCell class] forCellReuseIdentifier:UserBriefEmptyCell];
}


- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}


- (void)initAddressModel {
    
    _isEditState = TRUE;
    
    NSString* privince = _addressModel.privince;
    NSString* city = _addressModel.city;
    
    if (privince.length <= 0) {
        privince = @"";
    }
    
    if (city.length <= 0) {
        city = @"";
    }
    

    if (!_addressModel) {
        _addressModel = [[JUDIAN_READ_UserDeliveryAddressModel alloc] init];
        _isEditState = FALSE;
    }
    else {
        if (_addressModel.area.length > 0) {
            _selectedAddress = @"";
            _selectedAddress = [_selectedAddress stringByAppendingString:_addressModel.privince];
            _selectedAddress = [_selectedAddress stringByAppendingString:_MIDDLE_CIRCLE_DOT_];
            _selectedAddress = [_selectedAddress stringByAppendingString:_addressModel.city];
            _selectedAddress = [_selectedAddress stringByAppendingString:_MIDDLE_CIRCLE_DOT_];
            _selectedAddress = [_selectedAddress stringByAppendingString:_addressModel.area];
        }
        else {
            _selectedAddress = @"";
            _selectedAddress = [_selectedAddress stringByAppendingString:_addressModel.privince];
            _selectedAddress = [_selectedAddress stringByAppendingString:_MIDDLE_CIRCLE_DOT_];
            _selectedAddress = [_selectedAddress stringByAppendingString:_addressModel.city];
        }
    }
    
}





#pragma mark 选择地区
- (void)selectArea:(NSNotification*)obj {
    _selectedAddress = obj.object[@"areaName"];
    NSArray* array = [_selectedAddress componentsSeparatedByString:_MIDDLE_CIRCLE_DOT_];
    if (array.count > 1) {
        _addressModel.privince = array[0];
        _addressModel.city = array[1];
    }
    
    if (array.count > 2) {
        _addressModel.area = array[2];
    }
    
    [self.tableView reloadData];
}

#pragma mark 保存
- (void)saveAddress {
    
    [self updateAddressModel];

    if (_addressModel.user_name.length <= 0) {
        [MBProgressHUD showMessage:@"请输入收货人姓名"];
        return;
    }
    
    BOOL isMobile = [JUDIAN_READ_TestHelper isMobileNumber:_addressModel.phone_no];
    if (!isMobile) {
        [MBProgressHUD showMessage:@"非法手机号码"];
        return;
    }
    
    if (_addressModel.privince.length <= 0 || _addressModel.city.length <= 0 || _addressModel.area.length <= 0) {
        [MBProgressHUD showMessage:@"请选择所在地区"];
        return;
    }
    
    if (_addressModel.detailed_addr.length <= 0) {
        [MBProgressHUD showMessage:@"请输入详细地址"];
        return;
    }
    
    if (_block) {//对h5页面里的地址，进行编辑
        JUDIAN_READ_UserDeliveryAddressModel* model = _addressModel;
        
        if (model.privince.length <= 0) {
            model.privince = @"";
        }
        
        if (model.city.length <= 0) {
            model.city = @"";
        }
        
        if (model.area.length <= 0) {
            model.area = @"";
        }
        
        NSString* address = [NSString stringWithFormat:@"%@%@%@%@", model.privince, model.city, model.area, model.detailed_addr];
        NSDictionary* dictionary = @{
                                     @"name" : model.user_name,
                                     @"tel" : model.phone_no,
                                     @"adress" : address
                                     };
        _block(dictionary);
        //[self.navigationController popViewControllerAnimated:YES];
        //return;
    }
    

    
    WeakSelf(that);
    [_addressModel saveDeliveryAddress:^(id  _Nullable args) {
        [that.navigationController popViewControllerAnimated:YES];
    } isAdd:!_isEditState];
    
}


- (void)updateAddressModel {
    
    _addressModel.user_name = [_userNameCell getEditorText];
    _addressModel.phone_no = [_userPhoneCell getEditorText];
    _addressModel.default_addr = @([_defaultAddressSwitchCell getDefaultState]);
    _addressModel.detailed_addr = [_detailCell getEditorText];
    _addressModel.uid_b = [JUDIAN_READ_Account currentAccount].uid;
    
}


#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* tableViewCell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JUDIAN_READ_UserAddressEditorCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAddressEditorCell];
            _userNameCell = cell;
            [cell updateCell:_addressModel.user_name placeholder:@"收货人姓名" type:UIKeyboardTypeDefault];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }
        else if (indexPath.row == 1) {
            JUDIAN_READ_UserAddressEditorCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAddressEditorCell];
            _userPhoneCell = cell;
            [cell updateCell:_addressModel.phone_no placeholder:@"手机号码" type:UIKeyboardTypePhonePad];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }
        else if (indexPath.row == 2){
            JUDIAN_READ_UserAddressChoiceCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAddressChoiceCell];
            [cell updateCell:_selectedAddress placeholder:@"所在地区"];
            cell.rightArrowImageView.hidden = YES;
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            tableViewCell = cell;
        }
        else {
            JUDIAN_READ_UserAddressDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAddressDetailCell];
            _detailCell = cell;
            [cell updateCell:_addressModel.detailed_addr placeholder:@"详细地址：如道路、门牌号、小区、楼栋号"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }
        
        return tableViewCell;
    }
    else if (indexPath.section == 1){
        JUDIAN_READ_UserAddressDefaultCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAddressDefaultCell];
        [cell updateCell:_addressModel.default_addr.integerValue];
        _defaultAddressSwitchCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        
        if (indexPath.row == 0) {
            JUDIAN_READ_UserBriefEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:UserBriefEmptyCell];
            return cell;
        }

        JUDIAN_READ_UserAddressChoiceCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAddressChoiceCell];
        [cell updateCell:@"删除收货地址" placeholder:@""];
        cell.rightArrowImageView.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 73;
        }
        return 53;
    }
    
    if (indexPath.section == 1) {
        return 53;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 10;
        }
        return 53;
    }
    
    return 0;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    
    if (section == 1) {
        return 1;
    }
    
    if (section == 2) {
        return 2;
    }
    
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isEditState) {
        return 3;
    }
    
    return 2;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        [JUDIAN_READ_UserAreaListController enterUserAreaList:self.navigationController nextCascade:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        WeakSelf(that);
        [_addressModel deleteAddress:^(id  _Nullable args) {
            //[MBProgressHUD showMessage:@"删除成功"];
            [that.navigationController popViewControllerAnimated:YES];
        }];
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#if 0
uitextview.frame = (0,0,320,416);

uibutton.frame = (310,0,10,10);
[uibutton setimage:@"cross.png" forcontrolstate:uicontrolstatenoraml];
[uibutton addTarget:self action:@selector(clearButtonSelected:) forControlEvents:UIControlEventTouchUpInside];

-(void)clearButtonSelected{
    uitextview=@"";
}
#endif


@end
