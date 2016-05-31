//
//  BusStopDetailTableViewCell.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 28/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrowImageView.h"

@interface BusStopDetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbl_busNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busNumberSub;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busGoto;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busNearbyStop;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busFirstTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busFullDistance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_busDistance;

@property (weak, nonatomic) IBOutlet ArrowImageView *arrImg;
@property (weak, nonatomic) IBOutlet UIButton *btn_reverse;
@property (weak, nonatomic) IBOutlet UIButton *btn_fav;

@end
