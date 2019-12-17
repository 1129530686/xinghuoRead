//
//  JUDIAN_READ_UserAlbumController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAlbumController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserAlbumThumbCell.h"
#import "JUDIAN_READ_UserAlbumModel.h"
#import "JUDIAN_READ_ImageCropperViewController.h"
#import "UIImage+JUDIAN_READ_Blur.h"

#define UserAlbumThumbCell @"UserAlbumThumbCell"

@interface JUDIAN_READ_UserAlbumController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
JUDIAN_READ_ImageCropperDelegate>
@property(nonatomic, strong)UICollectionView* collectionView;
@property(nonatomic, copy)NSArray* dataArray;
@property(nonatomic, copy)CompletionBlock confirmBlock;
@end

@implementation JUDIAN_READ_UserAlbumController


+ (void)enterUserAlbumController:(UINavigationController*)navigationController block:(CompletionBlock)block {
    JUDIAN_READ_UserAlbumController* viewController = [[JUDIAN_READ_UserAlbumController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.confirmBlock = block;
    [navigationController pushViewController:viewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addCollectionView];
    [self loadUserAlbum];
}




- (void)addNavigationView {
    
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:@"用户相册" rightTitle:@""];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            
        }
    };
    
    CGFloat height = 64;
    if (iPhoneX) {
        height = 88;
    }
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.height.equalTo(@(height));
    }];
#endif
    self.title = @"用户相册";
    
}



- (void)addCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger navigationHeight = [self getNavigationHeight];
    NSInteger yPosition = 0;
    
    NSInteger height = SCREEN_HEIGHT - navigationHeight - bottomOffset;
  
    CGRect rect = CGRectMake(0, yPosition, SCREEN_WIDTH, height);
    self.collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    
    [self.collectionView registerClass:[JUDIAN_READ_UserAlbumThumbCell class] forCellWithReuseIdentifier:UserAlbumThumbCell];
    
    [self.view addSubview:self.collectionView];

}



- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}



- (void)loadUserAlbum {
    
    [MBProgressHUD showForWaiting:self.collectionView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    WeakSelf(that);
    dispatch_async(queue, ^{
        that.dataArray = [JUDIAN_READ_UserAlbumModel getAllUserAlbum];
        if (that.dataArray.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [that.collectionView reloadData];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:that.collectionView];
        });
    });

}



#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    JUDIAN_READ_UserAlbumThumbCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserAlbumThumbCell forIndexPath:indexPath];
    if (_dataArray.count > 0) {
        JUDIAN_READ_UserAlbumModel* model = _dataArray[row];
        [cell updateImage:model.thumbnailImage];
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellWidth = SCREEN_WIDTH / 4;
    cellWidth = ceil(cellWidth);
    NSInteger cellHeight = (cellWidth);
    
    return CGSizeMake(cellWidth, cellHeight);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        JUDIAN_READ_UserAlbumModel* model = _dataArray[indexPath.row];
        UIImage* image = [model getOriginalImageWithAsset:model.asset];
        [self showEditImageController:image];
    }
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark 图片截取协议
- (void)imageCropper:(JUDIAN_READ_ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    if (_confirmBlock) {
        
        UIImage* image = editedImage;//[editedImage scaleImage];
        _confirmBlock(image, nil);
        
        UIViewController* userBriefClass = nil;
        NSArray* array = [cropperViewController.navigationController viewControllers];
        for (UIViewController* element in array) {
            NSString* className = NSStringFromClass([element class]);
            if ([className isEqualToString:@"JUDIAN_READ_UserBriefViewController"]) {
                userBriefClass = element;
                break;
            }
        }
        
        if (userBriefClass) {
            [cropperViewController.navigationController popToViewController:userBriefClass animated:NO];
        }
    }
}


- (void)imageCropperDidCancel:(JUDIAN_READ_ImageCropperViewController *)cropperViewController {
     [cropperViewController.navigationController popViewControllerAnimated:YES];
}




- (void)showEditImageController:(UIImage *)image {
    
    if (!image) {
        return;
    }
    
    CGFloat y = (self.view.bounds.size.height - self.view.bounds.size.width) / 2.0;
    JUDIAN_READ_ImageCropperViewController *imageCropper = [[JUDIAN_READ_ImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.width) limitScaleRatio:3];
    imageCropper.delegate = self;
    [self.navigationController pushViewController:imageCropper animated:YES];
}





@end
