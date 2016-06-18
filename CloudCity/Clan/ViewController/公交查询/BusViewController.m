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
    
    _headerView = [[SegmentView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 44) andTitleArray:[CustomBusMode getGridTitle] clickBlock:^(NSInteger index) {
        self.selectedIndex = index;
    }];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.layer.shadowOffset = CGSizeMake(0, 0);
    _headerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _headerView.layer.shadowRadius = 1;
    _headerView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = _headerView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    _headerView.layer.shadowPath = shadowPath;
    
    [self.view addSubview:_headerView];
}

#pragma mark - Initialization


- (void)initTabBar
{
    BusNearbyViewController * vc = [[BusNearbyViewController alloc] init];
    BusLineViewController *vc2 = [[BusLineViewController alloc] init];
    BusStopViewController *vc3 = [[BusStopViewController alloc] init];
    BusTransferViewController * vc4 = [[BusTransferViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *navi4 = [[UINavigationController alloc] initWithRootViewController:vc4];

    self.viewControllers = @[navi,navi2,navi3,navi4];
}

- (void)dealloc {
    
}
@end
