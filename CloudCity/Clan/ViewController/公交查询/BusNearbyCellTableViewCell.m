//
//  BusNearbyCellTableViewCell.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 20/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusNearbyCellTableViewCell.h"

@implementation BusNearbyCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lbl_busNumber.font    = [UIFont boldSystemFontOfSize:20];
    _lbl_busNumberSub.font = [UIFont boldSystemFontOfSize:15];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
