//
//  DiscoverGroupModel.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 05/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscoverModel.h"

@interface DiscoverGroupModel : NSObject

/**
 *  discover group id
 */
@property (copy, nonatomic) NSString *group_id;
/**
 *  group name
 */
@property (copy, nonatomic) NSString *group_name;
/**
 *  items
 */
@property (copy, nonatomic) NSArray *items;

@end
