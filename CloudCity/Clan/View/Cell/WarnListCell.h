//
//  WarnListCell.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 18/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"
#import "YZButton.h"

@interface WarnListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YZButton *btn_avatar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_content;
@property (strong, nonatomic) UIImageView *iv_newmess;

@property (weak, nonatomic) IBOutlet UIImageView *iv_line;
@property (strong, nonatomic) NotificationModel *warn;
@end
