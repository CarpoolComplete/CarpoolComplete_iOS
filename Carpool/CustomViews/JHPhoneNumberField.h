//
//  JHPhoneNumberField.h
//  Carpool Complete
//
//  Created by JH Lee on 8/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <LTPhoneNumberField/LTPhoneNumberField.h>

IB_DESIGNABLE @interface JHPhoneNumberField : LTPhoneNumberField

@property (nonatomic, readwrite) IBInspectable CGFloat  border_width;
@property (nonatomic, readwrite) IBInspectable CGFloat  corner_radius;
@property (nonatomic, retain) IBInspectable UIColor     *border_color;
@property (nonatomic, readwrite) IBInspectable CGFloat  left_padding;

@end
