//
//  JUDIAN_READ_ChapterTitleItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterTitleItem.h"
#import "JUDIAN_READ_HorizontalStyleButton.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_NovelManager.h"


@interface JUDIAN_READ_ChapterTitleItem ()
@property(nonatomic, weak)JUDIAN_READ_HorizontalStyleButton* sortButton;
@property(nonatomic, weak)UILabel* directoryTipLabel;

@end




@implementation JUDIAN_READ_ChapterTitleItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}




- (void)addViews {
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"";
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    

    
    UIImage* downloadImage = [UIImage imageNamed:@"reader_catalog_download_tip"];
    
    UIButton* cacheButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage* image = [UIImage imageNamed:@"reader_catalog_cache_tip"];
    [cacheButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [cacheButton setImage:downloadImage forState:(UIControlStateNormal)];
    [cacheButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [cacheButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    cacheButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cacheButton setTitle:@"缓存" forState:(UIControlStateNormal)];
    cacheButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [cacheButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    _cacheButton = cacheButton;
    [self addSubview:cacheButton];
    [cacheButton addTarget:self action:@selector(handleCacheTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    UILabel* directoryTipLabel = [[UILabel alloc]init];
    directoryTipLabel.font = [UIFont systemFontOfSize:17];
    directoryTipLabel.text = @"目录";
    _directoryTipLabel = directoryTipLabel;
    [self addSubview:directoryTipLabel];
    
    
    UILabel* cacheCountLabel = [[UILabel alloc]init];
    cacheCountLabel.font = [UIFont systemFontOfSize:12];
    cacheCountLabel.text = @"";
    _cacheCountLabel = cacheCountLabel;
    
    [self addSubview:cacheCountLabel];
    
    
    
    JUDIAN_READ_HorizontalStyleButton *sortButton = [[JUDIAN_READ_HorizontalStyleButton alloc] initWithTitle:CGRectMake(0, 0, 26, 12) imageFrame:CGRectMake(2, 0, 13, 13)];
    [sortButton setTitle:@"正序" forState:UIControlStateNormal];
    sortButton.isClicked = TRUE;
    _sortButton = sortButton;
    [sortButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:sortButton];
    

    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-74);
        make.top.equalTo(that.mas_top).offset(37);
        make.height.equalTo(@(14));
    }];
    
    
    [cacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
        make.bottom.equalTo(that.mas_bottom).offset(-14);
        make.right.equalTo(that.mas_right).offset(-14);
    }];
    
    
    NSInteger width = [directoryTipLabel getTextWidth:17];
    [directoryTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.height.equalTo(@(17));
        make.bottom.equalTo(that.mas_bottom).offset(-17);
        make.width.equalTo(@(width));
    }];
    
    
    [cacheCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(directoryTipLabel.mas_right).offset(7);
        make.height.equalTo(@(12));
        make.bottom.equalTo(that.mas_bottom).offset(-17);
        make.right.equalTo(cacheButton.mas_left).offset(-10);
    }];
    
    
    [sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(45));
        make.height.equalTo(@(20));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
}



- (void)setViewStyle {
    
    NSString* text = @"已缓存";
    BOOL isCached = FALSE;
    if (_bookId) {
        isCached = [JUDIAN_READ_UserReadingModel getCachedStatus:_bookId];
        text = @"已缓存";
    }
    
    if (!isCached) {
        NSString* value = [JUDIAN_READ_NovelManager shareInstance].downloadingDictionary[_bookId];
        if (value) {
            isCached = TRUE;
            text = @"缓存中";
        }
    }
    
    _cacheButton.userInteractionEnabled = TRUE;
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        
        _directoryTipLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
        _titleLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
        _cacheCountLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
        
        [_sortButton setTitleColor:RGB(0xbb, 0xbb, 0xbb) forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"reader_asc_sort_tip_n"] forState:UIControlStateNormal];
        
        if (isCached) {
            
            _cacheButton.userInteractionEnabled = NO;
            
            _cacheButton.layer.cornerRadius = 3;
            _cacheButton.layer.masksToBounds = YES;
            _cacheButton.backgroundColor = RGB(0x33, 0x33, 0x33);
            [_cacheButton setBackgroundImage:nil forState:(UIControlStateNormal)];
            [_cacheButton setImage:nil forState:UIControlStateNormal];
            [_cacheButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_cacheButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_cacheButton setTitleColor:RGB(0x66, 0x66, 0x66) forState:(UIControlStateNormal)];
            [_cacheButton setTitle:text forState:(UIControlStateNormal)];
            _cacheButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        
    }
    else {
        _directoryTipLabel.textColor = RGB(0x33, 0x33, 0x33);
        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
        _cacheCountLabel.textColor = RGB(0x99, 0x99, 0x99);
        
        [_sortButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"reader_asc_sort_tip"] forState:UIControlStateNormal];
        
        if (isCached) {
            
            _cacheButton.userInteractionEnabled = NO;
            
            _cacheButton.layer.cornerRadius = 3;
            _cacheButton.layer.masksToBounds = YES;
            _cacheButton.backgroundColor = RGB(0xee, 0xee, 0xee);
            [_cacheButton setTitleColor:RGB(0xcc, 0xcc, 0xcc) forState:(UIControlStateNormal)];
            
            [_cacheButton setBackgroundImage:nil forState:(UIControlStateNormal)];
            [_cacheButton setImage:nil forState:UIControlStateNormal];
            [_cacheButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_cacheButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            
            [_cacheButton setTitle:text forState:(UIControlStateNormal)];
            _cacheButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
    }

}




- (void)handleTouchEvent:(JUDIAN_READ_HorizontalStyleButton*)sender {
    
    NSString* sortType = @"0";
    
    sender.isClicked = !sender.isClicked;
    if (sender.isClicked) {
        [sender setTitle:@"正序" forState:UIControlStateNormal];
        
        BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
        if (nightMode) {
            [sender setImage:[UIImage imageNamed:@"reader_asc_sort_tip_n"] forState:UIControlStateNormal];
        }
        else {
             [sender setImage:[UIImage imageNamed:@"reader_asc_sort_tip"] forState:UIControlStateNormal];
        }
        
        sortType = @"0";
    }
    else {
        [sender setTitle:@"倒序" forState:UIControlStateNormal];
        
        BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
        if (nightMode) {
            [sender setImage:[UIImage imageNamed:@"reader_desc_sort_tip_n"] forState:UIControlStateNormal];
        }
        else {
            [sender setImage:[UIImage imageNamed:@"reader_desc_sort_tip"] forState:UIControlStateNormal];
        }
        
        sortType = @"1";
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kChapterSortCmd),
                                                                                         @"value":sortType
                                                                                         }];
    
}





- (void)updateProgress:(NSString*)text {
    if ([text isEqualToString:@"已缓存"]) {
        [self setViewStyle];
    }
    else {
        [_cacheButton setTitle:text forState:(UIControlStateNormal)];
    }
}





- (void)handleCacheTouchEvent:(UIButton*)sender {

    _cacheButton.userInteractionEnabled = FALSE;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kDownloadCmd)
                                                                                         }];
    
}





@end
