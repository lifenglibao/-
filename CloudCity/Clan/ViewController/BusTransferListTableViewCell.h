//
//  BusTransferListTableViewCell.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 23/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusTransferListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_routePlanningBusNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_routePlanningBusInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_routePlanningBusStartStop;

@end
