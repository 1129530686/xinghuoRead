//
//  JUDIAN_READ_InviteFriendBottomViewl.m
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_InviteFriendBottomView.h"
#import "JUDIAN_READ_ShareInviteCodeItem.h"

typedef enum : NSUInteger {
    kShareWeixinTag = 1,
    kShareFriendTag,
    kSavePictureTag,
} ButtonTagEnum;



@implementation JUDIAN_READ_InviteFriendBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
 
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    JUDIAN_READ_ShareInviteCodeItem* weixinView = [[JUDIAN_READ_ShareInviteCodeItem alloc] init];
    weixinView.tag = kShareWeixinTag;
    [weixinView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [weixinView updateItem:@"微信邀请" imageName:@"weixin_logo"];
    [self addSubview:weixinView];
    
    JUDIAN_READ_ShareInviteCodeItem* friendView = [[JUDIAN_READ_ShareInviteCodeItem alloc] init];
    friendView.tag = kShareFriendTag;
    [friendView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [friendView updateItem:@"微信朋友圈" imageName:@"weixin_friend_logo"];
    [self addSubview:friendView];
    
    JUDIAN_READ_ShareInviteCodeItem* savePictureView = [[JUDIAN_READ_ShareInviteCodeItem alloc] init];
    savePictureView.tag = kSavePictureTag;
    [savePictureView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [savePictureView updateItem:@"保存图片" imageName:@"save_picture_logo"];
    [self addSubview:savePictureView];
    
    CGFloat width = SCREEN_WIDTH / 3.0f;
    
    WeakSelf(that);
    [weixinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(that.mas_left);
        make.top.equalTo(that.mas_top);
    }];
    
    [friendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(weixinView.mas_right);
        make.top.equalTo(that.mas_top);
    }];
    
    
    [savePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(friendView.mas_right);
        make.top.equalTo(that.mas_top);
    }];
    
}


- (void)hidePictureButton {
    UIView* view = [self viewWithTag:kSavePictureTag];
    view.hidden = YES;
}



- (void)handleTouchEvent:(UIControl*)sender {
    
    if (!_block) {
        return;
    }
    
    if (sender.tag == kShareWeixinTag) {
        _block(@"weixin");
    }
    else if(sender.tag == kShareFriendTag) {
        _block(@"friend");
    }
    else if(sender.tag == kSavePictureTag) {
        _block(@"save");
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

}

@end
