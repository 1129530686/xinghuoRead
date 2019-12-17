//
//  JUDIAN_READ_BookLeaderboardController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BookLeaderboardController.h"
#import "JUDIAN_READ_CertainCategoryLeaderboardController.h"


@interface JUDIAN_READ_BookLeaderboardController ()
@property(nonatomic, copy)NSString* channel;
@property(nonatomic, copy)NSString* editorId;
@property(nonatomic, copy)NSString* pressName;
@property(nonatomic, assign)BOOL isFromPress;
@property(nonatomic, assign)BOOL isComplete;
@end

@implementation JUDIAN_READ_BookLeaderboardController


+ (void)enterLeaderboardController:(UINavigationController*)navigationController editorid:(NSString*)editorid channel:(NSString*) channel pressName:(NSString*)pressName {
    JUDIAN_READ_BookLeaderboardController* viewConroller = [[JUDIAN_READ_BookLeaderboardController alloc] init];
    viewConroller.channel = channel;
    viewConroller.editorId = editorid;
    viewConroller.pressName = pressName;
    navigationController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewConroller animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* type = @"";
    if ([_editorId isEqualToString:@"1"]) {
        type = @"榜单";
    }
    else if ([_editorId isEqualToString:@"2"]) {
        type = @"完结";
    }
    
    if ([_channel isEqualToString:@"1"]) {
        self.title = [NSString stringWithFormat:@"%@%@",@"男频",type];
    }
    else if ([_channel isEqualToString:@"2"]) {
        self.title = [NSString stringWithFormat:@"%@%@",@"女频",type];
    }
    else {
        self.title = _pressName;
    }
    
    NSInteger count = 0;
    if (_channel.length <= 0 && _editorId.length > 0) {
        count = 4;
        _isFromPress = TRUE;
        
        [self addCompleteCategoryViewController];
    }
    else if(_channel.length > 0 && [_editorId isEqualToString:@"2"]) {
        count = 4;
        _isFromPress = FALSE;
        _isComplete = TRUE;
        [self addCompleteCategoryViewController];
    }
    else {
        count = 5;
        _isComplete = FALSE;
        _isFromPress = FALSE;
        [self addCategoryViewController];
    }
    

    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *norColor = RGB(0x33, 0x33, 0x33);
        *selColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
        *titleWidth = SCREEN_WIDTH / count;
    }];
    
    // 标题渐变
    // *推荐方式(设置标题渐变)
    [self setUpTitleGradient:^(TitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        
    }];
    
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        //        *isUnderLineDelayScroll = YES;
        *isUnderLineEqualTitleWidth = YES;
    }];
    
}



- (void)addCategoryViewController {

    JUDIAN_READ_CertainCategoryLeaderboardController *favouriteViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    favouriteViewController.editorId = @"";
    favouriteViewController.isComplete = _isComplete;
    favouriteViewController.isPress = _isFromPress;
    favouriteViewController.channelName = _channel;
    favouriteViewController.filterType = @"1";
    favouriteViewController.title = @"粉丝榜";
    favouriteViewController.sortType = @"粉丝";
    favouriteViewController.viewController = self;
    [self addChildViewController:favouriteViewController];
    
    
    JUDIAN_READ_CertainCategoryLeaderboardController *hotViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    hotViewController.isComplete = _isComplete;
    hotViewController.isPress = _isFromPress;
    hotViewController.editorId = @"";
    hotViewController.channelName = _channel;
    hotViewController.filterType = @"2";
    hotViewController.title = @"人气榜";
    hotViewController.sortType = @"人气";
    hotViewController.viewController = self;
    [self addChildViewController:hotViewController];
    
    
    JUDIAN_READ_CertainCategoryLeaderboardController *appreciateViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    appreciateViewController.isComplete = _isComplete;
    appreciateViewController.isPress = _isFromPress;
    appreciateViewController.editorId = @"";
    appreciateViewController.channelName = _channel;
    appreciateViewController.filterType = @"3";
    appreciateViewController.title = @"赞赏榜";
    appreciateViewController.sortType = @"次赞赏";
    appreciateViewController.viewController = self;
    [self addChildViewController:appreciateViewController];
    
    
    JUDIAN_READ_CertainCategoryLeaderboardController *newBookViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    newBookViewController.isPress = _isFromPress;
    newBookViewController.isComplete = _isComplete;
    newBookViewController.editorId = @"";
    newBookViewController.channelName = _channel;
    newBookViewController.filterType = @"4";
    newBookViewController.title = @"新书榜";
    newBookViewController.sortType = @"人气";
    newBookViewController.viewController = self;
    [self addChildViewController:newBookViewController];
    
    
    JUDIAN_READ_CertainCategoryLeaderboardController *completetionViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    completetionViewController.isPress = _isFromPress;
    completetionViewController.isComplete = _isComplete;
    completetionViewController.editorId = @"";
    completetionViewController.channelName = _channel;
    completetionViewController.filterType = @"5";
    completetionViewController.title = @"完结榜";
    completetionViewController.sortType = @"人气";
    completetionViewController.viewController = self;
    [self addChildViewController:completetionViewController];
    
    self.selectIndex = 0;
}



- (void)addCompleteCategoryViewController {
    
    JUDIAN_READ_CertainCategoryLeaderboardController *favouriteViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    favouriteViewController.isPress = _isFromPress;
    favouriteViewController.isComplete = _isComplete;
    favouriteViewController.editorId = _editorId;
    favouriteViewController.channelName = _channel;
    favouriteViewController.filterType = @"1";
    favouriteViewController.title = @"综合";
    favouriteViewController.sortType = @"粉丝";
    favouriteViewController.viewController = self;
    [self addChildViewController:favouriteViewController];
    

    JUDIAN_READ_CertainCategoryLeaderboardController *hotViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    hotViewController.isPress = _isFromPress;
    hotViewController.isComplete = _isComplete;
    hotViewController.editorId = _editorId;
    hotViewController.channelName = _channel;
    hotViewController.filterType = @"2";
    hotViewController.title = @"人气";
    hotViewController.sortType = @"人气";
    hotViewController.viewController = self;
    [self addChildViewController:hotViewController];
    
    
    JUDIAN_READ_CertainCategoryLeaderboardController *appreciateViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    appreciateViewController.isPress = _isFromPress;
    appreciateViewController.isComplete = _isComplete;
    appreciateViewController.editorId = _editorId;
    appreciateViewController.channelName = _channel;
    appreciateViewController.filterType = @"3";
    appreciateViewController.title = @"好评";
    appreciateViewController.sortType = @"分";
    appreciateViewController.viewController = self;
    [self addChildViewController:appreciateViewController];
    
    
    JUDIAN_READ_CertainCategoryLeaderboardController *newBookViewController = [[JUDIAN_READ_CertainCategoryLeaderboardController alloc] init];
    newBookViewController.isPress = _isFromPress;
    newBookViewController.isComplete = _isComplete;
    newBookViewController.editorId = _editorId;
    newBookViewController.channelName = _channel;
    newBookViewController.filterType = @"4";
    newBookViewController.title = @"赞赏";
    newBookViewController.sortType = @"次赞赏";
    newBookViewController.viewController = self;
    [self addChildViewController:newBookViewController];
    

    self.selectIndex = 0;
}


#pragma mark 埋点事件
- (void)clickWhichIndex:(NSInteger)index {
    
    NSString* type = @"";
    if (_isComplete) {
        
        switch (index) {
            case 0:
                type = @"综合";
                break;
            case 1:
                type = @"人气";
                break;
            case 2:
                type = @"好评";
                break;
            case 3:
                type = @"赞赏";
                break;
            default:
                break;
        }
        
        [GTCountSDK trackCountEvent:@"click_wanjie_list" withArgs:@{@"type":type}];
        [MobClick event:@"click_wanjie_list" attributes:@{@"type":type}];
    }
    else {
        
        switch (index) {
            case 0:
                type = @"粉丝榜";
                break;
            case 1:
                type = @"人气榜";
                break;
            case 2:
                type = @"赞赏榜";
                break;
            case 3:
                type = @"新书榜";
                break;
            case 4:
                type = @"完结榜";
                break;
            default:
                break;
        }
        
        [GTCountSDK trackCountEvent:@"click_bangdan_list" withArgs:@{@"type":type}];
        [MobClick event:@"click_bangdan_list" attributes:@{@"type":type}];
    }
    

}



@end
