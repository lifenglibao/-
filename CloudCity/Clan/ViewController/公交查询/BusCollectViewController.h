//
//  BusCollectViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 04/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface BusCollectViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI  *search;
@property (nonatomic, strong) BaseTableView  *tableView;
@property (nonatomic        ) NSMutableArray *collectData;
@property (nonatomic        ) NSInteger      selectedIndex;
@property (nonatomic, strong) NSMutableArray *routeResultArr;
@property (nonatomic, strong) NSString       *startLocationName;
@property (nonatomic, strong) NSString       *endLocationName;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@end
