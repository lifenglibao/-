//
//  BusLineViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusLineViewController.h"
#import "CustomeTextField.h"
#import "BusLineDetailViewController.h"
#import "AMapTipAnnotation.h"

@interface BusLineViewController ()

@end

@implementation BusLineViewController

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    [self initBusLineSearchField];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.busLineSearchFiled.frame.origin.x, self.busLineSearchFiled.bottom + 5, self.busLineSearchFiled.width, self.view.height - self.busLineSearchFiled.bottom) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    
}

- (void)initBusLineSearchField
{
    self.busLineSearchFiled = [[CustomeTextField alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 50)];
    self.busLineSearchFiled.delegate = self;
    self.busLineSearchFiled.placeholder = @"输入线路名";
    [self.busLineSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:self.busLineSearchFiled];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.busLineSearchFiled) {
        self.tableView.frame = CGRectMake(self.busLineSearchFiled.frame.origin.x, self.busLineSearchFiled.bottom + 5, self.busLineSearchFiled.width, self.view.height - self.busLineSearchFiled.bottom);
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
    tips.types    = @"交通设施服务";
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
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = tip.name;
    line.city               = @"0395";
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
    if (response.buslines.count != 0)
    {
        [self.view endEditing:YES];
        AMapTip *tip = self.tips[self.tableView.indexPathForSelectedRow.row];
        BusLineDetailViewController *vc = [[BusLineDetailViewController alloc] init];
        vc.busLineArray = [NSMutableArray arrayWithArray:response.buslines];
        vc.title = tip.name;
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
