//
//  BusSearchHistoryViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 27/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"

@interface BusSearchHistoryViewController : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *historyArray;
@property (strong, nonatomic) UIView *headerView;

- (void)writeHistoryPlist :(NSString *)str;
- (void)writeHistoryPlist :(NSString *)str withlat:(CGFloat )lat lon:(CGFloat) lon;

typedef NS_ENUM(NSInteger, BusSearchHistoryType)
{
    BusSearchHistoryTypeLine = 0,
    BusSearchHistoryTypeStop,
    BusSearchHistoryTypeTransfer
};

@property (nonatomic) BusSearchHistoryType historyType;

@end
