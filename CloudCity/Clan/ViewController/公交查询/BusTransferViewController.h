//
//  BusTransfersViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 11/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "BusSearchHistoryViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface BusTransferViewController : BaseViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,AMapSearchDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UIView *backGroundView;
@property (nonatomic, strong) IBOutlet UITextField *busTransferStartSearchFiled;
@property (nonatomic, strong) IBOutlet UITextField *busTransferEndSearchFiled;
@property (nonatomic, strong) IBOutlet UIButton *transferBtn;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn;
@property (nonatomic, strong) IBOutlet UIView *sepView;

@property (nonatomic, strong) UITableView                    *tableView;
@property (nonatomic, strong) NSMutableArray                 *tips;
@property (nonatomic, strong) NSMutableArray                 *routeResultArr;
@property (nonatomic, strong) AMapSearchAPI                  *search;
@property (nonatomic, strong) BusSearchHistoryViewController * historyTableView;
@property (nonatomic        ) NSString                       *invertGeoResult;

typedef NS_ENUM(NSInteger, AMapRoutePlanningType)
{
    AMapRoutePlanningTypeDrive = 0,
    AMapRoutePlanningTypeWalk,
    AMapRoutePlanningTypeBus
};


@end
