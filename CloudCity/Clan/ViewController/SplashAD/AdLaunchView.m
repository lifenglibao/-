//
//  AdLaunchView.m
//  DGAdLaunchView ObjC
//
//  Created by 段昊宇 on 16/5/26.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "AdLaunchView.h"
#import "DACircularProgressView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "MZTimerLabel.h"
#import "AppConfigViewModel.h"
#import "AppDelegate.h"

AdLaunchType state = AdLaunchProgressType;

@interface AdLaunchView() 

@property(nonatomic, strong) UIImageView *adLocalBackground;
@property(nonatomic, strong) UIView *adBackground;
@property(nonatomic, strong) UIImageView *adImageView;
@property(nonatomic, strong) DACircularProgressView *progressView;
@property(nonatomic, strong) UIButton *progressButtonView;


@property (strong, nonatomic) AppConfigViewModel *configViewModel;
@property (assign) BOOL appPlugcfgLoadingComplete;
@property (assign) BOOL homeIndexcfgLoadingComplete;
@property (assign) BOOL forumsDatasLoadingComplete;

@property (nonatomic,strong) NSMutableArray *splashData;
@property (nonatomic) NSInteger duration;

@end

@implementation AdLaunchView


- (void) buildUI {
    
    self.adLocalBackground = [UIImageView new];
    self.adLocalBackground.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    NSString *imgName = [Util splashImageName];
    UIImage *splashImage = kIMG(imgName);
    self.adLocalBackground.image = splashImage;
    self.adLocalBackground.alpha = 0.0;
    [self.view addSubview:self.adLocalBackground];
    
    [UIView beginAnimations:nil context:nil];//标记动画块开始
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];//定义动画加速和减速方式
    [UIView setAnimationDuration:1.5];//动画时长
    [UIView setAnimationDelegate:self];
    self.adLocalBackground.alpha = 1.0;
    //动画结束后回调方法
    
    [UIView commitAnimations];//标志动滑块结束
}

-(void)hiddenAnimation
{
    [UIView beginAnimations:@"HideArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:0.0];
    self.adLocalBackground.alpha = 0.0;
    [self.adLocalBackground removeFromSuperview];
    [UIView commitAnimations];
}


- (void)viewDidLoad {
    
    self.splashData = [NSMutableArray array];
    state = AdLaunchProgressType;
    [self loadmodel];
//    [self buildUI];
    
    
    if([Util oneDayPast])
    {
        WEAKSELF
        [_configViewModel getAppSplashcfgWithBlock:^(id result) {
            
            if ([[result objectForKey:API_STATUS_CODE] integerValue] == 200) {
                weakSelf.splashData = [result objectForKey:@"result"][0];
                weakSelf.imgUrl = [[result objectForKey:@"result"][0] objectForKey:@"pic"];
                weakSelf.duration = [[[result objectForKey:@"result"][0] objectForKey:@"duration"] integerValue];
            }else {
                weakSelf.splashData = nil;
                weakSelf.imgUrl = nil;
                weakSelf.duration = 5;
            }
            
//            [self hiddenAnimation];
            [self initADBackGroundView];
            [self showImage];
            [self requestBanner];
            [self showProgressView];
            
            dispatch_time_t show = dispatch_time(DISPATCH_TIME_NOW, self.duration * NSEC_PER_SEC);
            dispatch_after(show, dispatch_get_main_queue(), ^(void){
                [self toHidenState];
            });
        }];
        
        [_configViewModel checkAppVersionWithBlock:^(id result) {
            if ([[result objectForKey:API_STATUS_CODE] integerValue] == 200) {
                
                [[TMCache sharedCache] setObject:[[result objectForKey:@"result"] objectForKey:APP_IOS_CURRENT_VERSION] forKey:APP_IOS_CURRENT_VERSION];
                [[TMCache sharedCache] setObject:[[result objectForKey:@"result"] objectForKey:APP_IOS_MIN_VERSION] forKey:APP_IOS_MIN_VERSION];
                [[TMCache sharedCache] setObject:[[result objectForKey:@"result"] objectForKey:APP_DOWNLOAD_URL] forKey:APP_DOWNLOAD_URL];
                [[TMCache sharedCache] setObject:[[result objectForKey:@"result"] objectForKey:APP_IOS_NEW_VERSION_UPDATE_INFO] forKey:APP_IOS_NEW_VERSION_UPDATE_INFO];
                [[TMCache sharedCache] setObject:[[result objectForKey:@"result"] objectForKey:APP_IOS_DOWNLOAD_URL] forKey:APP_IOS_DOWNLOAD_URL];
            }
        }];
        
    }else{
        [self toHidenState];
    }

    [self requestAppBaseDatas];
}


#pragma mark - 展示图片
- (void) showImage {
    
    self.adImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.adImageView setUserInteractionEnabled: YES];
    
    
    if (self.imgUrl) {
        [self.adImageView sd_setImageWithURL: [[NSURL alloc] initWithString: self.imgUrl]];
    }else{
        NSString *imgName = [Util splashImageName];
        UIImage *splashImage = kIMG(imgName);
        self.adImageView.image = splashImage;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(singleTap)];
    [self.adImageView addGestureRecognizer: singleTap];
    [self.adBackground addSubview: _adImageView];
}

#pragma mark - 图片点击事件
- (void) singleTap {
    [self toHidenState];
    [self._delegate adLaunch:self withAdData:self.splashData];
}

#pragma mark - 下载图片
- (void) requestBanner {
    
    if (self.imgUrl) {
        [[SDWebImageManager sharedManager] downloadImageWithURL: [[NSURL alloc] initWithString: self.imgUrl]
                                                        options: SDWebImageAvoidAutoSetImage
                                                       progress: nil
                                                      completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          NSLog(@"图片下载成功");
                                                      }];
    }
}

#pragma mark - 展示跳过按钮
- (void) showProgressView {
    switch (state) {
        case AdLaunchProgressType:
            self.progressButtonView = [[UIButton alloc] initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 20, 40, 40)];
            [self.progressButtonView setTitle: @"跳" forState: UIControlStateNormal];
            self.progressButtonView.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.progressButtonView.backgroundColor = [UIColor clearColor];
            [self.progressButtonView addTarget: self
                                        action: @selector(toHidenState)
                              forControlEvents: UIControlEventTouchUpInside];
            [self.adBackground addSubview: self.progressButtonView];
            
            self.progressView = [[DACircularProgressView alloc] initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 20, 40, 40)];
            self.progressView.userInteractionEnabled = NO;
            self.progressView.progress = 0;
            [self.adBackground addSubview: self.progressView];
            [self.progressView setProgress: 1 animated: YES initialDelay: 0.5 withDuration:self.duration];
            break;
            
        case AdLaunchTimerType:
            self.progressButtonView = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            self.progressButtonView.layer.masksToBounds = YES;
            self.progressButtonView.layer.cornerRadius = 12;
            self.progressButtonView.backgroundColor = [UIColor blackColor];
            self.progressButtonView.alpha = 0.3;
            [self.progressButtonView addTarget: self
                                        action: @selector(toHidenState)
                              forControlEvents: UIControlEventTouchUpInside];
            
            
            MZTimerLabel *timeLabel = [[MZTimerLabel alloc] initWithTimerType: MZTimerLabelTypeTimer];
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.timeFormat = @"s 跳过";
            timeLabel.textColor = [UIColor whiteColor];
            timeLabel.font = [UIFont systemFontOfSize: 14];
            timeLabel.userInteractionEnabled = NO;
            [timeLabel setCountDownTime: self.duration];
            
            [timeLabel start];
            [self.adBackground addSubview: self.progressButtonView];
            [self.adBackground addSubview: timeLabel];
            
            [self.progressButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(64, 24));
                make.top.equalTo(self).offset(24);
                make.right.equalTo(self).offset(-16);
            }];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.progressButtonView);
            }];
            
            break;
    }
    
    

}

#pragma mark - 消失动画
- (void) toHidenState {
    
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,  ^ {
        [self checkAndCloseLoadingPage];
    });
}

- (void ) initADBackGroundView {
//    CGRect  scr = [UIScreen mainScreen].bounds;
//    CGFloat wid = scr.size.width;
//    CGFloat hei = scr.size.height;
//    
//    UIView *footer = [[UIView alloc] initWithFrame: CGRectMake(0, hei - 128, wid, 128)];
//    footer.backgroundColor = [UIColor whiteColor];
//    
//    UIImageView *slogan = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"KDTKLaunchSlogan_Content"]];
//    [footer addSubview: slogan];
//    
//    [slogan mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(footer);
//    }];
    
   self.adBackground = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.adBackground.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.adBackground];
}



#pragma mark - 初始化
- (void)loadmodel
{
    self.configViewModel = [AppConfigViewModel new];
}


#pragma mark - 请求数据
- (void)requestAppBaseDatas
{
    WEAKSELF
    [_configViewModel getAppBaseConfigWithBlock:^(BOOL result) {
        /*
         * 1、请求插件后面的配置信息
         * 2、请求首页的indexcfg配置信息
         * 3、请求所有的版块儿信息
         * 4、请求主页面banner和link配置
         * 5、请求发现模块数据
         */
        [weakSelf requestAppPlugcfg];
        [weakSelf requestHomeIndexcfg];
        [weakSelf requestForumsDatas];
        [weakSelf requestCCHomePageInfo];
        [weakSelf requestCCDiscoverInfo];
        [weakSelf requestCCDiscoverLatestInfo];
    }];
}


- (void)requestCCDiscoverLatestInfo
{
    [_configViewModel getCCLatestDiscoverWithBlock:^(BOOL result) {
        
    }];
}
//发现模块
- (void)requestCCDiscoverInfo
{
    WEAKSELF
    [_configViewModel getCCDiscoverWithBlock:^(BOOL result) {
        
    }];
}

//插件后台的配置信息
- (void)requestAppPlugcfg
{
    WEAKSELF
    [_configViewModel getAppPlugcfgWithBlock:^(BOOL result) {
        weakSelf.appPlugcfgLoadingComplete = YES;
//        [weakSelf checkAndCloseLoadingPage];
    }];
}

//请求首页的indexcfg配置信息
- (void)requestHomeIndexcfg
{
    WEAKSELF
    [_configViewModel getAppHomeIndexcfgWithBlock:^(BOOL result) {
        weakSelf.homeIndexcfgLoadingComplete = YES;
//        [weakSelf checkAndCloseLoadingPage];
    }];
}

//版块儿所有的信息
- (void)requestForumsDatas
{
    WEAKSELF
    [_configViewModel requestBoardListWithBlock:^(BOOL result) {
        weakSelf.forumsDatasLoadingComplete = YES;
//        [weakSelf checkAndCloseLoadingPage];
    }];
}

- (void)requestCCHomePageInfo
{
    [_configViewModel getCCHomePagecfgWithBlock:^(BOOL result) {
        NSLog(@"\nCC API ------ 获取主页面banner,link成功.");
    }];
}
//检查并关掉loading页面
- (void)checkAndCloseLoadingPage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KDZ_ColsingLoadingPage" object:nil];

}

@end
