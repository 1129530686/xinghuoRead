//
//  JUDIAN_READ_UserInfoEditorCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserInfoEditorCell : UITableViewCell
- (void)updateInfo:(NSString*)title placeholder:(NSString*)placeholder content:(NSString*)content;
- (NSString*)getEditorText;
@end

NS_ASSUME_NONNULL_END
