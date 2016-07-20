//
//  YZThemeStyle.h
//  Clan
//
//  Created by chivas on 15/4/7.
//  Copyright (c) 2015年 Youzu. All rights reserved.
//

#ifndef Clan_YZThemeStyle_h
#define Clan_YZThemeStyle_h

// API LOCAL
//#define YZBaseURL @"http://192.168.1.171/CloudCity/community/"
//#define YZBasePath @"upload/api/mobile/iyz_index.php"
//#define CCBaseURL @"http://192.168.1.171/CloudCity/cc_api2/index.php/"
//#define CC_FUNCTION_NOT_FOUND  [NSString stringWithFormat:@"%@app/AppConfig/funcNotFound",CCBaseURL]

// API SERVER
#define YZBaseURL @"http://123.206.23.53/cc_bbs/"
#define YZBasePath @"api/mobile/iyz_index.php"
#define CCBaseURL @"http://123.206.23.53/cc_api/index.php/"
#define CC_FUNCTION_NOT_FOUND  [NSString stringWithFormat:@"%@app/AppConfig/funcNotFound",CCBaseURL]

#define kAPP_DOWNLOAD_URL @"http://192.168.1.171/cc_api/index.php/app/AppDownload/downloadApp" //app下载地址
#define ThemeStyle @"ThemeStyle" //plist文件名
#define YZSegMentColor @"YZSegMent" //分割栏
#define YZBBSName @"YZBBSName" //论坛名
#define kShareAppkeySina @"ShareAppkeySina"
#define kShareAppkeyTecent @"ShareAppkeyTecent"
#define kShareAppkeyWechat @"ShareAppkeyWechat"
#define kShareAppSecretSina @"ShareAppSecretSina"
#define kShareAppSecretWechat @"ShareAppSecretWechat"
#define kShareAppSecretTecent @"ShareAppSecretTecent"
#define kShareAppRedirectUriSina @"ShareAppRedirectUriSina"
#define kBOARDSTYLE @"BOARDSTYLE" //版块儿样式
#define kCLOUDCITYAPPVERSION @"CLOUDCITYAPPVERSION" //bigApp Version
#define KCustomItemNotifi @"customItemNOtifi" //自定义itemBar通知

//ThridpartLoginConfig 第三方登录配置文件
#define kSupportQQLogin @"SupportQQLogin" //是否支持QQ登录
#define kSupportSinaLogin @"SupportSinaLogin" //是否支持sina登录
#define kSupportWechatLogin @"SupportWechatLogin" //是否支持Wechat登录

//是否支持签到
#define kcheckin_enabled @"checkin_enabled" //是否支持签到

#define kAppDescription @"AppDescription" //关于我们描述

#define kOpenImageMode @"open_image_mode"

#define KAllowAvatarChange @"AllowAvatarChange"

#define kurl_qqlogin_end @"url_qqlogin_end"
#define kurl_qqlogin @"url_qqlogin"
#define kwechatSwitch @"wechatSwitch"
#define kweiboSwitch @"weiboSwitch"

#define kAppVersion @"AppVersion"
#define kJpushAppSecret @"JpushAppSecret"
#define kJpushAppKey @"JpushAppKey"

#define kProvinceArray  [NSArray arrayWithObjects:@"北京市",@"天津市",@"河北省", @"山西省", @"内蒙古自治区", @"辽宁省", @"吉林省", @"黑龙江省", @"上海市", @"江苏省", @"浙江省", @"安徽省", @"福建省", @"江西省", @"山东省", @"河南省", @"湖北省", @"湖南省", @"广东省", @"广西壮族自治区", @"海南省", @"重庆市", @"四川省", @"贵州省", @"云南省", @"西藏自治区", @"陕西省", @"甘肃省", @"青海省", @"宁夏回族自治区", @"新疆维吾尔自治区", @"台湾省", @"香港特别行政区", @"澳门特别行政区", @"海外", @"其他", nil]

#endif

// Bus Functions

#define MAPKEY @"AMAPKEY"
#define CURRENT_AREA_CODE @"0395"
#define BUS_STOP_SEARCH_TYPE @"1507"
#define LUOHE_MAP_RECT_MAKE_X 219274180.99575466
#define LUOHE_MAP_RECT_MAKE_Y 107631269.07922892
#define LUOHE_MAP_RECT_MAKE_WIDTH 0
#define LUOHE_MAP_RECT_MAKE_HEIGHT 0

#define BUSLINEFAV @"busLineFav_" //公交线路收藏
#define BUSSTOPFAV @"busStopFav_"    //公交站点收藏
#define BUSTRANSFERFAV @"busTransferFav_"   //公交换乘收藏

#define API_STATUS_CODE @"code"
#define DEFAULT_INTERVAL 1   //多少天执行一次某些方法
#define IOS_APP 1
#define APP_IOS_CURRENT_VERSION @"APP_IOS_CURRENT_VERSION"
#define APP_IOS_MIN_VERSION @"APP_IOS_MIN_VERSION"
#define APP_IOS_NEW_VERSION_UPDATE_INFO @"APP_IOS_NEW_VERSION_UPDATE_INFO"
#define APP_IOS_DOWNLOAD_URL @"APP_IOS_DOWNLOAD_URL" // appstore
#define APP_DOWNLOAD_URL @"APP_DOWNLOAD_URL" // webpage

