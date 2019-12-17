//
//  JUDIAN_READ_UserPhotoMenu.m
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserPhotoMenu.h"


#define ITEM_HEIGHT 47

#define BUTTON_PHOTO_TAG 100
#define BUTTON_CAMERA_TAG 101
#define BUTTON_CANCEL_TAG 102

@interface JUDIAN_READ_UserPhotoMenu ()
@property(nonatomic, weak)UIView* container;
@end



@implementation JUDIAN_READ_UserPhotoMenu

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
    UIView* container = [[UIView alloc] init];
    _container = container;
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    

    UIButton* cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelButton.tag = BUTTON_CANCEL_TAG;
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [container addSubview:cancelButton];

    
    UIView* seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [container addSubview:seperatorView];
    

    UIButton* photoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    photoButton.tag = BUTTON_PHOTO_TAG;
    [photoButton setTitle:@"从手机相册选择" forState:(UIControlStateNormal)];
    photoButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [photoButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [container addSubview:photoButton];

    
    UIButton* cameraButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cameraButton.tag = BUTTON_CAMERA_TAG;
    [cameraButton setTitle:@"拍照" forState:(UIControlStateNormal)];
    cameraButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cameraButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIView* cameraLineView = [[UIView alloc] init];
    cameraLineView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [cameraButton addSubview:cameraLineView];
    
    [container addSubview:cameraButton];


    NSInteger height = [self getContainerHeight];
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(height));
        make.bottom.equalTo(that.mas_bottom).offset(height);
    }];
    
    NSInteger bottomOffset = [self getBottomOfffset];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(ITEM_HEIGHT));
        make.bottom.equalTo(container.mas_bottom).offset(-bottomOffset);
    }];
    
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(7));
        make.bottom.equalTo(cancelButton.mas_top);
    }];
    
    
    [photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(ITEM_HEIGHT));
        make.bottom.equalTo(seperatorView.mas_top);
    }];
    
    
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(ITEM_HEIGHT));
        make.bottom.equalTo(photoButton.mas_top);
    }];
    
    

    
    [cameraLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.left.equalTo(cameraButton.mas_left);
        make.right.equalTo(cameraButton.mas_right);
        make.bottom.equalTo(cameraButton.mas_bottom);
    }];
    
}



- (NSInteger)getContainerHeight {
    
    NSInteger height = ITEM_HEIGHT * 3 + 7;
    return height + [self getBottomOfffset];
}


- (NSInteger)getBottomOfffset {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    return bottomOffset;
    
    
}



- (void)showView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, -[that getContainerHeight]);
    }completion:^(BOOL finished) {
        
    }];
}




- (void)hideView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, [that getContainerHeight]);
    }completion:^(BOOL finished) {
        [that removeFromSuperview];
    }];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}




- (void)handleTouchEvent:(UIButton*)sender {
    [self hideView];
    
    if (!_block) {
        return;
    }
    
    
    if (sender.tag == BUTTON_PHOTO_TAG) {
        _block(@"photo");
        return;
    }
    
    if (sender.tag == BUTTON_CAMERA_TAG) {
        _block(@"camera");
        return;
    }
    
    
    if (sender.tag == BUTTON_CANCEL_TAG) {
        return;
    }

}


@end
