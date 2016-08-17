//
//  JHTextField.h
//  LeoExterior
//
//  Created by JH Lee on 4/8/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface JHTextField : UITextField

@property (nonatomic, readwrite) IBInspectable CGFloat  border_width;
@property (nonatomic, readwrite) IBInspectable CGFloat  corner_radius;
@property (nonatomic, retain) IBInspectable UIColor     *border_color;
@property (nonatomic, readwrite) IBInspectable CGFloat  left_padding;

@end
