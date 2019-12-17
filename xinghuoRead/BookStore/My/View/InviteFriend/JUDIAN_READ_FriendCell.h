//
//  JUDIAN_READ_FriendCell.h
//  universalRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FriendCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *sepView;


- (void)setFriendDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
