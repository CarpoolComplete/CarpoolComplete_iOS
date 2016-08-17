//
//  JHPhoneNumberField.m
//  Carpool Complete
//
//  Created by JH Lee on 8/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "JHPhoneNumberField.h"

@implementation JHPhoneNumberField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.left_padding, 20)];
    self.leftView = leftPadding;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.border_width;
    self.layer.borderColor = self.border_color.CGColor;
    self.layer.cornerRadius = self.corner_radius;
}

@end
