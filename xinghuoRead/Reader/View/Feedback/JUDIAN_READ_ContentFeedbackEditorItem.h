//
//  JUDIAN_READ_ContentFeedbackEditorItem.h
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_FeedbackTextView.h"

typedef enum : NSUInteger {
    kFeedEditorType = 1,
    kUserSignatureType,
} UserEditorEnum;


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ContentFeedbackEditorItem : UIView
@property(nonatomic, weak)JUDIAN_READ_FeedbackTextView* textView;
- (void)updateWordCount:(NSInteger)length;
- (void)updateTextFont:(NSInteger)size;
- (instancetype)initWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
