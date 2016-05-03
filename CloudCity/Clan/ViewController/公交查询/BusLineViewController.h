//
//  BusLineViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
@interface BusLineViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *busStopArray;
@property (nonatomic, strong) NSDictionary *tableDic;
@property (nonatomic) CGFloat lastScrollOffset;
@end
