//
//  JUDIAN_READ_TagView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_TagView.h"
#import "JUDIAN_READ_TagModel.h"
#import "JUDIAN_READ_TagCell.h"
#import "JUDIAN_READ_AppDelegate.h"

@interface JUDIAN_READ_TagView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) JUDIAN_READ_TagModel  *selectModel;


@end

@implementation JUDIAN_READ_TagView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.tableView];
    }
    return self;
}



#pragma mark 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3*46) style:UITableViewStylePlain];
        _tableView.rowHeight = 46;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_TagCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_TagCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    if (dataArr) {
        _tableView.height = 46*dataArr.count;
    }
    [self.tableView reloadData];
}
#pragma collectionview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_TagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_TagCell" forIndexPath:indexPath];
    [cell setTagDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        return;
    }
    
    JUDIAN_READ_TagModel *model = self.dataArr[indexPath.row];
    if (model.is_checkd.intValue == 1) {
        return;
    }
    for (JUDIAN_READ_TagModel *info in self.dataArr) {
        info.is_checkd = @"0";
    }
    
    model.is_checkd = [NSString stringWithFormat:@"%d",!(model.is_checkd.intValue)];
    self.selectModel = model;
    [tableView reloadData];
    
    [self removeFromSuperview];
    if (self.refreshBlock) {
        self.refreshBlock(model.title, self.selectModel.type);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
//    if (self.refreshBlock) {
//        self.refreshBlock(self.selectModel.title, self.selectModel.type);
//    }
}

@end
