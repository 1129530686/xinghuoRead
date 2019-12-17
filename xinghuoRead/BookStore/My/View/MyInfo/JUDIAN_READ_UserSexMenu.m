//
//  JUDIAN_READ_UserSexMenu.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserSexMenu.h"


#define ITEM_HEIGHT 47

#define BUTTON_PHOTO_TAG 100
#define BUTTON_CAMERA_TAG 101
#define BUTTON_CANCEL_TAG 102

@interface JUDIAN_READ_UserSexMenu ()
<UIPickerViewDelegate,
UIPickerViewDataSource>
@property(nonatomic, weak)UIView* container;
@property(nonatomic, weak)UIPickerView* pickerView;
@property(nonatomic, assign)NSInteger selectedRow;
@end


@implementation JUDIAN_READ_UserSexMenu


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addContainer];
        [self addSexPicker];
        [self addBarView];
    }
    return self;
}



- (void)addContainer {
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    _container = container;
    
    NSInteger height = [self getContainerHeight];
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(height));
        make.bottom.equalTo(that.mas_bottom).offset(height);
    }];
    
}





- (void)addSexPicker {
    
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [_container addSubview:pickerView];
    
    NSInteger bottomOffset = [self getBottomOffset];
    WeakSelf(that);
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(153));
        make.bottom.equalTo(that.container.mas_bottom).offset(-bottomOffset);
    }];

}



- (void)addBarView {
    UIView* barView = [[UIView alloc] init];
    barView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [_container addSubview:barView];
    
    
    UIButton* leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:(UIControlStateNormal)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    [_container addSubview:leftButton];
    
    
    UIButton* rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:(UIControlStateNormal)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confrim) forControlEvents:(UIControlEventTouchUpInside)];
    [_container addSubview:rightButton];
    
    WeakSelf(that);
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.pickerView.mas_top);
    }];
    
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(@(56));
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.pickerView.mas_top);
    }];
    
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right);
        make.width.equalTo(@(56));
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.pickerView.mas_top);
    }];
    
    
}



- (void)dateChange:(UIDatePicker *)datePicker {
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"yyyy-MM-dd";
    //_selectedDateString = [formatter stringFromDate:datePicker.date];
}



- (NSInteger)getContainerHeight {
    NSInteger bottomOffset = [self getBottomOffset];
    return 193 + bottomOffset;
}


- (NSInteger)getBottomOffset {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    return bottomOffset;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}



- (void)showView:(NSString*)sexName {
    
    if ([sexName isEqualToString:@"女"]) {
        _selectedRow = 0;
    }
    else {
        _selectedRow = 1;
    }
    
    [_pickerView selectRow:_selectedRow inComponent:0 animated:YES];
    
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




- (void)confrim {
    if (_block) {
        NSString* sexName = [self getSexName:_selectedRow];
        _block(sexName);
    }
    
    [self hideView];
}


- (void)cancel {
    [self hideView];
}



#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getSexName:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRow = row;
}

- (NSString*)getSexName:(NSInteger)row {
    if (row == 0) {
        return @"女";
    }
    if (row == 1) {
        return @"男";
    }
    return @"";
}


#if 0
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:15];
        pickerLabel.contentMode = UIViewContentModeCenter;
        pickerLabel.textColor = [UIColor blueColor];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIView* view = [self pickerView:pickerView viewForRow:row forComponent:component reusingView:nil];
    view.backgroundColor = [UIColor greenColor];
}
#endif
@end
