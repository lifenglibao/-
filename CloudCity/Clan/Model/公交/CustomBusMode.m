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

+ (NSString *)handleStringWithHalfBrackets:(NSString *)str{
    
    NSMutableString * muStr = [NSMutableString stringWithString:str];
    while (1) {
        NSRange range = [muStr rangeOfString:@"("];
        if (range.location != NSNotFound) {
            NSInteger loc = range.location;
            [muStr deleteCharactersInRange:NSMakeRange(loc, muStr.length - loc)];
        }else{
            break;
        }
    }
    
    return muStr;
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
    NSRange range2 = [str rangeOfString:@"路..."];

    if (range.location != NSNotFound ) {
        NSInteger loc = range.location+1;
        [muStr deleteCharactersInRange:NSMakeRange(loc, muStr.length - loc)];
    }else if (range2.location != NSNotFound ) {
        NSInteger loc = range2.location+3;
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

+ (NSString *)handleStringIncludeBrackets:(NSString *)str{
    
    NSMutableString * muStr = [NSMutableString stringWithString:str];
    while (1) {
        NSRange range = [muStr rangeOfString:@"("];
        if (range.location != NSNotFound) {
            NSInteger loc = range.location + 1;
            [muStr deleteCharactersInRange:NSMakeRange(loc, muStr.length - (muStr.length - loc))];
        }else{
            break;
        }
    }
    
    return muStr;
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

+ (NSMutableArray *)getRoutePlanningBusDetailLine:(AMapTransit *)transit {
    
    NSMutableArray *result = [NSMutableArray array];
    
    if (transit == nil || transit.segments.count == 0)
    {
        return nil;
    }
    
    [transit.segments enumerateObjectsUsingBlock:^(AMapSegment *segment, NSUInteger idx, BOOL *stop) {
        
//         [result addObjectsFromArray:[self naviRouteForSegment:segment segmentIdx:idx]];
        [result addObjectsFromArray:[self naviRouteForWalking:segment.walking]];
        [result addObjectsFromArray:[self naviRouteForBusLine:segment.buslines]];
    }];
    
    
    return result;
}

//+ (NSMutableArray *)naviRouteForSegment:(AMapSegment *)segment segmentIdx:(NSUInteger)idx
//{
//    NSMutableArray * temp = [NSMutableArray array];
//
//    if (segment == nil)
//    {
//        return nil;
//    }
//    
//    [temp addObjectsFromArray:[self naviRouteForWalking:segment.walking]];
//    [temp addObjectsFromArray:[self naviRouteForBusLine:segment.buslines]];
//
//    return temp;
//}


+ (NSMutableArray *)naviRouteForBusLine:(NSArray *)busLine
{
    NSMutableArray * temp = [NSMutableArray array];
    
    if (busLine == nil || busLine.count == 0)
    {
        return nil;
    }
    
    [busLine enumerateObjectsUsingBlock:^(AMapBusLine *line, NSUInteger idx, BOOL *stop) {
        
        [temp addObject:[NSDictionary dictionaryWithObject:line.departureStop.name forKey:@"departureStop"]];
        [temp addObject:[NSDictionary dictionaryWithObject:line.name forKey:@"busName"]];
        [temp addObject:[NSDictionary dictionaryWithObjectsAndKeys:line.viaBusStops,@"viaBusStops",line.arrivalStop.name,@"arrivalStop", nil]];

    }];
    
    return temp;
}

+ (NSMutableArray *)naviRouteForWalking:(AMapWalking *)walking
{
    NSMutableArray * temp = [NSMutableArray array];

    if (walking == nil || walking.steps.count == 0)
    {
        return nil;
    }
    
    [walking.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        [temp addObject:[NSDictionary dictionaryWithObjectsAndKeys:step.instruction,@"tips", nil]];
    }];
    
    return temp;
}

+ (UIView *)locationServiceUnEnabled:(CGRect) frame
{
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 150)];
    img.image = kIMG(@"dataNothing");
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom + 20, frame.size.width, 50)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.numberOfLines = 0;
    lbl.text = @"抱歉\n定位失败,或者您还未开启定位服务";
    
    [maskView addSubview:img];
    [maskView addSubview:lbl];
    return maskView;
}

+ (NSMutableAttributedString *) changeTextColorToRed :(NSString *)string withRange:(NSString *)subString
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:subString].location, [[noteStr string] rangeOfString:subString].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    
    return noteStr;
}

+ (NSDictionary *)calculateNearestStopWithUserLocation:(CLLocationCoordinate2D )userLocation data:(AMapBusLine *)line
{
    MAMapPoint point1 = MAMapPointForCoordinate(userLocation);
    NSMutableArray *res = [NSMutableArray array];
    for (AMapBusStop *stop in line.busStops) {
        
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(stop.location.latitude,stop.location.longitude));
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        NSLog(@"%f",distance);
        NSLog(@"%@",[NSNumber numberWithDouble:distance]);
        [res addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        stop.name,@"name",
                        [NSNumber numberWithFloat:distance],@"distance",
                        [NSNumber numberWithDouble:stop.location.latitude],@"lat",
                        [NSNumber numberWithDouble:stop.location.longitude],@"long",nil]];
    }
    
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    NSArray *sortedArr = [res sortedArrayUsingDescriptors:sortDesc];
    
    return [sortedArr objectAtIndex:0];

//    NSArray *sortedArr = [res sortedArrayUsingSelector:@selector(compare:)];

//    [res sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSString *a = (NSString *)obj1;
//        NSString *b = (NSString *)obj2;
//        
//        int aNum = [[a substringFromIndex:1] intValue];
//        int bNum = [[b substringFromIndex:1] intValue];
//        
//        if (aNum > bNum) {
//            return NSOrderedDescending;
//        }
//        else if (aNum < bNum){
//            return NSOrderedAscending;
//        }
//        else {
//            return NSOrderedSame;
//        }
//    }];
}

@end
