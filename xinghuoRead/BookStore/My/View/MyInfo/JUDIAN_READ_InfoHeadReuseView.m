//
//  JUDIAN_READ_InfoHeadReuseView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_InfoHeadReuseView.h"

@implementation JUDIAN_READ_InfoHeadReuseView

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)leadAction:(id)sender {
    if (self.TouchBlock) {
        self.TouchBlock(@"0",@"0");
    }
}

- (IBAction)centerAction:(id)sender {
    if (self.TouchBlock) {
        self.TouchBlock(@"1",@"1");
    }
    
}
- (IBAction)trailAction:(id)sender {
    if (self.TouchBlock) {
        self.TouchBlock(@"2",@"2");
    }
}

- (void)setPersonInfoDataWithModel:(id)model section:(NSInteger)section{
    
    
}

@end
