//
//  AdultObj.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdultObj : NSObject

@property (nonatomic, retain) NSNumber      *adult_id;
@property (nonatomic, retain) NSNumber      *adult_user_id;
@property (nonatomic, readwrite) USER_TYPE  adult_type;
@property (nonatomic, retain) NSString      *adult_avatar_url;
@property (nonatomic, retain) NSString      *adult_first_name;
@property (nonatomic, retain) NSString      *adult_last_name;
@property (nonatomic, retain) NSString      *adult_phone;
@property (nonatomic, retain) NSString      *adult_email;
@property (nonatomic, retain) NSDate        *adult_created_at;

- (AdultObj *)initWithDictionary:(NSDictionary *)dicAdult;
- (NSDictionary *)currentDictionary;
- (NSURL *)adultAvatarUrl;

@end
