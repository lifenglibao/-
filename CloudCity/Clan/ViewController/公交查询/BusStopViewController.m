//
//  BusStopViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 04/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusStopViewController.h"
#import "BusStopDetailViewController.h"

@interface BusStopViewController ()

@end

@implementation BusStopViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"BusSearchNotiFicationForStop" object:nil queue:NSOperationQueuePriorityNormal usingBlock:^(NSNotification * _Nonnull note) {
        self.busStopSearchFiled.text = (NSString *)note.userInfo;
    }];
    self.tips = [NSMutableArray array];
    [self initBusStopSearchField];
    [self initSearchBtn];
    [self initSearch];
    [self initSearchDisplay];
    [self addSearchHistory];
    // Do any additional setup after loading the view.
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initSearchDisplay
{
    self.tableView                     = [[UITableView alloc] initWithFrame:CGRectMake(self.busStopSearchFiled.frame.origin.x, self.busStopSearchFiled.bottom + 5, self.busStopSearchFiled.width, self.view.height - self.busStopSearchFiled.bottom) style:UITableViewStylePlain];
    self.tableView.dataSource          = self;
    self.tableView.delegate            = self;
    self.tableView.hidden              = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    
}

- (void)initBusStopSearchField
{
    self.busStopSearchFiled             = [CustomBusMode setSearchTextFieldWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 50)];
    self.busStopSearchFiled.delegate    = self;
    self.busStopSearchFiled.placeholder = @"输入站点名";
    [self.busStopSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:self.busStopSearchFiled];
}

- (void)initSearchBtn
{
    self.searchBtn                 = [UIButton buttonWithTitle:@"查询" andImage:@"" andFrame:CGRectMake(self.busStopSearchFiled.frame.origin.x, self.busStopSearchFiled.bottom + 20, self.busStopSearchFiled.width, 44) target:self action:@selector(searchBtnClicked:)];
    self.searchBtn.backgroundColor = kColourWithRGB(72, 185, 132);
    [self.view addSubview:self.searchBtn];
}

- (void)addSearchHistory
{
    _historyTableView = [[BusSearchHistoryViewController alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.searchBtn.bottom + 50, self.busStopSearchFiled.width, 300) style:UITableViewStylePlain];
    [_historyTableView setHistoryType:BusSearchHistoryTypeStop];
    [self.view addSubview:_historyTableView];
}

- (void)searchBtnClicked:(UIButton *)sender
{
    [self showProgressHUDWithStatus:@""];
    [self clearAndShowAnnotationWithTip:self.busStopSearchFiled.text];
    [self.historyTableView writeHistoryPlist:self.busStopSearchFiled.text];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.busStopSearchFiled) {
        self.tableView.frame = CGRectMake(self.busStopSearchFiled.frame.origin.x, self.busStopSearchFiled.bottom + 5, self.busStopSearchFiled.width, self.view.height - self.busStopSearchFiled.bottom);
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
    tips.keywords = key;
    tips.types    = BUS_STOP_SEARCH_TYPE;
    tips.city     = CURRENT_AREA_CODE;
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
        cell.imageView.image = [UIImage imageNamed:@"sousuo_gray"];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    if (tip.location == nil)
    {
        cell.imageView.image = [UIImage imageNamed:@"sousuo_gray"];
    }
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.district;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        [self.view endEditing:YES];
        [self.tableView setHidden:YES];
        [self.view sendSubviewToBack:self.tableView];
        AMapTip *tip = self.tips[indexPath.row];
        self.busStopSearchFiled.text = tip.name;
        
    }else if (tableView == _historyTableView) {
        self.busStopSearchFiled.text = _historyTableView.historyArray[indexPath.row];
    }
}

- (void)clearAndShowAnnotationWithTip:(NSString *)tip
{
    AMapBusStopSearchRequest *stop = [[AMapBusStopSearchRequest alloc] init];
    stop.keywords                  = tip;
    stop.city                      = CURRENT_AREA_CODE;
    [self.search AMapBusStopSearch:stop];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.tips.count == 0) {
        return;
    }
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
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
        [self.view endEditing:YES];
        self.tableView.hidden = YES;
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

@end
