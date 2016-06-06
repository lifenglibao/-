//
//  BusTransferListViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 23/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferListViewController.h"
#import "BusTransferListTableViewCell.h"
#import "BusTransferDetailViewController.h"
#import "CustomBusMode.h"
#import "BusMapViewController.h"
#import "PopoverView.h"
#import "SegmentView.h"

@interface BusTransferListViewController ()

@end

@implementation BusTransferListViewController


- (id)init
{
    if (self = [super init])
    {
        self.currentCourse = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"换乘方案";
    [self addGridView];
    [self initTableView];
    [self initNavBar];
    // Do any additional setup after loading the view from its nib.
}

- (void)initNavBar
{
    
//    
//    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)];
//    statFilter.layer.cornerRadius = 13.f;
//    statFilter.layer.borderColor = [UIColor whiteColor].CGColor;
//    statFilter.layer.borderWidth = 1.0f;
//    statFilter.layer.masksToBounds = YES;
//    statFilter.bounds = CGRectMake(0, 0, 138.f, 30.f);
//    [statFilter setSelectedSegmentIndex:0];
//    [statFilter addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
//    self.navigationItem.titleView = statFilter;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    UIButton *viewmore = [UIButton buttonWithTitle:nil andImage:@"more_N" andFrame:CGRectMake(rightView.right - 37, (44-30)/2, 37, 30) target:self action:@selector(viewMoreAction:)];
    viewmore.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightView addSubview:viewmore];
    self.viewMoreBtn = viewmore;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightItem, nil]];
}

- (void)addGridView
{
    _headerView = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 44) andTitleArray:[CustomBusMode getTransferGridTitle] andIconArray:nil clickBlock:^(NSInteger index) {
        NSLog(@"123");
    }];
    
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.layer.shadowOffset = CGSizeMake(0, 0);
    _headerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _headerView.layer.shadowRadius = 1;
    _headerView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = _headerView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    _headerView.layer.shadowPath = shadowPath;
    
    [self.view addSubview:_headerView];
}

- (void)initTableView
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom + 10, ScreenWidth, ScreenHeight - 84 - _headerView.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.busRoute.transits.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *busCellIdentifier = @"busTransferCell";
    
    BusTransferListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"BusTransferListTableViewCell" bundle:nil] forCellReuseIdentifier:busCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BusTransferListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.lbl_routePlanningBusNumber.text    = [CustomBusMode getRoutePlanningBusNumber:[self.busRoute.transits[indexPath.section] segments]];
    cell.lbl_routePlanningBusNumber.height  = [Util heightForText:cell.lbl_routePlanningBusNumber.text font:cell.lbl_routePlanningBusNumber.font withinWidth:cell.lbl_routePlanningBusNumber.width];
    cell.lbl_routePlanningBusInfo.text      = [CustomBusMode getRoutePlanningBusInfo:self.busRoute.transits[indexPath.section]];
    cell.lbl_routePlanningBusStartStop.text = [CustomBusMode getRoutePlanningBusStartStop:[self.busRoute.transits[indexPath.section] segments]];
    
    cell.lbl_routePlanningBusStartStop.width = [Util widthForText:cell.lbl_routePlanningBusStartStop.text font:cell.lbl_routePlanningBusStartStop.font withinHeight:cell.lbl_routePlanningBusStartStop.height];
    
    [cell.contentView needsUpdateConstraints];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    BusTransferDetailViewController *vc = [[BusTransferDetailViewController alloc] init];
//    vc.currentCourse = indexPath.section;
//    vc.busRoute  = self.busRoute;
//    vc.routeStartLocation = self.routeStartLocation;
//    vc.routeDestinationLocation = self.routeDestinationLocation;
//    [self.parentViewController.navigationController pushViewController:vc animated:YES];
    
//    BusMapViewController *subViewController = [[BusMapViewController alloc] init];
//    subViewController.busRoute = self.busRoute;
//    subViewController.currentCourse = self.currentCourse;
//    [self.navigationController pushViewController:subViewController animated:YES];
}

//更多按钮
- (void)viewMoreAction:(id)sender
{
    NSString *favoImgName = [CustomBusMode isFavoed_withID:[NSString stringWithFormat:@"%@%@-%@",BUSTRANSFERFAV,self.routeStartLocation,self.routeDestinationLocation] withFavoID:[NSString stringWithFormat:@"%@-%@",self.routeStartLocation,self.routeDestinationLocation] forType:myBusTransfer] ? @"detail_favo_H" : @"favo_N";
    NSArray *titls = @[@"收藏",@"地图"];
    NSArray *imgsN = @[favoImgName,@"share_N"];
    NSArray *imgsH = @[favoImgName,@"share_N"];
    PopoverView *pop = [[PopoverView alloc]initWithFromBarButtonItem:_viewMoreBtn inView:self.view titles:titls images:imgsN selectImages:imgsH];
    pop.selectIndex = 0;
    WEAKSELF
    pop.selectRowAtIndex = ^(NSInteger index)
    {
        STRONGSELF
        if (index == 0)
            [strongSelf favoPortalAction];
        else if (index == 1)
            [strongSelf gotoMap];
    };
    [pop show];
}

- (void)gotoMap
{
//    BusMapViewController *subViewController = [[BusMapViewController alloc] init];
//    subViewController.busRoute = self.busRoute;
//    subViewController.currentCourse = self.currentCourse;
//    [self.navigationController pushViewController:subViewController animated:YES];
}

//收藏取消收藏
- (void)favoPortalAction
{
    //    if ([self checkLoginState]) {
    
    _isFav = [CustomBusMode isFavoed_withID:[NSString stringWithFormat:@"%@%@-%@",BUSTRANSFERFAV,self.routeStartLocation,self.routeDestinationLocation] withFavoID:[NSString stringWithFormat:@"%@-%@",self.routeStartLocation,self.routeDestinationLocation] forType:myBusTransfer];
    
    if (_isFav) {
        //已收藏 删除收藏
        [CustomBusMode deleteFavoed_withID:[NSString stringWithFormat:@"%@%@-%@",BUSTRANSFERFAV,self.routeStartLocation,self.routeDestinationLocation] withFavoID:[NSString stringWithFormat:@"%@-%@",self.routeStartLocation,self.routeDestinationLocation] forType:myBusTransfer];
        [self showHudTipStr:@"取消收藏成功"];
    }else{
        [CustomBusMode addFavoed_withID:[NSString stringWithFormat:@"%@%@-%@",BUSTRANSFERFAV,self.routeStartLocation,self.routeDestinationLocation] withFavoID:[NSString stringWithFormat:@"%@-%@",self.routeStartLocation,self.routeDestinationLocation] forType:myBusTransfer];
        [self showHudTipStr:@"收藏成功"];
        
    }
    //    }
    
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
