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

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic) NSMutableArray *collectData;
@property (nonatomic) NSInteger selectedIndex;

@end
