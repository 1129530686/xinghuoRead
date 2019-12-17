//
//  JUDIAN_READ_FriendCell.m
//  universalRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_FriendCell.h"
#import "JUDIAN_READ_InviteFriendModel.h"

@implementation JUDIAN_READ_FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:20];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFriendDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_InviteFriendModel *info = model[indexPath.row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.headImg] placeholderImage:[UIImage imageNamed:@"head_default_big"]];
    self.nameLab.text = info.nickname;
    self.timeLab.text = info.updateTime;
    self.idLab.text = info.uidb;
}

@end
