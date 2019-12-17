//
//  JUDIAN_READ_MoreMenu.m
//  xinghuoRead
//
//  Created by judian on 2019/4/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_MoreMenu.h"
#import "JUDIAN_READ_MoreItem.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_MoreMenu ()
@property(nonatomic, strong)UIImageView* bgImageView;
@end



@implementation JUDIAN_READ_MoreMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    _bgImageView = [[UIImageView alloc]init];
    [self addSubview:_bgImageView];
    
    WeakSelf(that);
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(that.mas_top).offset(0);
        make.right.equalTo(that.mas_right).offset(0);
        make.width.equalTo(that.mas_width);
        make.height.equalTo(that.mas_height);
        
    }];
    
    
    JUDIAN_READ_MoreItem* shareItem = [[JUDIAN_READ_MoreItem alloc]initWithTitle:@"分享" imageName:@"reader_menu_item_share" bottomLine:TRUE];
    [self addSubview:shareItem];
    shareItem.tag = kMenuItemShareCmd;
    [shareItem addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
 
    [shareItem mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(that.mas_top).offset(kReaderMoreMenuItemOffset);
        make.height.equalTo(@(kReaderMoreMenuItemHeight));
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);

    }];
    
    
    JUDIAN_READ_MoreItem* introductionItem = [[JUDIAN_READ_MoreItem alloc]initWithTitle:@"简介" imageName:@"reader_menu_item_introduction" bottomLine:TRUE];
    [self addSubview:introductionItem];
    introductionItem.tag = kMenuItemIntroductionCmd;
    [introductionItem addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [introductionItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareItem.mas_bottom);
        make.height.equalTo(@(kReaderMoreMenuItemHeight));
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        
    }];
    
    
    JUDIAN_READ_MoreItem* feedbackItem = [[JUDIAN_READ_MoreItem alloc]initWithTitle:@"报错" imageName:@"reader_menu_item_feedback" bottomLine:FALSE];
    [self addSubview:feedbackItem];
    feedbackItem.tag = kMenuItemFeedbackCmd;
    
    [feedbackItem addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [feedbackItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(introductionItem.mas_bottom);
        make.height.equalTo(@(kReaderMoreMenuItemHeight));
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        
    }];
    
}


- (void)setBgImageName:(NSString *)bgImageName {
    _bgImageName = bgImageName;
    
}




- (void)setViewStyle {
 
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _bgImageView.image = [UIImage imageNamed:@"reader_more_menu_tip_n"];
        
        JUDIAN_READ_MoreItem* shareItem = [self viewWithTag:kMenuItemShareCmd];
        [shareItem setViewStyle:@"reader_menu_item_share_n" nightMode:nightMode];
        
        JUDIAN_READ_MoreItem* instruductionItem = [self viewWithTag:kMenuItemIntroductionCmd];
        [instruductionItem setViewStyle:@"reader_menu_item_introduction_n" nightMode:nightMode];
        
        
        JUDIAN_READ_MoreItem* feedbackItem = [self viewWithTag:kMenuItemFeedbackCmd];
        [feedbackItem setViewStyle:@"reader_menu_item_feedback_n" nightMode:nightMode];
        
    }
    else {
        _bgImageView.image = [UIImage imageNamed:@"reader_more_menu_tip"];
        
        JUDIAN_READ_MoreItem* shareItem = [self viewWithTag:kMenuItemShareCmd];
        [shareItem setViewStyle:@"reader_menu_item_share" nightMode:nightMode];
        
        JUDIAN_READ_MoreItem* instruductionItem = [self viewWithTag:kMenuItemIntroductionCmd];
        [instruductionItem setViewStyle:@"reader_menu_item_introduction" nightMode:nightMode];
        
        
        JUDIAN_READ_MoreItem* feedbackItem = [self viewWithTag:kMenuItemFeedbackCmd];
        [feedbackItem setViewStyle:@"reader_menu_item_feedback" nightMode:nightMode];
    }

}



- (void)handleTouchEvent:(UIControl*)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(sender.tag)}];
}




@end
