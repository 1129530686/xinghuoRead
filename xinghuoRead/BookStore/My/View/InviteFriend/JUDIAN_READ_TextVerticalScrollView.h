//
//  JUDIAN_READ_TextVerticalScrollView.h
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TextVerticalScrollView : UIView

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSTimeInterval scrollTimeInterval;

- (void)buildAttributedText:(NSArray*)array;
- (void)resetTimer;
@end

NS_ASSUME_NONNULL_END
