//
//  BusTransfersViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 11/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferViewController.h"
#import "BusTransferListViewController.h"
#import "Locator.h"

@interface BusTransferViewController ()

@property (nonatomic) AMapRoutePlanningType routePlanningType;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@end

@implementation BusTransferViewController

@synthesize startCoordinate         = _startCoordinate;
@synthesize destinationCoordinate   = _destinationCoordinate;


- (id)init
{
    if (self = [super init])
    {
        self.routeResultArr = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    [self initSearchFiled];
    [self initSearch];
    [self initSearchDisplay];
    [self addSearchHistory];
    [self initUserLocation];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"BusSearchNotiFicationForTransfer" object:nil queue:NSOperationQueuePriorityNormal usingBlock:^(NSNotification * _Nonnull note) {
        if ([self.busTransferStartSearchFiled.text isEqualToString:@""]) {
            self.busTransferStartSearchFiled.text = [note.userInfo objectForKey:@"name"];
            self.startCoordinate                  = CLLocationCoordinate2DMake([[note.userInfo objectForKey:@"lat"] floatValue], [[note.userInfo objectForKey:@"lon"] floatValue]);
        }else{
            self.busTransferEndSearchFiled.text   = [note.userInfo objectForKey:@"name"];
            self.destinationCoordinate            = CLLocationCoordinate2DMake([[note.userInfo objectForKey:@"lat"] floatValue], [[note.userInfo objectForKey:@"lon"] floatValue]);
        }
    }];

    // Do any additional setup after loading the view from its nib.
}


- (void)initUserLocation
{
    if ([[Locator sharedLocator] IsLocationServiceEnabled]) {

        CLLocationCoordinate2D  gaodeGPS      = MACoordinateConvert([(Locator *)[Locator sharedLocator] userLocation], MACoordinateTypeGPS);
        self.startCoordinate                  = CLLocationCoordinate2DMake(gaodeGPS.latitude, gaodeGPS.longitude);
        self.busTransferStartSearchFiled.text = @"我的位置";
    }else{
        self.busTransferStartSearchFiled.text = @"";
    }
}

- (void)initSearch
{
    self.search          = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initSearchDisplay
{
    self.tableView            = [[UITableView alloc] initWithFrame:CGRectMake(self.backGroundView.frame.origin.x, self.busTransferStartSearchFiled.bottom + 5, self.backGroundView.width, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.hidden     = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
}

- (void)initSearchFiled
{
    self.busTransferStartSearchFiled.delegate = self;
    [self.busTransferStartSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];

    self.busTransferEndSearchFiled.delegate   = self;
    [self.busTransferEndSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,_busTransferStartSearchFiled.height)];
    leftView.backgroundColor = kCLEARCOLOR;
    _busTransferStartSearchFiled.leftView = leftView;
    _busTransferStartSearchFiled.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel * leftView2 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,_busTransferEndSearchFiled.height)];
    leftView2.backgroundColor = kCLEARCOLOR;
    _busTransferEndSearchFiled.leftView = leftView2;
    _busTransferEndSearchFiled.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addSearchHistory
{
    _historyTableView = [[BusSearchHistoryViewController alloc] initWithFrame:CGRectMake(self.backGroundView.frame.origin.x, self.searchBtn.bottom + 50, ScreenWidth - 40, 300) style:UITableViewStylePlain];
    [_historyTableView setHistoryType:BusSearchHistoryTypeTransfer];
    [self.view addSubview:_historyTableView];
}

- (IBAction)transferBtnClicked:(UIButton *)sender {
    
    sender.selected                       = !sender.selected;
    NSString *tempStarTetx                = self.busTransferStartSearchFiled.text;
    NSString *tempEndTetx                 = self.busTransferEndSearchFiled.text;

    CLLocationCoordinate2D tempStartCoor  = self.startCoordinate;
    CLLocationCoordinate2D tempEndCorr    = self.destinationCoordinate;

    self.busTransferStartSearchFiled.text = tempEndTetx;
    self.busTransferEndSearchFiled.text   = tempStarTetx;

    self.startCoordinate                  = tempEndCorr;
    self.destinationCoordinate            = tempStartCoor;
    
}

- (IBAction)searchBtnClicked:(UIButton *)sender {
    
    if (![self.busTransferStartSearchFiled.text isEqualToString:@""] && ![self.busTransferEndSearchFiled.text isEqualToString:@""]) {
        
        [self showProgressHUDWithStatus:@""];
        [self invertGeo];
        self.routePlanningType = AMapRoutePlanningTypeBus;
        [self searchRoutePlanningBus];
        
        [self.historyTableView writeHistoryPlist:self.busTransferStartSearchFiled.text withlat:self.startCoordinate.latitude lon:self.startCoordinate.longitude];
        [self.historyTableView writeHistoryPlist:self.busTransferEndSearchFiled.text withlat:self.destinationCoordinate.latitude lon:self.destinationCoordinate.longitude];
    }else{
        [self showHudTipStr:@"请填写正确的路线名称"];
    }
}


#pragma mark - AMapSearchDelegate

/* 逆地理*/

- (void) invertGeo {
    
    if (![self.busTransferStartSearchFiled.text isEqualToString:@"我的位置"] && ![self.busTransferEndSearchFiled.text isEqualToString:@"我的位置"]) {
        return;
    }
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

    if ([self.busTransferStartSearchFiled.text isEqualToString:@"我的位置"]) {
    regeo.location                    = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    }else if ([self.busTransferEndSearchFiled.text isEqualToString:@"我的位置"]){
    regeo.location                    = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    }

    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        self.invertGeoResult = [NSString stringWithFormat:@"%@",response.regeocode.formattedAddress];
    }
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    [self.view endEditing:YES];
    if (response.route == nil)
    {
        [self showHudTipStr:@"抱歉,未找到该路线,换个路线试试"];
        return;
    }
    
    //  返程
    
    AMapTransitRouteSearchRequest *naviBack = [[AMapTransitRouteSearchRequest alloc] init];

    naviBack.requireExtension               = YES;
    naviBack.city                           = CURRENT_AREA_CODE;

    /* 出发点. */
    naviBack.origin                         = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                               longitude:self.destinationCoordinate.longitude];

    /* 目的地. */
    naviBack.destination                    = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                                    longitude:self.startCoordinate.longitude];

    [self.routeResultArr addObject:response.route];

    if (self.routeResultArr.count == 2) {

        [self hideProgressHUD];

    BusTransferListViewController *vc       = [[BusTransferListViewController alloc] init];
    vc.totalBusRoute                        = self.routeResultArr;

    if (![Util isBlankString:self.invertGeoResult]) {
        if ([self.busTransferStartSearchFiled.text isEqualToString:@"我的位置"]) {
            vc.routeStartLocation                   = self.invertGeoResult;
            vc.routeDestinationLocation             = self.busTransferEndSearchFiled.text;
        }else if ([self.busTransferEndSearchFiled.text isEqualToString:@"我的位置"]){
            vc.routeStartLocation                   = self.busTransferStartSearchFiled.text;
            vc.routeDestinationLocation             = self.invertGeoResult;
        }
    }else{
        vc.routeStartLocation                   = self.busTransferStartSearchFiled.text;
        vc.routeDestinationLocation             = self.busTransferEndSearchFiled.text;
    }

    vc.startCoordinate                      = self.startCoordinate;
    vc.destinationCoordinate                = self.destinationCoordinate;
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }else{
        [self.search AMapTransitRouteSearch:naviBack];
    }
}

#pragma mark - RoutePlanning Search

/* 公交路径规划搜索. */
- (void)searchRoutePlanningBus
{
    /// 公交换乘策略：0-最快捷模式；1-最经济模式；2-最少换乘模式；3-最少步行模式；4-最舒适模式；5-不乘地铁模式
    
    //  启程
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];

    navi.requireExtension               = YES;
    navi.city                           = CURRENT_AREA_CODE;

    /* 出发点. */
    navi.origin                         = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination                    = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapTransitRouteSearch:navi];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self.view endEditing:YES];
    [self hideProgressHUD];
    [self showHudTipStr:@"抱歉,未找到该路线,换个路线试试"];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.busTransferStartSearchFiled) {
        self.tableView.frame  = CGRectMake(self.backGroundView.frame.origin.x, self.busTransferStartSearchFiled.bottom + 20, self.backGroundView.width, 200);
    }else if (textField == self.busTransferEndSearchFiled) {
        self.tableView.frame  = CGRectMake(self.backGroundView.frame.origin.x, self.busTransferEndSearchFiled.bottom + 20, self.backGroundView.width, 200);
    }
    self.tableView.hidden = NO;
    [self.view bringSubviewToFront:self.tableView];
}

- (void) isEditing:(UITextField *)textField
{
    [self searchTipsWithKey:textField.text];
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    [self.view bringSubviewToFront:self.tableView];
    if ([textField.text isEqualToString:@""]) {
        [self.view sendSubviewToBack:self.tableView];
        self.tableView.hidden = YES;
    }
}

- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords  = key;
    tips.city      = CURRENT_AREA_CODE;
    tips.cityLimit = YES; //是否限制城市
    
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.district;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip                          = self.tips[indexPath.row];

    if ([self.busTransferStartSearchFiled isFirstResponder]) {

        self.startCoordinate                  = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        self.busTransferStartSearchFiled.text = tip.name;
    }else if ([self.busTransferEndSearchFiled isFirstResponder]) {
        self.destinationCoordinate            = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        self.busTransferEndSearchFiled.text   = tip.name;
    }
    self.tableView.hidden                 = YES;
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BusSearchNotiFicationForTransfer" object:nil];
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
