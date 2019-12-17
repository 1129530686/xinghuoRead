//
//  JUDIAN_READ_ProblemDetailController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/21.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ProblemDetailController.h"

@interface JUDIAN_READ_ProblemDetailController ()

@end

@implementation JUDIAN_READ_ProblemDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈与帮助";
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)];
    web.scrollView.bounces = NO;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [web loadRequest:request];
    web.backgroundColor = [UIColor clearColor];
    web.opaque = NO;
    [self.view addSubview:web];}



@end
