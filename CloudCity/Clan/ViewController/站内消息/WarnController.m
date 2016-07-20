//
//  WarnController.m
//  Clan
//
//  Created by 昔米 on 15/9/9.
//  Copyright (c) 2015年 Youzu. All rights reserved.
//

#import "WarnController.h"
#import "WarnListCell.h"
#import "NotificationModel.h"
#import "DialogListViewModel.h"
#import "MeViewController.h"
#import "TOWebViewController.h"
#import "NewFriendsController.h"
#import "PostDetailVC.h"

@interface WarnController () <UITableViewDataSource, UITableViewDelegate>
{
    DialogListViewModel *_viewmodel;
    WarnListCell *_tempCell;
    NSIndexPath *_tobeReloadPath;
}
@property (nonatomic, strong)  NSMutableArray *dataSourceArr;
@property (nonatomic, strong)  NSString *currentID;

@end

@implementation WarnController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];

    if (_tobeReloadPath) {
        [self.tableview deselectRowAtIndexPath:_tobeReloadPath animated:YES];
        NotificationModel *model = _dataSourceArr[_tobeReloadPath.row];
        model.is_have_read = @"1";
        [self.tableview reloadRowsAtIndexPaths:@[_tobeReloadPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        _tobeReloadPath = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSourceArr = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAutoUpdate) name:@"AUTO_REFRESH_XINXI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"DO_DIALOG_UPDATE" object:nil];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = kCOLOR_BG_GRAY;
    //计算cell高度用得
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([WarnListCell class]) bundle:nil];
    _tempCell = [nib instantiateWithOwner:nil options:nil][0];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"WarnListCell"];
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    //请求posts第一页数据
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 70.0;
    [Util setExtraCellLineHidden:self.tableview];
    
    
    self.navigationItem.rightBarButtonItem = nil;
    [self addPullRefreshAction];
    [self showProgressHUDWithStatus:@""];
    [self requestData];
    
    if (self.tabBarController) {
        self.bottomToSuperView.constant = kTABBAR_HEIGHT;
    }else{
        self.bottomToSuperView.constant = 0;
    }
    [self.view layoutIfNeeded];
}

- (void)doAutoUpdate
{
    if (!self.tableview.header.isRefreshing) {
        //是否正在下拉刷新
        [self.tableview beginRefreshing];
    }
}

#pragma mark - 接收通知
- (void) receiveNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"DO_DIALOG_UPDATE"]) {
//        _laterDisappear = YES;
        [self requestData];
    }
}


- (void)requestData
{
    BOOL islogin = [UserModel currentUserInfo].logined;
    if (!islogin) {
        [self hideProgressHUD];
        [self.tableview endHeaderRefreshing];
        [self.tableview hideTableFooter];
        [self goToLoginPage];
        return;
    }
    if (!_viewmodel) {
        _viewmodel = [DialogListViewModel new];
    }
    WEAKSELF
    [_viewmodel requestWarnListWithReturnBlock:^(bool success, id data) {
        STRONGSELF
//        if (!strongSelf.laterDisappear) {
//            [strongSelf removeTheTip];
//        }
        [self hideProgressHUD];
        [strongSelf.tableview endHeaderRefreshing];
        if (success) {
            [strongSelf.dataSourceArr removeAllObjects];
            [strongSelf.dataSourceArr addObjectsFromArray:data];
            [strongSelf.tableview reloadData];
        } else {
            if (data && [data isKindOfClass:[NSString class]] && [data isEqualToString:kCookie_expired]) {
                [strongSelf showHudTipStr:data];
                [strongSelf goToLoginPage];
            }
        }
        [strongSelf.view configBlankPage:DataIsNothingWithDefault hasData:(strongSelf.dataSourceArr.count > 0) hasError:(NO) reloadButtonBlock:^(id sender) {
            [strongSelf requestData];
        }];
    }];
    [self updateNotificationCount];
}


- (void)updateNotificationCount
{
    if (!_currentID) {
        return;
    }
    BOOL islogin = [UserModel currentUserInfo].logined;
    if (!islogin) {
        [self hideProgressHUD];
        [self.tableview endHeaderRefreshing];
        [self.tableview hideTableFooter];
        [self goToLoginPage];
        return;
    }
    if (!_viewmodel) {
        _viewmodel = [DialogListViewModel new];
    }
    WEAKSELF
    [_viewmodel readWarnListWithReturnBlockWithID:_currentID andReturnBlock:^(bool success, id data) {
        STRONGSELF
        
        [self hideProgressHUD];
        [strongSelf.tableview endHeaderRefreshing];
        if (success) {
            [strongSelf.tableview reloadData];
        } else {
            if (data && [data isKindOfClass:[NSString class]] && [data isEqualToString:kCookie_expired]) {
                [strongSelf showHudTipStr:data];
                [strongSelf goToLoginPage];
            }
        }
    }];
    
    [_viewmodel requestUnReadWarnListWithReturnBlock:^(bool success, id data) {
        
    }];
}

//上拉下拉刷新
- (void)addPullRefreshAction
{
    WEAKSELF
    [_tableview createHeaderViewBlock:^{
        STRONGSELF;
        [strongSelf requestData];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarnListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarnListCell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    NotificationModel *warn = _dataSourceArr[indexPath.row];
    cell.warn = warn;
    cell.btn_avatar.path = indexPath;
    [cell.btn_avatar addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tempCell.warn = _dataSourceArr[indexPath.row];
    [_tempCell setNeedsLayout];
    CGFloat height = [_tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //由于分割线，所以contentView的高度要小于row 一个像素。
    return height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotificationModel *model = _dataSourceArr[indexPath.row];
    _tobeReloadPath = indexPath;
    model.is_have_read = @"1";
    _currentID = model.plid;
    
    [self showProgressHUDWithStatus:@""];
    [self updateNotificationCount];
    
    if ([model.type isEqualToString:@"system"]) {
        TOWebViewController *web = [[TOWebViewController alloc]initWithURLString:model.tags]; //hard code
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
    else if ([model.type isEqualToString:@"post"] && [model.category isEqualToString:@"1"]) {
        PostDetailVC *detail = [[PostDetailVC alloc]init];
        PostModel *postModel = [PostModel new];
        postModel.tid = model.tags;
        detail.postModel =  postModel;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if ([model.type isEqualToString:@"friend"] && [model.category isEqualToString:@"2"]) {
        
        NewFriendsController *newsF = [[NewFriendsController alloc]init];
        newsF.title = @"新的朋友";
        [self.navigationController pushViewController:newsF animated:YES];
    }
//    else if ([model.type isEqualToString:@""]) {
//        MeViewController *home = [[MeViewController alloc]init];
//        home.hidesBottomBarWhenPushed = YES;
//        UserModel *user = [UserModel new];
//        user.uid = model.authorid;
//        home.user = user;
//        [self.navigationController pushViewController:home animated:YES];
//    }
}

#pragma mark - actions
- (IBAction)avatarBtnAction:(id)sender
{

}

//- (void)updateButtonsToMatchTableState
//{
//    if (self.tableview.editing)
//    {
//        // Show the option to cancel the edit.
//        self.navigationItem.rightBarButtonItem = self.cancelButton;
//        if (_targetVC) {
//            _targetVC.navigationItem.rightBarButtonItem = self.cancelButton;
//        }
//        
//        [self updateDeleteButtonTitle];
//        
//        // Show the delete button.
//        self.navigationItem.leftBarButtonItem = self.deleteButton;
//        if (_targetVC) {
//            _targetVC.navigationItem.leftBarButtonItem = self.deleteButton;
//        }
//    }
//    else
//    {
//        self.navigationItem.leftBarButtonItem = self.backButton;
//        if (_targetVC) {
//            if (self.backButton) {
//                if (!_isRightItemBar) {
//                    [_targetVC addBackBtn];
//                }else{
//                    _targetVC.navigationItem.leftBarButtonItem = self.backButton;
//                }
//            } else {
//                if (_isRightItemBar) {
//                    _targetVC.navigationItem.leftBarButtonItem = self.backButton;
//                }
//                _targetVC.navigationItem.leftBarButtonItem = nil;
//            }
//        }
//        if (_dataSourceArr.count > 0)
//        {
//            self.editButton.enabled = YES;
//        }
//        else
//        {
//            self.editButton.enabled = NO;
//        }
//        self.navigationItem.rightBarButtonItem = self.editButton;
//        if (_targetVC) {
//            _targetVC.navigationItem.rightBarButtonItem = self.editButton;
//        }
//    }
//}
//
//- (void)setupNavigationButtonsForVC:(UIViewController *)vc
//{
//    _targetVC = vc;
//    _targetVC.navigationItem.rightBarButtonItem = _editButton;
//    if (!_isRightItemBar) {
//        _targetVC.navigationItem.leftBarButtonItem = nil;
//    }else{
//        _targetVC.navigationItem.leftBarButtonItem = self.backButton;
//    }
//    [_tableview setEditing:NO];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
