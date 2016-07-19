//
//  MessageController.m
//  Clan
//
//  Created by 昔米 on 15/9/9.
//  Copyright (c) 2015年 Youzu. All rights reserved.
//

#import "MessageController.h"
#import "DialogListViewController.h"
#import "WarnController.h"
#import "LFGridView.h"
#import "SearchViewController.h"

@interface MessageController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentscroll;
@property (nonatomic, strong) DialogListViewController *dialogVC;
@property (nonatomic, strong) WarnController *warnVC;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LFGridView *gridView;

//@property (nonatomic, strong)  UIBarButtonItem *cancelButton;
//@property (nonatomic, strong)  UIBarButtonItem *deleteButton;
//@property (nonatomic, strong)  UIBarButtonItem *backButton;
@end

@implementation MessageController

- (void)notificationCome:(NSNotification *)noti
{
    if ([noti.name isEqualToString:@"UPDATE_MESSAGEVC_GRIDVIEW"]) {
        [_gridView updateTitleCount];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNav];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGridView];
    [self buildUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCome:) name:@"UPDATE_MESSAGEVC_GRIDVIEW" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DLog(@"MessageController dealloc");
    _contentscroll.delegate = nil;
}

#pragma mark - 自定义方法

- (void)backView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buildUI
{
    float height = self.tabBarController ? kSCREEN_HEIGHT-64-kTABBAR_HEIGHT-_headerView.height : kSCREEN_HEIGHT-64-_headerView.height;
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _headerView.bottom, kSCREEN_WIDTH, height)];
    sv.delegate = self;
    sv.scrollEnabled = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    sv.pagingEnabled = YES;
    [sv setContentSize:CGSizeMake(kSCREEN_WIDTH*2, height)];
    self.contentscroll = sv;
    [self.view addSubview:sv];
    [self showDialogView];
}

- (void)addGridView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    }
    if (!_gridView) {
        _gridView = [[LFGridView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 41)];
    }
    _gridView.backgroundColor = [UIColor whiteColor];
    _gridView.target = self;
    [_gridView addCardWithTitle:@"好友消息" withSel:@selector(showDialogView)];
    [_gridView addCardWithTitle:@"提醒" withSel:@selector(showWarnView)];
    [_gridView addCardDone];
    [_gridView updateTitleCount];
    //添加阴影线
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _gridView.bottom, kSCREEN_WIDTH, 3)];
    lineView.image = kIMG(@"qiehuanxuanxiang");
    [_headerView addSubview:_gridView];
    [_headerView addSubview:lineView];
    [self.view addSubview:_headerView];
}

- (void)navback:(id)sender
{
    if (_isRightItemBar) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)initNav
{
    UIView *rightView;
        self.navigationItem.title = [NSString returnStringWithPlist:YZBBSName];
    if (!rightView) {
        rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    for (UIView *view in rightView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuoshouye"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)] animated:NO];
    
    
    NSNumber *valNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"KNEWS_MESSAGE"];
    NSString *navTitle = @"nav_left";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 5, 30, 30);
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.layer.cornerRadius = 15;
    leftButton.clipsToBounds = YES;
    UserModel *cUsr = [UserModel currentUserInfo];
    if (cUsr && cUsr.logined) {
        [leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:cUsr.avatar] forState:UIControlStateNormal placeholderImage:kIMG(@"portrait_small")];
    } else {
        [leftButton sd_cancelBackgroundImageLoadForState:UIControlStateNormal];
        [leftButton sd_cancelImageLoadForState:UIControlStateNormal];
        [leftButton setImage:kIMG(navTitle) forState:UIControlStateNormal];
    }
    [rightView addSubview:leftButton];
    if ((!isNull(valNum) && valNum.intValue != 0)) {
        //加红点
        UIImageView *redPod = nil;
        redPod = [[UIImageView alloc]initWithImage:[Util imageWithColor:[UIColor redColor]]];
        redPod.backgroundColor = [UIColor redColor];
        redPod.layer.cornerRadius = 4;
        redPod.clipsToBounds = YES;
        [rightView addSubview:redPod];
        [redPod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(rightView.mas_trailing).offset(-8);
            make.top.equalTo(rightView.mas_top).offset(6);
            make.width.equalTo(@8);
            make.height.equalTo(@8);
        }];
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.leftBarButtonItem = leftItem ;
}

- (void)searchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

//好友消息界面
- (void)showDialogView
{
    if (!_dialogVC) {
        DialogListViewController *dialog = [[DialogListViewController alloc]initWithNibName:@"DialogListViewController" bundle:[NSBundle mainBundle]];
        dialog.isRightItemBar = _isRightItemBar;
        dialog.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kVIEW_H(_contentscroll));
        [_contentscroll addSubview:dialog.view];
        self.dialogVC = dialog;
        [self addChildViewController:dialog];
    }
    [_contentscroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

//消息提醒界面
- (void)showWarnView
{
    if (!_warnVC) {
        WarnController *warn = [[WarnController alloc]init];
        warn.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kVIEW_H(_contentscroll));
        [_contentscroll addSubview:warn.view];
        self.warnVC = warn;
        [self addChildViewController:warn];
    }
    [_contentscroll setContentOffset:CGPointMake(kSCREEN_WIDTH, 0) animated:YES];
//    [self setUpNaviButtons];
}


#pragma mark - Scrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger index = scrollView.contentOffset.x / kSCREEN_WIDTH;
//    [_segment setSelectedSegmentIndex:index];
}


@end
