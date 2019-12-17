//
//  JUDIAN_READ_TextVerticalScrollView.m
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_TextVerticalScrollView.h"
#import "JUDIAN_READ_PromotionUserCountActivity.h"

#define TEXT_Y_POS -2

@interface JUDIAN_READ_TextVerticalScrollView ()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)NSUInteger count;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, strong)NSMutableArray* attributedTextArray;
@end



@implementation JUDIAN_READ_TextVerticalScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _attributedTextArray = [NSMutableArray array];

        _width = frame.size.width;
        _height = frame.size.height;
        _timeInterval = 3;
        _scrollTimeInterval = 0.3;
        [self initSubViews];
    }
    return self;
}

/// 创建Label
- (void)initSubViews {
    self.clipsToBounds = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, TEXT_Y_POS, _width - 2 * 14, _height)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //_scrollLbl.userInteractionEnabled = NO;
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    //[_scrollLbl addGestureRecognizer:tap];
    [self addSubview:_titleLabel];
}




- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}


- (void)timerMethod {
    
    _count++;
    if (_count == _attributedTextArray.count) {
        _count = 0;
    }

    WeakSelf(that);
    /// 两次动画实现类似UIScrollView的滚动效果，控制坐标和隐藏状态
    [UIView animateWithDuration:_scrollTimeInterval animations:^{
        that.titleLabel.frame = CGRectMake(0, -that.height, that.width, that.height);
    } completion:^(BOOL finished) {
        
        that.titleLabel.hidden = YES;
        that.titleLabel.frame = CGRectMake(0, that.height, that.width, that.height);
        that.titleLabel.hidden = NO;
        
        [UIView animateWithDuration:that.scrollTimeInterval animations:^{
            that.titleLabel.attributedText = [that getCurrentContent];
            that.titleLabel.frame = CGRectMake(0, TEXT_Y_POS, that.width, that.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
}


- (void)buildAttributedText:(NSArray*)array {
    
    if (array.count <= 0) {
        return;
    }
    
    for (JUDIAN_READ_PromotionMessageModel* model in array) {
        NSString* title = [NSString stringWithFormat:@"  %@", model.title];
        NSMutableAttributedString* attributedText = [self createAttributedText:title];
        [_attributedTextArray addObject:attributedText];
    }
    
    [self reset];
    [self startTimer];

}


- (void)reset {
    _count = 0;
    _titleLabel.frame = CGRectMake(0, TEXT_Y_POS, _width, _height);
    _titleLabel.attributedText = [self getCurrentContent];
    
    [self resetTimer];
}




- (NSMutableAttributedString *)getCurrentContent {
    if (_attributedTextArray.count <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = _attributedTextArray[_count];
    return attributedText;
}



- (void)clickAction {
    //if (_delegate && [(id)_delegate respondsToSelector:@selector(noticeScrollDidClickAtIndex:content:)]) {
    //    [_delegate noticeScrollDidClickAtIndex:_count content:_contents[_count]];
    //}
}




- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];

    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"big_horn_tip"];
    attach.bounds = CGRectMake(0, 0 , 16, 16);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [attributedText insertAttributedString:imgStr atIndex:0];
    [attributedText addAttribute: NSBaselineOffsetAttributeName value:@(-3.0) range: NSMakeRange(0,1)];
    
    
    return attributedText;
}

- (void)resetTimer {
    
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerMethod) object:nil];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
    

}


@end
