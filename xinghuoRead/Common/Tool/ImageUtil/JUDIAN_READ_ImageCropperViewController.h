//
//  JUDIAN_READ_ImageCropperViewController.h
//
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JUDIAN_READ_ImageCropperViewController;

@protocol JUDIAN_READ_ImageCropperDelegate <NSObject>

- (void)imageCropper:(JUDIAN_READ_ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(JUDIAN_READ_ImageCropperViewController *)cropperViewController;

@end

@interface JUDIAN_READ_ImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<JUDIAN_READ_ImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
