//
//  BusStopViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 04/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusStopViewController.h"
#import "CustomeTextField.h"
#import "BusStopDetailViewController.h"

@interface BusStopViewController ()

@end

@implementation BusStopViewController


- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    [self initBusStopSearchField];
    [self initSearch];
    [self initSearchDisplay];
    // Do any additional setup after loading the view.
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
}

- (void)initSearchDisplay
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.busStopSearchFiled.frame.origin.x, self.busStopSearchFiled.bottom + 5, self.busStopSearchFiled.width, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
}

- (void)initBusStopSearchField
{
    self.busStopSearchFiled = [[CustomeTextField alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 50)];
    self.busStopSearchFiled.delegate = self;
    self.busStopSearchFiled.placeholder = @"输入站点名";
    [self.busStopSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:self.busStopSearchFiled];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.busStopSearchFiled) {
        self.tableView.frame = CGRectMake(self.busStopSearchFiled.frame.origin.x, self.busStopSearchFiled.bottom + 5, self.busStopSearchFiled.width, 200);
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
    tips.keywords = key;
    tips.city     = @"0395";
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
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndShowAnnotationWithTip:tip];
}

- (void)clearAndShowAnnotationWithTip:(AMapTip *)tip
{
    if ([self.busStopSearchFiled isFirstResponder]) {
    
        AMapBusStopSearchRequest *stop = [[AMapBusStopSearchRequest alloc] init];
        stop.keywords = tip.name;
        stop.city     = @"0395";
        [self.search AMapBusStopSearch:stop];
    }
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}

/* 公交站点搜索回调. */

- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response
{
    if (response.busstops.count != 0)
    {
        [self.view endEditing:YES];
        BusStopDetailViewController *vc = [[BusStopDetailViewController alloc] init];
        vc.busStopArray = [NSMutableArray arrayWithArray:response.busstops];
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}


@end
