//
//  JUDIAN_READ_UserSubAreaViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserSubAreaViewController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserAreaItemCell.h"
#import "JUDIAN_READ_UserAreaModel.h"


#define UserAreaItemCell @"UserAreaItemCell"


@interface JUDIAN_READ_UserSubAreaViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSArray* areaArray;
@property(nonatomic, copy)NSString* titleText;
@property(nonatomic, assign)BOOL nextCascade;
@end

@implementation JUDIAN_READ_UserSubAreaViewController


+ (void)enterSubAreaViewController:(UINavigationController*)navigationController title:(NSString*)title data:(NSArray*)array nextCascade:(BOOL)nextCascade {
    
    NSString* key = _AREA_KEY_;
    NSString* areaName = [NSUserDefaults getUserDefaults:key];
    if (areaName.length > 0) {
        areaName = [NSString stringWithFormat:@"%@%@%@", areaName,_MIDDLE_CIRCLE_DOT_, title];
        [NSUserDefaults saveUserDefaults:key value:areaName];
    }
    else {
        [NSUserDefaults saveUserDefaults:key value:title];
    }
    
    
    JUDIAN_READ_UserSubAreaViewController* viewController = [[JUDIAN_READ_UserSubAreaViewController alloc] init];
    viewController.areaArray = array;
    viewController.titleText = title;
    viewController.nextCascade = nextCascade;
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
}



- (void)addNavigationView {
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:_titleText rightTitle:@""];
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
    self.title = _titleText;
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
    
    [tableView registerClass:[JUDIAN_READ_UserAreaItemCell class] forCellReuseIdentifier:UserAreaItemCell];
    
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
    
    JUDIAN_READ_UserAreaItemCell* cell = [tableView dequeueReusableCellWithIdentifier:UserAreaItemCell];
    if (_areaArray.count > 0) {
        JUDIAN_READ_UserAreaModel* model = _areaArray[indexPath.row];
        BOOL isRightArrow = (model.children.count > 0) && _nextCascade;
        [cell updateArea:model.name isRightArrow:isRightArrow];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 53;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _areaArray.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_areaArray.count > 0) {
        JUDIAN_READ_UserAreaModel* model = _areaArray[indexPath.row];
        
        if (!_nextCascade) {
            
            NSString* selctedArea = [self getAreaName:model.name];
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
            
            return;
        }
        
        
        if (model.children.count <= 0) {
            NSString* selctedArea = [self getAreaName:model.name];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addressHandler" object: @{
                                                                                                 @"areaName":selctedArea
                                                                                                 }];
            
            UIViewController* addressViewController = nil;
            for (UIViewController* element in self.navigationController.viewControllers) {
                NSString* className = NSStringFromClass([element class]);
                if ([className isEqualToString:@"JUDIAN_READ_UserShippingAddressEditorController"]) {
                    addressViewController = element;
                    break;
                }
            }
            
            [self.navigationController popToViewController:addressViewController animated:YES];

            return;
        }
        [JUDIAN_READ_UserSubAreaViewController enterSubAreaViewController:self.navigationController title:model.name data:model.children nextCascade:TRUE];
    }
    
}



- (NSString*)getAreaName:(NSString*)name {
    
    NSString* key = _AREA_KEY_;
    NSString* areaName = [NSUserDefaults getUserDefaults:key];
    if (areaName.length > 0) {
        areaName = [NSString stringWithFormat:@"%@%@%@", areaName, _MIDDLE_CIRCLE_DOT_, name];
    }
    
    return areaName;
}


- (void)dealloc {
    
    NSString* key = _AREA_KEY_;
    NSString* areaName = [NSUserDefaults getUserDefaults:key];

    NSRange range = [areaName rangeOfString:_MIDDLE_CIRCLE_DOT_ options:(NSBackwardsSearch)];
    if (range.length > 0) {
        areaName = [areaName substringToIndex:range.location];
        [NSUserDefaults saveUserDefaults:key value:areaName];
    }
    else {
        [NSUserDefaults removeUserDefaults:key];
    }

}


@end
