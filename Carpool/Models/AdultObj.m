//
//  AdultObj.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "AdultObj.h"

@implementation AdultObj

- (id)init {
    self = [super init];
    if(self) {
        self.adult_id = @0;
        self.adult_user_id = @0;
        self.adult_type = APP_USER;
        self.adult_avatar_url = @"";
        self.adult_first_name = @"";
        self.adult_last_name = @"";
        self.adult_email = @"";
        self.adult_phone = @"";
        self.adult_created_at = [NSDate date];
    }
    
    return self;
}

- (AdultObj *)initWithDictionary:(NSDictionary *)dicAdult {
    AdultObj *objAdult = [[AdultObj alloc] init];
    
    if(dicAdult[@"adult_id"] && ![dicAdult[@"adult_id"] isEqual:[NSNull null]]) {
        objAdult.adult_id = [NSNumber numberWithInt:[dicAdult[@"adult_id"] intValue]];
    }
    
    if(dicAdult[@"adult_user_id"] && ![dicAdult[@"adult_user_id"] isEqual:[NSNull null]]) {
        objAdult.adult_user_id = [NSNumber numberWithInt:[dicAdult[@"adult_user_id"] intValue]];
    }
    
    if(dicAdult[@"adult_avatar_url"] && ![dicAdult[@"adult_avatar_url"] isEqual:[NSNull null]]) {
        objAdult.adult_avatar_url = dicAdult[@"adult_avatar_url"];
    }
    
    if(dicAdult[@"adult_first_name"] && ![dicAdult[@"adult_first_name"] isEqual:[NSNull null]]) {
        objAdult.adult_first_name = dicAdult[@"adult_first_name"];
    }
    
    if(dicAdult[@"adult_last_name"] && ![dicAdult[@"adult_last_name"] isEqual:[NSNull null]]) {
        objAdult.adult_last_name = dicAdult[@"adult_last_name"];
    }
    
    if(dicAdult[@"adult_email"] && ![dicAdult[@"adult_email"] isEqual:[NSNull null]]) {
        objAdult.adult_email = dicAdult[@"adult_email"];
    }
    
    if(dicAdult[@"adult_phone"] && ![dicAdult[@"adult_phone"] isEqual:[NSNull null]]) {
        objAdult.adult_phone = dicAdult[@"adult_phone"];
    }
    
    if(dicAdult[@"adult_created_at"] && ![dicAdult[@"adult_created_at"] isEqual:[NSNull null]]) {
        objAdult.adult_created_at = [[GlobalService sharedInstance] dateFromString:dicAdult[@"adult_created_at"] withFormat:nil];
    }
    
    return objAdult;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"adult_id":           self.adult_id,
             @"adult_user_id":      self.adult_user_id,
             @"adult_avatar_url":   self.adult_avatar_url,
             @"adult_first_name":   self.adult_first_name,
             @"adult_last_name":    self.adult_last_name,
             @"adult_email":        self.adult_email,
             @"adult_phone":        self.adult_phone,
             @"adult_created_at":   [[GlobalService sharedInstance] stringFromDate:self.adult_created_at withFormat:nil]
             };
}

- (NSURL *)adultAvatarUrl {
    NSString *strAvatarUrl = @"";
    if(self.adult_type == APP_USER) {
        strAvatarUrl = [NSString stringWithFormat:@"%@/assets/avatar/%@", SERVER_URL, self.adult_avatar_url];
    } else {
        strAvatarUrl = self.adult_avatar_url;
    }
    
    return [NSURL URLWithString:strAvatarUrl];
}

@end
