//
//  NotificationModel.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 16/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"plid":@"id",
             @"msgtoid_avatar":@"avatar"
             };
}


@end
