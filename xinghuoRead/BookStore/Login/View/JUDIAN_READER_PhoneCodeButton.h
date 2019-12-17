//
//  PhoneCodeButton.h
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READER_PhoneCodeButton : UIButton

@property (nonatomic, strong, readwrite) NSTimer *timer;
- (void)startUpTimer;
- (void)invalidateTimer;
@end
