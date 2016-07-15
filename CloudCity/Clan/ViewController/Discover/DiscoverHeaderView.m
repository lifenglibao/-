//
//  DiscoverHeaderView.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 09/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "DiscoverHeaderView.h"

@interface DiscoverHeaderView()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation DiscoverHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.label                    = [[UILabel alloc] init];
        self.label.font               = [UIFont systemFontOfSize:15];
        self.label.left               = 20;

        self.lineView                 = [[UIView alloc] init];
        self.lineView.frame           = CGRectMake(0, 30, ScreenWidth, 0.5);
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.label];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void) setTitleText:(NSString *)text
{
    self.label.text = text;
    [self.label sizeToFit];
}


@end
