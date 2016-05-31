//
//  BusSearchHistoryViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 27/05/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusSearchHistoryViewController.h"

@interface BusSearchHistoryViewController ()

@end

@implementation BusSearchHistoryViewController


#pragma mark - 查看沙盒plist历史记录文件
- (NSString *)historyWithDocument
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"];
    NSString *fileName;
    if (_historyType == BusSearchHistoryTypeLine) {
        fileName = [documentPath stringByAppendingPathComponent:@"buslinesearchhistory.plist"];
    }else if (_historyType == BusSearchHistoryTypeStop) {
        fileName = [documentPath stringByAppendingPathComponent:@"busstopsearchhistory.plist"];
    }else if (_historyType == BusSearchHistoryTypeTransfer) {
        fileName = [documentPath stringByAppendingPathComponent:@"bustransfersearchhistory.plist"];
    }
    return fileName;
}

- (void) setHistoryType:(BusSearchHistoryType)historyType {
    _historyType = historyType;
    self.historyArray = [[NSMutableArray alloc] initWithContentsOfFile:[self historyWithDocument]];
//    [self addHeaderView];
//    self.tableHeaderView = _headerView;
//    self.sectionHeaderHeight = 0;
    self.tableHeaderView.hidden = _historyArray.count == 0;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style])
    {
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark - 清空历史记录
- (void)clearhistory
{
    [_historyArray removeAllObjects];
    [_historyArray writeToFile:[self historyWithDocument] atomically:YES];
    self.tableHeaderView.hidden = YES;
    [self reloadData];
}

- (void)accessoryAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    UITableViewCell *cell = (UITableViewCell *)[[imageView superview] superview];
    NSInteger row = [self indexPathForCell:cell].row;
//    _mySearchBar.text = _historyArray[row];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 33)];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width/3, 33)];
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    nameLabel.textColor = UIColorFromRGB(0xa6a6a6);
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"最近查询";
    [_headerView addSubview:nameLabel];
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(self.width/1.5, 0, self.width/3, _headerView.height)];
    UIImageView *clearImageView = [[UIImageView alloc]initWithImage:kIMG(@"shanchu")];
    clearImageView.frame = CGRectMake(0, 10, 15, 15);
    [subView addSubview:clearImageView];
    
    UILabel *clearLabel = [[UILabel alloc]initWithFrame:CGRectMake(clearImageView.right, 0, subView.width - clearImageView.width - 5, subView.height)];
    clearLabel.font = [UIFont systemFontOfSize:12.0f];
    clearLabel.textColor = UIColorFromRGB(0xa6a6a6);
    clearLabel.textAlignment = NSTextAlignmentCenter;
    clearLabel.text = @"清空历史记录";
    [subView addSubview:clearLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearhistory)];
    [subView addGestureRecognizer:tap];
    [_headerView addSubview:subView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _headerView.bottom-0.5, self.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xE6E6E6);
    [_headerView addSubview:line];
    _headerView.backgroundColor = kCOLOR_BG_GRAY;
    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if ([_historyArray count]>0) {
        UIImageView *accessoryView = [[UIImageView alloc]initWithImage:kIMG(@"lishixinxi")];
        accessoryView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accessoryAction:)];
        [accessoryView addGestureRecognizer:tap];
        cell.accessoryView = accessoryView;
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, cell.contentView.height)];
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        textLabel.textColor = UIColorFromRGB(0x424242);
        textLabel.text = _historyArray[indexPath.row];
        [cell.contentView addSubview:textLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row != _historyArray.count - 1) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(textLabel.left, cell.contentView.bottom - 0.5, self.width, 0.5)];
            line.backgroundColor = UIColorFromRGB(0xE6E6E6);
            [cell.contentView addSubview:line];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BusSearchNotiFication" object:nil userInfo:_historyArray[indexPath.row]];
//    _mySearchBar.text = _historyArray[indexPath.row];
//    [self searchBarSearchButtonClicked:_mySearchBar];
}

- (void)writeHistoryPlist :(NSString *)str{
    
    NSMutableArray *temp;
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }else{
        temp = [[NSMutableArray alloc] initWithContentsOfFile:[self historyWithDocument]];
    }
    if([_historyArray count]>10)
    {
        [temp removeLastObject];
    }
    if (_historyArray.count > 0) {
        _historyArray = (NSMutableArray *)[[temp reverseObjectEnumerator] allObjects];
        BOOL isExist = NO;
        for (NSString *name in _historyArray) {
            if ([name isEqualToString:str]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [_historyArray addObject:str];
            _historyArray = (NSMutableArray *)[[_historyArray reverseObjectEnumerator] allObjects];
            [_historyArray writeToFile:[self historyWithDocument] atomically:YES];
        }else{
            _historyArray = (NSMutableArray *)[[_historyArray reverseObjectEnumerator] allObjects];
        }
    }else{
        [_historyArray addObject:str];
        [_historyArray writeToFile:[self historyWithDocument] atomically:YES];
    }
    self.tableHeaderView.hidden = NO;
    [self reloadData];
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
