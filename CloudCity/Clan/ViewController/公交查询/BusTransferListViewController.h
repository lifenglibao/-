//
//  BusTransferListViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 23/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface BusTransferListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) AMapRoute *busRoute;
@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic) NSString *routeStartLocation;
@property (nonatomic) NSString *routeDestinationLocation;

@end
