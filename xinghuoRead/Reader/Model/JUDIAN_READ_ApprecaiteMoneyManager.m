//
//  JUDIAN_READ_ApprecaiteMoneyManager.m
//  xinghuoRead
//
//  Created by judian on 2019/7/20.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ApprecaiteMoneyManager.h"
#import "JUDIAN_READ_LoadingFictionView.h"
#import "JUDIAN_READ_IAPShare.h"
#import "JUDIAN_READ_NovelManager.h"

@interface JUDIAN_READ_ApprecaiteMoneyManager ()
@property(nonatomic, strong)JUDIAN_READ_LoadingFictionView* loadingView;
@property(nonatomic, copy)NSString* money;
@property(nonatomic, copy)NSString* source;
@property(nonatomic, weak)UIView* container;
@end



@implementation JUDIAN_READ_ApprecaiteMoneyManager


- (instancetype)initWithView:(UIView*)view {
    self = [super init];
    if (self) {
        _container = view;
        [self addLoadingView:view];
    }
    
    return self;
}




- (void)appreciateMoney:(NSDictionary*)dictionary source:(NSString*)source {
    
    _money = dictionary[@"price"];
    _source = source;
    
    [self showLoadingView:YES];
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] appreciateChapter:dictionary block:^(id  _Nonnull parameter) {
        
        if (!parameter) {
            [that showLoadingView:NO];
            return;
        }
        
        NSDictionary* result = parameter;
        [self launchIap:result];
    }];
    
}



- (void)launchIap:(NSDictionary*) result {
    
    NSString* productIdentifier = result[@"appstroe_pid"];
    NSString* orderId = result[@"trade_no"];
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productIdentifier, nil];
    [JUDIAN_READ_IAPShare sharedHelper].iap = [[JUDIAN_READ_IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#if _IS_RELEASE_VERSION_ == 1
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = YES;
#else
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = NO;
#endif
    
    WeakSelf(that);
    [[JUDIAN_READ_IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response && [JUDIAN_READ_IAPShare sharedHelper].iap.products.count > 0) {
             
             SKProduct* product = [[JUDIAN_READ_IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             [[JUDIAN_READ_IAPShare sharedHelper].iap buyProduct:product
                                                    onCompletion:^(SKPaymentTransaction* trans){
                                                        
                                                        if(trans.error)
                                                        {
                                                            [that showLoadingView:NO];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                            
                                                            NSData* appstoreData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                            NSString* receipt = [appstoreData base64EncodedStringWithOptions:0];
                                                            
                                                            NSString* path = [[JUDIAN_READ_IAPShare sharedHelper] getChargeFilePath:orderId];
                                                            [receipt writeToFile:path atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
                                                            [JUDIAN_READ_UserReadingModel addChargeHistory:orderId type:@"2"];
                                                            
                                                            [that verifyOrder:orderId receipt:receipt trans:trans];
                                                            
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                            [that showLoadingView:NO];
                                                        }
                                                    }];
         }
         else {
             [that showLoadingView:NO];
         }
     }];
    
    
}





- (void)verifyOrder:(NSString*)orderId receipt:(NSString*)receipt trans:(SKPaymentTransaction*)trans {
    
    if (!orderId || !receipt) {
        [self showLoadingView:NO];
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"trade_no" : orderId,
                                 @"type" : @"ios",
                                 @"receipt" : receipt
                                 };
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] updteAppreciateStatus:dictionary block:^(id  _Nonnull parameter) {
        NSString* result = parameter;
        
        [[JUDIAN_READ_IAPShare sharedHelper] deleteChargeFile:orderId];
        [JUDIAN_READ_UserReadingModel deleteChargeHistory:orderId];
        
        if ([result isEqualToString:@"1"]) {
            
            if (that.isOnlyOneAppreciate) {
                [NSUserDefaults saveUserDefaults:_ONLY_ONE_APPRECIATE_ value:@"1"];
            }
            
            [[JUDIAN_READ_IAPShare sharedHelper].iap provideContentWithTransaction:trans];
            
            [that addAppreciateClickEvent:@"打赏成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView* promptView = [that.container viewWithTag:REWARD_VIDEO_VIEW_TAG];
                [promptView removeFromSuperview];
            });
            
        }
        else {
            [that addAppreciateClickEvent:@"打赏失败"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [that showLoadingView:NO];
        });
        
        if (that.block) {
            that.block(result);
        }

    }];
    
}





- (void)addLoadingView:(UIView*)view {
    
    _loadingView = [[JUDIAN_READ_LoadingFictionView alloc]initSquareView];
    _loadingView.backgroundColor = [UIColor clearColor];
    [view addSubview:_loadingView];
    _loadingView.hidden = YES;
    [_loadingView updateImageArray:NO];
    
 
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(@(0));
        make.bottom.equalTo(view.mas_bottom).offset(0);
    }];
    
}


- (void)addAppreciateClickEvent:(NSString*)aState {
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSString* state = aState;
    if (!state) {
        state = @"";
    }
    
    if (!_source) {
        _source = @"";
    }
    
    if (!_money) {
        _money = @"";
    }
    
    NSDictionary* dictionary = @{@"source" : _source,
                                 @"price" : _money,
                                 @"type" : @"APPLE PAY",
                                 @"state": state
                                 };
    
    [MobClick event:@"click_reward" attributes:dictionary];
    
}



- (void)showLoadingView:(BOOL)show {
    
    _loadingView.hidden = !show;
    [_loadingView playAnimation:show];
    
#if 0
    if (show) {
        WeakSelf(that);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(90 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(that)strongThat = that;
            strongThat.loadingView.hidden = YES;
        });
    }
#endif
}



@end
