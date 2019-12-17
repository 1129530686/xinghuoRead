//
//  JUDIAN_READ_PageViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/4/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PageViewController.h"
#import "JUDIAN_READ_CoreTextManager.h"

@interface JUDIAN_READ_PageViewController ()<UIGestureRecognizerDelegate>

@end

@implementation JUDIAN_READ_PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#if 0
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
        gR.delegate = self;
    }
#endif
}

#if 1
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Touch gestures below top bar should not make the page turn.
    //CGPoint touchPoint = [touch locationInView:self.view];
    
    //CGFloat leftWidth = 0.32f * WIDTH_SCREEN;
    //CGFloat rightWidth = 0.68f * WIDTH_SCREEN;
    
    //CGFloat width = 100;
    //NSInteger left = (WIDTH_SCREEN - width) / 2;
    //BOOL inRange = (touchPoint.x > left && touchPoint.x < left + width);
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    
    return YES;
}
#endif

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = [[JUDIAN_READ_CoreTextManager shareInstance] getFrameOutOfAd];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
