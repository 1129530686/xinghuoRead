//
//  JUDIAN_READ_ProblemController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ProblemController.h"
#import "JUDIAN_READ_ProblemDetailController.h"

@interface JUDIAN_READ_ProblemController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView  *webView;


@end

@implementation JUDIAN_READ_ProblemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈与帮助";
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = [[WKUserContentController alloc]init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) configuration:config];
    _webView.allowsBackForwardNavigationGestures = NO;
    _webView.navigationDelegate = self;
    [_webView goBack];
    _webView.scrollView.delegate = self;
    
    NSMutableString *requestPath = [NSMutableString stringWithString:API_HOST_NAME];
    [requestPath appendString:_USER_FAQ_LINK_];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestPath]];
    self.urlStr = requestPath;
    [_webView loadRequest:request];
    [self.view addSubview:self.webView];
}



// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    if ([self.urlStr isEqualToString:urlStr]) {
        //允许跳转
        decisionHandler(WKNavigationResponsePolicyAllow);
    }else{
        //不允许跳转
        decisionHandler(WKNavigationResponsePolicyCancel);
        JUDIAN_READ_ProblemDetailController *vc = [JUDIAN_READ_ProblemDetailController new];
        vc.urlString = urlStr;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)dealloc{
    [_webView evaluateJavaScript:@"localStorage.clear()" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        
    }];
}




@end
