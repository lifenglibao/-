//
//  BusTransferDetailViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 10/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferDetailViewController.h"
#import "BusMapViewController.h"
#import "CustomBusMode.h"
#import "PopoverView.h"

@interface BusTransferDetailViewController ()


@end

@implementation BusTransferDetailViewController

- (id)init
{
    if (self = [super init])
    {
        self.routeData = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"换乘方案";
    [self initTableView];
    [self setRightNavItem];
    [self getRoutePlanningData];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightNavItem
{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    UIButton *viewmore = [UIButton buttonWithTitle:nil andImage:@"more_N" andFrame:CGRectMake(rightView.right - 37, (44-30)/2, 37, 30) target:self action:@selector(viewMoreAction:)];
    viewmore.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightView addSubview:viewmore];
    self.viewMoreBtn = viewmore;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightItem, nil]];
}


- (void)getRoutePlanningData
{
    self.routeData = [CustomBusMode getRoutePlanningBusDetailLine:self.busRoute.transits[self.currentCourse]];
    if (self.routeData && self.routeData.count !=0) {
        
        [self.routeData insertObject:[NSDictionary dictionaryWithObjectsAndKeys:self.routeStartLocation,@"start", nil] atIndex:0];
        [self.routeData addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.routeDestinationLocation,@"end", nil]];
        [self.tableView reloadData];
    }else{
        
    }
}
- (void)initTableView
{
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 84) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busCellIdentifier = @"busRouteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:busCellIdentifier];
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        [cell.textLabel sizeToFit];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setLineBreakMode:NSLineBreakByCharWrapping];
    }

    if ([self.routeData[indexPath.row] objectForKey:@"start"]) {
        cell.textLabel.text  = self.routeStartLocation;
        cell.imageView.image = kIMG(@"icon_start_stop");
        cell.imageView.layer.cornerRadius = 15;
    }else if ([self.routeData[indexPath.row] objectForKey:@"tips"]) {
        cell.textLabel.text  = [self.routeData[indexPath.row] objectForKey:@"tips"];
        cell.imageView.image = kIMG(@"man");
    }else if ([self.routeData[indexPath.row] objectForKey:@"departureStop"]) {
        cell.textLabel.attributedText = [CustomBusMode changeTextColorToRed :[NSString stringWithFormat:@"在%@上车",[self.routeData[indexPath.row] objectForKey:@"departureStop"]] withRange:[self.routeData[indexPath.row] objectForKey:@"departureStop"]];
        cell.imageView.image = kIMG(@"bus");
    }else if ([self.routeData[indexPath.row] objectForKey:@"busName"]) {
        cell.textLabel.attributedText = [CustomBusMode changeTextColorToRed :[NSString stringWithFormat:@"乘坐%@",[self.routeData[indexPath.row] objectForKey:@"busName"]] withRange:[self.routeData[indexPath.row] objectForKey:@"busName"]];
        cell.imageView.image = kIMG(@"bus");
    }else if ([self.routeData[indexPath.row] objectForKey:@"arrivalStop"] || [self.routeData[indexPath.row] objectForKey:@"viaBusStops"]) {
        cell.textLabel.attributedText = [CustomBusMode changeTextColorToRed :[NSString stringWithFormat:@"途径%lu站,在%@下车",[[self.routeData[indexPath.row] objectForKey:@"viaBusStops"] count],[self.routeData[indexPath.row] objectForKey:@"arrivalStop"]]withRange:[self.routeData[indexPath.row] objectForKey:@"arrivalStop"]];
        cell.imageView.image = kIMG(@"bus");
    }else if ([self.routeData[indexPath.row] objectForKey:@"end"]) {
        cell.textLabel.text  = self.routeDestinationLocation;
        cell.imageView.image = kIMG(@"icon_end_stop");
        cell.imageView.layer.cornerRadius = 15;
    }

    cell.imageView.layer.masksToBounds = YES;
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//更多按钮
- (void)viewMoreAction:(id)sender
{
    NSString *favoImgName = [Util isFavoed_withID:@"" forType:myBusTransfer] ? @"detail_favo_H" : @"favo_N";
    NSArray *titls = @[@"收藏",@"地图"];
    NSArray *imgsN = @[favoImgName,@"share_N"];
    NSArray *imgsH = @[favoImgName,@"share_N"];
    PopoverView *pop = [[PopoverView alloc]initWithFromBarButtonItem:_viewMoreBtn inView:self.view titles:titls images:imgsN selectImages:imgsH];
    pop.selectIndex = 0;
    WEAKSELF
    pop.selectRowAtIndex = ^(NSInteger index)
    {
        STRONGSELF
        if (index == 0)
            [strongSelf favoPortalAction];
        else if (index == 1)
            [strongSelf gotoMap];
    };
    [pop show];
}

- (void)gotoMap
{
    BusMapViewController *subViewController = [[BusMapViewController alloc] init];
    subViewController.busRoute = self.busRoute;
    subViewController.currentCourse = self.currentCourse;
    [self.navigationController pushViewController:subViewController animated:YES];
}

//收藏取消收藏
- (void)favoPortalAction
{
    if ([self checkLoginState]) {
        
//        _isFav = [Util isFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] forType:myBusTransfer];
//        
//        if (_isFav) {
//            //已收藏 删除收藏
//            [Util deleteFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] forType:myBusTransfer];
//            [self showHudTipStr:@"取消收藏成功"];
//        }else{
//            [Util addFavoed_withID:[NSString stringWithFormat:@"bus_line_%@",str] withFavoID:str forType:myBusTransfer];
//            [self showHudTipStr:@"收藏成功"];
//            
//        }
    }

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
