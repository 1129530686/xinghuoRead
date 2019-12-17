//
//  JUDIAN_READ_InviteFriendRuleCell.m
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_InviteFriendRuleCell.h"

@implementation JUDIAN_READ_InviteFriendRuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
 //
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
 
    UIImageView* imageView = [[UIImageView alloc] init];
    
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    //imageView.clipsToBounds = YES;
    
    imageView.image = [UIImage imageNamed:@"invite_friend_rule_bg"];
    [self.contentView addSubview:imageView];
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(22);
        make.right.equalTo(that.contentView.mas_right).offset(-22);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-27);
    }];
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
