//
//  CustomBusMode.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "CustomBusMode.h"

@implementation CustomBusMode


+(NSArray *)getGridTitle{
    
    return [NSArray arrayWithObjects:@"附近",@"线路",@"站点",@"换乘",@"收藏", nil];
}

+(UIView*)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.image = [UIImage imageNamed:imageName];
    rightView.size = CGSizeMake(40, 40);
    rightView.contentMode = UIViewContentModeCenter;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    return rightView;
}

+(UIView*)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, textField.height)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:imageName];
    img.frame = CGRectMake(10, 10, 30, 30);
    img.contentMode = UIViewContentModeCenter;
    [leftView addSubview:img];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return leftView;
}

+(UIButton*)setGPSButtonWithTitle:(NSString *)title imageName:(NSString *)imageName CGRect:(CGRect)frame target:(id)tar action:(SEL)ac{
    
    UIButton *gpsBtn = [[UIButton alloc] init];
    gpsBtn.frame = frame;
    if (title) {
        [gpsBtn setTitle:title forState:UIControlStateNormal];
    }
    [gpsBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [gpsBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateSelected];
    [gpsBtn addTarget:tar action:ac forControlEvents:UIControlEventTouchUpInside];
    return gpsBtn;
}

+(UIButton*)setTrafficButtonWithTitle:(NSString *)title imageName:(NSString *)imageName CGRect:(CGRect)frame target:(id)tar action:(SEL)ac{
    
    UIButton *trafficBtn = [[UIButton alloc] init];
    trafficBtn.frame = frame;
    if (title) {
        [trafficBtn setTitle:title forState:UIControlStateNormal];
    }
    [trafficBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [trafficBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateSelected];
    [trafficBtn addTarget:tar action:ac forControlEvents:UIControlEventTouchUpInside];
    return trafficBtn;
}
@end
