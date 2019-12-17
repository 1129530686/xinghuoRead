//
//  JUDIAN_READ_CacheStoreCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/15.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CacheStoreCell.h"
#import "JUDIAN_READ_ReadListModel.h"

@implementation JUDIAN_READ_CacheStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:3];
    WeakSelf(obj);
    self.trailView.touchBlock = ^{
        [obj trailBtnAction:nil];
    };
    self.freeLab.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)trailBtnAction:(id)sender {
    if (self.downLoadBlock) {
        WeakSelf(obj);
        self.downLoadBlock(obj,nil);
    }
}


- (void)setDataWithRecordModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ReadListModel *info = model[indexPath.section];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.nameLab.text = info.bookname;
    self.timeLab.text = info.update_time;
    self.trailBtn.hidden = NO;
    self.statusLab.hidden = YES;
    self.trailView.hidden = YES;
    if (info.progress == 100) {
        [self.trailBtn setTitle:@"已缓存" forState:UIControlStateNormal];
        [self.trailBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.trailBtn.userInteractionEnabled = NO;
    }else if(!info.isLoading){ //未再下载
        [self.trailBtn setTitle:@"" forState:UIControlStateNormal];
        [self.trailBtn setImage:[UIImage imageNamed:@"cache_list_download"] forState:UIControlStateNormal];
        
        if (info.loadFail) {
            self.statusLab.hidden = NO;
            self.statusLab.text = @"缓存失败";
            [self.trailBtn setImage:[UIImage imageNamed:@"cache_list_failure"] forState:UIControlStateNormal];
        }
        self.trailBtn.userInteractionEnabled = YES;
    }else{
        self.trailBtn.hidden = YES;
        self.statusLab.hidden = NO;
        self.trailView.hidden = NO;
        self.statusLab.text = [NSString stringWithFormat:@"%ld%%",info.progress];
        self.trailView.progress = info.progress/100.0;
    }
}





@end

