//
//  LFGridView.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 16/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "LFGridView.h"
#import "LoginViewController.h"
#import "UIView+Additions.h"
@implementation LFGridView

- (void)dealloc
{
    _target = nil;
    _titleArray = nil;
    _actionDic = nil;
    
    DLog(@"YZCardView dealloc");
}

- (void)addCardDone{
    [self resetViews];
}

- (void)updateTitleCount{
    NSDictionary *count = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationCount"];

    if ([count objectForKey:@"pm_count"] && [count objectForKey:@"notification_count"]) {
        int valNum = 0;

        for (UIButton *btn in self.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                
                int i = (int)btn.tag - 1000;

                for (UIView *view in btn.subviews) {
                    if (view.tag == i+10086) {
                        [view removeFromSuperview];
                    }
                }

                if (i == 0) {
                    valNum = [[count objectForKey:@"pm_count"] intValue];
                }else{
                    valNum = [[count objectForKey:@"notification_count"] intValue];
                }
                
                if (valNum && valNum != 0) {
                    //改变
                    UIButton *newMess_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn addSubview:newMess_btn];
                    newMess_btn.enabled = NO;
                    newMess_btn.layer.cornerRadius = 10;
                    newMess_btn.clipsToBounds = YES;
                    newMess_btn.tag = i+10086;
                    if (valNum > 99) {
                        [newMess_btn setTitle:@"99+" forState:UIControlStateNormal];
                    }
                    else {
                        [newMess_btn setTitle:[NSString stringWithFormat:@"%d",valNum] forState:UIControlStateNormal];
                    }
                    [newMess_btn.titleLabel setFont:[UIFont fitFontWithSize:K_FONTSIZE_Icon]];
                    [newMess_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [newMess_btn setBackgroundImage:[Util imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
                    [newMess_btn setBackgroundColor:[UIColor redColor]];
                    [newMess_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(btn.mas_centerX).offset(50);
                        make.centerY.equalTo(btn.mas_centerY).offset(-10);
                        make.width.equalTo(@20);
                        make.height.equalTo(@20);
                    }];
                }
            }
        }
    }
}

- (void)addCardWithTitle:(NSString *)title withSel:(SEL)selector
{
    if ([Util isBlankString:title]) {
        return;
    }
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    if (!_actionDic) {
        _actionDic = [NSMutableDictionary new];
    }
    if (!isNull(title)) {
        [_titleArray addObject:title];
        [_actionDic setObject:NSStringFromSelector(selector) forKey:title];
    }
}

- (void)resetViews
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    if (_titleArray.count <= 0) {
        return;
    }
    float width = (kVIEW_W(self)-(_titleArray.count-1)*1)/_titleArray.count;
    float height = kVIEW_H(self);

    for (int i = 0; i < _titleArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor returnColorWithPlist:YZSegMentColor]  forState:UIControlStateSelected];
        [btn setTitleColor:_textColor?:UIColorFromRGB(0x424242)  forState:UIControlStateNormal];
        btn.backgroundColor = kCLEARCOLOR;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = _textFont ? :[UIFont systemFontOfSize:15.0f];
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(width*i+i*1, 0, width, height);
        btn.tag = 1000+i;

        if (i == 0) {
            _tempBtn = btn;
            _tempBtn.selected = YES;
        }
        
        [self addSubview:btn];
        if (i != _titleArray.count-1) {
            UIView *seperLine = [[UIView alloc]init];
            seperLine.backgroundColor = kUIColorFromRGB(0xd4d4d4);
            seperLine.frame = CGRectMake(kVIEW_BX(btn), 12, 1, kVIEW_H(self)-24);
            //            [self addSubview:seperLine];
        }
    }
    
    NSLog(@"%f",_tempBtn.titleLabel.size.width);
    //由于第一次取不到titleview的frame 所以先移动一次
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.tag = 5555;
    indicatorView.backgroundColor = [UIColor returnColorWithPlist:YZSegMentColor];
    NSLog(@"%f",_tempBtn.center.x);
    indicatorView.frame = CGRectMake(_tempBtn.center.x - 59/2, kVIEW_H(self)-3, 59, 3);
    [self addSubview:indicatorView];
}

- (IBAction)tapAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn isEqual:_tempBtn]) {
        return;
    }
    if (btn.tag == 1002 && !_isPostView) {
        UserModel *_cuser = [UserModel currentUserInfo];
        if (!_cuser || !_cuser.logined) {
            //没有登录 跳出登录页面
            LoginViewController *login = [[LoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.additionsViewController presentViewController:nav animated:YES completion:nil];
            return;
        }
    }
   
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
    UIView *tempView = [self buttonWithTitleView:btn.tag];
    UIView *indicatorView = [self viewWithTag:5555];
    [UIView animateWithDuration:.2 animations:^{
        indicatorView.frame = CGRectMake(btn.center.x - 59/2, kVIEW_H(self)-3, 59, 3);
    }];
    int i = (int)btn.tag - 1000;
    NSString *title = _titleArray[i];
    [self.target performSelector:NSSelectorFromString(_actionDic[title]) withObject:_tempBtn];
}

- (void)changeTitleAtIndex:(int)index withNewTitle:(NSString *)title
{
    [_titleArray replaceObjectAtIndex:index withObject:title];
    //    [self changeView];
    //    [self resetViews];
}

- (UIView *)buttonWithTitleView:(NSInteger)tag{
    UIButton *button = (UIButton *)[self viewWithTag:tag];
    for (UIView *titleView in [button subviews]) {
        if ([titleView isKindOfClass:[titleView class]]) {
            return titleView;
        }
    }
    return nil;
}

#pragma mark - alert
- (void)alertWithWarning:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}


@end
