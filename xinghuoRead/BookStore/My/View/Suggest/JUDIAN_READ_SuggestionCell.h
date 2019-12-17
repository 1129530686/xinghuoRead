//
//  JUDIAN_READ_SuggestionCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"
#import "JUDIAN_READ_TextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SuggestionCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet JUDIAN_READ_TextView *bottomTextView;
@property (nonatomic,copy) CompletionBlock  inputBlock;
@property (weak, nonatomic) IBOutlet UILabel *countLab;


- (void)setDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
