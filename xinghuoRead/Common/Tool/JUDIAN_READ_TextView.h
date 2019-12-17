//
//  JUDIAN_READ_TextView
//  
//
//  Created by apple on 2018-04-27.
//  Copyright © 2018 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_TextView : UITextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) NSInteger placeholderFont;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) BOOL placeHolderCenterY;


//- (void)contentSizeToFit:(BOOL)isFit isHorizon:(BOOL)isHorizon isVertical:(BOOL)isVertical;

@end
