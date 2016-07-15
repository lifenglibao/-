//
//  DiscoverViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BaseViewController.h"
#import "DiscoverModel.h"
#import "DiscoverGroupModel.h"
#import "CustomHomeMode.h"
#import "LxGridView.h"
#import "NSObject+MJKeyValue.h"
#import "HomeViewModel.h"

@interface DiscoverViewController : BaseViewController <LxGridViewDataSource, LxGridViewDelegateFlowLayout, LxGridViewCellDelegate>
@property (strong, nonatomic) DiscoverGroupModel *discoverGroupModel;
@property (strong, nonatomic) DiscoverModel      *discoverModel;
@property (strong, nonatomic) CustomHomeMode     *customHomeModel;
@property (strong, nonatomic) HomeViewModel      *homeviewmodel;
@end
