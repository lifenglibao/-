//
//  CustomBusMode.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 26/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "CustomBusMode.h"
#import "MJExtension.h"

@implementation CustomBusMode


+(NSArray *)getGridTitle{
    
    return [NSArray arrayWithObjects:@"附近",@"线路",@"站点",@"换乘",@"收藏", nil];
}

+(NSArray *)getTransferGridTitle{
    
    return [NSArray arrayWithObjects:@"查看返程",@"推荐路线", nil];
}

+(NSArray *)getTransferFilterTitle{
    
    return [NSArray arrayWithObjects:@"推荐路线",@"步行少",@"换乘少",@"时间短", nil];
}

+(UITextField*)setSearchTextFieldWithFrame:(CGRect)frame {

    UITextField *field    = [[UITextField alloc] initWithFrame:frame];
    field.backgroundColor = [UIColor whiteColor];
    field.borderStyle     = UITextBorderStyleNone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.leftView        = [self setLeftViewWithTextField:field imageName:@"sousuo_gray"];
    
    return field;
}

+(UIView*)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIView * leftView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, textField.height)];
    leftView.backgroundColor = kCLEARCOLOR;
    UIImageView *img         = [[UIImageView alloc]init];
    img.image                = kIMG(imageName);
    img.frame                = CGRectMake(10, 10, 30, 30);
    img.contentMode          = UIViewContentModeCenter;
    [leftView addSubview:img];
    textField.leftView       = leftView;
    textField.leftViewMode   = UITextFieldViewModeAlways;
    return leftView;
}

+(UIButton*)setGPSButtonWithTitle:(NSString *)title imageName:(NSString *)imageName CGRect:(CGRect)frame target:(id)tar action:(SEL)ac{
    
    UIButton *gpsBtn           = [[UIButton alloc] init];
    gpsBtn.frame               = frame;
    if (title) {
        [gpsBtn setTitle:title forState:UIControlStateNormal];
    }
    [gpsBtn setImage:kIMG(imageName) forState:UIControlStateNormal];
    [gpsBtn addTarget:tar action:ac forControlEvents:UIControlEventTouchUpInside];

    gpsBtn.layer.shadowOffset  = CGSizeMake(0, 1);
    gpsBtn.layer.shadowColor   = [UIColor darkGrayColor].CGColor;
    gpsBtn.layer.shadowRadius  = 1;
    gpsBtn.layer.shadowOpacity = .5f;
    CGRect shadowFrame         = gpsBtn.layer.bounds;
    CGPathRef shadowPath       = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    gpsBtn.layer.shadowPath    = shadowPath;
    
    return gpsBtn;
}

+(UIView*)setTrafficButtonWithTitle:(NSString *)title imageName:(NSString *)imageName CGRect:(CGRect)frame target:(id)tar action:(SEL)ac{
    
    UIView *trafficView         = [[UIView alloc] init];
    trafficView.frame           = frame;
    trafficView.backgroundColor = [UIColor lightGrayColor];
    [trafficView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:tar action:ac]];

    UIImageView *img            = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, trafficView.width - 10, 25)];
    img.image                   = kIMG(imageName);

    UILabel *lbl                = [[UILabel alloc] initWithFrame:CGRectMake(5, img.bottom - 5, img.width, 10)];
    lbl.textAlignment           = NSTextAlignmentCenter;
    lbl.font                    = [UIFont systemFontOfSize:12];
    lbl.textColor               = [UIColor whiteColor];
    lbl.text                    = title;

    [trafficView addSubview:img];
    [trafficView addSubview:lbl];
    return trafficView;
}

+(UIView*)setZoomViewWithFrame:(CGRect)frame target:(id)tar action1:(SEL)ac1 action2:(SEL)ac2{
    
    UIView *view                   = [[UIView alloc] init];
    view.backgroundColor           = [UIColor whiteColor];
    view.frame                     = frame;
    view.userInteractionEnabled    = YES;
    
    UIImageView *imgPlus           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    imgPlus.userInteractionEnabled = YES;
    imgPlus.image                  = kIMG(@"icon_plus");
    [imgPlus addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:tar action:ac1]];

    UILabel *lineLabel             = [[UILabel alloc]initWithFrame:CGRectMake(5, view.height/2 - 0.5, view.width - 10, 0.5)];
    lineLabel.backgroundColor      = [UIColor grayColor];

    UIImageView *imgMin            = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.height/2 + 5, 35, 35)];
    imgMin.userInteractionEnabled  = YES;
    imgMin.image                   = kIMG(@"icon_min");
    [imgMin addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:tar action:ac2]];

    view.layer.shadowOffset        = CGSizeMake(0, 1);
    view.layer.shadowColor         = [UIColor darkGrayColor].CGColor;
    view.layer.shadowRadius        = 1;
    view.layer.shadowOpacity       = .5f;
    CGRect shadowFrame             = view.layer.bounds;
    CGPathRef shadowPath           = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    view.layer.shadowPath          = shadowPath;

    [view addSubview:imgPlus];
    [view addSubview:lineLabel];
    [view addSubview:imgMin];

    return view;
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

+ (NSString *)handleStringGetBusEndStop:(NSString *)str{
    
    NSString *substring = @"";
    while (1) {
        NSRange range = [str rangeOfString:@"--"];
        NSRange range1 = [str rangeOfString:@")"];
        if (range.location != NSNotFound && range1.location != NSNotFound) {
            NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"-- )"];
            NSArray *splitString = [str componentsSeparatedByCharactersInSet:delimiters];
            substring = [splitString objectAtIndex:2];
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
    if ([str isEqualToString:@"0.0"]) {
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

+ (NSArray *)getFilterRoutePlanning:(NSArray*)array withParameter:(NSString*)par {
    
    NSString *sortKey = @"";
    
    if ([par isEqualToString:@"步行少"]) {
        
        sortKey = @"walkingDistance";
        
    }else if ([par isEqualToString:@"换乘少"]) {
        
        //segments
        //sortKey = @"@count";
        NSArray* sortedArray= [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            if([[obj1 segments] count] > [[obj2 segments]count])
                return NSOrderedDescending;
            if([[obj1 segments]count] < [[obj2 segments]count])
                return NSOrderedAscending;
            return NSOrderedSame;
        }];
        
        return sortedArray;
        
    }else if ([par isEqualToString:@"时间短"]) {
        
        sortKey = @"duration";

    }else{
        sortKey = @"distance";
        //推荐路线
    }
    
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]];
    NSArray *sortedArr = [array sortedArrayUsingDescriptors:sortDesc];
    
    return sortedArr;
}


+ (NSString *)getRoutePlanningBusNumber:(NSArray*)array {
    NSString *string = @"";
    AMapBusLine *tempBusLine;
    
    for (AMapSegment *_seg in array) {
        if (_seg.buslines.count!=0) {
            tempBusLine = _seg.buslines.firstObject;
            if ([string isEqualToString:@""]) {
                string = [self handleStringWithCharRoad:tempBusLine.name];
                string = [self handleStringWithHalfBrackets:string];
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

    if (![[[NSNumber numberWithDouble:transit.cost] stringValue] isEqualToString:@"0"]) {
        string = [NSString stringWithFormat:@"%@ | %@ | 步行%@ | %.1f元",[self timeformatFromSeconds:transit.duration], [self metresConvertToKM:transit.distance], [self metresConvertToKM:transit.walkingDistance], [[NSNumber numberWithDouble:transit.cost] floatValue]];
    }else{
        string = [NSString stringWithFormat:@"%@ | %@ | 步行%@",[self timeformatFromSeconds:transit.duration], [self metresConvertToKM:transit.distance], [self metresConvertToKM:transit.walkingDistance]];
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
        
        [result addObjectsFromArray:[self naviRouteForWalking:segment.walking]];
        [result addObjectsFromArray:[self naviRouteForBusLine:segment.buslines]];
    }];
    
    
    return result;
}

+ (NSMutableArray *)naviRouteForBusLine:(NSArray *)busLine
{
    NSMutableArray * temp = [NSMutableArray array];
    NSString * str = [NSString string];
    if (busLine == nil || busLine.count == 0)
    {
        return nil;
    }
    
    for (AMapBusLine *line in busLine) {
        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@上车",line.departureStop.name] forKey:@"departureStop"]];
        
        for (int i = 0; i < line.viaBusStops.count; i++) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",[(AMapBusStop*)line.viaBusStops[i] name]]];
            if (i != line.viaBusStops.count) {
                str = [str stringByAppendingString:@"\n\n"];
            }
        }
        
        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"\n%@\n\n%@",line.name,str] forKey:@"endStop"]];
        
        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@下车",line.arrivalStop.name] forKey:@"arrivalStop"]];
        
//        [temp addObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:line.viaBusStops.count] forKey:@"total_stop"]];

    }
//    [busLine enumerateObjectsUsingBlock:^(AMapBusLine *line, NSUInteger idx, BOOL *stop) {
//        
//        
//        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@上车",line.departureStop.name] forKey:@"departureStop"]];
//        
//        for (int i = 0; i < line.viaBusStops.count; i++) {
//            [str stringByAppendingString:[NSString stringWithFormat:@"%@",[(AMapBusStop*)line.viaBusStops[i] name]]];
//            [str stringByAppendingString:@"\n"];
//        }
//        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"开往%@\n%@",[self handleStringGetBusEndStop:line.name],str] forKey:@"endStop"]];
//
//        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@下车",line.arrivalStop.name] forKey:@"arrivalStop"]];
//
//    }];

    return temp;
}

+ (NSMutableArray *)naviRouteForWalking:(AMapWalking *)walking
{
    NSMutableArray * temp = [NSMutableArray array];

    if (walking == nil || walking.steps.count == 0)
    {
        return nil;
    }
    
    if (walking.distance && walking.duration) {
        [temp addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"步行%@ 约%@",[self metresConvertToKM:walking.distance],[self timeformatFromSeconds:walking.duration]] forKey:@"walking"]];
        return temp;
    }
    
    return nil;
}


//+ (NSMutableArray *)naviRouteForBusLine:(NSArray *)busLine
//{
//    NSMutableArray * temp = [NSMutableArray array];
//    
//    if (busLine == nil || busLine.count == 0)
//    {
//        return nil;
//    }
//    
//    [busLine enumerateObjectsUsingBlock:^(AMapBusLine *line, NSUInteger idx, BOOL *stop) {
//        
//        [temp addObject:[NSDictionary dictionaryWithObject:line.departureStop.name forKey:@"departureStop"]];
//        [temp addObject:[NSDictionary dictionaryWithObject:line.name forKey:@"busName"]];
//        [temp addObject:[NSDictionary dictionaryWithObjectsAndKeys:line.viaBusStops,@"viaBusStops",line.arrivalStop.name,@"arrivalStop", nil]];
//
//    }];
//    
//    return temp;
//}
//
//+ (NSMutableArray *)naviRouteForWalking:(AMapWalking *)walking
//{
//    NSMutableArray * temp = [NSMutableArray array];
//
//    if (walking == nil || walking.steps.count == 0)
//    {
//        return nil;
//    }
//    
//    [walking.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
//        [temp addObject:[NSDictionary dictionaryWithObjectsAndKeys:step.instruction,@"tips", nil]];
//    }];
//    
//    return temp;
//}

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


// 公交是否收藏
+ (BOOL)isFavoed_withID:(NSString *)sid withFavoID:(NSString *)favoID forType:(CollcetionType)type
{
    NSString *fileKey = nil;
    switch (type) {
        case myBusLine:
            fileKey = kKEY_FAVO_BUSLINE;
            break;
        case myBusStop:
            fileKey = kKEY_FAVO_BUSSTOP;
            break;
        case myBusTransfer:
            fileKey = kKEY_FAVO_BUSTRANSFER;
            break;
        default:
            fileKey = @"";
            break;
    }
    if (!fileKey) {
        return NO;
    }
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:fileKey];
    return [dic.allKeys containsObject:sid];
}


//公交 增加本地收藏
+ (BOOL)addFavoed_withID:(NSString *)sid withFavoID:(NSString *)favoID forType:(CollcetionType) type
{
    if (!favoID || !sid) {
        return NO;
    }
    NSString *fileKey = nil;
    switch (type) {
        case myBusLine:
            fileKey = kKEY_FAVO_BUSLINE;
            break;
        case myBusStop:
            fileKey = kKEY_FAVO_BUSSTOP;
            break;
        case myBusTransfer:
            fileKey = kKEY_FAVO_BUSTRANSFER;
            break;
        default:
            fileKey = @"";
            break;
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:fileKey];
    if (!dic) {
        dic = [NSDictionary new];
    }
    if (dic && ![dic.allKeys containsObject:sid]) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithDictionary:dic];
        if (favoID) {
            [dic1 setObject:favoID forKey:sid];
            [[NSUserDefaults standardUserDefaults] setObject:dic1 forKey:fileKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return YES;
}

+ (NSString *)getFavoIDFromID:(NSString *)fid forType:(CollcetionType)type
{
    NSString *fileKey = nil;
    switch (type) {
        case myBusLine:
            fileKey = kKEY_FAVO_BUSLINE;
            break;
        case myBusStop:
            fileKey = kKEY_FAVO_BUSSTOP;
            break;
        case myBusTransfer:
            fileKey = kKEY_FAVO_BUSTRANSFER;
            break;
        default:
            fileKey = @"";
            break;
    }
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:fileKey];
    return dic[fid];
}


//删除本地收藏
+ (void)deleteFavoed_withID:(NSString *)sid withFavoID:(NSString *)favoID forType:(CollcetionType)type
{
    NSString *fileKey = nil;
    switch (type) {
        case myBusLine:
            fileKey = kKEY_FAVO_BUSLINE;
            break;
        case myBusStop:
            fileKey = kKEY_FAVO_BUSSTOP;
            break;
        case myBusTransfer:
            fileKey = kKEY_FAVO_BUSTRANSFER;
            break;
        default:
            fileKey = @"";
            break;
    }
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:fileKey];
    if (!dic) {
        dic = [NSDictionary new];
    }
    if (dic && [dic.allKeys containsObject:sid]) {
        DLog(@"删除 %@",sid);
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dic1 removeObjectForKey:sid];
        [[NSUserDefaults standardUserDefaults] setObject:dic1 forKey:fileKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)cleanUpLocalFavoArray
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kKEY_FAVO_BUSLINE];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kKEY_FAVO_BUSSTOP];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kKEY_FAVO_BUSTRANSFER];
}

@end
