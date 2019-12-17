//
//  JUDIAN_READ_NovelCatalogInformationView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelCatalogInformationView.h"

#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_UserReadingModel.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_HorizontalStyleButton.h"


@interface JUDIAN_READ_NovelCatalogInformationView ()
@property(nonatomic, weak)UILabel* chapterCountLabel;
@property(nonatomic, weak)UILabel* catalogLabel;
@property(nonatomic, weak)UILabel* cachedLabel;
@property(nonatomic, weak)JUDIAN_READ_HorizontalStyleButton* sortButton;
@end


@implementation JUDIAN_READ_NovelCatalogInformationView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    UILabel* chapterCountLabel = [[UILabel alloc]init];
    _chapterCountLabel = chapterCountLabel;
    chapterCountLabel.textColor = RGB(0x66, 0x66, 0x66);
    chapterCountLabel.font = [UIFont systemFontOfSize:12];
    chapterCountLabel.text = @"";
    [self addSubview:chapterCountLabel];
    
    
    UILabel* catalogLabel = [[UILabel alloc]init];
    _catalogLabel = catalogLabel;
    catalogLabel.textColor = RGB(0x33, 0x33, 0x33);
    catalogLabel.font = [UIFont systemFontOfSize:17];
    catalogLabel.text = @"目录";
    catalogLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:catalogLabel];
    
    
    UILabel* cachedLabel = [[UILabel alloc]init];
    _cachedLabel = cachedLabel;
    cachedLabel.textColor = RGB(0x66, 0x66, 0x66);
    cachedLabel.font = [UIFont systemFontOfSize:12];
    cachedLabel.text = @"";
    
    cachedLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:cachedLabel];
    
    
    WeakSelf(that);
    [catalogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(13);
        make.height.equalTo(@(17));
        make.centerY.equalTo(that.mas_centerY);
        make.width.equalTo(@(0));
    }];
    
    
    [chapterCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(catalogLabel.mas_right).offset(10);
        make.height.equalTo(@(12));
        make.bottom.equalTo(catalogLabel.mas_bottom);
        make.width.equalTo(@(0));
    }];
    
    
    [cachedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-13);
        make.height.equalTo(@(12));
        make.centerY.equalTo(that.mas_centerY);
        make.width.equalTo(@(0));
    }];
    
    
    
    JUDIAN_READ_HorizontalStyleButton *sortButton = [[JUDIAN_READ_HorizontalStyleButton alloc] initWithTitle:CGRectMake(0, 0, 26, 12) imageFrame:CGRectMake(0, 0, 13, 13)];
    [sortButton setTitle:@"正序" forState:UIControlStateNormal];
    sortButton.isClicked = TRUE;
    _sortButton = sortButton;
    [sortButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:sortButton];
    
    [sortButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:UIControlStateNormal];
    [sortButton setImage:[UIImage imageNamed:@"reader_asc_sort_tip"] forState:UIControlStateNormal];
    
    [sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(45));
        make.height.equalTo(@(20));
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    
}




- (void)handleTouchEvent:(JUDIAN_READ_HorizontalStyleButton*)sender {
    
    NSString* sortType = @"0";
    
    sender.isClicked = !sender.isClicked;
    if (sender.isClicked) {
        [sender setTitle:@"正序" forState:UIControlStateNormal];
        sortType = @"0";
    }
    else {
        [sender setTitle:@"倒序" forState:UIControlStateNormal];
        sortType = @"1";
    }
    
    if (_block) {
        _block(sortType);
    }
}




- (void)setTextWithModel:(JUDIAN_READ_NovelSummaryModel*)model {
    /*
    NSString* text = @"";
    if([JUDIAN_READ_UserReadingModel getCachedStatus:model.nid]){
        text = @"已缓存";
    }
    else {
        text = @"缓存";;
    }
    
    NSString* value = [JUDIAN_READ_NovelManager shareInstance].downloadingDictionary[model.nid];
    if (value) {
        text = @"已缓存";
    }
    
    _cachedLabel.text = text;
     */
    
    _chapterCountLabel.text = [NSString stringWithFormat:@"共%@章", model.chapters_total];
    
    CGFloat countLabelWidth = [_chapterCountLabel getTextWidth:12];
    [_chapterCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(countLabelWidth));
    }];
    
    
    
    CGFloat catalogLabelWidth = [_catalogLabel getTextWidth:17];
    [_catalogLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(catalogLabelWidth));
    }];
    
    
    CGFloat cahedLabelWidth = [_chapterCountLabel getTextWidth:12];
    [_cachedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(cahedLabelWidth));
    }];
    
    
}






@end
