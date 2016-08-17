//
//  ContactUserObj.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactUserObj : NSObject

@property (nonatomic, readwrite) NSInteger          contact_id;
@property (nonatomic, retain) UIImage               *contact_avatar;
@property (nonatomic, retain) NSString              *contact_first_name;
@property (nonatomic, retain) NSString              *contact_last_name;
@property (nonatomic, retain) NSString              *contact_phone_local;
@property (nonatomic, retain) NSString              *contact_phone_number;

- (id)initWithId:(NSInteger)contact_id
          Avatar:(UIImage *)contact_avatar
       FirstName:(NSString *)contact_first_name
        LastName:(NSString *)contact_last_name
      PhoneLocal:(NSString *)contact_phone_local
     PhoneNumber:(NSString *)contact_phone_number;

- (NSDictionary *)currentDictionary;

- (NSString *)initialName;

@end
