//
//  NotificationModel.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 16/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject


@property (copy, nonatomic) NSString *plid;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *is_have_read;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *authorid;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *from_id;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *from_idtype;
@property(copy, nonatomic) NSString *msgtoid_avatar;
@property(copy, nonatomic) NSString *from_num;
@property (copy, nonatomic) NSString *content;

@end
