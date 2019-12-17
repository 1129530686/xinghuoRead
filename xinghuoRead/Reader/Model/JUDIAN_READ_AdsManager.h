//
//  JUDIAN_READ_AdsManager.h
//  xinghuoRead
//
//  Created by judian on 2019/6/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JUDIAN_READ_AdSize250ViewCell.h"
#import "JUDIAN_READ_MiniAdViewCell.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_VipCustomPromptView.h"

#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import "JUDIAN_READ_GdtAdSize250ViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AdsManager : NSObject

@property (nonatomic, strong)NSMutableArray* gdtAdArray;
@property (nonatomic, strong)NSMutableArray* adsDataArray;

+ (instancetype)createAdsManager:(UIViewController*)viewController collectionView:(UICollectionView*)collectionView readChpater:(NSMutableDictionary*) readChpater;

+ (void)computeAttributedTextHeight:(NSAttributedString*)attributedString width:(CGFloat)width height:(NSInteger*)height lineCount:(NSInteger*)lineCount;
+ (NSMutableAttributedString*)createAttributedText:(NSString*)text color:(UIColor*)color;
+ (CTFrameRef)getTextFrameRef:(CGRect)frame attributedString:(NSAttributedString*)attributedString;

- (void)buildAdView:(BUNativeAd*)nativeAd cell:(JUDIAN_READ_AdSize250ViewCell*) cell;
- (void)buildMiniAdView:(BUNativeAd*)nativeAd cell:(JUDIAN_READ_MiniAdViewCell*) cell;

- (BOOL)canLoadBuAds;
- (BOOL)canLoadGdtAds;

- (void)initRewardViedoAd;
- (void)loadAdData;

- (void)buildBuAdsDataWithBigView:(JUDIAN_READ_AdSize250ViewCell*)cell index:(NSInteger)index;
- (void)buildBuAdsDataWithMiniView:(JUDIAN_READ_MiniAdViewCell*)cell index:(NSInteger)index;
- (void)buildGdtAdsData:(JUDIAN_READ_GdtAdSize250ViewCell*)cell index:(NSInteger)index;

- (void)computeAdDscriptionHeight:(NSInteger)index width:(CGFloat)width height:(NSInteger*)height lineCount:(NSInteger*)lineCount ;




@end

NS_ASSUME_NONNULL_END
