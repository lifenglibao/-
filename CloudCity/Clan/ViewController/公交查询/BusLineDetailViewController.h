//
//  BusLineDetailViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import "BusViewController.h"

@interface BusLineDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *busLineArray;
@property (nonatomic) CGFloat lastScrollOffset;
@property (nonatomic) BOOL isFav;
@property (nonatomic, strong) UIButton *favBtn;
@property (nonatomic, strong) AMapBusLine *line;
@property (nonatomic, strong) MAMapView *mapView;

@end
