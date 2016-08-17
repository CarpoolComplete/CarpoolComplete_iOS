//
//  PassengerObj.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "PassengerObj.h"

@implementation PassengerObj

- (id)init {
    self = [super init];
    if(self) {
        self.passenger_id = @0;
        self.passenger_user_id = @0;
        self.passenger_first_name = @"";
        self.passenger_last_name = @"";
        self.passenger_created_at = [NSDate date];
    }
    
    return self;
}

- (PassengerObj *)initWithDictionary:(NSDictionary *)dicPassenger {
    PassengerObj *objPassenger = [[PassengerObj alloc] init];
    
    if(dicPassenger[@"passenger_id"] && ![dicPassenger[@"passenger_id"] isEqual:[NSNull null]]) {
        objPassenger.passenger_id = [NSNumber numberWithInt:[dicPassenger[@"passenger_id"] intValue]];
    }
    
    if(dicPassenger[@"passenger_user_id"] && ![dicPassenger[@"passenger_user_id"] isEqual:[NSNull null]]) {
        objPassenger.passenger_user_id = [NSNumber numberWithInt:[dicPassenger[@"passenger_user_id"] intValue]];
    }
    
    if(dicPassenger[@"passenger_first_name"] && ![dicPassenger[@"passenger_first_name"] isEqual:[NSNull null]]) {
        objPassenger.passenger_first_name = dicPassenger[@"passenger_first_name"];
    }
    
    if(dicPassenger[@"passenger_last_name"] && ![dicPassenger[@"passenger_last_name"] isEqual:[NSNull null]]) {
        objPassenger.passenger_last_name = dicPassenger[@"passenger_last_name"];
    }
    
    if(dicPassenger[@"passenger_created_at"] && ![dicPassenger[@"passenger_created_at"] isEqual:[NSNull null]]) {
        objPassenger.passenger_created_at = [[GlobalService sharedInstance] dateFromString:dicPassenger[@"passenger_created_at"] withFormat:nil];
    }
    
    return objPassenger;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"passenger_id":           self.passenger_id,
             @"passenger_user_id":      self.passenger_user_id,
             @"passenger_first_name":   self.passenger_first_name,
             @"passenger_last_name":    self.passenger_last_name,
             @"passenger_created_at":   [[GlobalService sharedInstance] stringFromDate:self.passenger_created_at withFormat:nil]
             };
}

- (NSString *)initialName {
    NSString *strLastName = @"";
    if(self.passenger_last_name.length > 0) {
        strLastName = [[self.passenger_last_name substringToIndex:1] uppercaseString];
    }
    
    return [NSString stringWithFormat:@"%@ %@.", self.passenger_first_name, strLastName];
}

@end
