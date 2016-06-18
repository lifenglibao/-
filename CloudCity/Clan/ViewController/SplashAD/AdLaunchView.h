//
//  AdLaunchView.h
//  DGAdLaunchView ObjC
//
//  Created by 段昊宇 on 16/5/26.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdLaunchView;

typedef NS_ENUM(NSUInteger, AdLaunchType) {
    AdLaunchProgressType = 0,
    AdLaunchTimerType
};

@protocol AdLaunchViewDelegate <NSObject>

- (void) adLaunch: (AdLaunchView *)launchView;
- (void) adLaunch:(AdLaunchView *)launchView withAdData:(NSMutableArray *)array;
@end

@interface AdLaunchView : BaseViewController
@property(nonatomic, retain) id<AdLaunchViewDelegate> _delegate;
@property(nonatomic, strong) NSString * imgUrl;
@end
