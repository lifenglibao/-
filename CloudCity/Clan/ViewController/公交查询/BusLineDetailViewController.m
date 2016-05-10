//
//  BusLineDetailViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusLineDetailViewController.h"
#import "CustomGridView.h"
#import "NSDate+Helper.h"
#import "SegmentView.h"
#import "Util.h"
#import "LoginViewController.h"

@interface BusLineDetailViewController ()
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@end

@implementation BusLineDetailViewController
@synthesize tableView = _tableView;


- (void)viewWillAppear:(BOOL)animated
{
    [self initNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.line = self.busLineArray.firstObject;
    [self initMapView];
    [self initTableView];
    [self addHeaderView];
    [self addFooterView];
    
    // Do any additional setup after loading the view.
}

- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.visibleMapRect = MAMapRectMake(219274180.99575466, 107631269.07922892, 0, 0);
}

- (void)initNavBar
{
    NSRange range = [self.line.name rangeOfString:@"("];
    NSString *str = [self.line.name substringToIndex:range.location];
    
    _isFav = [Util isFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] forType:myBusLine];
    _favBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_favBtn addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_isFav) {
        [_favBtn setImage:[UIImage imageNamed:@"detail_favo_H"] forState:UIControlStateNormal];
    }else{
        [_favBtn setImage:[UIImage imageNamed:@"favo_N"] forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favBtn];
}

- (void)addHeaderView {
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 84)];
    _headerView.backgroundColor = [UIColor whiteColor];
    CustomGridView *gridView = [[CustomGridView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 61)];
    [gridView initScrollView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.target = self;
    NSArray * title = [NSArray arrayWithObjects:[self.busLineArray.firstObject valueForKey:@"endStop"],[self.busLineArray.lastObject valueForKey:@"endStop"], nil];
    for (int index = 0; index<title.count; index++) {
        [gridView addCardWithTitle:[NSString stringWithFormat:@"开往: %@",title[index]] withSel:@selector(headerViewAction:)];
    }
    [gridView addCardDone];
    
    [_headerView addSubview:gridView];
    
    UIView * busInfo = [[UIView alloc] initWithFrame:CGRectMake(0, gridView.bottom, ScreenWidth, 20)];
    busInfo.backgroundColor = [UIColor clearColor];
    
    UILabel * firstBus = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 70, 20)];
    firstBus.font = [UIFont systemFontOfSize:12];
    firstBus.text = [NSString stringWithFormat:@"首班: %@",[NSDate getBusTimeFromString:self.line.startTime]];
    
    UILabel * endBus = [[UILabel alloc] initWithFrame:CGRectMake(firstBus.right, 0, 70, 20)];
    endBus.font = [UIFont systemFontOfSize:12];
    endBus.text = [NSString stringWithFormat:@"末班: %@",[NSDate getBusTimeFromString:self.line.endTime]];
    
    UILabel * busDistance = [[UILabel alloc] initWithFrame:CGRectMake(endBus.right, 0, 100, 20)];
    busDistance.font = [UIFont systemFontOfSize:12];
    busDistance.text = [NSString stringWithFormat:@"全程: %.2f公里", self.line.distance];
    
    UILabel * busPrice = [[UILabel alloc] initWithFrame:CGRectMake(busDistance.right, 0, 100, 20)];
    busPrice.font = [UIFont systemFontOfSize:12];
    busPrice.text = [NSString stringWithFormat:@"票价: %.1f-%.1f元",self.line.basicPrice,self.line.totalPrice];
    
    [busInfo addSubview:firstBus];
    [busInfo addSubview:endBus];
    [busInfo addSubview:busDistance];
    [busInfo addSubview:busPrice];
    
    [_headerView addSubview:busInfo];
    
    _headerView.layer.shadowOffset = CGSizeMake(0, 1);
    _headerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _headerView.layer.shadowRadius = 1;
    _headerView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = _headerView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    _headerView.layer.shadowPath = shadowPath;
    
    [self.view addSubview:_headerView];
    
}

- (void)addFooterView {
    
    NSArray * title = [NSArray arrayWithObjects:@"刷新",@"地图", nil];
    NSArray * icon = [NSArray arrayWithObjects: [UIImage imageNamed:@"1_10"],[UIImage imageNamed:@"1_2"],nil];
    
    _footerView = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, ScreenHeight - 120, ScreenWidth, 60) andTitleArray:title andIconArray:icon clickBlock:^(NSInteger index) {
        if (index == 0) {
            [self.tableView reloadData];
        }else if (index == 1) {
            [self go2Map];
        }
    }];
    _footerView.backgroundColor = [UIColor whiteColor];
    _footerView.layer.shadowOffset = CGSizeMake(0, 0);
    _footerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _footerView.layer.shadowRadius = 1;
    _footerView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = _footerView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    _footerView.layer.shadowPath = shadowPath;
    
    [self.view addSubview:_footerView];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 84) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.shadowOffset = CGSizeMake(2.5, 2.5);
    self.tableView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    [self.view addSubview:_tableView];
}

- (void)headerViewAction:(id)sender {
    
    NSInteger index = [sender tag]-1000;
    self.line = self.busLineArray[index];
    [self.tableView reloadData];
}

- (void)go2Map {
    
    NSString *className = @"BusMapViewController";
    
    BaseMapViewController *subViewController = [[NSClassFromString(className) alloc] init];
    subViewController.mapView = self.mapView;
    subViewController.busLine = self.line;
    [self.navigationController pushViewController:(UIViewController*)subViewController animated:YES];
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
    NSRange range = [self.line.name rangeOfString:@"("];
    NSString *str = [self.line.name substringToIndex:range.location];
    _isFav = [Util isFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] forType:myBusLine];
    
    if (_isFav) {
        //已收藏 删除收藏
        [_favBtn setImage:[UIImage imageNamed:@"favo_N"] forState:UIControlStateNormal];
        [Util deleteFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] forType:myBusLine];
        [self showHudTipStr:@"取消收藏成功"];
    }else{
        [_favBtn setImage:[UIImage imageNamed:@"detail_favo_H"] forState:UIControlStateNormal];
        [Util addFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] withFavoID:str forType:myBusLine];
        [self showHudTipStr:@"收藏成功"];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 84)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 84;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 54)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.line.busStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busCellIdentifier = @"busCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:busCellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [self.line.busStops[indexPath.row] valueForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = @"BusMapViewController";
    
    BaseMapViewController *subViewController = [[NSClassFromString(className) alloc] init];
    subViewController.mapView = self.mapView;
    subViewController.busStop = self.line.busStops[indexPath.row];
    [self.navigationController pushViewController:(UIViewController*)subViewController animated:YES];
}

@end
