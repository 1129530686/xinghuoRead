//
//  JUDIAN_READ_UserAlbumModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAlbumModel : NSObject
@property(nonatomic, strong)PHAsset* asset;
@property(nonatomic, strong)UIImage* thumbnailImage;

+ (void)uploadImage:(id)image block:(modelBlock)block;
+ (NSArray*)getAllUserAlbum;
- (UIImage *)getOriginalImageWithAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
