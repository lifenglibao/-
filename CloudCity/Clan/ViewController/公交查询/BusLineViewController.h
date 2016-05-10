//
//  BusLineViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface BusLineViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AMapSearchDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITextField *busLineSearchFiled;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, strong) AMapSearchAPI *search;
@end
