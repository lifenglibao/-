//
//  BusLineDetailViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusLineDetailViewController.h"
#import "CustomGridView.h"
#import "SegmentView.h"
#import "Util.h"
#import "LoginViewController.h"
#import "CustomBusMode.h"
#import "BusMapViewController.h"
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
    [self initTableView];
    [self addHeaderView];
    [self addFooterView];
    
    // Do any additional setup after loading the view.
}

- (void)initNavBar
{
//    _isFav = [CustomBusMode isFavoed_withID:[NSString stringWithFormat:@"%@%@",BUSLINEFAV,self.title] withFavoID:[NSString stringWithFormat:@"%@",self.title] forType:myBusLine];
//    NSString *favoImgName = _isFav ? @"detail_favo_H" : @"favo_N";
//
//    _favBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [_favBtn addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_favBtn setImage:kIMG(favoImgName) forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favBtn];
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
    
    UIView * busInfo = [[UIView alloc] initWithFrame:CGRectMake(0, gridView.bottom, ScreenWidth, 25)];
    busInfo.backgroundColor = [UIColor clearColor];
    
    UIImageView *firstBusImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
    firstBusImg.image = kIMG(@"icon_bus_start");
    firstBusImg.layer.cornerRadius = 1.5f;
    firstBusImg.layer.masksToBounds = YES;
    
    firstBus = [[UILabel alloc] initWithFrame:CGRectMake(firstBusImg.right + 5, 0, 50, 20)];
    firstBus.font = [UIFont systemFontOfSize:14];
    
    UIImageView *endBusImg = [[UIImageView alloc] initWithFrame:CGRectMake(firstBus.right, 0, 15, 15)];
    endBusImg.image = kIMG(@"icon_bus_end");
    endBusImg.layer.cornerRadius = 1.5f;
    endBusImg.layer.masksToBounds = YES;
    
    endBus = [[UILabel alloc] initWithFrame:CGRectMake(endBusImg.right + 5, 0, 50, 20)];
    endBus.font = [UIFont systemFontOfSize:14];
    
    busDistance = [[UILabel alloc] initWithFrame:CGRectMake(endBus.right, 0, 100, 20)];
    busDistance.font = [UIFont systemFontOfSize:14];
    
    busPrice = [[UILabel alloc] initWithFrame:CGRectMake(busDistance.right + 10, 0, 100, 20)];
    busPrice.font = [UIFont systemFontOfSize:14];
    

    [busInfo addSubview:firstBusImg];
    [busInfo addSubview:firstBus];
    [busInfo addSubview:endBusImg];
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
    
    [self updateHeaderViewInfomation];
    [self.view addSubview:_headerView];
    
}

- (void)addFooterView {

    _isFav                = [CustomBusMode isFavoed_withID:[NSString stringWithFormat:@"%@%@",BUSLINEFAV,self.title] withFavoID:[NSString stringWithFormat:@"%@",self.title] forType:myBusLine];
    NSString *favoImgName = _isFav ? @"detail_favo_H" : @"detail_favo";

    NSArray * title       = [NSArray arrayWithObjects:@"收藏",@"地图", nil];
    NSArray * icon        = [NSArray arrayWithObjects: kIMG(favoImgName) , kIMG(@"1_2"),nil];
    
    if (_footerView) {
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    
    _footerView = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, ScreenHeight - 120, ScreenWidth, 60) andTitleArray:title andIconArray:icon clickBlock:^(NSInteger index) {
        if (index == 0) {
            [self favAction];
        }else if (index == 1) {
            [self go2Map];
        }
    }];
    _footerView.backgroundColor     = [UIColor whiteColor];
    _footerView.layer.shadowOffset  = CGSizeMake(0, 0);
    _footerView.layer.shadowColor   = [UIColor darkGrayColor].CGColor;
    _footerView.layer.shadowRadius  = 1;
    _footerView.layer.shadowOpacity = .5f;
    CGRect shadowFrame              = _footerView.layer.bounds;
    CGPathRef shadowPath            = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    _footerView.layer.shadowPath    = shadowPath;
    
    [self.view addSubview:_footerView];
    
}

- (void)initTableView {
    
    self.tableView                    = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 84) style:UITableViewStylePlain];
    self.tableView.delegate           = self;
    self.tableView.dataSource         = self;
    self.tableView.backgroundColor    = [UIColor clearColor];
    self.tableView.layer.shadowOffset = CGSizeMake(2.5, 2.5);
    self.tableView.layer.shadowColor  = [UIColor darkGrayColor].CGColor;
    [self.view addSubview:_tableView];
}

- (void)updateHeaderViewInfomation {
    

    firstBus.text    = [CustomBusMode replaceStringWithBusModel:[CustomBusMode getBusTimeFromString:self.line.startTime]];
    endBus.text      = [CustomBusMode replaceStringWithBusModel:[CustomBusMode getBusTimeFromString:self.line.endTime]];

    busDistance.text = [NSString stringWithFormat:@"全程: %.2f公里", self.line.distance];
    
    if (self.line.basicPrice == self.line.totalPrice ) {
        
        NSString *temp = [CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",self.line.basicPrice]];
        if ([temp isEqualToString:@"未知"]) {
            busPrice.text = [NSString stringWithFormat:@"票价: %@",temp];
        }else{
            busPrice.text = [NSString stringWithFormat:@"票价: %@元",temp];
        }
    }else{
        NSString *temp = [CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",self.line.basicPrice]];
        NSString *temp2 = [CustomBusMode replaceStringWithBusModel:[NSString stringWithFormat:@"%.1f",self.line.totalPrice]];

        if ([temp isEqualToString:@"未知"] || [temp2 isEqualToString:@"未知"]) {
            busPrice.text = [NSString stringWithFormat:@"票价: %@-%@",temp,temp2];
        }else{
            busPrice.text = [NSString stringWithFormat:@"票价: %@-%@元",temp,temp2];
        }
        
    }
}
- (void)headerViewAction:(id)sender {
    
    NSInteger index = [sender tag]-1000;
    self.line = self.busLineArray[index];
    [self updateHeaderViewInfomation];
    [self.tableView reloadData];
}

- (void)go2Map {
    
    BusMapViewController *subViewController = [[BusMapViewController alloc] init];
    subViewController.busLine = self.line;
    [self.navigationController pushViewController:subViewController animated:YES];
    
}

- (void)favAction{
    
//    if (![UserModel currentUserInfo].logined || ![[NSUserDefaults standardUserDefaults]objectForKey:Code_CookieData]) {
//        //没有登录 跳出登录页面
//        LoginViewController *login = [[LoginViewController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
//        nav.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:nav animated:YES completion:nil];
//        return;
//    }
    _isFav = [CustomBusMode isFavoed_withID:[NSString stringWithFormat:@"%@%@",BUSLINEFAV,self.title] withFavoID:[NSString stringWithFormat:@"%@",self.title] forType:myBusLine];
    
    if (_isFav) {
        [CustomBusMode deleteFavoed_withID:[NSString stringWithFormat:@"%@%@",BUSLINEFAV,self.title] withFavoID:[NSString stringWithFormat:@"%@",self.title] forType:myBusLine];
        [self showHudTipStr:@"取消收藏成功"];
    }else{
        [CustomBusMode addFavoed_withID:[NSString stringWithFormat:@"%@%@",BUSLINEFAV,self.title] withFavoID:[NSString stringWithFormat:@"%@",self.title] forType:myBusLine];
        [self showHudTipStr:@"收藏成功"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self addFooterView];
    });
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
    cell.textLabel.text = [self.line.busStops[indexPath.row] valueForKey:@"name"];
    
    if ([cell.textLabel.text isEqualToString:self.line.startStop] ) {
        cell.imageView.image = kIMG(@"icon_start_stop");
        cell.imageView.layer.cornerRadius = 15;
    }
    else if ([cell.textLabel.text isEqualToString:self.line.endStop] ) {
        cell.imageView.image = kIMG(@"icon_end_stop");
        cell.imageView.layer.cornerRadius = 15;
    }
    else {
        cell.imageView.image = kIMG(@"icon_stop");
        cell.imageView.layer.cornerRadius = 10;
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.imageView.layer.masksToBounds = YES;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusMapViewController *subViewController = [[BusMapViewController alloc] init];
    subViewController.busStop = self.line.busStops[indexPath.row];
    [self.navigationController pushViewController:subViewController animated:YES];
}

@end
