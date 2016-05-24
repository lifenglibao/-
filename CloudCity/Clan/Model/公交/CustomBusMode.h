//
//  CustomBusMode.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface CustomBusMode : NSObject
{
    
}

+(NSArray *)getGridTitle;
+(UIImageView*)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName;
+(UIImageView*)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName;
+(UIButton*)setGPSButtonWithTitle:(NSString *)title imageName:(NSString *)imageName CGRect:(CGRect)frame target:(id)tar action:(SEL)ac;
+ (NSString *)handleStringWithBrackets:(NSString *)str;
+ (NSString *)handleStringGetBrackets:(NSString *)str;
+ (NSString *)replaceStringWithBusModel:(NSString *)str;
+ (NSString *)getBusTimeFromString:(NSString *)string;
+ (NSString *)handleStringWithCharRoad:(NSString *)str;
+ (NSString *)getRoutePlanningBusStartStop:(NSArray *)array;
+ (NSString *)getRoutePlanningBusNumber:(NSArray*)array;
+ (NSString *)getRoutePlanningBusInfo:(AMapTransit *)transit;
@end
