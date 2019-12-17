#pragma mark Common Methods Define


//**************************************   ios版本  **************************************8
//iOS7
#define isiOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

//iOS8
#define isiOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

//iOS9
#define isiOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

//iOS10
#define isiOS10 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)

//iOS11
#define isiOS11 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) ? YES : NO)

//**************************************   屏幕适配  **************************************8
//v2.3版本定义的文件名格式
#define kFileNameFormatter @"yyyy-MM-dd HHmmssSSS"


//做iphone4屏幕适配
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//做iphone5屏幕适配
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//做iphone6屏幕适配
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//做iphone6+屏幕适配
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//iphoneMax适配
#define iPhoneMAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX [JUDIAN_READ_DeviceUtils isIphoneX]

//iPad适配
#define iPhone4_Or_iPad (([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].length>0 || iPhone4)? YES : NO)

//是否是4寸以及4寸以上屏幕，适配iPhone6，iPhone6 plus
#define isScreenOverIphone4  (HEIGHT_SCREEN > 480 ? YES :NO)

//是否是4.7寸以及4.7寸以上屏幕，适配iPhone6，iPhone6 plus
#define isScreenOverIphone5  (HEIGHT_SCREEN > 568 ? YES :NO)

//4.7寸以上屏幕，适配iPhone6 plus，iphonex
#define isScreenOverIphone6  (HEIGHT_SCREEN > 667 ? YES :NO)





//**************************************  颜色   **************************************8
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)      RGBA(r, g, b, 1.0f)

//app主色
#define kThemeColor RGB(232, 29, 82)

//间隔线1px颜色
#define KSepColor RGB(238, 238, 238)

//背景颜色
#define kBackColor   RGB(245, 245, 245)

//字体颜色
#define kColor51 RGB(51, 51, 51)
#define kColor63 RGB(63, 63, 63)
#define kColor82 RGB(82, 82, 82)
#define kColor100 RGB(100, 100, 100)
#define kColor153 RGB(153, 153, 153)
#define kColor204 RGB(204, 204, 204)
#define kColorOrange RGB(255, 160, 48)
#define kColorGreen RGB(84, 186, 151)
#define kColorPurple RGB(187, 129, 251)
#define kColorLightRed RGB(255, 121, 128)
#define kColorBrown RGB(132, 88, 32)
#define kColorWhite [UIColor whiteColor]
#define kColorRed RGB(232, 29, 82)
#define kColorGray [UIColor getColor:@"CCCCCC"]
#define kColorBlue RGB(85, 157, 255)
#define kColor47 [UIColor getColor:@"474869"]
#define kColorFF [UIColor getColor:@"FF7980"]
#define kColor00 [UIColor getColor:@"00B00E"]


//**************************************  字体大小   **************************************8
#define kFontSize10  [UIFont systemFontOfSize:10]
#define kFontSize11  [UIFont systemFontOfSize:11]
#define kFontSize12  [UIFont systemFontOfSize:12]
#define kFontSize13  [UIFont systemFontOfSize:13]
#define kFontSize14  [UIFont systemFontOfSize:14]
#define kFontSize15  [UIFont systemFontOfSize:15]
#define kFontSize16  [UIFont systemFontOfSize:16]
#define kFontSize17  [UIFont systemFontOfSize:17]
#define kFontSize18  [UIFont systemFontOfSize:17]
#define kFontSize19  [UIFont systemFontOfSize:17]


//字号大小(根据屏幕缩放)
#define kAutoFontSize24_26                       (iPhone6Plus) ? 26.0 : 24.0
#define kAutoFontSize18                          (iPhone5 || iPhone4 ) ? 16.0 : 18.0
#define kAutoFontSize15_16                       (iPhone6Plus) ? 16.0 : 15.0
#define kAutoFontSize14_15                       (iPhone6Plus) ? 15.0 : 14.0
#define kAutoFontSize12_14                       (iPhone6Plus) ? 14.0 : 12.0
#define kAutoFontSize12_13                       (iPhone6Plus) ? 13.0 : 12.0
#define kAutoFontSize11_12                       (iPhone6Plus) ? 12.0 : 11.0
#define kAutoFontSize10_11                       (iPhone6Plus) ? 11.0 : 10.0
#define kAutoFontSize10                          (iPhone5 || iPhone4 ) ? 8.0 : 10.0




//**************************************  屏幕尺寸   **************************************8
#define WIDTH_SCREEN ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT_SCREEN ([UIScreen mainScreen].bounds.size.height)
#define kScaleFrom_iPhone6_Design(_X_) (_X_ * (WIDTH_SCREEN / 375))
#define SCREEN_WIDTH   (WIDTH_SCREEN > HEIGHT_SCREEN ? HEIGHT_SCREEN : WIDTH_SCREEN)
#define SCREEN_HEIGHT  (WIDTH_SCREEN > HEIGHT_SCREEN ? WIDTH_SCREEN : HEIGHT_SCREEN)

//导航栏高度,标签栏高度，状态栏高度
#define Height_NavBar    ((iPhoneX == YES) ? (88.0f) : (64.0f))
#define Height_TabBar    ((iPhoneX == YES) ? (83.0f) : (49.0f))
#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define Height_Content   ((iPhoneX == YES) ? (((SCREEN_HEIGHT) - (Height_NavBar)) - 34) :((SCREEN_HEIGHT) - (Height_NavBar)))
#define SafeHeight     ((iPhoneX == YES) ? ((SCREEN_HEIGHT) - 34) :(SCREEN_HEIGHT))
#define BottomHeight     ((iPhoneX == YES) ? 34 : 0)
#define ViewFrame CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)




//**************************************  其他   **************************************8
//获取版本号
#define GET_VERSION_NUMBER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//缩放比例
#define autoSizeScaleX ((SCREEN_HEIGHT > 568) ? SCREEN_WIDTH/320.0 : 1.0)
#define autoSizeScaleY ((SCREEN_HEIGHT > 568) ? SCREEN_HEIGHT/568.0 : 1.0)

//iOS 11
/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

#define kKeyWindow [UIApplication sharedApplication].keyWindow

//weakself
#define WeakSelf(__obj) __weak typeof(self) __obj = self


// Block
typedef void (^VoidBlock)(void);
typedef void(^CompletionBlock)(_Nullable id, _Nullable id);


//**************************************  时间格式   **************************************8
#define timeFormatter @"yyyy-MM-dd"

#define PAGE_APPRECIATE_VIEW_HEIGH (121 + 25)
#define TOP_OFFSET (iPhoneX ? 24 : 0)
#define BOTTOM_OFFSET (iPhoneX ? 34 : 0)

//阅读器页面左右边距
#define CONTENT_VIEW_SIDE_EDGE 20

//#define READER_PAGE_FRAME CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 63 - BOTTOM_OFFSET)

//小说下载路径
#define NOVEL_DOWNLOAD_PATH @"judian/download"

//充值订单路径
#define CHARGE_HISTORY_PATH @"judian/charge"

typedef enum : NSUInteger {
    
    kBackCmd = 0x10,
    kDownloadCmd = 0x11,
    kNoAdertiseCmd = 0x12,
    kMoreCmd = 0x13,
    
    kCatalogCmd = 0x14,
    kNightCmd = 0x15,
    kStyleSettingCmd = 0x16,
    
    kMenuItemShareCmd = 0x17,
    kMenuItemIntroductionCmd = 0x18,
    kMenuItemFeedbackCmd = 0x19,
    
    kLineSpaceCmd = 0x21,
    kBrightnessCmd = 0x22,
    kFontSizeCmd = 0x23,
    kBackgroudColorCmd = 0x24,
    
    kArchiveSettingCmd = 0x25,
    
    kChapterContentCmd = 0x26,
    kChapterSortCmd = 0x27,
    
    kCancelFeedbackCmd = 0x28,
    kConfrimFeedbackCmd = 0x29,
    
    kHideStatusViewCmd = 0x30,
    kAppreciateMoneyCmd = 0x31,
    kDayLightCmd = 0x32,
    kToBookStoreCmd = 0x33,
    kUserSugguestCmd = 0x34,
    kPageStyleCmd = 0x35,
    kAppreciateChapterListCmd = 0x36,
} ReaderTextStyleButtonCmd;


typedef enum : NSUInteger {
    
    kReaderNavigationBarHeight = 48,
    kReaderBottomBarHeight = 63,
    
    kReaderMoreMenuWidth = 120,
    kReaderMoreMenuHeight = 134,
    
    kReaderMoreMenuItemHeight = 40,
    kReaderMoreMenuItemOffset = 10,

} ReaderSettingViewHeight;



typedef enum : NSUInteger {
    
    kTitleFontSize = 14,
    
    kLineSpaceTitleLeft = 14,
    kLineSpaceButtonLeft = 68,
    KLineSpaceButtionWidth = 80,
    KLineSpaceButtionHeight = 30,
    
    KBackgroundButtionWidth = 107,
    KBackgroundCircleWidth = 30,
    KBackgroundCircleRight = 12,
    
    KFontSizeButtionWidth = 130,
    
    kLightSlideWidth = 280,
    kLightSlideHeight = 20,

} ReaderTextStyleItemSize;



typedef enum : NSUInteger {
    
    kSmallFontSizeTag = 0x100,
    kBigFontSizeTag,
    
    kProtectionEyeTag,
    kLightGrayTag,
    kLightYellowTag,
    kLightGreenTag,
    kLightBlackTag,
    
    kLineSpaceSmallTag,
    kLineSpaceMiddleTag,
    kLineSpaceBigTag,
    
    kStylePageCurlTag,
    kStylePageScrollTag,
    kStylePageVerticalTag,
    kStylePageCoverTag

} ReaderTextStyleCmd;


typedef enum : NSUInteger {
    
    kChapterErrorTag = 0x300,
    kContentErrorTag,
    kLayoutErrorTag,
    kSexErrorTag,
    kCopyRightErrorTag,
    kOtherErrorTag,
    kAppDesignErrorTag
    
} ReaderFeebackTypeCmd;


typedef enum : NSUInteger {
    kWeixinTag = 0x310,
    kFriendTag,
    kQQTag,
    kQQZoneTag,
    kWeiboTag,
    kCopyLinkTag
} ReaderNovelShareCmd;



typedef enum : NSUInteger {
    kRmbButtonTag = 0x400
} ReaderAppreciateMoneyTag;


typedef enum : NSUInteger {
    
    //kFontSizeStep = 3,
    //kMinFontSize = 12,
    //kDefaultFont = 18,
    //kMaxFontSize = 33,
    //kDefaultTitleFont = 20,

    //kMinParagraphSpacing = 20,
    //kDefaultParagraphSpacing = 24,
    //kParagraphStep = 4,
    
    //kLineSpaceSmallSize = 0,
    //kLineSpaceMiddleSize = 5,
    //kLineSpaceBigSize = 10,
    
    kLightGrayIndex = 0,
    kLightYellowIndex = 1,
    kLightGreenIndex = 2,
    kLightBlackIndex = 3,
    
    kStylePageCurlIndex = 0,
    kStylePageScrollIndex = 1,
    kStylePageVerticalIndex = 2,
    kStylePageCoverIndex = 3,

} ReaderTextStyleLevel;

typedef enum : NSUInteger {
    DIRECTION_NONE = 0,
    DIRECTION_UP = 1,
    DIRECTION_DOWN = 2,
} TurningChapterEnum;


typedef enum : NSUInteger {
    kNetworkError = 1,//网络异常
    kWebKitError,//网络异常
    kNoHistory,//无记录
    kNoUserContribution,//无赞赏记录
} NoDataTypeEnum;

typedef void(^modelBlock)(_Nullable id args);
#define _MIDDLE_CIRCLE_DOT_ @"·"

#define _AREA_KEY_ @"areaName"
#define _AD_BUTTON_TEXT_ @"查看详情 >"
#define _ONLY_ONE_APPRECIATE_ @"onlyOneAppreciate"
#define _NO_CHAPTER_CODE_ @"1000"
#define _IS_PERMANENT_MEMBER_ @"isPermanentMember"
#define _DOWN_FICTION_FLAG_ @"v120"

#define READER_TEXT_COLOR RGB(0x11, 0x11, 0x11)
#define READER_TEXT_NIGHT_COLOR RGB(0x9b, 0x9b, 0x9b)

#define READER_BG_LIGHT_GRAY_COLOR RGB(0xf4, 0xf4, 0xe9)
#define READER_BG_LIGHT_YELLOW_COLOR RGB(0xe6, 0xdd, 0xc6)
#define READER_BG_LIGHT_GREEN_COLOR RGB(0xcf, 0xea, 0xcb)
#define READER_BG_LIGHT_BLACK_COLOR RGB(0x22, 0x22, 0x22)


#define READER_TAB_BAR_TEXT_COLOR RGB(0x66, 0x66, 0x66)

#define READER_SETTING_PANEL_BUTTON_TEXT_COLOR RGB(0x33, 0x33, 0x33)
#define READER_SETTING_PANEL_BUTTON_BORDER_COLOR RGB(0xcc, 0xcc, 0xcc)
#define READER_SETTING_PANEL_BUTTON_CLICKED_COLOR RGB(0xe8, 0x1d, 0x52)

#define READER_NAVIGATION_BAR_NIGHT_BG_COLOR RGB(0x22, 0x22, 0x22)
#define READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR RGB(0x99, 0x99, 0x99)


#define READER_CONTENT_BG_COLOR RGB(0xf9, 0xf9, 0xf9)

#define APPSTORE_URL @"https://itunes.apple.com/cn/app/id1462710009?mt=8"

#define MULTIPLY_PAGE_BROWSE_STYLE 0

#define REWARD_VIDEO_VIEW_TAG 1201

#define SLIDER_WIDTH 26

#define DESCRIPTION_WIDTH (SCREEN_WIDTH - 68)

#define EYE_VIEW_Z_POSITION (NSIntegerMax - 15)
#define LIGHT_VIEW_Z_POSITION (NSIntegerMax - 14)
#define GUIDE_VIEW_Z_POSITION (NSIntegerMax - 10)
#define LOADING_VIEW_Z_POSITION (NSIntegerMax - 8)

#define _FICTION_DOWNLOAD_INTERVAL_ 0.3

#define _GDT_AD_STATE_ 1

#define _USER_FAQ_LINK_ @"/appprogram/static/user-faq?version=2"

//app开屏广告类型 1为广点通 2为穿山甲
#define _APP_SPLASH_AD_TYPE_ 1

//0为测试版本  1为正式版本
#define _IS_RELEASE_VERSION_ 1


#if _IS_RELEASE_VERSION_ == 1

#define API_HOST_NAME @"https://apiprdssl.zhuishubao.com"
#define EARNING_TASK_INTRODUCTION_URL @"http://download.zhuishubao.com/"


//穿山甲
#define CHUAN_SHAN_JIA_AD_APP_ID @"5020263"
#define CHUAN_SHAN_JIA_FEED_ID @"920263227"
#define CHUAN_SHAN_JIA_REWARD_VEDIO_ID @"920263567"
#define CHUAN_SHAN_JIA_OPEN_SCREEN_AD_ID @"820263309"
#define CHUAN_SHAN_JIA_BANNER_AD_ID @"920263243"
#define CHUAN_SHAN_JIA_DRAW_SCREEN_AD_ID @"920263753"
#define CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID @""

//广点通
#define GDT_AD_APP_ID  @"1109288613"
#define GDT_FICTION_AD_ID_1 @"4080362817162430"
#define GDT_FICTION_AD_ID_2 @"1050968877263309"
#define GDT_BOOK_INTRODUCTION_AD_ID @"7080763827767375"
#define GDT_BOOK_SHELF_AD_ID @"4050365897463234"
#define GDT_SPLASH_AD_ID @"5060587115729724"
#define GDT_REWARD_VIDEO_AD_ID  @"5070386397178290"

//bugly崩溃日志收藏
#define APP_BUGLY_ID  @"99c3ec362e"

//友盟id
#define APP_UM_ID @"5cc56723570df3e8d4000afd"
#define APP_WEIXIN_ID @"wx321490b4036708ad"
#define APP_WEIXIN_SECRET @"6be17cc07718557e2a26f4e655914296"
#define APP_QQ_ID @"101577730"
#define APP_SINA_ID @"1546680316"
#define APP_SINA_SECRET @"42620ebf88d0169f81b2826208b4a95e"

//个推  
#define GT_APP_ID  @"JpL5582Krt6b0UPcFLfE04"
#define GT_APP_KEY @"AwWsQ4QvxY9l6NbOFei4c"
#define GT_APP_SECRET @"XpqPKvOPZjA7JN7kzdL0NA"


#else

#define API_HOST_NAME @"http://apiuat.zhuishubao.com"
//#define API_HOST_NAME @"http://192.168.1.192"
#define EARNING_TASK_INTRODUCTION_URL @"http://download.zhuishubao.com/"


//穿山甲
#define CHUAN_SHAN_JIA_AD_APP_ID @"5000546"
#define CHUAN_SHAN_JIA_FEED_ID @"900546910"
#define CHUAN_SHAN_JIA_OPEN_SCREEN_AD_ID @"800546808"
#define CHUAN_SHAN_JIA_REWARD_VEDIO_ID @"900546826"
#define CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID @""

//广点通
#define GDT_AD_APP_ID  @"1109288613"
#define GDT_FICTION_AD_ID_1 @"4080362817162430"
#define GDT_FICTION_AD_ID_2 @"1050968877263309"
#define GDT_BOOK_INTRODUCTION_AD_ID @"7080763827767375"
#define GDT_BOOK_SHELF_AD_ID @"4050365897463234"
#define GDT_SPLASH_AD_ID @"5060587115729724"
#define GDT_REWARD_VIDEO_AD_ID @"5070386397178290"

//bugly崩溃日志收藏
#define APP_BUGLY_ID  @"c9ae494b85"

//友盟id
#define APP_UM_ID @"5cc56723570df3e8d4000afd"
#define APP_WEIXIN_ID @"wx321490b4036708ad"
#define APP_WEIXIN_SECRET @"6be17cc07718557e2a26f4e655914296"
#define APP_QQ_ID @"101577730"
#define APP_SINA_ID @"1546680316"
#define APP_SINA_SECRET @"42620ebf88d0169f81b2826208b4a95e"

//个推
#define GT_APP_ID  @"JpL5582Krt6b0UPcFLfE04"
#define GT_APP_KEY @"AwWsQ4QvxY9l6NbOFei4c"
#define GT_APP_SECRET @"XpqPKvOPZjA7JN7kzdL0NA"

#endif

/**
 public String SIT_BASE_URL = "http://apisit.zhuishubao.com:8088"; //集成开发测试环境，用于开发调试
 public String UAT_BASE_URL = "http://apiuat.zhuishubao.com"; //测试环境，用户提交测试阶段测试，内部试用体验。
 public String PRD_BASE_URL = "http://apiprd.zhuishubao.com";    //线上环境，生产部署环境
 
 */
