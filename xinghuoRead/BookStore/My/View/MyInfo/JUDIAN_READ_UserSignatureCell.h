//
//  JUDIAN_READ_UserSignatureCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserSignatureCell : UITableViewCell
- (void)updateTextView:(NSString*)text;
- (NSString*)getEditorText;
@end

NS_ASSUME_NONNULL_END