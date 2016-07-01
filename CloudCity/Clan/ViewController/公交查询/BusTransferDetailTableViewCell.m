//
//  BusTransferDetailTableViewCell.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 25/06/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusTransferDetailTableViewCell.h"

@implementation BusTransferDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 0, 30, 30);
    self.textLabel.left  = self.imageView.right + 20;
//    self.detailTextLabel.frame = CGRectMake(self.accessoryView.left - 50, 0, 50, 30);
    
    CGPoint pos = self.imageView.center;
    pos.y       = self.textLabel.center.y;
    self.imageView.center = pos;
}

@end
