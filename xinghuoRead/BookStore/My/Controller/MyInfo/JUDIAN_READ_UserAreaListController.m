//
//  JUDIAN_READ_UserAreaListController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAreaListController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserAreaItemCell.h"
#import "JUDIAN_READ_UserAreaModel.h"
#import "JUDIAN_READ_UserSubAreaViewController.h"
#import "JUDIAN_READ_UserCurrentLocationCell.h"
#import "JUDIAN_READ_UserLocationManager.h"

#define UserAreaItemCell @"UserAreaItemCell"
#define UserCurrentLocationCell @"UserCurrentLocationCell"


@interface JUDIAN_READ_UserAreaListController ()
<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSArray* areaArray;
@property(nonatomic, strong)JUDIAN_READ_UserLocationManager* locationManager;
@property(nonatomic, strong)JUDIAN_READ_UserAreaModel* currentLocationModel;
@property(nonatomic, assign)BOOL nextCascade;
@end




@implementation JUDIAN_READ_UserAreaListController


+ (void)enterUserAreaList:(UINavigationController*)navigationController nextCascade:(BOOL)nextCascade {
    
    NSString* key = _AREA_KEY_;
    [NSUserDefaults removeUserDefaults:key];
    
    JUDIAN_READ_UserAreaListController* viewController = [[JUDIAN_READ_UserAreaListController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.nextCascade = nextCascade;
    [navigationController pushViewController:viewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addTableView];
    
    [self loadAreaData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:YES];
    
    [self initLocationManager];
}



- (void)addNavigationView {
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:@"选择地区" rightTitle:@""];
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
    self.title = @"选择地区";
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
    
    [tableView registerClass:[JUDIAN_READ_UserCurrentLocationCell class] forCellReuseIdentifier:UserCurrentLocationCell];
    [tableView registerClass:[JUDIAN_READ_UserAreaItemCell class] forCellReuseIdentifier:UserAreaItemCell];
 
}


- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}


- (void)initLocationManager {
    
    _currentLocationModel = [[JUDIAN_READ_UserAreaModel alloc] init];
    _currentLocationModel.name = @"正在获取位置...";
    _currentLocationModel.code = @"0";
    
    _locationManager = [[JUDIAN_READ_UserLocationManager alloc] init];
    _locationManager.viewController = self;
    
    WeakSelf(that);

    _locationManager.simpleLocationBlock = ^(id  _Nullable arg1, id  _Nullable arg2, id  _Nullable arg3) {
            
            if (arg1 && arg2) {
                that.currentLocationModel.name = [NSString stringWithFormat:@"%@%@%@", arg1, _MIDDLE_CIRCLE_DOT_, arg2];
                that.currentLocationModel.code = [that findCodeWithName:arg1 subArea:arg2];
                
                if (that.nextCascade && arg3) {
                    that.currentLocationModel.name = [that.currentLocationModel.name stringByAppendingString:_MIDDLE_CIRCLE_DOT_];
                    that.currentLocationModel.name = [that.currentLocationModel.name stringByAppendingString:arg3];
                }
                
            }
            else if(arg1) {
                that.currentLocationModel.name = arg1;
                that.currentLocationModel.code = [that findCodeWithName:arg1 subArea:nil];
            }
            
            [that.tableView reloadData];
    };
    
    
    _locationManager.errorLocationBlock = ^(id  _Nullable arg1, id  _Nullable arg2, id  _Nullable arg3) {
        that.currentLocationModel.name = @"获取位置失败";
        that.currentLocationModel.code = @"0";
        [that.tableView reloadData];
    };
    
    [_locationManager startLocationService];

}


- (void)loadAreaData {
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    
    NSError *error = nil;
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    _areaArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserAreaModel class] json:array];
    
    if (!error) {
        [_tableView reloadData];
    }
}



- (NSString*)findCodeWithName:(NSString*)name subArea:(NSString*)subArea {
    
    NSString* cityCode = @"";
    NSArray* subAreaArray = nil;
    
    for (JUDIAN_READ_UserAreaModel* model in _areaArray) {
        if ([model.name isEqualToString:name]) {
            subAreaArray = model.children;
            cityCode = model.code;
            break;
        }
    }
    
  
    for (JUDIAN_READ_UserAreaModel* model in subAreaArray) {
        if ([model.name isEqualToString:subArea]) {
            cityCode = model.code;
            break;
        }
    }
    
    
    return cityCode;
}


#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        JUDIAN_READ_UserCurrentLocationCell* cell = [tableView dequeueReusableCellWithIdentifier:UserCurrentLocationCell];
        [cell updateLocation:_currentLocationModel.name];
        return cell;
    }
    
    
    JUDIAN_READ_UserAreaItemCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAreaItemCell];
    if (_areaArray.count > 0) {
        JUDIAN_READ_UserAreaModel* model = _areaArray[indexPath.row];
        [cell updateArea:model.name isRightArrow:YES];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        return 67;
    }
    return 53;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _areaArray.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (_currentLocationModel.code.integerValue > 0) {
            
            NSString* selctedArea = _currentLocationModel.name;
            
            if (_nextCascade) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addressHandler" object: @{
                                                                                                   @"areaName":selctedArea
                                                                                                   }];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"areaHandler" object: @{
                                                                                                   @"areaName":selctedArea
                                                                                                   }];
            
            
                UIViewController* addressViewController = nil;
                for (UIViewController* element in self.navigationController.viewControllers) {
                    NSString* className = NSStringFromClass([element class]);
                    if ([className isEqualToString:@"JUDIAN_READ_UserBriefViewController"]) {
                        addressViewController = element;
                        break;
                    }
                }
                
                [self.navigationController popToViewController:addressViewController animated:YES];
            }
        }
        
        return;
    }
    
    if (_areaArray.count > 0) {
        JUDIAN_READ_UserAreaModel* model = _areaArray[indexPath.row];
        [JUDIAN_READ_UserSubAreaViewController enterSubAreaViewController:self.navigationController title:model.name data:model.children nextCascade:_nextCascade];
    }

}
@end
