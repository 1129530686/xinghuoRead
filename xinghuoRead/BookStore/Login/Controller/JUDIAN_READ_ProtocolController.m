//
//  JUDIAN_READ_ProtocolController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/28.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ProtocolController.h"


@interface JUDIAN_READ_ProtocolController ()<UIWebViewDelegate>

@end

@implementation JUDIAN_READ_ProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)];
    NSMutableString *requestPath = [NSMutableString stringWithString:API_HOST_NAME];
    if ([self.value isEqualToString:@"user"]) {
        self.title = @"用户服务协议";
        [requestPath appendString:@"/appprogram/static/use-protocol"];
        [MobClick event:LoginRecord attributes:@{click_ua:@"点击用户协议"}];
    }else{
        self.title = @"隐私协议";
        [MobClick event:LoginRecord attributes:@{click_pp:@"点击隐私协议"}];
        [requestPath appendString:@"/appprogram/static/privacy-policy"];
    }
    web.scrollView.bounces = NO;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestPath]];
    [web loadRequest:request];
    web.delegate = self;
    web.backgroundColor = [UIColor clearColor];
    web.opaque = NO;
    [self.view addSubview:web];
}



@end
