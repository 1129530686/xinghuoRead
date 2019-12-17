//
//  JUDIAN_READ_LayoutConfigure.m
//  xinghuoRead
//
//  Created by judian on 2019/4/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_TextStyleManager.h"

#define FILE_NAME @"text_v120.configure"

@interface JUDIAN_READ_TextStyleManager ()

@end


@implementation JUDIAN_READ_TextStyleManager

+ (instancetype)shareInstance {
    static JUDIAN_READ_TextStyleManager* _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JUDIAN_READ_TextStyleManager alloc]init];
        [_instance unarchiveTextStyle];
        if (!_instance.textStyleModel) {
            [_instance initTextStyle];
        }
    });

    return _instance;
}



- (void)initTextStyle {
    
    JUDIAN_READ_TextStyleModel* model = [[JUDIAN_READ_TextStyleModel alloc]init];
    [model initStyle];
    _textStyleModel = model;
    [self archiveTextStyle];
}



- (void)archiveTextStyle {
    NSString *configurePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    configurePath = [configurePath stringByAppendingPathComponent:FILE_NAME];
    [NSKeyedArchiver archiveRootObject:_textStyleModel toFile:configurePath];
}



- (void)unarchiveTextStyle {

    NSString *configurePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    configurePath = [configurePath stringByAppendingPathComponent:FILE_NAME];
    
    _textStyleModel = [NSKeyedUnarchiver unarchiveObjectWithFile:configurePath];
}



@end
