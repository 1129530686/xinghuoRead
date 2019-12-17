//
//  JUDIAN_READ_DatePickerContainer.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_DatePickerContainer.h"

@interface JUDIAN_READ_DatePickerContainer ()
@property(nonatomic, weak)UIView* container;
@property(nonatomic, strong)UIDatePicker* birthdayDatePicker;
@property(nonatomic, copy)NSString* selectedDateString;
@end



@implementation JUDIAN_READ_DatePickerContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addContainer];
        [self addDatePicker];
        [self addBarView];
        
        _selectedDateString = [self getDateString:[NSDate date]];
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





- (void)addDatePicker {
    
    _birthdayDatePicker = [[UIDatePicker alloc] init];
    _birthdayDatePicker.backgroundColor = [UIColor whiteColor];
    //设置地区: zh-中国
    _birthdayDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    _birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    // 设置当前显示时间
    [_birthdayDatePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [_birthdayDatePicker setMaximumDate:[NSDate date]];
    
    //监听DataPicker的滚动
    [_birthdayDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    [_container addSubview:_birthdayDatePicker];
    
    NSInteger bottomOffset = [self getBottomOffset];
    
    WeakSelf(that);
    [_birthdayDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [leftButton addTarget:self action:@selector(cancelDate) forControlEvents:(UIControlEventTouchUpInside)];
    [_container addSubview:leftButton];
    
    
    UIButton* rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:(UIControlStateNormal)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confrimDate) forControlEvents:(UIControlEventTouchUpInside)];
    [_container addSubview:rightButton];
    
    WeakSelf(that);
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.birthdayDatePicker.mas_top);
    }];
    
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(@(56));
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.birthdayDatePicker.mas_top);
    }];
    
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right);
        make.width.equalTo(@(56));
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.birthdayDatePicker.mas_top);
    }];
    

}


- (void)setDefaultDate:(NSString*)dateStr {
    
    if (dateStr.length <= 0) {
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate* birthday = [formatter dateFromString:dateStr];
    _birthdayDatePicker.date = birthday;
    _selectedDateString = dateStr;
}


- (void)dateChange:(UIDatePicker *)datePicker {
    _selectedDateString = [self getDateString:datePicker.date];
}



- (NSString*)getDateString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
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




- (void)confrimDate {
    if (_block) {
        _block(_selectedDateString);
    }
    
    [self hideView];
}


- (void)cancelDate {
    [self hideView];
}





@end
