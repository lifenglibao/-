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

@interface BusTransferListViewController ()

@end

@implementation BusTransferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"换乘方案";
    [self initTableView];

    // Do any additional setup after loading the view from its nib.
}

- (void)initTableView
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight - 84) style:UITableViewStyleGrouped];
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
    
    BusTransferDetailViewController *vc = [[BusTransferDetailViewController alloc] init];
    vc.currentCourse = indexPath.section;
    vc.busRoute  = self.busRoute;
    vc.routeStartLocation = self.routeStartLocation;
    vc.routeDestinationLocation = self.routeDestinationLocation;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
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
