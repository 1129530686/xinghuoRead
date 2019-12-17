//
//  JUDIAN_READ_UserAddressEditorCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_CustomBackgroundViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface JUDIAN_READ_UserAddressEditorCell : UITableViewCell
- (void)updateCell:(NSString*)text placeholder:(NSString*)placeholder type:(NSInteger)type;
- (NSString*)getEditorText;
@end



@interface JUDIAN_READ_UserAddressChoiceCell : JUDIAN_READ_CustomBackgroundViewCell
@property(nonatomic, weak)UIImageView* rightArrowImageView;
- (void)updateCell:(NSString*)text placeholder:(NSString*)placeholder;
@end


@interface JUDIAN_READ_UserAddressDetailCell : UITableViewCell
- (void)updateCell:(NSString*)text placeholder:(NSString*)placeholder;
- (NSString*)getEditorText;
@end


@interface JUDIAN_READ_UserDefaultAddressSwitch : UIButton
@property(nonatomic, assign)BOOL on;
@end


@interface JUDIAN_READ_UserAddressDefaultCell : UITableViewCell
- (BOOL)getDefaultState;
- (void)updateCell:(BOOL)on;
@end



NS_ASSUME_NONNULL_END
