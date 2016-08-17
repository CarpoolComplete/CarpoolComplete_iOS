//
//  PassengerObj.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassengerObj : NSObject

@property (nonatomic, retain) NSNumber      *passenger_id;
@property (nonatomic, retain) NSNumber      *passenger_user_id;
@property (nonatomic, retain) NSString      *passenger_first_name;
@property (nonatomic, retain) NSString      *passenger_last_name;
@property (nonatomic, retain) NSDate        *passenger_created_at;

- (PassengerObj *)initWithDictionary:(NSDictionary *)dicPassenger;
- (NSDictionary *)currentDictionary;
- (NSString *)initialName;

@end
