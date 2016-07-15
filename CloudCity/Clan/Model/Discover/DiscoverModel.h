//
//  DiscoverModel.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
/**
 *  discover id
 */
@property (copy, nonatomic) NSString *discover_id;
/**
 *  类型
 */
@property (copy, nonatomic) NSString *type;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;
/**
 *  内容链接
 */
@property (copy, nonatomic) NSString *url;
/**
 *  图片
 */
@property (copy, nonatomic) NSString *pic;
/**
 *  tag id
 */
@property (copy, nonatomic) NSString *tags;
/**
 *  创建时间
 */
@property (copy, nonatomic) NSString *created_at;
/**
 *  是否需要登录才能获取能容
 */
@property (copy, nonatomic) NSString *is_require_login;

@property (copy, nonatomic) NSString *group_id;

@property (copy, nonatomic) NSString *group_name;

@property (copy, nonatomic) NSString *is_selected;

@end

