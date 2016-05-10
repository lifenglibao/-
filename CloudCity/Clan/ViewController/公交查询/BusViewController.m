//
//  BusViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 25/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusViewController.h"
#import "CustomGridView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "BusStopAnnotation.h"
#import "AMapTipAnnotation.h"
#import "BusLineViewController.h"
#import "CustomeTextField.h"
#import "SegmentView.h"
#import "BusStopViewController.h"
#import "BusNearbyViewController.h"
#import "BusLineDetailViewController.h"
#import "BusTransferViewController.h"

@interface BusViewController ()

@property (strong, nonatomic) UIView *headerView;

@end

@implementation BusViewController

- (void)notificationCome:(NSNotification *)noti {
    if ([noti.name isEqualToString:@"NEARBY_TAPED"]) {
        [self nearBySearch:[noti.userInfo objectForKey:@"name"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公交";
    [self initSearch];
    [self initTabBar];
    [self addGridView];
    [self initUserLocation];
    [self searchPoiByCenterCoordinate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCome:) name:@"NEARBY_TAPED" object:nil];
    // Do any additional setup after loading the view.
}

- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initUserLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEARBY_TAPED" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEARBY_REFRESHED" object:self];
}

- (void)addGridView {
    
    _headerView = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 44) andTitleArray:[CustomBusMode getGridTitle] clickBlock:^(NSInteger index) {
        self.selectedIndex = index;
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


- (void)nearBySearch:(NSString *)keyWord
{
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = keyWord;
    line.city               = @"0395";
    line.requireExtension = YES;
    [self.search AMapBusLineNameSearch:line];
}

- (void)searchPoiByCenterCoordinate
{
    CLLocationCoordinate2D  gaodeGPS = MACoordinateConvert(self.locationManager.location.coordinate, MACoordinateTypeGPS);
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude: gaodeGPS.latitude longitude:gaodeGPS.longitude];
    request.keywords            = @"公交站";
    request.radius              = 1000;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
}

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:response.pois forKey:@"nearbyBusStop"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEARBY_REFRESHED" object:nil userInfo:dic];
}

/* 公交路线搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        [self.view endEditing:YES];
        BusLineDetailViewController *vc = [[BusLineDetailViewController alloc] init];
        vc.busLineArray = [NSMutableArray arrayWithArray:response.buslines];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Initialization


- (void)initTabBar
{
    BusNearbyViewController * vc = [[BusNearbyViewController alloc] init];
    BusLineViewController *vc2 = [[BusLineViewController alloc] init];
    BusStopViewController *vc3 = [[BusStopViewController alloc] init];
    BusTransferViewController * vc4 = [[BusTransferViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *navi4 = [[UINavigationController alloc] initWithRootViewController:vc4];

    self.viewControllers = @[navi,navi2,navi3,navi4];
}

@end
