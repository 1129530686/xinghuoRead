//
//  JUDIAN_READ_PageNavigationView.h
//  xinghuoRead
//
//  Created by judian on 2019/4/24.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^callback)(ReaderTextStyleCmd cmd);


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_PageNavigationView : UIControl

@property(nonatomic, copy)callback handleTouchEvent;
@property(nonatomic, weak)UILabel* titleLabel;

@property(nonatomic, copy)NSString* bookName;
@property(nonatomic, copy)NSString* chapterName;

- (void)setViewStyle;

@end

NS_ASSUME_NONNULL_END
