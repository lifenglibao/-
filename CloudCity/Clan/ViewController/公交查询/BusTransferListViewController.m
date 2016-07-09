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
        self.selectedFilterIndex = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"换乘方案";
    self.busRoute = self.totalBusRoute[self.currentCourse];
    [self addGridView];
    [self initTableView];
    [self initNavBar];
    [self initfilterTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initNavBar
{
    
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
        if (index == 0) {
            
            self.currentCourse = (self.currentCourse == 0) ? (self.currentCourse = 1) : (self.currentCourse = 0);
            self.busRoute = self.totalBusRoute[self.currentCourse];
            [self.tableView reloadData];

        }else{
            [self animateFilterTable];
        }
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

- (void)initfilterTableView
{
    self.filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -200, ScreenWidth, 200) style:UITableViewStylePlain];
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    self.filterTableView.backgroundColor = [UIColor whiteColor];
    self.filterTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_filterTableView];
    [self.filterTableView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.filterTableView) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.filterTableView) {
        return 1;
    }
    return self.busRoute.transits.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.filterTableView) {
        return [[CustomBusMode getTransferFilterTitle] count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.filterTableView) {
        return 50;
    }
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.filterTableView) {
        
        static NSString *busCellIdentifier = @"busTransitsCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:busCellIdentifier];
        }
        
        cell.textLabel.text = [CustomBusMode getTransferFilterTitle][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        if (indexPath.row == self.selectedFilterIndex) {
            cell.accessoryType  = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }
        return cell;
        
    }else if (tableView == self.tableView) {
        static NSString *busCellIdentifier = @"busTransferCell";
        
        BusTransferListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"BusTransferListTableViewCell" bundle:nil] forCellReuseIdentifier:busCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BusTransferListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        cell.lbl_routePlanningBusNumber.text    = [CustomBusMode getRoutePlanningBusNumber:[self.busRoute.transits[indexPath.section] segments]];
        cell.lbl_routePlanningBusNumber.height  = [Util heightForText:cell.lbl_routePlanningBusNumber.text font:cell.lbl_routePlanningBusNumber.font withinWidth:cell.lbl_routePlanningBusNumber.width];
        cell.lbl_routePlanningBusInfo.text      = [CustomBusMode getRoutePlanningBusInfo:self.busRoute.transits[indexPath.section]];
        cell.lbl_routePlanningBusStartStop.text = [CustomBusMode getRoutePlanningBusStartStop:[self.busRoute.transits[indexPath.section] segments]];
        
        cell.lbl_routePlanningBusStartStop.width = [Util widthForText:cell.lbl_routePlanningBusStartStop.text font:cell.lbl_routePlanningBusStartStop.font withinHeight:cell.lbl_routePlanningBusStartStop.height];
        
        [cell.contentView needsUpdateConstraints];
    }
}

- (void)presentCurrentRouteModel
{
    self.busRoute.transits = [NSArray arrayWithArray:[CustomBusMode getFilterRoutePlanning:self.busRoute.transits withParameter:[CustomBusMode getTransferFilterTitle][self.selectedFilterIndex]]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.filterTableView) {
        self.selectedFilterIndex = indexPath.row;
        [self.filterTableView reloadData];
        [self animateFilterTable];
        [self presentCurrentRouteModel];
    }else{
        
        BusMapViewController *subViewController = [[BusMapViewController alloc] init];
        subViewController.needShowDetailView = YES;
        subViewController.busRoute = self.busRoute;
        subViewController.currentCourse = indexPath.section;
        subViewController.startLocationName = self.routeStartLocation;
        subViewController.destinationLocationName = self.routeDestinationLocation;
        [self.navigationController pushViewController:subViewController animated:YES];
    }
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


- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = self.filterTableView.center;

    if ([self.filterTableView isHidden]) {
        
        pos.y = 150;
        [self.filterTableView setHidden:NO];
    }
    else {
        pos.y = -200;
        [self.filterTableView setHidden:YES];
    }
    self.filterTableView.center = pos;
    [UIView commitAnimations];
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
