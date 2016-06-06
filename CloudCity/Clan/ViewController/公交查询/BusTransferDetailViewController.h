//
//  BusTransferDetailViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 10/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface BusTransferDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
@property (nonatomic, strong) AMapRoute *busRoute;
@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic) NSString *routeStartLocation;
@property (nonatomic) NSString *routeDestinationLocation;

@property (nonatomic) NSMutableArray *routeData;

@end
