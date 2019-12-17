//
//  JDNorvalCell.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import "JUDIAN_READ_NorvalColCell.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_BookDetailModel.h"
#import "JUDIAN_READ_BookStoreModel.h"

@implementation JUDIAN_READ_NorvalColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0.5 color:KSepColor cornerRadius:2];
    self.introduceLab.font = [UIFont systemFontOfSize:kAutoFontSize12_13];
    self.authorLab.font = [UIFont systemFontOfSize:kAutoFontSize12_13];
    self.countLab.font = [UIFont systemFontOfSize:kAutoFontSize10_11];
    self.popularLab.font = [UIFont systemFontOfSize:kAutoFontSize11_12];
    [self.countLab doBorderWidth:0.5 color:kColor204 cornerRadius:2];

}

//书城首页
- (void)setPushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.iconheight.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
    self.iconWidth.constant = (SCREEN_WIDTH-30-54)/4;
    NSArray *arr = model;
   
    JUDIAN_READ_ReadListModel *info = arr[indexPath.row]; 
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.nameLab.text = info.bookname;

    self.introduceLab.text = [info.brief removeAllWhitespace];
    self.authorLab.text = [info.author removeAllWhitespace];
    self.countLab.text = [NSString stringWithFormat:@" %@ ",info.cat_name];
    self.popularLab.text = [NSString stringWithFormat:@"%@人气",[self changeType:info.readingNum]];
}


- (void)setv0PushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_BookStoreModel *info1 = model;
    self.iconLead.constant = 0;
    self.iconheight.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
    self.iconWidth.constant = (SCREEN_WIDTH-30-54)/4;
    NSArray *arr;
    if (indexPath.section == 1) {
        arr = info1.push;
    }
    if (indexPath.section == 2) {
        arr = info1.like;
    }
    if (indexPath.section == 3) {
        arr = info1.newest;
    }
    if (indexPath.section == 4) {
        arr = info1.faves;
    }
    JUDIAN_READ_ReadListModel *info = arr[indexPath.row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.nameLab.text = info.bookname;
    
    self.introduceLab.text = info.brief;
    self.authorLab.text = info.author;
    self.countLab.text = [NSString stringWithFormat:@" %@ ",info.cat_name];
    self.popularLab.text = [NSString stringWithFormat:@"%@人气",[self changeType:info.readingNum]];

}

//搜索数据
- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.iconheight.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
    self.iconWidth.constant = (SCREEN_WIDTH-30-54)/4;
    JUDIAN_READ_BookDetailModel *info = model[indexPath.row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.nameLab.text = info.bookname;
    self.introduceLab.text = [info.brief removeAllWhitespace];
    NSString *str1 = [info.author stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    self.authorLab.text = str1;

    
    self.countLab.text = [NSString stringWithFormat:@" %@ ",info.cat_name];
    self.popularLab.text = [NSString stringWithFormat:@"%@人气",[self changeType:info.readingNum]];

}

- (void)setSearchPushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.iconheight.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
    self.iconWidth.constant = (SCREEN_WIDTH-30-54)/4;
    JUDIAN_READ_ReadListModel *info = model[indexPath.section][indexPath.row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    if ([info isKindOfClass:[JUDIAN_READ_BookDetailModel class]]) {
        self.nameLab.text = info.bookname;
    }else{
        self.nameLab.text = info.title;
    }
    self.introduceLab.text = [info.brief removeAllWhitespace];
    self.authorLab.text = info.author;
    self.countLab.text = [NSString stringWithFormat:@" %@ ",info.cat_name];
    self.popularLab.text = [NSString stringWithFormat:@"%@人气",[self changeType:info.readingNum]];

}

//子分类
- (void)setChildCategoryDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath tag:(NSString *)tag{
    JUDIAN_READ_BookDetailModel *info = model[indexPath.row];
    [self setSearchDataWithModel:model indexPath:indexPath];
    if (!tag || !tag.length) {
        self.popularLab.text = [NSString stringWithFormat:@"%@粉丝",[self changeType:info.favoriteNum]];

    }else{
        self.popularLab.text = [NSString stringWithFormat:@"%@人气",[self changeType:info.readingNum]];

    }
    self.countLab.hidden = YES;
    
}

- (NSString *)changeType:(NSString *)str{
    NSString *x;
    if (str.intValue >= 10000) {
        x =  [NSString stringWithFormat:@"%.1f万",str.intValue/10000.0];
    }else{
        x = [NSString stringWithFormat:@"%@",str];
    }
    return x;
}


@end
