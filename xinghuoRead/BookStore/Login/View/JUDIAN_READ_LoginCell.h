//
//  JUDIAN_READ_LoginCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/28.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"
#import "JUDIAN_READER_PhoneCodeButton.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_LoginCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet JUDIAN_READER_PhoneCodeButton *trailBtn;
@property (nonatomic,copy) CompletionBlock getBlock;//获取验证码
@property (nonatomic,copy) void (^tfBlock)(JUDIAN_READ_LoginCell *cellSelf, NSString *str);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailBtnSpace;

- (void)setKeyboardType:(UIKeyboardType)type;

- (void)setDataWithIndexPath:(NSIndexPath *)indexPath model:(id)model;

- (void)setChangePhoneDataWithIndexPath:(NSIndexPath *)indexPath model:(id)model placeArr:(NSArray *)places;

- (void)setMWithDrawDataWithIndexPath:(NSIndexPath *)indexPath model:(id)model placeArr:(NSArray *)places;



@end

NS_ASSUME_NONNULL_END
