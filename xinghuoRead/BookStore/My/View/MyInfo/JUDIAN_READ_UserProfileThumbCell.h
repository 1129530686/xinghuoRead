//
//  JUDIAN_READ_UserProfileThumbCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserProfileThumbCell : UITableViewCell
@property(nonatomic, copy)touchBlock block;
- (void)updateImageWithUrl:(NSString*)imageUrl;
- (void)updateImage:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
