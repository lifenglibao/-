//
//  BusStopDetailViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import "BusViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface BusStopDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) BaseTableView  *tableView;
@property (nonatomic, strong) NSMutableArray *busStopArray;
@property (nonatomic, strong) NSMutableArray *lineArray;

@property (nonatomic        ) BOOL           isFav;
@property (nonatomic, strong) UIButton       *favBtn;
@property (nonatomic, strong) AMapBusStop    *busStop;
@property (nonatomic, strong) AMapSearchAPI  *search;

@property (nonatomic        ) NSInteger      currentIndex;
@end
