//
//  BusStopDetailViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseMapViewController.h"
#import "BusViewController.h"

@interface BusStopDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *busStopArray;
@property (nonatomic) BOOL isFav;
@property (nonatomic, strong) UIButton *favBtn;
@property (nonatomic, strong) AMapBusStop *busStop;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
