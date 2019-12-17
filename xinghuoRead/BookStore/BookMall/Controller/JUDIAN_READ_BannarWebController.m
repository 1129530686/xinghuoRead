//
//  JUDIAN_READ_BannarWebController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/13.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_UserShippingAddressController.h"
#import "JUDIAN_READ_UserShippingAddressEditorController.h"
#import "JUDIAN_READ_CoinRecordController.h"
#import "JUDIAN_READ_SuggestionController.h"
#import "JUDIAN_READ_MyInfoController.h"

// WKWebView 内存不释放的问题解决
@interface JUDIAN_READ_WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end


@implementation JUDIAN_READ_WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end



@interface JUDIAN_READ_BannarWebController ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, strong)WKWebView * webView;
@property(nonatomic, assign)BOOL canRefresh;
@property(nonatomic, copy)NSString* promptName;
@end

@implementation JUDIAN_READ_BannarWebController

+ (instancetype)shareInstance {
#if 0
    static JUDIAN_READ_BannarWebController* _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JUDIAN_READ_BannarWebController alloc]init];
        _instance.url = @"goldmall";
        [_instance loadData];
    });
    
    return _instance;
#else
    JUDIAN_READ_BannarWebController* _instance = [[JUDIAN_READ_BannarWebController alloc]init];
    _instance.url = @"goldmall";
    return _instance;
#endif
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _canRefresh = YES;
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [self.view addSubview:self.webView];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [MBProgressHUD showLoadingForView:self.webView];

#if 0
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)];
    web.scrollView.bounces = NO;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]];
    [web loadRequest:request];
    web.delegate = self;
    web.backgroundColor = [UIColor clearColor];
    web.opaque = NO;
    [self.view addSubview:web];
#endif
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    //self.hideBar = NO;
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_return_black"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];

    [self loadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.webView];
}



- (void)back {
    //WKBackForwardList * backForwardList = [_webView backForwardList];
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (WKWebView *)webView{
    
    if(_webView == nil) {
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"";
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        JUDIAN_READ_WeakScriptMessageDelegate *weakScriptMessageDelegate = [[JUDIAN_READ_WeakScriptMessageDelegate alloc] initWithDelegate:self];
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
        //[wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"toGetCoin"];
        config.userContentController = wkUController;
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        [javascript appendString:jSString];
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:FALSE];
        [config.userContentController addUserScript:wkUScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;

    }
    

    
    return _webView;
}


- (void)loadData {
    
    NSURLRequest *request = nil;
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    
    BOOL isMall = [_url containsString:@"goldmall"];
    if (isMall) {
        if(uid.length > 0) {
            _url = [NSString stringWithFormat:@"%@/mall/goldmall?uidb=%@", API_HOST_NAME, uid];
        }
        else {
            _url = [NSString stringWithFormat:@"%@/mall/goldmall", API_HOST_NAME];
        }
    }
    
    if (_canRefresh) {
        request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
        [self.webView loadRequest:request];
    }
    else {
        if ([_promptName isEqualToString:@"toGetCoin"]) {
            NSString* cmd = @"ZSB_INFRM('refreshgold')";
            [_webView evaluateJavaScript:cmd completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                
            }];
        }
    }
    
}



- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    //NSDictionary * parameter = message.body;
    //parameter[@"params"]
    if([message.name isEqualToString:@"toGetCoin"]){
        
    }
}




#pragma mark -- WKNavigationDelegate
/*
 WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
 */

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
 
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //[self.progressView setProgress:0.0f animated:NO];
    [MBProgressHUD hideHUDForView:self.webView];
    
    if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BadNet" object:@{
                                                                                          @"cmd":@"netError"
                                                                                          }];
        });
    }
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (BOOL)needNavigationBar {
    return FALSE;
}

- (void)refreshData {
    [self loadData];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if ([_url containsString:@"myInviting"] && (uid.length > 0)) {
        NSString* cmd = [NSString stringWithFormat:@"ZSB_INFRM('getuidb', %@)",uid];
        [webView evaluateJavaScript:cmd completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            
        }];
    }

    [MBProgressHUD hideHUDForView:self.webView];
    [self hideTipView];
    //[self getCookie];
}



- (void)getCookie{
    
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [_webView evaluateJavaScript:JSCookieString completionHandler:nil];
    
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
   // [self.progressView setProgress:0.0f animated:NO];
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSString *htmlHeadString = @"";
    if([urlStr hasPrefix:htmlHeadString]){
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //NSString * urlStr = navigationResponse.response.URL.absoluteString;
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
#if 0
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
#if 0
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
#endif
}
#endif
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}

#pragma mark -- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
#if 0
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
#endif
}


// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
//#if 0
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
//#endif

}


// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{

    completionHandler(@"");
    
    WeakSelf(that);
    
    _promptName = prompt;
    
    if ([prompt containsString:@"toGetCoin"]) {
        _canRefresh = FALSE;
        [JUDIAN_READ_UserEarningsViewController entryEarningsViewController:self.navigationController];
    }
    else if ([prompt containsString:@"toAddAddress"]) {
        _canRefresh = FALSE;
        [JUDIAN_READ_UserShippingAddressEditorController enterShippingAddresssEditor:self.navigationController model:nil block:^(id  _Nullable args) {
            NSString *jsString = @"";
            jsString = [self dataTojsonString:args];
            NSString* cmd = [NSString stringWithFormat:@"ZSB_INFRM('adress', %@)", jsString];
            [that.webView evaluateJavaScript:cmd completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                
            }];
        }];
    }
    else if ([prompt containsString:@"toChooseAddress"]) {
        _canRefresh = FALSE;
        [JUDIAN_READ_UserShippingAddressController enterShippingAddresssController:self.navigationController block:^(id  _Nullable args) {
            NSString *jsString = @"";
            jsString = [self dataTojsonString:args];
            NSString* cmd = [NSString stringWithFormat:@"ZSB_INFRM('adress', %@)", jsString];
            [that.webView evaluateJavaScript:cmd completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                
            }];
        }];
    }
    else if ([prompt containsString:@"toLogin"]) {
        _canRefresh = TRUE;
        JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else if ([prompt containsString:@"toMyCoin"]) {
        _canRefresh = FALSE;
        JUDIAN_READ_CoinRecordController *vc = [JUDIAN_READ_CoinRecordController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([prompt containsString:@"toFeedBack"]){
        JUDIAN_READ_SuggestionController *vc = [JUDIAN_READ_SuggestionController new];
        [self.navigationController pushViewController:vc animated:YES];
        _canRefresh = NO;
    }else if ([prompt containsString:@"toPersonal"]){
        NSRange range = [prompt rangeOfString:@"="];
        NSString *idb = [prompt substringWithRange:NSMakeRange(range.location+1, prompt.length-range.location-1)];
        JUDIAN_READ_MyInfoController *infoVC = [JUDIAN_READ_MyInfoController new];
        infoVC.uid_b = idb;
        infoVC.isSelf = NO;
        _canRefresh = NO;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}




-(NSString*)dataTojsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}




// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    //移除注册的js方法
   // [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcNoPrams"];
   // [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcWithPrams"];
    //移除观察者
    //[_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    //[_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
}


#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView)
        {
            self.title = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
