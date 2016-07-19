//
//  DiscoverViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverHeaderView.h"
#import "TOWebViewController.h"
#import "SearchViewController.h"

static NSString * const LxGridViewCellReuseIdentifier = @stringify(LxGridViewCellReuseIdentifier);

@interface DiscoverViewController ()

@property (nonatomic,retain) NSMutableArray * dataArray;

@end

@implementation DiscoverViewController
{
    LxGridViewFlowLayout * _gridViewFlowLayout;
    LxGridView * _gridView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self  initNav];
    [self  loadMoel];
    [_gridView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title     = @"发现";
    _homeviewmodel = [HomeViewModel new];
    [self  initCollectionView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNav
{
    UIView *rightView;
        self.navigationItem.title = [NSString returnStringWithPlist:YZBBSName];
    if (!rightView) {
        rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    for (UIView *view in rightView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuoshouye"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)] animated:NO];
    
    
    NSNumber *valNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"KNEWS_MESSAGE"];
    NSString *navTitle = @"nav_left";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 5, 30, 30);
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.layer.cornerRadius = 15;
    leftButton.clipsToBounds = YES;
    UserModel *cUsr = [UserModel currentUserInfo];
    if (cUsr && cUsr.logined) {
        [leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:cUsr.avatar] forState:UIControlStateNormal placeholderImage:kIMG(@"portrait_small")];
    } else {
        [leftButton sd_cancelBackgroundImageLoadForState:UIControlStateNormal];
        [leftButton sd_cancelImageLoadForState:UIControlStateNormal];
        [leftButton setImage:kIMG(navTitle) forState:UIControlStateNormal];
    }
    [rightView addSubview:leftButton];
    if ((!isNull(valNum) && valNum.intValue != 0)) {
        //加红点
        UIImageView *redPod = nil;
        redPod = [[UIImageView alloc]initWithImage:[Util imageWithColor:[UIColor redColor]]];
        redPod.backgroundColor = [UIColor redColor];
        redPod.layer.cornerRadius = 4;
        redPod.clipsToBounds = YES;
        [rightView addSubview:redPod];
        [redPod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(rightView.mas_trailing).offset(-8);
            make.top.equalTo(rightView.mas_top).offset(6);
            make.width.equalTo(@8);
            make.height.equalTo(@8);
        }];
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.leftBarButtonItem = leftItem ;
}

- (void)searchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

- (void)loadMoel {
    
    self.customHomeModel = [_homeviewmodel request_discoverDataArray];
    self.dataArray       = [NSMutableArray arrayWithArray:self.customHomeModel.discover];
}

- (void)initCollectionView {
    
    _gridViewFlowLayout                                 = [[LxGridViewFlowLayout alloc]init];
    _gridViewFlowLayout.sectionInset                    = UIEdgeInsetsMake(18, 18, 18, 18);
    _gridViewFlowLayout.minimumLineSpacing              = 9;
    _gridViewFlowLayout.itemSize                        = CGSizeMake(60, 78);

    _gridView                                           = [[LxGridView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, ScreenBoundsHeight) collectionViewLayout:_gridViewFlowLayout];
    _gridView.contentInset                              = UIEdgeInsetsMake(20, 0, 0, 0);
    _gridView.delegate                                  = self;
    _gridView.dataSource                                = self;
    _gridView.backgroundColor                           = [UIColor whiteColor];
    [self.view addSubview:_gridView];

    [_gridView registerClass:[LxGridViewCell class] forCellWithReuseIdentifier:LxGridViewCellReuseIdentifier];
    [_gridView registerClass:[DiscoverHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader"];
    _gridView.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.discoverGroupModel = [DiscoverGroupModel mj_objectWithKeyValues:self.dataArray[section]];
    return self.discoverGroupModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxGridViewCell * cell        = [collectionView dequeueReusableCellWithReuseIdentifier:LxGridViewCellReuseIdentifier forIndexPath:indexPath];

    cell.delegate                = self;
//    cell.editing = _gridView.editing;

    self.discoverGroupModel      = [DiscoverGroupModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
    self.discoverModel           = [DiscoverModel mj_objectWithKeyValues:self.discoverGroupModel.items[indexPath.item]];

    cell.title                   = self.discoverModel.title;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.discoverModel.pic] placeholderImage:nil options:SDWebImageRefreshCached];

    NSDictionary *latestDiscover = [[TMCache sharedCache] objectForKey:@"CCDiscoverLatestInfo"];

    if ([self.discoverGroupModel.group_id isEqualToString:[latestDiscover objectForKey:@"group_id"]] && [self.discoverModel.discover_id isEqualToString:[latestDiscover objectForKey:@"id"]] && [[latestDiscover objectForKey:@"is_selected"]isEqualToString:@"0"]) {
    cell.badge.hidden            = NO;
    }else{
    cell.badge.hidden            = YES;
    }
    return cell;
}
//CCDiscoverLatestInfo
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
//    self.discoverGroupModel = [DiscoverGroupModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
//    self.discoverModel = [DiscoverModel mj_objectWithKeyValues:self.discoverGroupModel.items[indexPath.item]];
    
//    NSDictionary * dataDict = self.dataArray[sourceIndexPath.item];
//    [self.dataArray removeObjectAtIndex:sourceIndexPath.item];
//    [self.dataArray insertObject:dataDict atIndex:destinationIndexPath.item];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {self.view.width,25};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DiscoverHeaderView *headView;
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
        self.discoverGroupModel = [DiscoverGroupModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
        [headView setTitleText:self.discoverGroupModel.group_name];
    }
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.discoverGroupModel      = [DiscoverGroupModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
    self.discoverModel           = [DiscoverModel mj_objectWithKeyValues:self.discoverGroupModel.items[indexPath.item]];

    NSDictionary *latestDiscover = [[TMCache sharedCache] objectForKey:@"CCDiscoverLatestInfo"];

    if ([self.discoverGroupModel.group_id isEqualToString:[latestDiscover objectForKey:@"group_id"]] && [self.discoverModel.discover_id isEqualToString:[latestDiscover objectForKey:@"id"]]) {
        [latestDiscover setValue:@"1" forKey:@"is_selected"];
        [[TMCache sharedCache] removeObjectForKey:@"CCDiscoverLatestInfo"];
        [[TMCache sharedCache] setObject:latestDiscover forKey:@"CCDiscoverLatestInfo"];
        [_gridView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GET_LATEST_DISCOVER" object:nil];
    }

    TOWebViewController *web     = [[TOWebViewController alloc]initWithURLString:self.discoverModel.url];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
