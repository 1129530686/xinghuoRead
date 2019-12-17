//
//  JUDIAN_READ_ChapterListItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterListItem.h"
#import "JUDIAN_READ_ChapterTitleCell.h"
#import "JUDIAN_READ_VerticalSlider.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_ChapterListItem ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSArray* dataSource;

@property(nonatomic, weak)JUDIAN_READ_VerticalSlider* slider;

@end



@implementation JUDIAN_READ_ChapterListItem


- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSource = [NSArray array];
        _clickIndex = 0;
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    tableView.estimatedRowHeight = 0;

    [self addSubview:tableView];
    
    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
    NSString* imageName = @"reader_catalog_slider_thumb";
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        imageName = @"reader_catalog_slider_thumb_n";
    }

    JUDIAN_READ_VerticalSlider* slider = [[JUDIAN_READ_VerticalSlider alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _slider = slider;
    [slider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:slider];

    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    _slider.hidden = YES;
    [_slider addTarget:self action:@selector(contentOffsetValueChanged:) forControlEvents:UIControlEventValueChanged];//

}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_tableView.contentSize.height > 0) {
        _slider.hidden = NO;
    }
    
    _slider.frame = CGRectMake(self.frame.size.width - SLIDER_WIDTH, 0, SLIDER_WIDTH, self.frame.size.height);
    [_slider updateViewFrame];

    _slider.minimumValue = 0;
    _slider.maximumValue = _tableView.contentSize.height - self.frame.size.height;
    _slider.value = _slider.maximumValue;
    _slider.continuous = YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"chapterTitleCell";
    JUDIAN_READ_ChapterTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JUDIAN_READ_ChapterTitleCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == _clickIndex) {
        cell.isClicked = TRUE;
    }
    else {
        cell.isClicked = FALSE;
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataSource.count > 0) {
        [cell setTitleWithModel:_dataSource[indexPath.row]];
    }
    
    [cell setViewStyle];

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSource.count <= 0) {
        return;
    }
    
    _clickIndex = indexPath.row;
    [tableView reloadData];
    
    JUDIAN_READ_ChapterTitleModel* model = _dataSource[indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kChapterContentCmd),
                                                                                         @"value":model.chapnum
                                                                                         }];
}



- (void)realoadData:(NSArray*)array {
    _dataSource = [array copy];
    [_tableView reloadData];
    
    WeakSelf(that);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [that setNeedsLayout];
    });

}




- (void)scrollToTop:(NSInteger)index {
    //that.clickIndex
    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (that.dataSource.count <= 0) {
            return;
        }
        
        if (that.dataSource.count <= index) {
            return;
        }
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [that.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:(YES)];
    });
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _slider.value = _slider.maximumValue - scrollView.contentOffset.y;
}



- (void)contentOffsetValueChanged:(UISlider*)sender {
    
    CGFloat y = (_slider.maximumValue - sender.value);
    [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, y)];

}



@end
