//
//  LaunchController.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import "JUDIAN_READ_LaunchController.h"
#import "JUDIAN_READ_MainViewController.h"

#define COUNT_DOWN 3

@interface JUDIAN_READ_LaunchController ()
@property (nonatomic,strong) NSTimer  *timer;
@property (nonatomic,assign) int  count;
@property (nonatomic,strong) UILabel  *lab;

@end

@implementation JUDIAN_READ_LaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startAction:) userInfo:nil repeats:YES];
    self.view.backgroundColor = kBackColor;
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString *str = @"guild_1";
    if (iPhone6Plus) {
        str = @"guild_2";
    }else if (iPhoneMAX){
        str = @"guild_4";
    }else if (iPhoneX){
        str = @"guild_3";
    }
    
    imgV.image = [UIImage imageNamed:str];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 -27, Height_StatusBar, 27, 27)];
    NSString* countTip = [NSString stringWithFormat:@"%ld", (long)COUNT_DOWN];
    [lab setText:countTip titleFontSize:14 titleColot:kColorWhite];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [lab doBorderWidth:0 color:nil cornerRadius:27/2.0];
    self.lab = lab;
    [imgV addSubview:lab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn doBorderWidth:0 color:nil cornerRadius:20];
    btn.frame = CGRectMake((SCREEN_WIDTH-180)/2, SCREEN_HEIGHT - 40 - 33 - BottomHeight, 180, 40);
    [btn setText:@"进入追书宝" titleFontSize:16 titleColot:kColorWhite];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GTCountSDK trackCountEvent:@"guide_page" withArgs:@{@"expose":@"曝光次数"}];
    [MobClick event:@"guide_page" attributes:@{@"expose":@"曝光次数"}];

}


#pragma mark 开始
- (void)startAction:(UIButton *)btn{
    self.count++;
    int x = COUNT_DOWN - self.count;
    self.lab.text = [NSString stringWithFormat:@"%d",x];
    
    if (self.count == COUNT_DOWN || [btn isKindOfClass:[UIButton class]]) {
        [self.timer invalidate];
        self.timer = nil;
        JUDIAN_READ_MainViewController *tabVC = [[JUDIAN_READ_MainViewController alloc]init];
        [kKeyWindow setRootViewController:tabVC];
        
        [tabVC enterFictionBrowseViewController];
        
        if (self.count == COUNT_DOWN) {
            [GTCountSDK trackCountEvent:@"guide_page" withArgs:@{@"enterStyle":@"倒计时自动进入"}];
            [MobClick event:@"guide_page" attributes:@{@"enterStyle":@"倒计时自动进入"}];

        }else{
            [GTCountSDK trackCountEvent:@"guide_page" withArgs:@{@"enterStyle":@"点击进入追书宝按钮"}];
            [MobClick event:@"guide_page" attributes:@{@"enterStyle":@"点击进入追书宝按钮"}];

        }
    }
}



@end
