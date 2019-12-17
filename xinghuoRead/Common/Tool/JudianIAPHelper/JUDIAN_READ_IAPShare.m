#import "JUDIAN_READ_IAPShare.h"
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_NovelManager.h"

#if ! __has_feature(objc_arc)
#error You need to either convert your project to ARC or add the -fobjc-arc compiler flag to JUDIAN_READ_IAPShare.m.
#endif

@implementation JUDIAN_READ_IAPShare
@synthesize iap= _iap;

+ (JUDIAN_READ_IAPShare *) sharedHelper {
    static JUDIAN_READ_IAPShare * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[JUDIAN_READ_IAPShare alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}


+(id)toJSON:(NSString *)json
{
    NSError* e = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options: NSJSONReadingMutableContainers
                                                      error: &e];
    
    if(e==nil) {
        return jsonObject;
    }
    else {
        NSLog(@"%@",[e localizedDescription]);
        return nil;
    }
    
}

#pragma mark 保存支付记录
- (NSString*)getChargeFilePath:(NSString*)orderId {
    NSString* bookPath = @"";
    bookPath = CHARGE_HISTORY_PATH;
    bookPath = [JUDIAN_READ_APIRequest makePath:bookPath];
    bookPath = [NSString stringWithFormat:@"%@/%@.%@", bookPath, orderId, @"txt"];
    return bookPath;
}



- (void)deleteChargeFile:(NSString*)orderId {
    NSString* path = [self getChargeFilePath:orderId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}



- (void)sychronizeChargeHistory {
    
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        return;
    }
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("sychronizeChargeQueque", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrent_queue, ^{
        
        dispatch_semaphore_t signal;
        signal = dispatch_semaphore_create(0);
        
        NSArray* array = [JUDIAN_READ_UserReadingModel getAllChargeHistory];
        
        for (NSDictionary* dictionary in array) {
            
            NSString* orderId = dictionary[@"orderId"];
            NSString* chargeType = dictionary[@"chargeType"];
            
            NSString* path = [self getChargeFilePath:orderId];
            NSString *receipt = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            if (!orderId) {
                orderId = @"";
            }
            
            if (!receipt) {
                receipt = @"";
            }
            
            if ([chargeType isEqualToString:@"2"]) {//同步赞赏记录
                
                NSDictionary* dictionary = @{
                                             @"trade_no" : orderId,
                                             @"type" : @"ios",
                                             @"receipt" : receipt
                                             };
                
                [[JUDIAN_READ_NovelManager shareInstance] updteAppreciateStatus:dictionary block:^(id  _Nonnull parameter) {
                    
                    [[JUDIAN_READ_IAPShare sharedHelper] deleteChargeFile:orderId];
                    [JUDIAN_READ_UserReadingModel deleteChargeHistory:orderId];
                    
                    dispatch_semaphore_signal(signal);
                }];
                
            }
            else {//同步充值记录
                NSDictionary *dic = @{@"trade_no" : orderId,
                                      @"type" : @"ios",
                                      @"receipt" : receipt,
                                      };
                
                [JUDIAN_READ_MyTool updateAppPayWithParams:dic completionBlock:^(id result, id error) {
                    
                    [[JUDIAN_READ_IAPShare sharedHelper] deleteChargeFile:orderId];
                    [JUDIAN_READ_UserReadingModel deleteChargeHistory:orderId];
                    
                    dispatch_semaphore_signal(signal);
                }];
                
            }
            
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        }
        
    });
    
}

@end
