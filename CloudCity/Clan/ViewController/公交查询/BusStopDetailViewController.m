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

@interface BusStopDetailViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation BusStopDetailViewController
@synthesize tableView = _tableView;


- (void)viewWillAppear:(BOOL)animated
{
    [self initNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.busStop = self.busStopArray.firstObject;
    self.title = self.busStop.name;
    [self initTableView];
    [self initSearch];
    
    // Do any additional setup after loading the view.
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - self.navigationController.navigationBar.height - 30) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
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
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.busStop.buslines count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busCellIdentifier = @"busCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:busCellIdentifier];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *busNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    busNumLabel.textColor = [UIColor returnColorWithPlist:YZSegMentColor];
    busNumLabel.font = [UIFont boldSystemFontOfSize:20];
    busNumLabel.textAlignment = NSTextAlignmentCenter;
    
    NSRange range = [[self.busStop.buslines[indexPath.section] valueForKey:@"name"] rangeOfString:@"路"];
    NSString *str = [[self.busStop.buslines[indexPath.section] valueForKey:@"name"]substringToIndex:range.location+1];
    busNumLabel.text = str;
    
    UILabel *busStopLabel = [[UILabel alloc] initWithFrame:CGRectMake(busNumLabel.right + 20, 5, tableView.width - busNumLabel.right - 20, 50)];
    busStopLabel.numberOfLines = 0;
    busStopLabel.lineBreakMode = NSLineBreakByCharWrapping;
    busStopLabel.font = [UIFont boldSystemFontOfSize:16];
    busStopLabel.textColor = [UIColor grayColor];
    busStopLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.busStop.buslines[indexPath.section] valueForKey:@"startStop"],[self.busStop.buslines[indexPath.section] valueForKey:@"endStop"]];
    
    UILabel *busTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(busNumLabel.right + 20, busStopLabel.bottom , tableView.width - busNumLabel.right - 20, 30)];
    busTimeLabel.textColor = [UIColor lightGrayColor];
    busTimeLabel.font = [UIFont systemFontOfSize:12];
    busTimeLabel.text = [NSString stringWithFormat:@"首末班车 %@-%@",[self.busStop.buslines[indexPath.section] valueForKey:@"startTime"],[self.busStop.buslines[indexPath.section]valueForKey:@"endTime"]];
    
    [cell.contentView addSubview:busNumLabel];
    [cell.contentView addSubview:busStopLabel];
    [cell.contentView addSubview:busTimeLabel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSRange range = [[self.busStop.buslines[indexPath.section] valueForKey:@"name"] rangeOfString:@"路"];
    NSString *str = [[self.busStop.buslines[indexPath.section] valueForKey:@"name"]substringToIndex:range.location+1];
    [self clearAndShowAnnotationWithTip:str];

}

- (void)clearAndShowAnnotationWithTip:(NSString *)tip
{
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = tip;
    line.city               = @"0395";
    line.requireExtension = YES;
    [self.search AMapBusLineNameSearch:line];
}

/* 公交路线搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        [self.view endEditing:YES];
        BusLineDetailViewController *vc = [[BusLineDetailViewController alloc] init];
        vc.busLineArray = [NSMutableArray arrayWithArray:response.buslines];
        NSRange range = [[self.busStop.buslines[self.tableView.indexPathForSelectedRow.section] valueForKey:@"name"] rangeOfString:@"路"];
        NSString *str = [[self.busStop.buslines[self.tableView.indexPathForSelectedRow.section] valueForKey:@"name"]substringToIndex:range.location+1];
        vc.title = str;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
