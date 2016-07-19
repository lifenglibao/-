//
//  LFGridView.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 16/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFGridView : UIView
{
    NSMutableArray *_titleArray;
    NSMutableDictionary *_actionDic;
    UIButton *_tempBtn;
}

@property (weak, nonatomic) id target;
@property (assign) int defaultIndex;
@property (strong, nonatomic)UIFont *textFont;
@property (copy, nonatomic) NSString *gridType;
@property (strong, nonatomic)UIColor *textColor;
@property (assign, nonatomic) BOOL isPostView;
- (void)addCardWithTitle:(NSString *)title withSel:(SEL)selector;

- (void)changeTitleAtIndex:(int)index withNewTitle:(NSString *)title;

- (IBAction)tapAction:(id)sender;

- (void)addCardDone;
- (void)updateTitleCount;

@end
