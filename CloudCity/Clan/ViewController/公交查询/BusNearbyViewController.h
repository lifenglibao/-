//
//  BusNearbyViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface BusNearbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *nearByArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL isReadMore;
@property (assign, nonatomic) BOOL isNoMore;
@property (strong, nonatomic) UIView *maskView;
@end
