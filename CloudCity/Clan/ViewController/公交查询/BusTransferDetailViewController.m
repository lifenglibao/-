//
//  BusTransferDetailViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 10/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferDetailViewController.h"
#import "CustomBusMode.h"
#import "BusTransferDetailTableViewCell.h"

@interface BusTransferDetailViewController ()


@end

@implementation BusTransferDetailViewController

- (id)init
{
    if (self = [super init])
    {
        self.isOpen = false;
        self.routeData = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"换乘方案";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self getRoutePlanningData];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth - 20, ScreenBoundsHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.routeData[indexPath.row];
    if (self.isOpen && [dic.allKeys containsObject:@"endStop"]) {
        return [Util heightForText:[self.routeData[indexPath.row] objectForKey:@"endStop"] font:[UIFont systemFontOfSize:13] withinWidth:tableView.width];
    }
    return 30;
}

- (BusTransferDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busCellIdentifier = @"busRouteCell";
    
    BusTransferDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[BusTransferDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:busCellIdentifier];
        
    }
    
//    if ([self.routeData[indexPath.row] objectForKey:@"start"]) {
//        cell.textLabel.text  = self.routeStartLocation;
//        cell.imageView.image = kIMG(@"icon_start_stop");
//        cell.imageView.layer.cornerRadius = 15;
//    }else if ([self.routeData[indexPath.row] objectForKey:@"tips"]) {
//        cell.textLabel.text  = [self.routeData[indexPath.row] objectForKey:@"tips"];
//        cell.imageView.image = kIMG(@"man");
//    }else if ([self.routeData[indexPath.row] objectForKey:@"departureStop"]) {
//        cell.textLabel.attributedText = [CustomBusMode changeTextColorToRed :[NSString stringWithFormat:@"在%@上车",[self.routeData[indexPath.row] objectForKey:@"departureStop"]] withRange:[self.routeData[indexPath.row] objectForKey:@"departureStop"]];
//        cell.imageView.image = kIMG(@"bus");
//    }else if ([self.routeData[indexPath.row] objectForKey:@"busName"]) {
//        cell.textLabel.attributedText = [CustomBusMode changeTextColorToRed :[NSString stringWithFormat:@"乘坐%@",[self.routeData[indexPath.row] objectForKey:@"busName"]] withRange:[self.routeData[indexPath.row] objectForKey:@"busName"]];
//        cell.imageView.image = kIMG(@"bus");
//    }else if ([self.routeData[indexPath.row] objectForKey:@"arrivalStop"] || [self.routeData[indexPath.row] objectForKey:@"viaBusStops"]) {
//        cell.textLabel.attributedText = [CustomBusMode changeTextColorToRed :[NSString stringWithFormat:@"途径%lu站,在%@下车",[[self.routeData[indexPath.row] objectForKey:@"viaBusStops"] count],[self.routeData[indexPath.row] objectForKey:@"arrivalStop"]]withRange:[self.routeData[indexPath.row] objectForKey:@"arrivalStop"]];
//        cell.imageView.image = kIMG(@"bus");
//    }else if ([self.routeData[indexPath.row] objectForKey:@"end"]) {
//        cell.textLabel.text  = self.routeDestinationLocation;
//        cell.imageView.image = kIMG(@"icon_end_stop");
//        cell.imageView.layer.cornerRadius = 15;
//    }

    
    if ([self.routeData[indexPath.row] objectForKey:@"start"]) {
        cell.textLabel.text  = self.routeStartLocation;
        UIImage * img = [UIImage imageWithColor:[UIColor blueColor] withFrame:CGRectMake(0, 0, 5, 5) alpha:0.7];
        cell.imageView.image = img;
        cell.imageView.layer.cornerRadius = 15;
        
    }else if ([self.routeData[indexPath.row] objectForKey:@"walking"]) {
        cell.textLabel.text  = [self.routeData[indexPath.row] objectForKey:@"walking"];
        cell.imageView.image = kIMG(@"walking_man");
        cell.imageView.frame = CGRectMake(20, 0, 10, 10);

    }else if ([self.routeData[indexPath.row] objectForKey:@"departureStop"]) {
        cell.textLabel.text = [self.routeData[indexPath.row] objectForKey:@"departureStop"];
        cell.imageView.image = [UIImage imageWithColor:[UIColor clearColor] withFrame:CGRectMake(0, 0, 5, 5) alpha:1];
        
    }else if ([self.routeData[indexPath.row] objectForKey:@"endStop"]) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = [self.routeData[indexPath.row] objectForKey:@"endStop"];
        cell.imageView.image = kIMG(@"bus");
        cell.imageView.frame = CGRectMake(20, 0, 10, 10);
        
        cell.accessoryView = [[ UIImageView alloc ] initWithImage:kIMG(@"rate_down")];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 15, 15)];
        
    }else if ([self.routeData[indexPath.row] objectForKey:@"arrivalStop"]){
        cell.textLabel.text = [self.routeData[indexPath.row] objectForKey:@"arrivalStop"];
        cell.imageView.image = [UIImage imageWithColor:[UIColor clearColor] withFrame:CGRectMake(0, 0, 5, 5) alpha:1];

    }else if ([self.routeData[indexPath.row] objectForKey:@"walking"]) {
        cell.textLabel.text  = [self.routeData[indexPath.row] objectForKey:@"walking"];
        cell.imageView.image = kIMG(@"walking_man");
        cell.imageView.frame = CGRectMake(20, 0, 10, 10);
        
    }else if ([self.routeData[indexPath.row] objectForKey:@"end"]) {
        cell.textLabel.text  = self.routeDestinationLocation;
        UIImage * img = [UIImage imageWithColor:[UIColor redColor] withFrame:CGRectMake(0, 0, 5, 5) alpha:0.7];
        cell.imageView.image = img;
        cell.imageView.layer.cornerRadius = 15;
    }

    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel sizeToFit];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setLineBreakMode:NSLineBreakByCharWrapping];
    cell.imageView.layer.masksToBounds = YES;
    return cell;
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.routeData[indexPath.row];
    
    if ([dic.allKeys containsObject:@"endStop"]) {
        self.isOpen = !self.isOpen;
//        self.selectIndex = indexPath.row;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (self.isOpen) {
            cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            cell.accessoryView.transform = CGAffineTransformMakeRotation(0);
        }
    }
    
    [tableView endUpdates];
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
