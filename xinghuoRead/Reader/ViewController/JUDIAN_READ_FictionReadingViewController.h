//
//  JUDIAN_READ_NovelReadingViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/5/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JUDIAN_READ_PageSettingView.h"
#import "JUDIAN_READ_TextStyleSettingPanel.h"
#import "JUDIAN_READ_ChapterCatalogPanel.h"
#import "JUDIAN_READ_ContentFeedbackPanel.h"
#import "JUDIAN_READ_NovelSharePanel.h"
#import "JUDIAN_READ_SettingMenuPanel.h"

#import "JUDIAN_READ_AbstractViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FictionReadingViewController : JUDIAN_READ_AbstractViewController

+ (void)enterFictionViewController:(UINavigationController*)navigation book:(NSDictionary*)dictionary viewName:(NSString*)viewName;


@property (nonatomic, strong) JUDIAN_READ_SettingMenuPanel* settingView;
@property (nonatomic, strong) JUDIAN_READ_TextStyleSettingPanel* styleSettingPanel;
@property (nonatomic, strong) JUDIAN_READ_ChapterCatalogPanel* catalogPanel;
@property (nonatomic, strong) JUDIAN_READ_ContentFeedbackPanel* feedbackPanel;
@property (nonatomic, strong) JUDIAN_READ_NovelSharePanel* sharePanel;

@property (nonatomic, copy) NSArray* chapterList;

@property (nonatomic, copy)NSString* bookId;
@property (nonatomic, copy)NSString* bookName;
@property (nonatomic, copy)NSString* bookState;
@property (nonatomic, copy)NSString* chapterCount;
@property (nonatomic, copy)NSString* wordCount;

@property (nonatomic, copy)NSString* appreciateCount;
@property (nonatomic, copy)NSString* bookAuthor;

@property (nonatomic, copy)NSString* lastBrowsePosition;

- (void)hideStatusView:(BOOL)hidden;
- (void)updatePageViewController;
- (void)showProtectionEyeModeView;
- (void)setMaskViewBackgroundColor;

- (void)addSettingView;

- (void)prepareEnterAppreciateMoneyViewController;
- (void)enterFictionDescriptionViewController;

- (void)getFictionChapterContent:(NSString*)chapterId bookId:(NSString*)bookId direction:(NSInteger)direction;

- (void)prepareDownload;

- (void)enterBookStoreViewController;

@end

NS_ASSUME_NONNULL_END
