//
//  ContactUserObj.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ContactUserObj.h"

@implementation ContactUserObj

- (id)initWithId:(NSInteger)contact_id
          Avatar:(UIImage *)contact_avatar
       FirstName:(NSString *)contact_first_name
        LastName:(NSString *)contact_last_name
      PhoneLocal:(NSString *)contact_phone_local
     PhoneNumber:(NSString *)contact_phone_number {
    
    self = [super init];
    if(self) {
        self.contact_id = contact_id;
        self.contact_avatar = contact_avatar;
        self.contact_first_name = contact_first_name;
        self.contact_last_name = contact_last_name;
        self.contact_phone_local = contact_phone_local;
        self.contact_phone_number = contact_phone_number;
    }
    
    return self;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"invitation_driver_first_name":   self.contact_first_name,
             @"invitation_driver_last_name":    self.contact_last_name,
             @"invitation_driver_phone":        self.contact_phone_number
             };
}

- (NSString *)initialName {
    NSString *strLastName = @"";
    if(self.contact_last_name.length > 0) {
        strLastName = [[self.contact_last_name substringToIndex:1] uppercaseString];
    }
    
    return [NSString stringWithFormat:@"%@ %@.", self.contact_first_name, strLastName];
}

@end
