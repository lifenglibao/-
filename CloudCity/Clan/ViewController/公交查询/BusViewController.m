//
//  BusViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 25/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusViewController.h"
#import "CustomGridView.h"
#import "BusLineViewController.h"
#import "SegmentView.h"
#import "BusStopViewController.h"
#import "BusNearbyViewController.h"
#import "BusTransferViewController.h"
#import "BusCollectViewController.h"

@interface BusViewController ()

@property (strong, nonatomic) UIView *headerView;

@end

@implementation BusViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公交";
    [self initTabBar];
    [self addGridView];
    [self initAMapSearchSer];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAMapSearchSer {
    [AMapSearchServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
}

- (void)addGridView {
    
    _headerView                     = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 44) andTitleArray:[CustomBusMode getGridTitle] clickBlock:^(NSInteger index) {
    self.selectedIndex              = index;
    }];
    _headerView.backgroundColor     = [UIColor whiteColor];
    _headerView.layer.shadowOffset  = CGSizeMake(0, 0);
    _headerView.layer.shadowColor   = [UIColor darkGrayColor].CGColor;
    _headerView.layer.shadowRadius  = 1;
    _headerView.layer.shadowOpacity = .5f;
    CGRect shadowFrame              = _headerView.layer.bounds;
    CGPathRef shadowPath            = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    _headerView.layer.shadowPath    = shadowPath;

    [self.view addSubview:_headerView];
}

#pragma mark - Initialization


- (void)initTabBar
{
    BusNearbyViewController * vc   = [[BusNearbyViewController alloc] init];
    BusLineViewController *vc2     = [[BusLineViewController alloc] init];
    BusStopViewController *vc3     = [[BusStopViewController alloc] init];
    BusTransferViewController *vc4 = [[BusTransferViewController alloc] init];
    BusCollectViewController *vc5  = [[BusCollectViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    self.viewControllers = @[nav,nav2,nav3,nav4,nav5];
    
    [[[[self tabBar] items] objectAtIndex:0] setEnabled:FALSE];
    [[[[self tabBar] items] objectAtIndex:1] setEnabled:FALSE];
    [[[[self tabBar] items] objectAtIndex:2] setEnabled:FALSE];
    [[[[self tabBar] items] objectAtIndex:3] setEnabled:FALSE];
    [[[[self tabBar] items] objectAtIndex:4] setEnabled:FALSE];

}

- (void)dealloc {
    
}
@end
