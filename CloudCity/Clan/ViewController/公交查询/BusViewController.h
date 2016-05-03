//
//  BusViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 25/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBusMode.h"
#import "BaseMapViewController.h"

@class CustomBusMode;
@interface BusViewController : BaseViewController<UIScrollViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,AMapSearchDelegate>


@property (nonatomic, strong) UITextField *searchFiled;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, strong) NSMutableArray *busLines;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
