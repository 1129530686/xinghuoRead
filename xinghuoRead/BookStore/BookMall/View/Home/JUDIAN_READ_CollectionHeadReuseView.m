//
//  JDCollectionHeadReuseView.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import "JUDIAN_READ_CollectionHeadReuseView.h"
#import "JUDIAN_READ_BookStoreModel.h"

@implementation JUDIAN_READ_CollectionHeadReuseView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.trailBtn setImage:[UIImage imageNamed:@"Bookcity_refresh"] forState:UIControlStateNormal];

    // Initialization code
    
}
- (IBAction)trailBtnAction:(id)sender {
    UIButton *btn = sender;
    if (![btn.currentTitleColor isEqual:kColorWhite]) {
        
        CABasicAnimation *view = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        view.duration = 0.5;
        view.repeatCount = 1;
        view.toValue = @(2*M_PI);
        view.removedOnCompletion = NO;
        view.fillMode = kCAFillModeForwards;
        [self.trailBtn.layer addAnimation:view forKey:@"rotation"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        });
    }else{
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
    
}


- (void)setHomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_BookStoreModel *info = model[indexPath.section-1];
    [self.leadLab setText:info.title titleFontSize:17 titleColot:kColor100];
    self.trailBtn.hidden = YES;
    self.textBtn.hidden = YES;
}

- (void)setV0HomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *infos = model;
    self.leadLab.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    self.leadLab.text = infos[indexPath.section - 1];
    [self.trailBtn setImage:[UIImage imageNamed:@"Bookcity_refresh"] forState:UIControlStateNormal];
    if (indexPath.section == 4) {
        self.textBtn.hidden = YES;
        self.trailBtn.hidden = YES;
    }else{
        self.textBtn.hidden = NO;
        self.trailBtn.hidden = NO;
    }
    [self.textBtn setTitle:@"换一换" forState:UIControlStateNormal];
    self.textBtn.titleLabel.font = [UIFont systemFontOfSize:kAutoFontSize12_13];
    
}


- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *infos = model;
    self.leadLab.text = infos[indexPath.section];
    [self.leadLab setText:infos[indexPath.section] titleFontSize:12 titleColot:kColor153];
    self.textBtn.hidden = NO;
    if (indexPath.section == 0) {
        [self.textBtn setText:@"换一换" titleFontSize:12 titleColot:kColor51];
        [self.trailBtn setImage:[UIImage imageNamed:@"Bookcity_refresh"] forState:UIControlStateNormal];
        [self.trailBtn setTitleColor:kColor153 forState:UIControlStateNormal];
    }else{
        self.textBtn.hidden = YES;
        [self.trailBtn setImage:[UIImage imageNamed:@"search_icon_delete"] forState:UIControlStateNormal];
        [self.trailBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    }
}

- (void)setSearchPushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.backgroundColor = [UIColor whiteColor];
    self.leadLab.text = @"为您推荐";
    self.trailBtn.hidden = YES;
    self.textBtn.hidden = YES;
}



@end
