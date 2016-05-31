//
//  BusTransferListTableViewCell.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 23/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferListTableViewCell.h"

@implementation BusTransferListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lbl_routePlanningBusStartStop.layer.borderWidth   = 0.5;
    _lbl_routePlanningBusStartStop.layer.borderColor   = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
