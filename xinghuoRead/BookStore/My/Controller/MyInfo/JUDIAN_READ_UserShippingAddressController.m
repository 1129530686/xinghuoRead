//
//  JUDIAN_READ_UserShippingAddressController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserShippingAddressController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserAppendAddressCell.h"
#import "JUDIAN_READ_UserShippingAddressEditorController.h"
#import "JUDIAN_READ_UserBriefViewModel.h"


#define UserAppendAddressCell @"UserAppendAddressCell"
#define UserEditedAddressCell @"UserEditedAddressCell"


@interface JUDIAN_READ_UserShippingAddressController ()
<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSArray* addressArray;
@property(nonatomic, copy)modelBlock block;
@end

@implementation JUDIAN_READ_UserShippingAddressController


+ (void)enterShippingAddresssController:(UINavigationController*)navigationController block:(modelBlock)block{
    
    JUDIAN_READ_UserShippingAddressController* viewController = [[JUDIAN_READ_UserShippingAddressController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.block = block;
    [navigationController pushViewController:viewController animated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addTableView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:YES];
    
    WeakSelf(that);
    [JUDIAN_READ_UserDeliveryAddressModel buildDeliveryAddressModel:^(id  _Nullable args) {
        that.addressArray = args;
        [that.tableView reloadData];
    }];
}



- (void)addNavigationView {
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:@"收货地址" rightTitle:@""];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            
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
    self.title = @"收货地址";
    
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
    
    [tableView registerClass:[JUDIAN_READ_UserAppendAddressCell class] forCellReuseIdentifier:UserAppendAddressCell];
    [tableView registerClass:[JUDIAN_READ_UserEditedAddressCell class] forCellReuseIdentifier:UserEditedAddressCell];
    
    
}


- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}




#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        JUDIAN_READ_UserEditedAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:UserEditedAddressCell];
        if (_addressArray.count > 0) {
            [cell updateCell:_addressArray[indexPath.row]];
        }
        return cell;
    }
    
    JUDIAN_READ_UserAppendAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAppendAddressCell];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        return 66;
    }
    
    return 53;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _addressArray.count;
    }
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [JUDIAN_READ_UserShippingAddressEditorController enterShippingAddresssEditor:self.navigationController model:nil block:nil];
    }
    else {
        if (_addressArray.count > 0) {
            if (_block) {
                
                JUDIAN_READ_UserDeliveryAddressModel* model = _addressArray[indexPath.row];
                NSString* address = [NSString stringWithFormat:@"%@%@%@%@", model.privince, model.city, model.area, model.detailed_addr];
                NSDictionary* dictionary = @{
                  @"name" : model.user_name,
                  @"tel" : model.phone_no,
                  @"adress" : address
                  };
                _block(dictionary);
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                JUDIAN_READ_UserDeliveryAddressModel* model = _addressArray[indexPath.row];
                [JUDIAN_READ_UserShippingAddressEditorController enterShippingAddresssEditor:self.navigationController model:model block:nil];
            }
        }
    }
    
}



@end
