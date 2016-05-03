//
//  BusLineViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusLineViewController.h"
#import "CustomGridView.h"
#import "NSDate+Helper.h"
#import "SegmentView.h"

@interface BusLineViewController ()
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation BusLineViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableDic = self.busStopArray.firstObject;
    [self initMapView];
    [self initTableView];
    [self addHeaderView];
    [self addFooterView];

    // Do any additional setup after loading the view.
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (void)addHeaderView {
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 84)];
    _headerView.backgroundColor = [UIColor whiteColor];
    CustomGridView *gridView = [[CustomGridView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 61)];
    [gridView initScrollView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.target = self;
    NSArray * title = [NSArray arrayWithObjects:[self.busStopArray.firstObject valueForKey:@"endStop"],[self.busStopArray.lastObject valueForKey:@"endStop"], nil];
    for (int index = 0; index<title.count; index++) {
        [gridView addCardWithTitle:[NSString stringWithFormat:@"开往: %@",title[index]] withSel:@selector(headerViewAction:)];
    }
    [gridView addCardDone];

    [_headerView addSubview:gridView];

    UIView * busInfo = [[UIView alloc] initWithFrame:CGRectMake(0, gridView.bottom, ScreenWidth, 20)];
    busInfo.backgroundColor = [UIColor clearColor];
    
    UILabel * firstBus = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 70, 20)];
    firstBus.font = [UIFont systemFontOfSize:12];
    firstBus.text = [NSString stringWithFormat:@"首班: %@",[NSDate getBusTimeFromString:[self.tableDic valueForKey:@"startTime"]]];
    
    UILabel * endBus = [[UILabel alloc] initWithFrame:CGRectMake(firstBus.right, 0, 70, 20)];
    endBus.font = [UIFont systemFontOfSize:12];
    endBus.text = [NSString stringWithFormat:@"末班: %@",[NSDate getBusTimeFromString:[self.tableDic valueForKey:@"endTime"]]];
    
    UILabel * busDistance = [[UILabel alloc] initWithFrame:CGRectMake(endBus.right, 0, 100, 20)];
    busDistance.font = [UIFont systemFontOfSize:12];
    busDistance.text = [NSString stringWithFormat:@"全程: %.2f公里", [[NSString stringWithFormat:@"%@", [self.tableDic valueForKey:@"distance"]] floatValue]];
    
    UILabel * busPrice = [[UILabel alloc] initWithFrame:CGRectMake(busDistance.right, 0, 80, 20)];
    busPrice.font = [UIFont systemFontOfSize:12];
    busPrice.text = [NSString stringWithFormat:@"票价: %@-%@元",[self.tableDic valueForKey:@"basicPrice"],[self.tableDic valueForKey:@"totalPrice"]];
    
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
    
    NSArray * title = [NSArray arrayWithObjects:@"刷新",@"未定义",@"地图", nil];
    NSArray * icon = [NSArray arrayWithObjects: [UIImage imageNamed:@"1_10"],[UIImage imageNamed:@"1_1"],[UIImage imageNamed:@"1_2"],nil];

    _footerView = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, ScreenHeight - 120, ScreenWidth, 60) andTitleArray:title andIconArray:icon clickBlock:^(NSInteger index) {
        if (index == 1) {
            [self.tableView reloadData];
        }else if (index == 2) {
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
    self.tableDic = self.busStopArray[index];
    [self.tableView reloadData];
}

- (void)go2Map {
    
    NSString *className = @"BusMapViewController";
    
    BaseMapViewController *subViewController = [[NSClassFromString(className) alloc] init];
    subViewController.mapView = self.mapView;
    subViewController.busLine = (AMapBusLine*)self.tableDic;
    [self.navigationController pushViewController:(UIViewController*)subViewController animated:YES];
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
    return [[self.tableDic valueForKey:@"busStops"] count];
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
    cell.textLabel.text = [[self.tableDic valueForKey:@"busStops"][indexPath.row] valueForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = @"BusMapViewController";
    
    BaseMapViewController *subViewController = [[NSClassFromString(className) alloc] init];
    subViewController.mapView = self.mapView;
    subViewController.busStop = (AMapBusStop*)[self.tableDic valueForKey:@"busStops"][indexPath.row];
    [self.navigationController pushViewController:(UIViewController*)subViewController animated:YES];
}

#pragma mark - scrollview delegate 修复错位问题

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    CGFloat y = self.tableView.contentOffset.y;
//    if (y > self.lastScrollOffset) {
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect newFrame = _footerView.frame;
//            newFrame.origin.y = self.view.height;
//            _footerView.frame = newFrame;
//        } completion:^(BOOL finished) {
//
//        }];
//        
//    }else if (y < self.lastScrollOffset){
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect newFrame = _footerView.frame;
//            newFrame.origin.y = self.view.height - 50;
//            _footerView.frame = newFrame;
//        } completion:^(BOOL finished) {
//
//        }];
//    }
//    self.lastScrollOffset = y;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [UIView animateWithDuration:0.5 animations:^{
//        CGRect newFrame = _footerView.frame;
//        newFrame.origin.y = self.view.height - 50;
//        _footerView.frame = newFrame;
//    } completion:^(BOOL finished) {
//        
//    }];
//}


@end
