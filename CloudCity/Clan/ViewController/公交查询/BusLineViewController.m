//
//  BusLineViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusLineViewController.h"
#import "BusLineDetailViewController.h"
#import "AMapTipAnnotation.h"

@interface BusLineViewController ()

@end

@implementation BusLineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"BusSearchNotiFicationForBusLine" object:nil queue:NSOperationQueuePriorityNormal usingBlock:^(NSNotification * _Nonnull note) {
        self.busLineSearchFiled.text = (NSString *)note.userInfo;
    }];
    
    self.tips = [NSMutableArray array];
    [self initBusLineSearchField];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.busLineSearchFiled.frame.origin.x, self.busLineSearchFiled.bottom + 5, self.busLineSearchFiled.width, self.view.height - self.busLineSearchFiled.bottom) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    
}

- (void)initBusLineSearchField
{
    self.busLineSearchFiled = [CustomBusMode setSearchTextFieldWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 50)];
    self.busLineSearchFiled.delegate = self;
    self.busLineSearchFiled.placeholder = @"输入线路名";
    [self.busLineSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:self.busLineSearchFiled];
}

- (void)initSearchBtn
{
    self.searchBtn = [UIButton buttonWithTitle:@"查询" andImage:@"" andFrame:CGRectMake(self.busLineSearchFiled.frame.origin.x, self.busLineSearchFiled.bottom + 20, self.busLineSearchFiled.width, 44) target:self action:@selector(searchBtnClicked:)];
    self.searchBtn.backgroundColor = kColourWithRGB(72, 185, 132);
    [self.view addSubview:self.searchBtn];
}

- (void)addSearchHistory
{
    _historyTableView = [[BusSearchHistoryViewController alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.searchBtn.bottom + 50, self.busLineSearchFiled.width, 300) style:UITableViewStylePlain];
    [_historyTableView setHistoryType:BusSearchHistoryTypeLine];
    [self.view addSubview:_historyTableView];
}

- (void)searchBtnClicked:(UIButton *)sender
{
    [self showProgressHUDWithStatus:@""];
    [self clearAndShowAnnotationWithTip:self.busLineSearchFiled.text];
    [self.historyTableView writeHistoryPlist:self.busLineSearchFiled.text];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.busLineSearchFiled) {
        self.tableView.frame = CGRectMake(self.busLineSearchFiled.frame.origin.x, self.busLineSearchFiled.bottom + 5, self.busLineSearchFiled.width, self.view.height - self.busLineSearchFiled.bottom);
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
    tips.city     = CURRENT_AREA_CODE;
    tips.types    = @"交通设施服务";
    tips.cityLimit = YES;
    
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
        self.busLineSearchFiled.text = tip.name;
        
    }else if (tableView == _historyTableView) {
        self.busLineSearchFiled.text = _historyTableView.historyArray[indexPath.row];
    }
}

- (void)clearAndShowAnnotationWithTip:(NSString *)tip
{
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = tip;
    line.city               = CURRENT_AREA_CODE;
    line.requireExtension = YES;
    [self.search AMapBusLineNameSearch:line];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.tips.count == 0) {
        return;
    }
    [self.tips removeAllObjects];
    for (int i = 0; i<response.tips.count; i++) {
        if (![[(AMapTip*)response.tips[i] uid] isEqualToString:@""] && [(AMapTip*)response.tips[i] location] == NULL) {
            [self.tips addObject:response.tips[i]];
        }
    }
    [self.tableView reloadData];
}

/* 公交路线搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    [self hideProgressHUD];
    
    if (response.buslines.count != 0)
    {
        BusLineDetailViewController *vc = [[BusLineDetailViewController alloc] init];
        vc.busLineArray = [NSMutableArray arrayWithArray:response.buslines];
        vc.title = self.busLineSearchFiled.text;
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self hideProgressHUD];
    [self showHudTipStr:@"抱歉,未找到该线路信息或者网络出了点问题😢"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
