//
//  JUDIAN_READ_UserAlbumModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAlbumModel.h"
#import "JUDIAN_READ_APIRequest.h"


@implementation JUDIAN_READ_UserAlbumModel


+ (NSArray*)getAllUserAlbum {
    
    NSMutableArray *albumArray = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    // 获得所有的自定义相簿
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in albums) {
        
        PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
        
        if (result.count < 1 || [assetCollection.localizedTitle isEqualToString:@"视频"] || [assetCollection.localizedTitle isEqualToString:@"最近删除"]) {
            continue;
        }

        for (PHAsset *asset in result) {
            JUDIAN_READ_UserAlbumModel* model = [[JUDIAN_READ_UserAlbumModel alloc] init];
            model.thumbnailImage = [model getThumbWithAsset:asset];
            model.asset = asset;
            [albumArray addObject:model];
        }
        
    }
    
    
    return albumArray;
}


- (UIImage *)getThumbWithAsset:(PHAsset*)asset {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    __block UIImage *thumbnailImage = nil;
    //获得缩略图
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        thumbnailImage = result;
    }];
    
    return thumbnailImage;
    
}




- (UIImage *)getOriginalImageWithAsset:(PHAsset *)asset {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    __block UIImage *image = [[UIImage alloc] init];
    //获得原始图
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    return image;
}



+ (void)uploadImage:(id)image block:(modelBlock)block {
    
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (!uid) {
        return;
    }

    NSDictionary* dictionary = @{@"uidb" : uid};
    [JUDIAN_READ_APIRequest uploadImage:@"/appprogram/user/upload-headimg" params:dictionary image:image completion:^(NSDictionary * _Nonnull responseObject, NSError * _Nonnull error) {
        if (block) {
            block(responseObject);
        }
    }];
    
}



@end
