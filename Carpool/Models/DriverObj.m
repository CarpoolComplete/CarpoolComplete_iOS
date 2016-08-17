//
//  DriverObj.m
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "DriverObj.h"

@implementation DriverObj

- (id)init {
    self = [super init];
    if(self) {
        self.driver_invitation_id = @0;
        self.driver_user_id = @0;
        self.driver_first_name = @"";
        self.driver_last_name = @"";
        self.driver_email = @"";
        self.driver_phone = @"";
        self.driver_type = APP_USER;
        self.driver_avatar_url = @"";
        self.driver_status = DRIVER_STATUS_ACCEPT;
    }
    
    return self;
}

- (DriverObj *)initWithDictionary:(NSDictionary *)dicDriver {
    DriverObj *objDriver = [[DriverObj alloc] init];
    
    if(dicDriver[@"driver_invitation_id"] && ![dicDriver[@"driver_invitation_id"] isEqual:[NSNull null]]) {
        objDriver.driver_invitation_id = [NSNumber numberWithInt:[dicDriver[@"driver_invitation_id"] intValue]];
    }
    
    if(dicDriver[@"driver_user_id"] && ![dicDriver[@"driver_user_id"] isEqual:[NSNull null]]) {
        objDriver.driver_user_id = [NSNumber numberWithInt:[dicDriver[@"driver_user_id"] intValue]];
    }
    
    if(dicDriver[@"driver_first_name"] && ![dicDriver[@"driver_first_name"] isEqual:[NSNull null]]) {
        objDriver.driver_first_name = dicDriver[@"driver_first_name"];
    }
    
    if(dicDriver[@"driver_last_name"] && ![dicDriver[@"driver_last_name"] isEqual:[NSNull null]]) {
        objDriver.driver_last_name = dicDriver[@"driver_last_name"];
    }
    
    if(dicDriver[@"driver_email"] && ![dicDriver[@"driver_email"] isEqual:[NSNull null]]) {
        objDriver.driver_email = dicDriver[@"driver_email"];
    }
    
    if(dicDriver[@"driver_phone"] && ![dicDriver[@"driver_phone"] isEqual:[NSNull null]]) {
        objDriver.driver_phone = dicDriver[@"driver_phone"];
    }
    
    if(dicDriver[@"driver_type"] && ![dicDriver[@"driver_type"] isEqual:[NSNull null]]) {
        objDriver.driver_type = [dicDriver[@"driver_type"] intValue];
    }
    
    if(dicDriver[@"driver_avatar_url"] && ![dicDriver[@"driver_avatar_url"] isEqual:[NSNull null]]) {
        objDriver.driver_avatar_url = dicDriver[@"driver_avatar_url"];
    }
    
    if(dicDriver[@"driver_status"] && ![dicDriver[@"driver_status"] isEqual:[NSNull null]]) {
        objDriver.driver_status = [dicDriver[@"driver_status"] intValue];
    }
    
    return objDriver;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"driver_invitation_id":   self.driver_invitation_id,
             @"driver_user_id":         self.driver_user_id,
             @"driver_first_name":      self.driver_first_name,
             @"driver_last_name":       self.driver_last_name,
             @"driver_email":           self.driver_email,
             @"driver_phone":           self.driver_phone,
             @"driver_type":            [NSNumber numberWithInt:self.driver_type],
             @"driver_avatar_url":      self.driver_avatar_url,
             @"driver_status":          [NSNumber numberWithInt:self.driver_status]
             };
}

@end
