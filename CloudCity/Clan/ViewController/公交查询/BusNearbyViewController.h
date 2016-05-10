//
//  BusNearbyViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseMapViewController.h"

@interface BusNearbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nearByArray;

@end
