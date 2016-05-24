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

+ (NSString*)timeformatFromSeconds:(long)seconds
{
    NSString *minute = [NSString stringWithFormat:@"%ld",(seconds%3600)/60];
    NSString *format_time = [NSString stringWithFormat:@"%@分钟",minute];
    return format_time;
}

+ (NSString*)metresConvertToKM:(long)metres
{
    if (metres<1000) {
        return [NSString stringWithFormat:@"%ld米",metres];
    }
    NSString *strKM = [NSString stringWithFormat:@"%.2f公里",(metres/1000.00)];
    return strKM;
}

+ (NSString *)handleStringWithBrackets:(NSString *)str{
    
    NSMutableString * muStr = [NSMutableString stringWithString:str];
    while (1) {
        NSRange range = [muStr rangeOfString:@"("];
        NSRange range1 = [muStr rangeOfString:@")"];
        if (range.location != NSNotFound) {
            NSInteger loc = range.location;
            NSInteger len = range1.location - range.location;
            [muStr deleteCharactersInRange:NSMakeRange(loc, len + 1)];
        }else{
            break;
        }
    }
    
    return muStr;
}

+ (NSString *)handleStringWithCharRoad:(NSString *)str{
    
    NSMutableString * muStr = [NSMutableString stringWithString:str];

    NSRange range = [str rangeOfString:@"路("];
    if (range.location != NSNotFound ) {
        NSInteger loc = range.location+1;
        [muStr deleteCharactersInRange:NSMakeRange(loc, muStr.length - loc)];
    }
    
    return muStr;
}

+ (NSString *)handleStringGetBrackets:(NSString *)str{
    
    NSString *substring = @"";
    
    while (1) {
        NSRange range = [str rangeOfString:@"("];
        NSRange range1 = [str rangeOfString:@")"];
        if (range.location != NSNotFound && range1.location != NSNotFound) {
            NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
            NSArray *splitString = [str componentsSeparatedByCharactersInSet:delimiters];
            substring = [splitString objectAtIndex:1];
            return substring;
        }else{
            break;
        }
    }
    
    return substring;
}

+ (NSString *)replaceStringWithBusModel:(NSString *)str{
    
    NSString *string = str;
    
    if (str == nil || str == NULL) {
        string = @"未知";
        return string;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        
        string = @"未知";
        return string;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        string = @"未知";
        return string;
    }
    if ([str isEqualToString:@"00:00"]) {
        string = @"未知";
        return string;
    }
    if ([str isEqualToString:@"0"]) {
        string = @"未知";
        return string;
    }
    return string;
}

+ (NSString *)getBusTimeFromString:(NSString *)string {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"HHmm"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}

+ (NSString *)getRoutePlanningBusNumber:(NSArray*)array {
    NSString *string = @"";
    AMapBusLine *tempBusLine;
    
    for (AMapSegment *_seg in array) {
        if (_seg.buslines.count!=0) {
            tempBusLine = _seg.buslines.firstObject;
            if ([string isEqualToString:@""]) {
                string = [self handleStringWithCharRoad:tempBusLine.name];
            }else{
                string = [string stringByAppendingString:@" > "];
                string = [string stringByAppendingString:[self handleStringWithBrackets:tempBusLine.name]];
            }
        }
    }
    return string;
}

+ (NSString *)getRoutePlanningBusInfo:(AMapTransit*)transit {
    //min distance walking price
    NSString *string = @"";

    NSLog(@"%@",[[NSNumber numberWithDouble:transit.cost] stringValue]);
    if (![[[NSNumber numberWithDouble:transit.cost] stringValue] isEqualToString:@"0"]) {
        string = [NSString stringWithFormat:@"%@ | %@ | %@ | %.1f元",[self timeformatFromSeconds:transit.duration], [self metresConvertToKM:transit.distance], [self metresConvertToKM:transit.walkingDistance], [[NSNumber numberWithDouble:transit.cost] floatValue]];
    }else{
        string = [NSString stringWithFormat:@"%@ | %@ | %@",[self timeformatFromSeconds:transit.duration], [self metresConvertToKM:transit.distance], [self metresConvertToKM:transit.walkingDistance]];
    }
    return string;
}

+ (NSString *)getRoutePlanningBusStartStop:(NSArray *)array {
    NSString *string = @"";
    AMapBusLine *tempBusLine;
    
    AMapSegment *_seg = array.firstObject;
    if (_seg.buslines.count!=0) {
        tempBusLine = _seg.buslines.firstObject;
        string = ![tempBusLine.departureStop.name isEqualToString:@""] ? tempBusLine.departureStop.name : @"未知";
    }
    return string;
}

@end
