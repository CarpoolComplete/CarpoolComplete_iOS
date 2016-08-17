//
//  UserObj.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TRIAL_USER = 0,
    EXPIRED_USER,
    PAID_USER
}USER_STATUS;

@interface UserObj : NSObject

@property (nonatomic, retain) NSNumber      *user_id;
@property (nonatomic, retain) NSNumber      *user_family_id;
@property (nonatomic, retain) NSString      *user_first_name;
@property (nonatomic, retain) NSString      *user_last_name;
@property (nonatomic, retain) NSString      *user_email;
@property (nonatomic, retain) NSString      *user_pass;
@property (nonatomic, retain) NSString      *user_phone;
@property (nonatomic, retain) NSString      *user_avatar_url;
@property (nonatomic, retain) UIImage       *user_avatar_image;
@property (nonatomic, retain) NSDate        *user_created_at;
@property (nonatomic, readwrite) USER_STATUS user_status;
@property (nonatomic, readwrite) BOOL       user_is_creator;

- (UserObj *)initWithDictionary:(NSDictionary *)dicUser;
- (NSDictionary *)currentDictionary;

- (NSURL *)avatarUrl;
- (NSString *)initialName;
- (NSString *)fullName;

@end
