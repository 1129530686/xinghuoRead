//
//  JUDIAN_READ_InviteFriendPosterView.m
//  universalRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_InviteFriendPosterView.h"
#import "JUDIAN_READ_TestHelper.h"
#import "UIImage+JUDIAN_READ_Blur.h"

@interface JUDIAN_READ_InviteFriendPosterView ()
@property(nonatomic, weak)UIImageView* qrCodeImageView;
@property(nonatomic, assign)NSInteger totalHeight;
@end



@implementation JUDIAN_READ_InviteFriendPosterView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    UIImageView* bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"invite_friend_bg"];
    [self addSubview:bgImageView];
    
    //720 577
    UIImageView* appImageView = [[UIImageView alloc] init];
    appImageView.image = [UIImage imageNamed:@"invite_friend_app_tip"];
    [self addSubview:appImageView];
    
    //720 703
    UIImageView* qrCodeBgImageView = [[UIImageView alloc] init];
    qrCodeBgImageView.image = [UIImage imageNamed:@"invite_friend_qrcode_bg"];
    [self addSubview:qrCodeBgImageView];
    
    //193 193
    UIImageView* qrCodeImageView = [[UIImageView alloc] init];
    _qrCodeImageView = qrCodeImageView;
    [self addSubview:qrCodeImageView];
    

    UIImageView* logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"qr_icon_logo"];
    [self addSubview:logoImageView];
    logoImageView.hidden = NO;


    UILabel* longPressLabel = [[UILabel alloc] init];
    longPressLabel.textColor = RGB(0X33, 0X33, 0X33);
    longPressLabel.font = [UIFont systemFontOfSize:15];
    longPressLabel.textAlignment = NSTextAlignmentCenter;
    longPressLabel.text = @"长按扫码下载APP，领取话费";
    [self addSubview:longPressLabel];
    
    
    UILabel* qrcodeLabel = [[UILabel alloc] init];
    qrcodeLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    qrcodeLabel.font = [UIFont systemFontOfSize:20];
    qrcodeLabel.textAlignment = NSTextAlignmentCenter;
    qrcodeLabel.text = [self getCodeString];

    [self addSubview:qrcodeLabel];
    
    
    UILabel* inviteCodeTipLabel = [[UILabel alloc] init];
    inviteCodeTipLabel.textColor = RGB(0X33, 0X33, 0X33);
    inviteCodeTipLabel.font = [UIFont systemFontOfSize:14];
    inviteCodeTipLabel.textAlignment = NSTextAlignmentCenter;
    inviteCodeTipLabel.text = @"邀请码";
    [self addSubview:inviteCodeTipLabel];
    
    
    WeakSelf(that);
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(that.mas_width);
        make.top.equalTo(that.mas_top);
        make.height.equalTo(that.mas_height);
    }];
    
    
    NSInteger appImageHeight = (SCREEN_WIDTH  * 0.80f);

    [appImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(that.mas_width);
        make.top.equalTo(that.mas_top);
        make.height.equalTo(@(appImageHeight));
    }];
    
    NSInteger qrBgHeight = (SCREEN_WIDTH  * 0.98f);
    [qrCodeBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(that.mas_width);
        make.top.equalTo(appImageView.mas_bottom);
        make.height.equalTo(@(qrBgHeight));
    }];
    
    
    _totalHeight = appImageHeight + qrBgHeight;
    
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(193));
        make.height.equalTo(@(193));
        make.top.equalTo(appImageView.mas_bottom).offset(130);
        make.centerX.equalTo(qrCodeBgImageView.mas_centerX);
    }];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerX.equalTo(qrCodeImageView.mas_centerX);
        make.centerY.equalTo(qrCodeImageView.mas_centerY);
    }];
    
    
    [longPressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(15));
        make.bottom.equalTo(qrCodeImageView.mas_top).offset(-11);
    }];
    
    
    [qrcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(20));
        make.bottom.equalTo(longPressLabel.mas_top).offset(-19);
    }];
    
    
    
    [inviteCodeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.bottom.equalTo(qrcodeLabel.mas_top).offset(-10);
    }];
    
    NSString* qrCode = [JUDIAN_READ_TestHelper getQrCode];
    _qrCodeImageView.image = [UIImage generateQrCode:qrCode];
}



- (NSString*)getCodeString {
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length <= 0) {
        uid = @"";
    }
    return uid;
}


- (void)saveImageToAlbum {
    NSString* qrCode = [JUDIAN_READ_TestHelper getQrCode];
    _qrCodeImageView.image = [UIImage generateQrCode:qrCode];
    UIImage* image = [UIImage takeSnapShot:self];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);

}



- (UIImage*)getSnapShot {
    NSString* qrCode = [JUDIAN_READ_TestHelper getQrCode];
    _qrCodeImageView.image = [UIImage generateQrCode:qrCode];
    UIImage* image = [UIImage takeSnapShot:self];
    return image;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (!error) {
        [MBProgressHUD showMessage:@"保存成功"];
    }
}


- (NSInteger)getViewHeight {
    return _totalHeight;
}




@end
