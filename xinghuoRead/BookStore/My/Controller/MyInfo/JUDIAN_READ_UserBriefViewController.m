//
//  JUDIAN_READ_UserBriefViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserBriefViewController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserProfileThumbCell.h"
#import "JUDIAN_READ_UserBriefItemCell.h"
#import "JUDIAN_READ_UserBriefEmptyCell.h"
#import "JUDIAN_READ_UserBriefViewModel.h"
#import "JUDIAN_READ_UserAlbumController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+JUDIAN_READ_Blur.h"
#import "JUDIAN_READ_ImageCropperViewController.h"
#import "JUDIAN_READ_UserPhotoMenu.h"
#import "JUDIAN_READ_UserInfoEditorController.h"
#import "JUDIAN_READ_UserAreaListController.h"
#import "JUDIAN_READ_UserShippingAddressController.h"
#import "JUDIAN_READ_DatePickerContainer.h"
#import "JUDIAN_READ_UserSexMenu.h"
#import "JUDIAN_READ_UserAlbumModel.h"

#define UserProfileThumbCell @"UserProfileThumbCell"
#define UserBriefItemCell @"UserBriefItemCell"
#define UserBriefEmptyCell @"UserBriefEmptyCell"


@interface JUDIAN_READ_UserBriefViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
JUDIAN_READ_ImageCropperDelegate>

@property(nonatomic, strong)JUDIAN_READ_UserBriefModel* briefModel;
@property(nonatomic, strong)UIImage* portraitImage;
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, strong)JUDIAN_READ_UserPhotoMenu* photoMenu;
@property (nonatomic, strong)JUDIAN_READ_DatePickerContainer* birthdayDatePickerContainer;
@property (nonatomic, strong)JUDIAN_READ_UserSexMenu* sexPickerContainer;

@end

@implementation JUDIAN_READ_UserBriefViewController

+ (void)enterUserBriefViewController:(UINavigationController*)navigationController {
    JUDIAN_READ_UserBriefViewController* viewController = [[JUDIAN_READ_UserBriefViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addTableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectArea:) name:@"areaHandler" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:YES];
    
    [self initUserBrief];
}


- (void)initUserBrief {
    WeakSelf(that);
    [JUDIAN_READ_UserBriefModel buildModel:^(id  _Nullable args) {
        that.briefModel = args;
        [that.tableView reloadData];
    }];
}



- (void)addNavigationView {
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:@"个人信息" rightTitle:@""];
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
    
    self.title = @"个人信息";
}


- (void)addTableView {
    
    NSInteger navigationHeight = [self getNavigationHeight];
    NSInteger yPosition = 0;
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger height = SCREEN_HEIGHT - navigationHeight;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_UserProfileThumbCell class] forCellReuseIdentifier:UserProfileThumbCell];
    [tableView registerClass:[JUDIAN_READ_UserBriefItemCell class] forCellReuseIdentifier:UserBriefItemCell];
    [tableView registerClass:[JUDIAN_READ_UserBriefEmptyCell class] forCellReuseIdentifier:UserBriefEmptyCell];

}



- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}

- (void)selectArea:(NSNotification*)obj {
    BOOL isFirst = FALSE;
    if (_briefModel.province.length <= 0) {
        isFirst = TRUE;
    }
    _briefModel.area = obj.object[@"areaName"];
    WeakSelf(that);
    [_briefModel saveUserBriefModel:^(id  _Nullable args) {
        [that initUserBrief];
        
        [GTCountSDK trackCountEvent:@"personal_information" withArgs:@{@"infor_option" : @"地区"}];
        [MobClick event:@"personal_information" attributes:@{@"infor_option" : @"地区"}];
        
    } viewController:self isFirst:isFirst];

}

#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        JUDIAN_READ_UserProfileThumbCell* cell = [tableView dequeueReusableCellWithIdentifier:UserProfileThumbCell];
        WeakSelf(that);
        cell.block = ^(id  _Nullable args) {
            [that showPhoteMenu];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_portraitImage) {
            [cell updateImage:_portraitImage];
        }
        else {
            NSString* url = self.briefModel.headImg;
            [cell updateImageWithUrl:url];
        }
        
        return cell;
    }
    
    NSString* content = @"未填写";
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            JUDIAN_READ_UserBriefEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:UserBriefEmptyCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

        JUDIAN_READ_UserBriefItemCell* cell = [tableView dequeueReusableCellWithIdentifier:UserBriefItemCell];
        if (indexPath.row == 0) {
            if (_briefModel.nickname.length > 0) {
                content = _briefModel.nickname;
            }
            [cell updateCell:@"昵称" content:content bottomLine:YES];
        }
        else if (indexPath.row == 1) {
            if (_briefModel.sex.integerValue > 0) {
                content = [_briefModel getSexName];
            }
            [cell updateCell:@"性别" content:content bottomLine:YES];
        }
        else if (indexPath.row == 2) {
            if (_briefModel.wxNo.length > 0) {
                content = _briefModel.wxNo;
            }
            [cell updateCell:@"微信号" content:content bottomLine:YES];
        }
        else if (indexPath.row == 3) {
            if (_briefModel.birthday.length > 0) {
                content = _briefModel.birthday;
            }
            [cell updateCell:@"生日" content:content bottomLine:NO];
        }
        return cell;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            JUDIAN_READ_UserBriefEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:UserBriefEmptyCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        JUDIAN_READ_UserBriefItemCell* cell = [tableView dequeueReusableCellWithIdentifier:UserBriefItemCell];
        if (indexPath.row == 0) {
            if (_briefModel.profession.length > 0) {
                content = _briefModel.profession;
            }
            [cell updateCell:@"职业" content:content bottomLine:YES];
        }
        else if (indexPath.row == 1) {
            if (_briefModel.area.length > 0) {
                content = _briefModel.area;
                if ([content containsString:@"重庆"] && [content containsString:@"县"]) {
                    content = @"重庆市";
                }
            }
            [cell updateCell:@"地区" content:content bottomLine:YES];
        }
        else if (indexPath.row == 2) {
            if (_briefModel.personProfile.length > 0) {
                content = _briefModel.personProfile;
            }
            
            if (content.length <= 0) {
                content = @"未填写";
            }
            else {
                content = @"";
            }

            [cell updateCell:@"个性签名" content:content bottomLine:NO];
        }
        
        return cell;
    }
    

    if (indexPath.section == 3) {
        JUDIAN_READ_UserBriefItemCell* cell = [tableView dequeueReusableCellWithIdentifier:UserBriefItemCell];
        if (_briefModel.deliveryAddr.length > 0) {
            content = _briefModel.deliveryAddr;
        }
        [cell updateCell:@"收货地址" content:@"" bottomLine:NO];
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            return 10;
        }
        return 53;
    }
    
    
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            return 10;
        }
        return 53;
    }
    
    if (indexPath.section == 3) {
        return 53;
    }
    
    return 0;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 5;
    }
    
    if (section == 2) {
        return 4;
    }
    
    if (section == 3) {
        return 1;
    }
    
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [JUDIAN_READ_UserInfoEditorController enterUserInfoEditor:self.navigationController title:@"昵称" placeholder:@"" userBriefModel:_briefModel];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self createSexPicker];
        return;
    }

    if (indexPath.section == 1 && indexPath.row == 2) {
        [JUDIAN_READ_UserInfoEditorController enterUserInfoEditor:self.navigationController title:@"微信号" placeholder:@"填写微信号，与书友交流更方便哦~" userBriefModel:_briefModel];
        return;
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        [self createDatePicker];
        return;
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [JUDIAN_READ_UserInfoEditorController enterUserInfoEditor:self.navigationController title:@"职业" placeholder:@"填写职业，发现同行书友~" userBriefModel:_briefModel];
        return;
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        [JUDIAN_READ_UserAreaListController enterUserAreaList:self.navigationController nextCascade:NO];
        return;
    }

    if (indexPath.section == 2 && indexPath.row == 2) {
        [JUDIAN_READ_UserInfoEditorController enterUserInfoEditor:self.navigationController title:@"个性签名" placeholder:@"填写个性签名，更容易被别人发现哦~" userBriefModel:_briefModel];
        return;
    }
    
    if (indexPath.section == 3) {
        [JUDIAN_READ_UserShippingAddressController enterShippingAddresssController:self.navigationController block:nil];
        return;
    }
    
}


#pragma mark 进入相册控制器
- (void)enterAlbumViewController {

    WeakSelf(that);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JUDIAN_READ_UserAlbumController enterUserAlbumController:that.navigationController block:^(id arg1, id arg2) {
                    that.portraitImage = arg1;
                    [that.tableView reloadData];
                    
                    [JUDIAN_READ_UserAlbumModel uploadImage:arg1 block:^(id  _Nullable args) {
                        NSDictionary* dictionary = args;
                        if (dictionary) {
                            NSNumber* coins = dictionary[@"data"][@"info"][@"coins"];
                            if (coins.intValue > 0) {
                                NSString* tip = [NSString stringWithFormat:@"恭喜你获得%ld元宝", (long)coins.integerValue];
                                [MBProgressHUD showTipWithImage:tip image:[UIImage imageNamed:@"ingots_toast_tip"] toVc:that];
                            }
                            else {
                                [MBProgressHUD showMessage:@"头像上传成功"];
                            }
                            
                            [GTCountSDK trackCountEvent:@"personal_information" withArgs:@{@"infor_option" : @"头像"}];
                            [MobClick event:@"personal_information" attributes:@{@"infor_option" : @"头像"}];
                            
                        }
                        else {
                            [MBProgressHUD showMessage:@"头像上传失败"];
                        }
                    }];
                }];
            });
        }else {
            [JUDIAN_READ_TestHelper showSystemSettingAlert:@"请在系统设置中,启用“照片”服务" viewController:self];
        }
    }];
}



#pragma mark 进入相机控制器
- (void)enterCameraViewController {

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [JUDIAN_READ_TestHelper showSystemSettingAlert:@"请在系统设置中,启用“相机”服务" viewController:self];
        return;
    }
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* image = info[@"UIImagePickerControllerOriginalImage"];
    //image = [image scaleImage];
    [picker dismissViewControllerAnimated:YES completion:^{
       [self showEditImageController:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)showEditImageController:(UIImage *)image {
    CGFloat y = (self.view.bounds.size.height - self.view.bounds.size.width) / 2.0;
    JUDIAN_READ_ImageCropperViewController *imageCropper = [[JUDIAN_READ_ImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.width) limitScaleRatio:3];
    imageCropper.delegate = self;
    [self.navigationController pushViewController:imageCropper animated:YES];
}


#pragma mark 图片截取协议
- (void)imageCropper:(JUDIAN_READ_ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
        UIImage* image = editedImage;
        _portraitImage = image;
        [self.tableView reloadData];
    
        WeakSelf(that);
        [JUDIAN_READ_UserAlbumModel uploadImage:image block:^(id  _Nullable args) {
            NSDictionary* dictionary = args;
            if (dictionary) {
                NSNumber* coins = dictionary[@"data"][@"info"][@"coins"];
                if (coins.intValue > 0) {
                    NSString* tip = [NSString stringWithFormat:@"恭喜你获得%ld元宝", coins.integerValue];
                    [MBProgressHUD showTipWithImage:tip image:[UIImage imageNamed:@"ingots_toast_tip"] toVc:that];
                }
                else {
                    [MBProgressHUD showMessage:@"头像上传成功"];
                }
                
                [GTCountSDK trackCountEvent:@"personal_information" withArgs:@{@"infor_option" : @"头像"}];
                [MobClick event:@"personal_information" attributes:@{@"infor_option" : @"头像"}];
            }
            else {
                [MBProgressHUD showMessage:@"头像上传失败"];
            }
        }];
    
    
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


- (void)imageCropperDidCancel:(JUDIAN_READ_ImageCropperViewController *)cropperViewController {
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}


#pragma mark 弹出选择图片/相机窗口
- (void)showPhoteMenu {
    
    _photoMenu = [[JUDIAN_READ_UserPhotoMenu alloc]init];
    _photoMenu.frame = self.view.bounds;
    [self.view addSubview:_photoMenu];
    
    WeakSelf(that);
    _photoMenu.block = ^(id  _Nullable args) {
        NSString* cmd = args;
        if ([cmd isEqualToString:@"photo"]) {
            [that enterAlbumViewController];
        }
        else {
            [that enterCameraViewController];
        }
    };
    
    
    [_photoMenu showView];
}

#pragma mark 创建日期
- (void)createDatePicker {
    
    WeakSelf(that);
    
    _birthdayDatePickerContainer = [[JUDIAN_READ_DatePickerContainer alloc] init];
    [_birthdayDatePickerContainer setDefaultDate:self.briefModel.birthday];
    _birthdayDatePickerContainer.frame = self.view.bounds;
    _birthdayDatePickerContainer.block = ^(id  _Nullable args) {
        BOOL isFirst = FALSE;
        if (that.briefModel.birthday.length <= 0) {
            isFirst = TRUE;
        }
        that.briefModel.birthday = args;        
        [that.briefModel saveUserBriefModel:^(id  _Nullable args) {
            [that initUserBrief];
            
            [GTCountSDK trackCountEvent:@"personal_information" withArgs:@{@"infor_option" : @"生日"}];
            [MobClick event:@"personal_information" attributes:@{@"infor_option" : @"生日"}];
        } viewController:that isFirst:isFirst];
    };
    
    [self.view addSubview:_birthdayDatePickerContainer];
    
    [_birthdayDatePickerContainer showView];
}


#pragma mark 创建性别
- (void)createSexPicker {
    
    WeakSelf(that);
    _sexPickerContainer = [[JUDIAN_READ_UserSexMenu alloc] init];
    _sexPickerContainer.frame = self.view.bounds;
    
    _sexPickerContainer.block = ^(id  _Nullable args) {
        
        BOOL isFirst = FALSE;
        if (!that.briefModel.sex || that.briefModel.sex.intValue == 0) {
            isFirst = TRUE;
        }
        
        [that.briefModel updateSex:args];
        [that.briefModel saveUserBriefModel:^(id  _Nullable args) {
            [that initUserBrief];
            
            [GTCountSDK trackCountEvent:@"personal_information" withArgs:@{@"infor_option" : @"性别"}];
            [MobClick event:@"personal_information" attributes:@{@"infor_option" : @"性别"}];
            
        } viewController:that isFirst:isFirst];
    };
    
    [self.view addSubview:_sexPickerContainer];
    
    NSString* name = [_briefModel getSexName];
    [_sexPickerContainer showView:name];
}

#pragma mark 结束
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
