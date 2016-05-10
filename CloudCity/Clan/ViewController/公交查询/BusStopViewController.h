//
//  BusStopViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 04/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>


@interface BusStopViewController : BaseViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,AMapSearchDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITextField *busStopSearchFiled;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, strong) NSMutableArray *busLines;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
