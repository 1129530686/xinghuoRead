//
//  JUDIAN_READ_AbstractViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AbstractViewController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"

@interface JUDIAN_READ_AbstractViewController ()

@end

@implementation JUDIAN_READ_AbstractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"BadNet" object:nil];
    
}


- (void)addNavigationView {
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:@" " rightTitle:@""];
    [_noDataView addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [self popupWhenNetworkError];
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
        make.left.equalTo(that.noDataView.mas_left);
        make.right.equalTo(that.noDataView.mas_right);
        make.top.equalTo(that.noDataView.mas_top);
        make.height.equalTo(@(height));
    }];
    
}


- (void)showTipView:(NoDataTypeEnum)type {
 
    [_noDataView removeFromSuperview];

    BOOL showButton = NO;
    NSString* noDataTip = @"";
    UIImage* image = nil;
    
    if (type == kNetworkError) {
        showButton = YES;
        noDataTip = APP_NO_NETWORK_TIP;
        image = [UIImage imageNamed:@"default_wifi"];
    }
    else if(type == kNoHistory) {
        noDataTip = APP_NO_RECORD_TIP;
        image = [UIImage imageNamed:@"default_no_record"];
    }
    else if(type == kNoUserContribution) {
        noDataTip = APP_NO_RECORD_TIP;
        image = [UIImage imageNamed:@"default_no_record"];
    }
    else {
        noDataTip = APP_NO_RECORD_TIP;
        image = [UIImage imageNamed:@"default_no_data"];
    }
    
    UIControl* emptyView = [[UIControl alloc] init];
    _noDataView = emptyView;
    emptyView.backgroundColor = [UIColor whiteColor];
    //emptyView.layer.zPosition = EMPTY_VIEW_Z_POSITION;
    [self.view addSubview:emptyView];
    
 
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [emptyView addSubview:imageView];

    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = RGB(0x66, 0x66, 0x66);
    tipLabel.text = noDataTip;
    [emptyView addSubview:tipLabel];
    

    UIButton* actionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage* buttonImage = [UIImage imageNamed:@"default_button_reload"];
    [actionButton setBackgroundImage:buttonImage forState:(UIControlStateNormal)];
    [actionButton addTarget:self action:@selector(refreshData) forControlEvents:(UIControlEventTouchUpInside)];
    [emptyView addSubview:actionButton];
    actionButton.hidden = !showButton;
    
    WeakSelf(that);
    
    NSInteger topOffset = [self getTipViewTop];
    NSInteger bottomOffset = [self getTipViewBottom];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top).offset(topOffset);
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView.mas_centerX);
        make.centerY.equalTo(emptyView.mas_centerY);
        make.width.equalTo(@(140));
        make.height.equalTo(@(142));
    }];
    
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(13);
        make.height.equalTo(@(14));
        
        make.left.equalTo(emptyView.mas_left).offset(14);
        make.right.equalTo(emptyView.mas_right).offset(-14);
    }];
    
    
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(86));
        make.height.equalTo(@(30));
        make.centerX.equalTo(emptyView.mas_centerX);
        make.top.equalTo(tipLabel.mas_bottom).offset(13);
    }];
    
    BOOL showNavigationBar = [self needNavigationBar];
    if (type == kNetworkError && showNavigationBar) {
        [self addNavigationView];
    }
    
}


- (BOOL)needNavigationBar {
    return TRUE;
}

- (NSInteger)getTipViewTop {
    return 0;
}


- (NSInteger)getTipViewBottom {
    return 0;
}


- (void)notificationHandler:(NSNotification*)obj {
    if (![obj.object isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString* cmd = obj.object[@"cmd"];
    if ([cmd isEqualToString:@"netError"]) {
        [self showTipView:kNetworkError];
    }
    else {
        [self showTipView:kNoHistory];
    }
}



- (void)refreshData {
    
}


- (void)hideTipView {
    [_noDataView removeFromSuperview];
    _noDataView = nil;
}


- (void)popupWhenNetworkError {
    
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
