//
//  BusStopDetailViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusStopDetailViewController.h"
#import "CustomGridView.h"
#import "LoginViewController.h"
#import "Util.h"
#import "BusLineDetailViewController.h"
#import "BusStopDetailTableViewCell.h"

@interface BusStopDetailViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation BusStopDetailViewController
@synthesize tableView = _tableView;


- (id)init
{
    if (self = [super init])
    {
        self.currentIndex = 0;
        self.lineArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showProgressHUDWithStatus:@""];
    self.busStop = self.busStopArray.firstObject;
    [self.busStopArray removeAllObjects];
    self.title = self.busStop.name;
    [self initSearch];
    [self initUserLocation];
    [self getMoreInfoMationForBus:self.busStop.buslines];
    [self initTableView];
    [self performSelector:@selector(checkCllocationSerStatus) withObject:nil afterDelay:1.0];
    // Do any additional setup after loading the view.
}

- (void)checkCllocationSerStatus
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        // tableview releload;
        
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

- (void)locationServiceUnEnabled
{
    [self showHudTipStr:@"抱歉\n定位失败,或者您还未开启定位服务,您无法获取站点的距离信息"];
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initNavBar
{
    NSRange range = [self.busStop.name rangeOfString:@"("];
    NSString *str = [self.busStop.name substringToIndex:range.location];
    
    _isFav = [Util isFavoed_withID:[NSString stringWithFormat:@"bus_stop_%@",str] forType:myBusLine];
    _favBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_favBtn addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_isFav) {
        [_favBtn setImage:[UIImage imageNamed:@"detail_favo_H"] forState:UIControlStateNormal];
    }else{
        [_favBtn setImage:[UIImage imageNamed:@"favo_N"] forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favBtn];
}

- (void)initTableView {
    
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 84) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void) getMoreInfoMationForBus:(NSArray*)pois
{
    [self.lineArray removeAllObjects];
    [self filterData:pois];
    
    for (NSString *name in self.lineArray) {
        
        AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
        line.city               = CURRENT_AREA_CODE;
        line.requireExtension   = YES;
        line.keywords           = name;
        [self.search AMapBusLineNameSearch:line];
    }

}

- (void)filterData:(NSArray *)array {
    
    [self.lineArray removeAllObjects];

    for (AMapBusLine *line in array) {
        [line setName:[CustomBusMode handleStringWithCharRoad:line.name]];
        [self.lineArray addObject:line.name];
    }
    self.lineArray =[self.lineArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
}
- (void)favAction:(UIButton *)sender{
    
    if (![UserModel currentUserInfo].logined || ![[NSUserDefaults standardUserDefaults]objectForKey:Code_CookieData]) {
        //没有登录 跳出登录页面
        LoginViewController *login = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    sender.selected = !sender.selected;
    NSRange range = [self.busStop.name rangeOfString:@"("];
    NSString *str = [self.busStop.name substringToIndex:range.location];
    _isFav = [Util isFavoed_withID:[NSString stringWithFormat:@"bus_stop_%@",str] forType:myBusLine];
    
    if (_isFav) {
        //已收藏 删除收藏
        [_favBtn setImage:[UIImage imageNamed:@"favo_N"] forState:UIControlStateNormal];
        [Util deleteFavoed_withID:[NSString stringWithFormat:@"bus_stop_%@",str] forType:myBusLine];
        [self showHudTipStr:@"取消收藏成功"];
    }else{
        [_favBtn setImage:[UIImage imageNamed:@"detail_favo_H"] forState:UIControlStateNormal];
        [Util addFavoed_withID:[NSString stringWithFormat:@"bus_stop_%@",str] withFavoID:str forType:myBusLine];
        [self showHudTipStr:@"收藏成功"];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 5)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.busStopArray count];
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
    static NSString *busCellIdentifier = @"busStopDetailCell";
    
    BusStopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"BusStopDetailTableViewCell" bundle:nil] forCellReuseIdentifier:busCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BusStopDetailTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.busStopArray count] != 0) {
        
        cell.lbl_busNumber.text = [CustomBusMode handleStringWithCharRoad:[(AMapBusLine *)self.busStopArray[indexPath.section][self.currentIndex] name]];
//        cell.lbl_busNumberSub.text = [CustomBusMode handleStringGetBrackets:[(AMapPOI *)self.nearByArray[indexPath.section] address]];
        cell.lbl_busGoto.text = [CustomBusMode replaceStringWithBusModel:[self.busStopArray[indexPath.section][self.currentIndex] endStop]];
        
        cell.lbl_busFirstTime.text = [CustomBusMode replaceStringWithBusModel:[CustomBusMode getBusTimeFromString:[self.busStopArray[indexPath.section][self.currentIndex] startTime]]];
        cell.lbl_busEndTime.text = [CustomBusMode replaceStringWithBusModel:[CustomBusMode getBusTimeFromString:[self.busStopArray[indexPath.section][self.currentIndex] endTime]]];
        
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            
            NSDictionary *dic = [CustomBusMode calculateNearestStopWithUserLocation:MACoordinateConvert(self.locationManager.location.coordinate, MACoordinateTypeGPS) data:self.busStopArray[indexPath.section][self.currentIndex]];
            
            cell.lbl_busDistance.text   = [NSString stringWithFormat:@"%.0f米",[[dic objectForKey:@"distance"] floatValue]];
            cell.lbl_busNearbyStop.text = [dic objectForKey:@"name"];

            cell.arrImg.autoresizesSubviews = NO;
            CLLocationCoordinate2D target;
            target.latitude = [[dic objectForKey:@"lat"] floatValue];
            target.longitude = [[dic objectForKey:@"long"] floatValue];
            cell.arrImg.target = target;
            
        }else{
            cell.lbl_busNearbyStop.text = @"无法获取";
            cell.lbl_busDistance.text   = @"无法获取";
        }
        
        if ([self.busStopArray[indexPath.section][self.currentIndex] basicPrice] == [self.busStopArray[indexPath.section][self.currentIndex] totalPrice] ) {
            NSString *temp = [CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",[self.busStopArray[indexPath.section][self.currentIndex] basicPrice]]];
            cell.lbl_busPrice.text = [NSString stringWithFormat:@"%@",temp];
        }else{
            cell.lbl_busPrice.text = [NSString stringWithFormat:@"%@-%@",[CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",[self.busStopArray[indexPath.section][self.currentIndex] basicPrice]]],[CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",[self.busStopArray[indexPath.section][self.currentIndex] totalPrice]]]];
        }
        
        cell.lbl_busFullDistance.text = [NSString stringWithFormat:@"%@公里",[CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.2f",[(AMapBusLine *)self.busStopArray[indexPath.section][self.currentIndex] distance]]]];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearAndShowAnnotationWithTip:str];

}

- (void)clearAndShowAnnotationWithTip:(NSString *)tip
{
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = tip;
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
        [self.busStopArray addObject:response.buslines];
        [self.tableView reloadData];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self hideProgressHUD];
    [self showHudTipStr:@"抱歉,未找到该线路信息或者网络出了点问题😢"];
}

@end
