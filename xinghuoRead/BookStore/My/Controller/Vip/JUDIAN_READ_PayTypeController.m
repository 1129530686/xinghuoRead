//
//  JUDIAN_READ_PayTypeController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/10.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_PayTypeController.h"


@interface JUDIAN_READ_PayTypeController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView  *webView;
@property (nonatomic,strong) WKUserContentController  *userController;

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *headView;

@end

@implementation JUDIAN_READ_PayTypeController

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = NO;
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"currentCookies"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值引导";
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    _userController = userController;
    [userController addScriptMessageHandler:self name:@"currentCookies"];
    config.userContentController = userController;

    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) configuration:config];
    _webView.allowsBackForwardNavigationGestures = NO;
    _webView.navigationDelegate = self;
    [_webView goBack];
    _webView.scrollView.delegate = self;
    [_webView.configuration.userContentController addUserScript:noneSelectScript];
    
    
    NSMutableString *requestPath = [NSMutableString stringWithString:API_HOST_NAME];
    [requestPath appendString:@"/pay.html"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestPath]];
    [_webView loadRequest:request];
    [self.view addSubview:self.webView];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"currentCookies"]) {
        NSString * url = @"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/editAddress?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
}


- (void)dealloc {
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"currentCookies"];
    
}


@end
