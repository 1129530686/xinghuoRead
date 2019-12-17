//
//  TCCircleProgressView.h
//  
//
//  Created by hu on 8/10/18.
//  Copyright © 2018 hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_CircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic,copy) void (^touchBlock)(void);


@end
