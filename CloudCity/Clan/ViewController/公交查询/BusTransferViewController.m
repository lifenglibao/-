//
//  BusTransfersViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 11/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferViewController.h"
#import "CustomeTextField.h"
#import "BusTransferListViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    [self initSearchFiled];
    [self initSearch];
    [self initSearchDisplay];

    // Do any additional setup after loading the view from its nib.
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
}

- (void)initSearchDisplay
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.backGroundView.frame.origin.x, self.busTransferStartSearchFiled.bottom + 5, self.backGroundView.width, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
}

- (void)initSearchFiled
{
    self.busTransferStartSearchFiled.delegate = self;
    [self.busTransferStartSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    
    self.busTransferEndSearchFiled.delegate = self;
    [self.busTransferEndSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
}

- (IBAction)transferBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSString *tempStarTetx = self.busTransferStartSearchFiled.text;
    NSString *tempEndTetx  = self.busTransferEndSearchFiled.text;
    
    CLLocationCoordinate2D tempStartCoor  = self.startCoordinate;
    CLLocationCoordinate2D tempEndCorr    = self.destinationCoordinate;

    self.busTransferStartSearchFiled.text = tempEndTetx;
    self.busTransferEndSearchFiled.text = tempStarTetx;
    
    self.startCoordinate = tempEndCorr;
    self.destinationCoordinate = tempStartCoor;
    
}

- (IBAction)searchBtnClicked:(UIButton *)sender {
    
    [self showProgressHUDWithStatus:@""];
    self.routePlanningType = AMapRoutePlanningTypeBus;
    [self searchRoutePlanningBus];
}


#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    [self.view endEditing:YES];
    [self hideProgressHUD];
    if (response.route == nil)
    {
        [self showHudTipStr:@"抱歉,未找到该路径."];
        return;
    }
    BusTransferListViewController *vc = [[BusTransferListViewController alloc] init];
    vc.busRoute = response.route;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RoutePlanning Search

/* 公交路径规划搜索. */
- (void)searchRoutePlanningBus
{
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.city             = @"0395";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapTransitRouteSearch:navi];
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.busTransferStartSearchFiled) {
        self.tableView.frame = CGRectMake(self.backGroundView.frame.origin.x, self.busTransferStartSearchFiled.bottom + 10, self.backGroundView.width, 200);
    }else if (textField == self.busTransferEndSearchFiled) {
        self.tableView.frame = CGRectMake(self.backGroundView.frame.origin.x, self.busTransferEndSearchFiled.bottom + 10, self.backGroundView.width, 200);
    }
    self.tableView.hidden = NO;
}

- (void) isEditing:(UITextField *)textField
{
    [self searchTipsWithKey:textField.text];
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    
    if ([textField.text isEqualToString:@""]) {
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
    tips.city      = @"0395";
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
    AMapTip *tip = self.tips[indexPath.row];
    
    if ([self.busTransferStartSearchFiled isFirstResponder]) {
        self.startCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        self.busTransferStartSearchFiled.text = tip.name;
    }else if ([self.busTransferEndSearchFiled isFirstResponder]) {
        self.destinationCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        self.busTransferEndSearchFiled.text = tip.name;
    }
    self.tableView.hidden = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
