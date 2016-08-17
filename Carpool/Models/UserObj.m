//
//  UserObj.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "UserObj.h"

@implementation UserObj

- (id)init {
    self = [super init];
    if(self) {
        self.user_id = @0;
        self.user_family_id = @0;
        self.user_first_name = @"";
        self.user_last_name = @"";
        self.user_email = @"";
        self.user_avatar_url = @"";
        self.user_phone = @"";
        self.user_pass = @"";
        self.user_created_at = [NSDate date];
    }
    
    return self;
}

- (UserObj *)initWithDictionary:(NSDictionary *)dicUser {
    UserObj *objUser = [[UserObj alloc] init];
    
    if(dicUser[@"user_id"] && ![dicUser[@"user_id"] isEqual:[NSNull null]]) {
        objUser.user_id = [NSNumber numberWithInt:[dicUser[@"user_id"] intValue]];
    }
    
    if(dicUser[@"user_family_id"] && ![dicUser[@"user_family_id"] isEqual:[NSNull null]]) {
        objUser.user_family_id = [NSNumber numberWithInt:[dicUser[@"user_family_id"] intValue]];
    }
    
    if(dicUser[@"user_first_name"] && ![dicUser[@"user_first_name"] isEqual:[NSNull null]]) {
        objUser.user_first_name = dicUser[@"user_first_name"];
    }
    
    if(dicUser[@"user_last_name"] && ![dicUser[@"user_last_name"] isEqual:[NSNull null]]) {
        objUser.user_last_name = dicUser[@"user_last_name"];
    }
    
    if(dicUser[@"user_email"] && ![dicUser[@"user_email"] isEqual:[NSNull null]]) {
        objUser.user_email = dicUser[@"user_email"];
    }
    
    if(dicUser[@"user_avatar_url"] && ![dicUser[@"user_avatar_url"] isEqual:[NSNull null]]) {
        objUser.user_avatar_url = dicUser[@"user_avatar_url"];
    }
    
    if(dicUser[@"user_phone"] && ![dicUser[@"user_phone"] isEqual:[NSNull null]]) {
        objUser.user_phone = dicUser[@"user_phone"];
    }
    
    if(dicUser[@"user_pass"] && ![dicUser[@"user_pass"] isEqual:[NSNull null]]) {
        objUser.user_pass = dicUser[@"user_pass"];
    }
    
    objUser.user_is_creator = objUser.user_family_id.intValue == objUser.user_id.intValue;
    
    if(dicUser[@"user_created_at"] && ![dicUser[@"user_created_at"] isEqual:[NSNull null]]) {
        objUser.user_created_at = [[GlobalService sharedInstance] dateFromString:dicUser[@"user_created_at"] withFormat:nil];
    }
    
    if(dicUser[@"user_status"] && ![dicUser[@"user_status"] isEqual:[NSNull null]]) {
        if([dicUser[@"user_status"] isEqualToString:@"TRIAL"]) {
            objUser.user_status = TRIAL_USER;
        } else if([dicUser[@"user_status"] isEqualToString:@"PAID"]) {
            objUser.user_status = PAID_USER;
        } else {
            objUser.user_status = EXPIRED_USER;
        }
    }
    
    return objUser;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"user_id":            self.user_id,
             @"user_family_id":     self.user_family_id,
             @"user_first_name":    self.user_first_name,
             @"user_last_name":     self.user_last_name,
             @"user_email":         self.user_email,
             @"user_avatar_url":    self.user_avatar_url,
             @"user_phone":         self.user_phone,
             @"user_pass":          self.user_pass,
             @"user_created_at":    [[GlobalService sharedInstance] stringFromDate:self.user_created_at withFormat:nil],
             @"user_status":        self.user_status == TRIAL_USER ? @"TRIAL" : self.user_status == PAID_USER ? @"PAID" : @"EXPIRED"
             };
}

- (NSURL *)avatarUrl {
    NSString *strAvatarUrl = [NSString stringWithFormat:@"%@/assets/avatar/%@", SERVER_URL, self.user_avatar_url];
    return [NSURL URLWithString:strAvatarUrl];
}

- (NSString *)initialName {
    NSString *strLastName = @"";
    if(self.user_last_name.length > 0) {
        strLastName = [[self.user_last_name substringToIndex:1] uppercaseString];
    }
    
    return [NSString stringWithFormat:@"%@ %@.", self.user_first_name, strLastName];
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.user_first_name, self.user_last_name];
}

@end
