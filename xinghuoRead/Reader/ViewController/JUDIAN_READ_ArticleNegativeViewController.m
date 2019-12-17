//
//  JUDIAN_READ_ArticleNegativeView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ArticleNegativeViewController.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_CoreTextManager.h"

@interface JUDIAN_READ_ArticleNegativeViewController ()
@property(nonatomic, strong)UIImageView* bgImageView;
@end



@implementation JUDIAN_READ_ArticleNegativeViewController


- (id)init {
    self = [super init];
    if(self) {
        
        JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        self.view.backgroundColor = [style getBgColor];
        CGRect frame = [[JUDIAN_READ_CoreTextManager shareInstance] getFrameOutOfAd];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:nil];
        [imageView setAlpha:1];
        [self.view addSubview:imageView];
        
        self.bgImageView = imageView;
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}



- (void)updateBgImage:(UIViewController *)viewController {
    UIImage* bgImage = [self takeScreenshot:viewController.view];
    [self.bgImageView setImage:bgImage];
    self.positiveViewController = (id)viewController;
}



- (UIImage *)takeScreenshot:(UIView *)view {
    CGSize size = view.bounds.size;
    CGAffineTransform transform = CGAffineTransformMake(-1,0,0,1,size.width,0);
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    //NSLog(@"dealloc===%@===", NSStringFromClass([self class]));
    
}

@end
