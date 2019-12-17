//
//  JUDIAN_READ_HomeViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_PageSettingView.h"
#import "JUDIAN_READ_TextStyleSettingPanel.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_ChapterCatalogPanel.h"
#import "JUDIAN_READ_ContentFeedbackPanel.h"
#import "JUDIAN_READ_NovelSharePanel.h"
#import "JUDIAN_READ_AbstractViewController.h"
#import "JUDIAN_READ_SettingMenuPanel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ContentBrowseController : JUDIAN_READ_AbstractViewController

@property (nonatomic, strong) JUDIAN_READ_PageSettingView* settingView;
@property (nonatomic, strong) JUDIAN_READ_SettingMenuPanel* moreMenuPanel;
@property (nonatomic, strong) JUDIAN_READ_TextStyleSettingPanel* styleSettingPanel;
@property (nonatomic, strong) JUDIAN_READ_ChapterCatalogPanel* catalogPanel;
@property (nonatomic, strong) JUDIAN_READ_ContentFeedbackPanel* feedbackPanel;
@property (nonatomic, strong) JUDIAN_READ_NovelSharePanel* sharePanel;

@property (nonatomic, copy) NSArray* chapterList;

@property (nonatomic, copy)NSString* bookId;
@property (nonatomic, copy)NSString* bookName;
@property (nonatomic, copy)NSString* chapterCount;

+ (void)enterContentBrowseViewController:(UINavigationController*)navigation book:(NSDictionary*)dictionary viewName:(NSString*)viewName;

- (void)setMaskViewBackgroundColor;
- (void)showProtectionEyeModeView;
- (void)updatePageViewController;
- (void)hideStatusView:(BOOL)hidden;
- (void)enterFictionDescriptionViewController;
- (void)prepareDownload;
- (void)prepareEnterAppreciateMoneyViewController;
- (void)loadFictionContent:(NSInteger)chapterId refresh:(BOOL)refresh isCatalog:(BOOL)isCatalog;
- (void)enterBookStoreViewController;
- (void) updatePageStyle;
- (void)enterAppreciatedUserList;
- (void)updateViewStyle;
- (void)addMoreMenuView;
- (void)saveCurrentModel;

- (void)showLoadingView:(BOOL)isShow;


@end

NS_ASSUME_NONNULL_END
