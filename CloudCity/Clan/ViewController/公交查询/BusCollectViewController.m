//
//  BusCollectViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 04/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusCollectViewController.h"
#import "BusLineDetailViewController.h"
#import "BusStopDetailViewController.h"

@interface BusCollectViewController ()

@end

@implementation BusCollectViewController

- (void)viewWillAppear:(BOOL)animated {
    [self getCollectData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearch];
    [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)getCollectData
{
    self.selectedIndex = 0;
    self.collectData = [NSMutableArray array];
    NSDictionary *dicBusLine = [[NSUserDefaults standardUserDefaults] objectForKey:kKEY_FAVO_BUSLINE];
    NSDictionary *dicBusStop = [[NSUserDefaults standardUserDefaults] objectForKey:kKEY_FAVO_BUSSTOP];
    NSDictionary *dicBusTran = [[NSUserDefaults standardUserDefaults] objectForKey:kKEY_FAVO_BUSTRANSFER];
    
    for (NSString *keys in [dicBusLine allKeys]) {
        
        [self.collectData addObject:[NSDictionary dictionaryWithObject:[dicBusLine valueForKey:keys] forKey:kKEY_FAVO_BUSLINE]];
    }
    
    for (NSString *keys in [dicBusStop allKeys]) {
        
        [self.collectData addObject:[NSDictionary dictionaryWithObject:[dicBusStop valueForKey:keys] forKey:kKEY_FAVO_BUSSTOP]];
    }
    
    for (NSString *keys in [dicBusTran allKeys]) {
        
        [self.collectData addObject:[NSDictionary dictionaryWithObject:[dicBusTran valueForKey:keys] forKey:kKEY_FAVO_BUSTRANSFER]];
    }

    [self.tableView reloadData];
}

- (void)initTableView
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenBoundsHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dic = self.routeData[indexPath.row];
//    if (self.isOpen && [dic.allKeys containsObject:@"endStop"]) {
//        return [Util heightForText:[self.routeData[indexPath.row] objectForKey:@"endStop"] font:[UIFont systemFontOfSize:13] withinWidth:tableView.width];
//    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busCellIdentifier = @"busColletCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:busCellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        [cell.textLabel sizeToFit];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setLineBreakMode:NSLineBreakByCharWrapping];
        cell.imageView.layer.masksToBounds = YES;
    }
    
    if ([self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSLINE]) {
        
        cell.textLabel.text  = [self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSLINE];
        cell.imageView.image = kIMG(@"bus");
    }
    
    if ([self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSSTOP]) {
        
        cell.textLabel.text  = [self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSSTOP];
        cell.imageView.image = kIMG(@"bus");
    }
    
    if ([self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSTRANSFER]) {
        cell.textLabel.text  = [self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSTRANSFER];
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self showProgressHUDWithStatus:@""];
    
    if ([self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSLINE]) {
        [self busLineSearch:[self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSLINE]];
        
    }else if ([self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSSTOP]) {
        [self busStopSearch:[self.collectData[indexPath.row] valueForKey:kKEY_FAVO_BUSSTOP]];
        
    }else {
        
    }

}


- (void)busLineSearch:(NSString *)lineName{
    
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = lineName;
    line.city               = CURRENT_AREA_CODE;
    line.requireExtension = YES;
    [self.search AMapBusLineNameSearch:line];
}

/* 公交路线搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    [self hideProgressHUD];
    
    if (response.buslines.count != 0)
    {
        BusLineDetailViewController *vc = [[BusLineDetailViewController alloc] init];
        vc.busLineArray = [NSMutableArray arrayWithArray:response.buslines];
        vc.title = [self.collectData[self.selectedIndex] valueForKey:kKEY_FAVO_BUSLINE];
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}


- (void)busStopSearch:(NSString *)stopName{
    
    AMapBusStopSearchRequest *stop = [[AMapBusStopSearchRequest alloc] init];
    stop.keywords = stopName;
    stop.city     = CURRENT_AREA_CODE;
    [self.search AMapBusStopSearch:stop];
}

/* 公交站点搜索回调. */

- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response
{
    [self hideProgressHUD];
    
    if (response.busstops.count == 0)
    {
        [self showHudTipStr:@"抱歉,未找到该线路信息或者网络出了点问题😢"];
        return;
    }
    if (response.busstops.count != 0)
    {
        BusStopDetailViewController *vc = [[BusStopDetailViewController alloc] init];
        vc.busStopArray = [NSMutableArray arrayWithArray:response.busstops];
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self hideProgressHUD];
    [self showHudTipStr:@"抱歉,未找到该线路信息或者网络出了点问题😢"];
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
