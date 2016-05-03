//
//  CustomBusMode.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomBusMode : NSObject
{
    
}

+(NSArray *)getGridTitle;
+(UIImageView*)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName;
+(UIImageView*)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName;
+(UIButton*)setGPSButtonWithTitle:(NSString *)title imageName:(NSString *)imageName CGRect:(CGRect)frame target:(id)tar action:(SEL)ac;
@end
