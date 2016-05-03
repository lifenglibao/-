//
//  BusViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 25/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusViewController.h"
#import "CustomGridView.h"
#import "MBProgressHUD.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "BusStopAnnotation.h"
#import "AMapTipAnnotation.h"
#import "BusLineViewController.h"
#import "CustomeTextField.h"

@interface BusViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation BusViewController
@synthesize tips = _tips;
@synthesize search = _search;
@synthesize tableView = _tableView;
@synthesize searchFiled = _searchFiled;



- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
        self.busLines = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公交";
    [self addGridView];
    [self addScrollView];
    [self initSearch];
    [self initSearchField];
    [self initSearchDisplay];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerView.height, ScreenWidth, self.view.height-_headerView.height)];
    _scrollView.contentSize = CGSizeMake(ScreenWidth*2, self.view.height-_headerView.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = NO;

    [self.view addSubview:_scrollView];
}

- (void)addGridView {
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _headerView.backgroundColor = [UIColor whiteColor];
    CustomGridView *gridView = [[CustomGridView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 41)];
    gridView.gridType = @"searchType";
    [gridView initScrollView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.target = self;
    for (int index = 0; index<[CustomBusMode getGridTitle].count; index++) {
        [gridView addCardWithTitle:[CustomBusMode getGridTitle][index] withSel:@selector(customListAction:)];
    }
    [gridView addCardDone];
    
    //添加阴影线
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, gridView.bottom, ScreenWidth, 3)];
    lineView.image = kIMG(@"qiehuanxuanxiang");
    [_headerView addSubview:gridView];
    [_headerView addSubview:lineView];
    [self.view addSubview:_headerView];
}

- (void)customListAction:(id)sender{
    if ([sender tag]-1000 == 0) {
        self.searchFiled.placeholder = @"输入线路名";
    }else if ([sender tag]-1000 == 1) {
        self.searchFiled.placeholder = @"输入站点名";
    }
    [_scrollView scrollRectToVisible:CGRectMake(ScreenWidth * ([sender tag]-1000) , 0, ScreenWidth, _scrollView.height) animated:YES];
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

- (void)clearAndShowAnnotationWithTip:(AMapTip *)tip
{
    
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = tip.name;
    line.city               = @"0395";
    line.requireExtension   = YES;
    
    [self.search AMapBusLineNameSearch:line];
    
//    AMapBusLineIDSearchRequest *request = [[AMapBusLineIDSearchRequest alloc] init];
//    request.city                        = @"漯河";
//    request.uid                         = tip.uid;
//    request.requireExtension            = YES;
//    
//    [self.search AMapBusLineIDSearch:request];
}

#pragma mark - AMapSearchDelegate

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}

/* 公交搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        [self.view endEditing:YES];
        [self.busLines setArray:response.buslines];
        BusLineViewController *vc = [[BusLineViewController alloc] init];
        vc.busStopArray = [NSMutableArray arrayWithArray:self.busLines];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    /* 按下键盘enter, 搜索poi */
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords         = key;
    request.city             = @"0395";
    request.requireExtension = YES;
    [self.search AMapPOIKeywordsSearch:request];
    self.searchFiled.placeholder = key;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
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
    self.searchFiled.placeholder = tip.name;
}

#pragma mark - Initialization

- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initSearchField
{
    self.searchFiled = [[CustomeTextField alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth - 40 , 50)];
    self.searchFiled.delegate = self;
    [self.searchFiled addTarget:self action:@selector(isEditing:) forControlEvents:UIControlEventAllEditingEvents];
    [_scrollView addSubview:self.searchFiled];
}

- (void)initSearchDisplay
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.searchFiled.frame.origin.x, self.searchFiled.bottom + 5, self.searchFiled.width, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [_scrollView addSubview:self.tableView];

}

//func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//    let pageWidth = Int(Float(scrollView.frame.size.width))
//    
//    let page = Int(Float(scrollView.contentOffset.x) / Float(pageWidth))
//    segmented?.selectItemAtIndex(page, withAnimation: true)

@end
