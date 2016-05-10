//
//  BusNearbyViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusNearbyViewController.h"
#import "ArrowImageView.h"

@interface BusNearbyViewController ()

@end

@implementation BusNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showProgressHUDWithStatus:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAutoUpdate:) name:@"NEARBY_REFRESHED" object:nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void) doAutoUpdate:(NSNotification*)noti
{
    self.nearByArray = [noti.userInfo objectForKey:@"nearbyBusStop"];
    [self sortingData];
    [self.tableView reloadData];
    [self hideProgressHUD];
}

- (void) sortingData {
    NSMutableArray *data = [NSMutableArray array];
    for (AMapPOI *poi in self.nearByArray) {
        if ([poi.address containsString:@";"]) {
            NSArray* temp = [poi.address componentsSeparatedByString:@";"];
            for (int i = 0 ; i<temp.count; i++) {
                AMapPOI *subPoi = [[AMapPOI alloc] init];
                subPoi.uid = poi.uid;
                subPoi.name = poi.name;
                subPoi.type = poi.type;
                subPoi.location = poi.location;
                subPoi.distance = poi.distance;
                subPoi.address = temp[i];
                [data addObject:subPoi];
            }
        }else{
            [data addObject:poi];
        }
    }
    self.nearByArray = [NSMutableArray arrayWithArray:data];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.nearByArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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
    busNumLabel.text = [self.nearByArray[indexPath.section] valueForKey:@"address"];
    
    UILabel *busStopLabel = [[UILabel alloc] initWithFrame:CGRectMake(busNumLabel.right + 20, 5, tableView.width - busNumLabel.right - 20, 50)];
    busStopLabel.numberOfLines = 0;
    busStopLabel.lineBreakMode = NSLineBreakByCharWrapping;
    busStopLabel.font = [UIFont boldSystemFontOfSize:16];
    busStopLabel.textColor = [UIColor grayColor];
//    busStopLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.nearByArray[indexPath.section] valueForKey:@"startStop"],[self.nearByArray[indexPath.section] valueForKey:@"endStop"]];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(busNumLabel.right + 20, busStopLabel.bottom , 70, 30)];
    tempLabel.textColor = [UIColor lightGrayColor];
    tempLabel.font = [UIFont systemFontOfSize:12];
    tempLabel.text = @"离我最近站 ";
    
    UILabel *busNearByLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempLabel.right, busStopLabel.bottom , tableView.width - busNumLabel.right - tempLabel.width - 20, 30)];
    busNearByLabel.textColor = [UIColor returnColorWithPlist:YZSegMentColor];
    busNearByLabel.font = [UIFont systemFontOfSize:12];
    busNearByLabel.text = [self.nearByArray[indexPath.section] valueForKey:@"name"];
    
    ArrowImageView *arrow = [[ArrowImageView alloc] initWithImage:kIMG(@"userPosition")];
    arrow.frame = CGRectMake(busNearByLabel.right - 50, cell.contentView.height/2,30,30);
    arrow.autoresizesSubviews = NO;
    
    UILabel *busDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, tableView.width, 30)];
    busDistanceLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    busDistanceLabel.textColor = [UIColor lightGrayColor];
    busDistanceLabel.font = [UIFont systemFontOfSize:12];
    busDistanceLabel.text = [NSString stringWithFormat:@"距离: %@米",[self.nearByArray[indexPath.section] valueForKey:@"distance"]];
    
    [cell.contentView addSubview:busNumLabel];
    [cell.contentView addSubview:busStopLabel];
    [cell.contentView addSubview:tempLabel];
    [cell.contentView addSubview:busNearByLabel];
    [cell.contentView addSubview:busDistanceLabel];
    [cell.contentView addSubview:arrow];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEARBY_TAPED" object:nil userInfo:[NSDictionary dictionaryWithObject:[self.nearByArray[indexPath.section] valueForKey:@"address"] forKey:@"name"]];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEARBY_REFRESHED" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEARBY_TAPED" object:self];
    NSLog(@"delloc!!!!!!!!");
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
