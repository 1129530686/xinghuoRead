//
//  JUDIAN_READ_NovelShareView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelSharePanel : UIView

- (instancetype)initWithId:(NSString*)bookId;

- (void)addToKeyWindow:(UIView*)container;
- (void)showView;
- (void)removeSelf;
@end

NS_ASSUME_NONNULL_END
