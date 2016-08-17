//
//  JHButton.m
//  CloudShop
//
//  Created by JH Lee on 4/19/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "JHButton.h"

@implementation JHButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.border_width;
    self.layer.borderColor = self.border_color.CGColor;
    self.layer.cornerRadius = self.corner_radius;
}

@end
