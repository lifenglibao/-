//
//  BusTransferViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 10/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferViewController.h"
#import "CustomeTextField.h"

@interface BusTransferViewController ()

@end

@implementation BusTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    [self initBusTransferSearchField];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.busTransferStartSearchFiled.frame.origin.x, self.busTransferStartSearchFiled.bottom + 5, self.busTransferStartSearchFiled.width, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
}

- (void)initBusTransferSearchField
{
//    self.busTransferStartSearchFiled = [[CustomeTextField alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 50)];
    self.busTransferStartSearchFiled.delegate = self;
//    self.busTransferStartSearchFiled.placeholder = @"输入起始站";
    [self.busTransferStartSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
//    [self.view addSubview:self.busTransferStartSearchFiled];
    
//    self.busTransferEndSearchFiled = [[CustomeTextField alloc] initWithFrame:CGRectMake(20, self.busTransferStartSearchFiled.bottom, ScreenWidth - 40, 50)];
    self.busTransferEndSearchFiled.delegate = self;
//    self.busTransferEndSearchFiled.placeholder = @"输入终点站站";
    [self.busTransferEndSearchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
//    [self.view addSubview:self.busTransferEndSearchFiled];
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
