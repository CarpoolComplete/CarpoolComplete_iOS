//
//  UserMe.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"
#import "PassengerObj.h"
#import "EventObj.h"
#import "JHEvent.h"

@interface UserMe : NSObject

@property (nonatomic, retain) UserObj               *my_user;
@property (nonatomic, retain) NSMutableArray        *my_passengers;
@property (nonatomic, retain) NSMutableArray        *my_adults;
@property (nonatomic, retain) NSMutableArray        *my_events;
@property (nonatomic, retain) NSMutableArray        *my_invitations;
@property (nonatomic, retain) NSString              *my_access_token;

- (UserMe *)initWithDictionary:(NSDictionary *)dicMe;
- (NSDictionary *)currentDictionary;
- (void)updateUser:(UserObj *)objUser;
- (void)updateDriverProfile:(UserObj *)objDriver;

// Custom functions
- (void)addEvent:(EventObj *)objEvent;
- (void)addEvents:(NSArray *)aryEvents;
- (void)updateEvent:(EventObj *)objEvent;
- (void)updateEvents:(NSArray *)aryEvents;
- (void)removeEvent:(NSNumber *)event_id;
- (EventObj *)getEventById:(NSNumber *)event_id;

// Custom invitations
- (void)addInvitation:(EventObj *)objEvent;
- (void)updateInvitations:(NSArray *)aryInvitations;

//adult
- (void)addAdult:(UserObj *)objAdult;
- (void)updateAdult:(UserObj *)objAdult;
- (void)removeAdult;

// passenger
- (void)addPassenger:(PassengerObj *)objPassenger;
- (void)updatePassengerFrom:(PassengerObj *)fromPassenger To:(PassengerObj *)toPassenger;
- (void)updatePassengers:(NSArray *)aryPassengers;
- (void)removePassenger:(PassengerObj *)objPassenger;

@end
