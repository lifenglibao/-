//
//  BusNearbyViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusNearbyViewController.h"
#import "ArrowImageView.h"
#import "BusLineDetailViewController.h"
#import "BusNearbyCellTableViewCell.h"
#import "CustomBusMode.h"

@interface BusNearbyViewController ()

@end

@implementation BusNearbyViewController


#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.currentIndex = 0;
        self.page = 1;
        self.lineArray = [NSMutableArray array];
        self.nearByArray = [NSMutableArray array];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showHudTipStr:@"附近站点默认显示距离您1000米内的车站"];
    [self initSearch];
    [self initUserLocation];
    [self initTableView];
    [self performSelector:@selector(checkCllocationSerStatus) withObject:nil afterDelay:1.0];
}

#pragma mark -
- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initTableView
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 84) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    WEAKSELF
    [self.tableView createHeaderViewBlock:^{
        STRONGSELF
        strongSelf.page = 1;
        [strongSelf searchPoiByCenterCoordinate];
    }];
}

- (void)locationServiceUnEnabled
{
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, 150)];
    img.image = kIMG(@"dataNothing");
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom + 20, self.view.width, 50)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.numberOfLines = 0;
    lbl.text = @"抱歉\n定位失败,或者您还未开启定位服务";

    [self.maskView addSubview:img];
    [self.maskView addSubview:lbl];
    [self.view addSubview:self.maskView];
    [self.view bringSubviewToFront:self.maskView];
}

- (void)checkCllocationSerStatus
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [self searchPoiByCenterCoordinate];
    }else{
    }
}
- (void)initUserLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.delegate = self;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }else{
        [self locationServiceUnEnabled];
    }
}


#pragma mark - AMapSearchDelegate

- (void)searchPoiByCenterCoordinate
{
    [self showProgressHUDWithStatus:@""];
    CLLocationCoordinate2D  gaodeGPS = MACoordinateConvert(self.locationManager.location.coordinate, MACoordinateTypeGPS);
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude: gaodeGPS.latitude longitude:gaodeGPS.longitude];
    request.keywords            = @"公交站";
    request.radius              = 1000;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    request.page                = self.page;
    request.offset              = 20;
    [self.search AMapPOIAroundSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count <20) {
        _isNoMore = YES;
    }else{
        _isNoMore = NO;
    }
    if (response.pois.count != 0) {
        [self getMoreInfoMationForBus:response.pois];
    }
}

/* 公交路线搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        [self.lineArray addObject:response.buslines];
    }else{
        NSArray *arr = [NSArray arrayWithObjects:[[AMapBusLine alloc] init],[[AMapBusLine alloc] init], nil];
        [self.lineArray addObject:arr];
    }
    
    [self.tableView reloadData];
    [self hideProgressHUD];
    [self.view endLoading];
    [self.tableView endHeaderRefreshing];
    [self.tableView.footer endRefreshing];
    
    if (self.page != 1) {
        if (_isNoMore) {
            [self.tableView.footer noticeNoMoreData];
        }
    } else {
        if (_isNoMore) {
            [self.tableView removeFooter];
        } else {
            [self addPullRefreshActionWithUp];
        }
    }
}

- (void) getMoreInfoMationForBus:(NSArray*)pois
{
    if (self.page == 1) {
        [self.nearByArray removeAllObjects];
        [self.nearByArray addObjectsFromArray:pois];
    }else{
        [self.nearByArray addObjectsFromArray:pois];
    }
    [self sortingData];
    
    for (NSArray *row in self.nearByArray) {
        AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
        line.city               = @"0395";
        line.requireExtension   = YES;
        line.keywords = [row valueForKey:@"address"];
        [self.search AMapBusLineNameSearch:line];
    }
}

- (void) sortingData {
    NSMutableArray *data = [NSMutableArray array];
    for (AMapPOI *poi in self.nearByArray) {
        if ([poi.address containsString:@";"]) {
            NSArray* temp = [poi.address componentsSeparatedByString:@";"];
            for (int i = 0 ; i<temp.count; i++) {
                AMapPOI *subPoi = [[AMapPOI alloc] init];
                subPoi.uid = poi.uid;
                subPoi.name = poi.name;
                subPoi.type = poi.type;
                subPoi.location = poi.location;
                subPoi.distance = poi.distance;
                subPoi.address = temp[i];
                [data addObject:subPoi];
            }
        }else{
            [data addObject:poi];
        }
    }
    [self.nearByArray removeAllObjects];
    [self.nearByArray addObjectsFromArray:data];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.nearByArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *busCellIdentifier = @"busNearbyCell";

    BusNearbyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];

    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"BusNearbyCellTableViewCell" bundle:nil] forCellReuseIdentifier:busCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    }
    
//    UIImageView *contentV = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
//    contentV.image = kIMG(@"send_msg");
//    [cell.contentView addSubview:contentV];
//    [cell.contentView sendSubviewToBack:contentV];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BusNearbyCellTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.lbl_busNumber.text = [CustomBusMode handleStringWithBrackets:[(AMapPOI *)self.nearByArray[indexPath.section] address]];
    cell.lbl_busNumberSub.text = [CustomBusMode handleStringGetBrackets:[(AMapPOI *)self.nearByArray[indexPath.section] address]];
    cell.lbl_busGoto.text = [CustomBusMode replaceStringWithBusModel:[self.lineArray [indexPath.section][self.currentIndex] endStop]];
    
    cell.lbl_busFirstTime.text = [CustomBusMode replaceStringWithBusModel:[CustomBusMode getBusTimeFromString:[self.lineArray [indexPath.section][self.currentIndex] startTime]]];
    cell.lbl_busEndTime.text = [CustomBusMode replaceStringWithBusModel:[CustomBusMode getBusTimeFromString:[self.lineArray [indexPath.section][self.currentIndex] endTime]]];
    cell.lbl_busNearbyStop.text = [CustomBusMode handleStringWithBrackets:[(AMapPOI *)self.nearByArray[indexPath.section] name]];
    cell.lbl_busDistance.text = [NSString stringWithFormat:@"%ld米",(long)[(AMapPOI *)self.nearByArray[indexPath.section] distance]];
    
    if ([self.lineArray [indexPath.section][self.currentIndex] basicPrice] == [self.lineArray [indexPath.section][self.currentIndex] totalPrice] ) {
        NSString *temp = [CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",[self.lineArray [indexPath.section][self.currentIndex] basicPrice]]];
        cell.lbl_busPrice.text = [NSString stringWithFormat:@"%@",temp];
    }else{
        cell.lbl_busPrice.text = [NSString stringWithFormat:@"%@-%@",[CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",[self.lineArray [indexPath.section][self.currentIndex] basicPrice]]],[CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",[self.lineArray [indexPath.section][self.currentIndex] totalPrice]]]];
    }
    
    cell.lbl_busFullDistance.text = [NSString stringWithFormat:@"%@公里",[CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.2f",[(AMapBusLine*)self.lineArray [indexPath.section][self.currentIndex] distance]]]];
    cell.arrImg.autoresizesSubviews = NO;
    CLLocationCoordinate2D target;
    target.latitude = [[(AMapPOI *)self.nearByArray[indexPath.section] valueForKey:@"location"] latitude];
    target.longitude = [[(AMapPOI *)self.nearByArray[indexPath.section] valueForKey:@"location"] longitude];
    cell.arrImg.target = target;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([Util isBlankString:[(AMapBusLine*)self.lineArray[indexPath.section][self.currentIndex] uid]]) {
        [self showHudTipStr:@"当前车辆信息可能出错了"];
        return;
    }
    BusLineDetailViewController *vc = [[BusLineDetailViewController alloc] init];
    vc.title = [self.nearByArray[indexPath.section] valueForKey:@"address"];
//    vc.nearByStop = [self.nearByArray[self.tableView.indexPathForSelectedRow.section] valueForKey:@"name"];
    vc.busLineArray = [NSMutableArray arrayWithArray:self.lineArray[indexPath.section]];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnReverseClicked:(UIButton*)sender {
    if (self.currentIndex>0) {
        self.currentIndex = 0;
    }else{
        self.currentIndex = 1;
    }
    UITableViewCell*cell=(UITableViewCell*)sender.superview.superview;
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)btnFavClicked:(UIButton*)sender {
    
}

- (void)addPullRefreshActionWithUp
{
    if (!_tableView.legendFooter) {
        WEAKSELF
        [_tableView createFooterViewBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.page ++;
            [strongSelf searchPoiByCenterCoordinate];
        }];
    }
}

#pragma mark  -
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    CLLocationCoordinate2D  gaodeGPS = MACoordinateConvert(self.locationManager.location.coordinate, MACoordinateTypeGPS);
//    newLocation = [[CLLocation alloc] initWithLatitude:gaodeGPS.latitude longitude:gaodeGPS.longitude];
//    self.currentLocation = newLocation;
    //NPLog(@"lat: %f, long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingHeading];
    [manager stopUpdatingLocation];
    [self locationServiceUnEnabled];
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            // "Access to Location Services denied by user";
            //Do something...

            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            // "Location data unavailable";
            //Do something else...

            break;
        case kCLErrorHeadingFailure:
            // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.

        default:
            // "An unknown error has occurred";

            break;
    }
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
