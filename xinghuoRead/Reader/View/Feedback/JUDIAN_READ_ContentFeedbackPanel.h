//
//  JUDIAN_READ_ContentFeedbackPanel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ContentFeedbackPanel : UIView
- (void)addToKeyWindow:(UIView*)container;
- (void)showView;
- (void)setFictionInfo:(NSString*)bookName chapterName:(NSString*)chapterName;
- (void)removeSelf;

- (void)setViewStyle;

@end

NS_ASSUME_NONNULL_END
