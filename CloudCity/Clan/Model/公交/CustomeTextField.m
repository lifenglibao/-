//
//  CustomeTextField.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 27/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "CustomeTextField.h"
#import "CustomBusMode.h"

@implementation CustomeTextField


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = UITextBorderStyleNone;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.leftView = [CustomBusMode setLeftViewWithTextField:self imageName:@"sousuo_gray"];
//    self.rightView = [CustomBusMode setRightViewWithTextField:self imageName:@"shouye_guanbi"];

}


//- (CGRect) leftViewRectForBounds:(CGRect)bounds {
//    bounds.origin.x = 10;
//    bounds.size.width = 20;
//    bounds.size.height = 20;
//    bounds.origin.y = 15;
//    return bounds;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
