//
//  DriverObj.h
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DRIVER_STATUS_PENDING = 0,
    DRIVER_STATUS_ACCEPT = 1,
    DRIVER_STATUS_REJECT = -1
}DRIVER_STATUS;

@interface DriverObj : NSObject

@property (nonatomic, retain) NSNumber          *driver_invitation_id;
@property (nonatomic, retain) NSNumber          *driver_user_id;
@property (nonatomic, retain) NSString          *driver_first_name;
@property (nonatomic, retain) NSString          *driver_last_name;
@property (nonatomic, retain) NSString          *driver_email;
@property (nonatomic, retain) NSString          *driver_phone;
@property (nonatomic, readwrite) USER_TYPE      driver_type;
@property (nonatomic, retain) NSString          *driver_avatar_url;
@property (nonatomic, readwrite) DRIVER_STATUS  driver_status;

- (DriverObj *)initWithDictionary:(NSDictionary *)dicDriver;
- (NSDictionary *)currentDictionary;

@end
