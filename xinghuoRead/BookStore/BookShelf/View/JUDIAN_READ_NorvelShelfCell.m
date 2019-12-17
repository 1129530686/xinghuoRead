//
//  JUDIAN_READ_NorvelShelfCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_NorvelShelfCell.h"
#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_UserReadingModel.h"
#import "JUDIAN_READ_ReadListModel.h"

@interface JUDIAN_READ_NorvelShelfCell ()

@property (nonatomic,strong) NSMutableArray  *arr;


@end

@implementation JUDIAN_READ_NorvelShelfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0.5 color:KSepColor cornerRadius:3];
    [self.storeLab doBorderWidth:0.5 color:kColor204 cornerRadius:2];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)trailbtnAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}


- (void)setShelfDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.trailBtn.hidden = YES;
    self.iconHeight.constant = iPhone6Plus ? 91 : 81;
    self.iconWidth.constant = iPhone6Plus ? 64: 57;
    JUDIAN_READ_NovelSummaryModel *info = model[indexPath.row];
    self.topLab.hidden = NO;
    self.centerUnreadLab.hidden = NO;
    self.sepView.hidden = NO;
    self.bottomLab.hidden = NO;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.topLab.text = info.bookname;
    self.centerLab.text = info.read_chapter;
    self.centerUnreadLab.text = info.unread;
    [self setInfo:info];
    
}

- (void)setInfo:(JUDIAN_READ_NovelSummaryModel *)info{
    if (info.update_status.integerValue != 1) {
        self.storeLab.hidden = NO;
        [self.storeLab doBorderWidth:0 color:nil cornerRadius:2];
        self.leadConstant.constant = 7;
    }else{
        self.storeLab.hidden = YES;
        self.storeLab.text = @"";
        self.leadConstant.constant = 0;
    }
    
    if (info.update_status.integerValue == 1) {
        self.bottomLab.text = [NSString stringWithFormat:@" 完结 "];
        self.bottomLab.textColor = kColorGreen;
        [self.bottomLab doBorderWidth:0.5 color:kColorGreen cornerRadius:2];
    }else{
        self.bottomLab.text = [NSString stringWithFormat:@" 连载 "];
        self.bottomLab.textColor = kColorOrange;
        [self.bottomLab doBorderWidth:0.5 color:kColorOrange cornerRadius:2];
    }
    
    if([JUDIAN_READ_UserReadingModel getCachedStatus:info.nid]){
        self.trailLab.hidden = NO;
        [self.trailLab doBorderWidth:0.5 color:kColor204 cornerRadius:2];
    }else{
        self.trailLab.hidden = YES;
    }
}


- (void)setShelfDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath selectItem:(NSInteger)item isEditing:(BOOL)isEditing{
    self.trailBtn.hidden = NO;
    if (item == 0 || isEditing) {
        self.trailBtn.hidden = YES;
    }
    
    self.iconHeight.constant = iPhone6Plus ? 91 : 81;
    self.iconWidth.constant = iPhone6Plus ? 64: 57;
    if ([model count] > indexPath.row && [model count] != 0) {
        JUDIAN_READ_NovelSummaryModel *info = model[indexPath.row];
        self.topLab.hidden = NO;
        self.centerUnreadLab.hidden = NO;
        self.sepView.hidden = NO;
        self.bottomLab.hidden = NO;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
        self.topLab.text = info.bookname;
        self.centerLab.text = info.read_chapter;
        self.centerUnreadLab.text = info.unread;
        [self setInfo:info];
        
        if (info.is_favorite_book.intValue) {
            [self.trailBtn setImage:[UIImage imageNamed:@"bookcase_collected_sel"] forState:UIControlStateNormal];
          
        }else{
            [self.trailBtn setImage:[UIImage imageNamed:@"bookcase_collected"] forState:UIControlStateNormal];
        }
        
    }else{
        self.iconView.image = [UIImage imageNamed:@"bookcase_add"];
        self.centerLab.text = @"添加喜欢的小说吧~";
        self.topLab.hidden = YES;
        self.centerUnreadLab.hidden = YES;
        self.sepView.hidden = YES;
        self.bottomLab.hidden = YES;
        self.trailBtn.hidden = YES;
        self.storeLab.hidden = YES;
        self.trailLab.hidden = YES;
    }

}

-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        self.sepView.layer.backgroundColor = kColor153.CGColor;
                        image.image=[UIImage imageNamed:@"bookcase_management_check_sel"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"bookcase_management_check"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
}



@end
