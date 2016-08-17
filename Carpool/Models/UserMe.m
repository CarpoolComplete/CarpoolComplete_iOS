//
//  UserMe.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "UserMe.h"

@implementation UserMe

- (id)init {
    self = [super init];
    if(self) {
        self.my_user = [[UserObj alloc] init];
        self.my_adults = [[NSMutableArray alloc] init];
        self.my_passengers = [[NSMutableArray alloc] init];
        self.my_events = [[NSMutableArray alloc] init];
        self.my_invitations = [[NSMutableArray alloc] init];
        self.my_access_token = @"";
    }
    
    return self;
}

- (UserMe *)initWithDictionary:(NSDictionary *)dicMe {
    UserMe *objMe = [[UserMe alloc] init];
    
    if(dicMe[@"my_user"] && ![dicMe[@"my_user"] isEqual:[NSNull null]]) {
        objMe.my_user = [[UserObj alloc] initWithDictionary:dicMe[@"my_user"]];
    }
    
    if(dicMe[@"my_adults"] && ![dicMe[@"my_adults"] isEqual:[NSNull null]]) {
        NSArray *aryDicAdults = dicMe[@"my_adults"];
        for(NSDictionary *dicAdult in aryDicAdults) {
            UserObj *objAdult = [[UserObj alloc] initWithDictionary:dicAdult];
            [objMe.my_adults addObject:objAdult];
        }
    }
    
    if(dicMe[@"my_passengers"] && ![dicMe[@"my_passengers"] isEqual:[NSNull null]]) {
        NSArray *aryDicPassengers = dicMe[@"my_passengers"];
        for(NSDictionary *dicPassenger in aryDicPassengers) {
            PassengerObj *objPassenger = [[PassengerObj alloc] initWithDictionary:dicPassenger];
            [objMe.my_passengers addObject:objPassenger];
        }
    }
    
    if(dicMe[@"my_events"] && ![dicMe[@"my_events"] isEqual:[NSNull null]]) {
        NSArray *aryDicEvents = dicMe[@"my_events"];
        for(NSDictionary *dicEvent in aryDicEvents) {
            EventObj *objEvent = [[EventObj alloc] initWithDictionary:dicEvent];
            [objMe.my_events addObject:objEvent];
        }
    }
    
    if(dicMe[@"my_invitations"] && ![dicMe[@"my_invitations"] isEqual:[NSNull null]]) {
        NSArray *aryDicInvitations = dicMe[@"my_invitations"];
        for(NSDictionary *dicInvitation in aryDicInvitations) {
            EventObj *objEvent = [[EventObj alloc] initWithDictionary:dicInvitation];
            [objMe.my_invitations addObject:objEvent];
        }
    }
    
    if(dicMe[@"my_access_token"] && ![dicMe[@"my_access_token"] isEqual:[NSNull null]]) {
        objMe.my_access_token = dicMe[@"my_access_token"];
    }
    
    return objMe;
}

- (NSDictionary *)currentDictionary {
    NSMutableArray *aryDicAdults = [[NSMutableArray alloc] init];
    for(UserObj *objAdult in self.my_adults) {
        [aryDicAdults addObject:objAdult.currentDictionary];
    }
    
    NSMutableArray *aryDicPassengers = [[NSMutableArray alloc] init];
    for(PassengerObj *objPassenger in self.my_passengers) {
        [aryDicPassengers addObject:objPassenger.currentDictionary];
    }
    
    NSMutableArray *aryDicEvents = [[NSMutableArray alloc] init];
    for(EventObj *objEvent in self.my_events) {
        [aryDicEvents addObject:objEvent.currentDictionary];
    }
    
    NSMutableArray *aryDicInvitations = [[NSMutableArray alloc] init];
    for(EventObj *objInvitation in self.my_invitations) {
        [aryDicInvitations addObject:objInvitation.currentDictionary];
    }
    
    return @{
             @"my_user":            self.my_user.currentDictionary,
             @"my_adults":          aryDicAdults,
             @"my_passengers":      aryDicPassengers,
             @"my_events":          aryDicEvents,
             @"my_invitations":     aryDicInvitations,
             @"my_access_token":    self.my_access_token
             };
}

#pragma mark - Custom func
- (void)addEvent:(EventObj *)objEvent {
    if([GlobalService sharedInstance].user_setting.settings_sync) {
        // create new event on iCalc
        [[EventService sharedInstance] createEventWithEventObj:objEvent
                                                    completion:^(NSString *eventIdentifier, NSError *error) {
                                                        if(eventIdentifier) {
                                                            objEvent.event_sync_id = eventIdentifier;
                                                        }
                                                        
                                                        [self.my_events addObject:objEvent];
                                                        [[GlobalService sharedInstance] saveMe:self];
                                                    }];
    } else {
        [self.my_events addObject:objEvent];
        [[GlobalService sharedInstance] saveMe:self];
    }
}

- (void)addEvents:(NSArray *)aryEvents {
    [self.my_events addObjectsFromArray:aryEvents];
    [[GlobalService sharedInstance] saveMe:self];
}

- (void)updateEvent:(EventObj *)objEvent {
    for(int nIndex = 0; nIndex < self.my_events.count; nIndex++) {
        EventObj *tmpEvent = self.my_events[nIndex];
        if(objEvent.event_id.intValue == tmpEvent.event_id.intValue) {
            objEvent.event_sync_id = tmpEvent.event_sync_id;
            
            if([GlobalService sharedInstance].user_setting.settings_sync) {
                [[EventService sharedInstance] updateEventWithEventObj:objEvent
                                                            completion:^(NSString *eventIdentifier, NSError *error) {
                                                                if(eventIdentifier) {
                                                                    objEvent.event_sync_id = eventIdentifier;
                                                                }
                                                                [self.my_events replaceObjectAtIndex:nIndex withObject:objEvent];
                                                                [[GlobalService sharedInstance] saveMe:self];
                                                            }];
            } else {
                [self.my_events replaceObjectAtIndex:nIndex withObject:objEvent];
                [[GlobalService sharedInstance] saveMe:self];
            }
            break;
        }
    }
    
    for(int nIndex = 0; nIndex < self.my_invitations.count; nIndex++) {
        EventObj *tmpEvent = self.my_invitations[nIndex];
        if(tmpEvent.event_id.intValue == objEvent.event_id.intValue) {
            [self.my_invitations replaceObjectAtIndex:nIndex withObject:objEvent];
            [[GlobalService sharedInstance] saveMe:self];
        }
    }
    
    [[GlobalService sharedInstance] updateInvitesBadges];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
}

- (void)updateEvents:(NSArray *)aryEvents {
    if([GlobalService sharedInstance].user_setting.settings_sync) {
        [[EventService sharedInstance] deleteAllEvents:self.my_events
                                            completion:^(NSError *error) {
                                                [[EventService sharedInstance] updateEventsWithEventObjects:aryEvents
                                                                                                 completion:^(NSArray *savedEvents, NSError *error) {
                                                                                                     [self.my_events setArray:savedEvents];
                                                                                                     [[GlobalService sharedInstance] saveMe:self];
                                                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
                                                                                                     });
                                                                                                 }];
                                            }];
    } else {
        NSMutableArray *aryNewEvents = [[NSMutableArray alloc] init];
        for(int nIndex = 0; nIndex < aryEvents.count; nIndex++) {
            EventObj *objEvent = aryEvents[nIndex];
            BOOL isExist = NO;
            for(EventObj *tmpEvent in self.my_events) {
                if(objEvent.event_id.intValue == tmpEvent.event_id.intValue) {
                    objEvent.event_sync_id = tmpEvent.event_sync_id;
                    isExist = YES;
                    break;
                }
            }
            
            [aryNewEvents addObject:objEvent];
        }
    
        [self.my_events setArray:aryNewEvents];
        [[GlobalService sharedInstance] saveMe:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
    }
}

- (void)removeEvent:(NSNumber *)event_id {
    for(int nIndex = 0; nIndex < self.my_events.count; nIndex++) {
        EventObj *tmpEvent = self.my_events[nIndex];
        if(event_id.intValue == tmpEvent.event_id.intValue) {
            if([GlobalService sharedInstance].user_setting.settings_sync) {
                [[EventService sharedInstance] deleteEventWithEventObj:tmpEvent
                                                            completion:nil];
            }
            
            [self.my_events removeObjectAtIndex:nIndex];
            break;
        }
    }
    
    for(int nIndex = 0; nIndex < self.my_invitations.count; nIndex++) {
        EventObj *tmpEvent = self.my_invitations[nIndex];
        if(event_id.intValue == tmpEvent.event_id.intValue) {
            [self.my_invitations removeObjectAtIndex:nIndex];
            break;
        }
    }
    
    [[GlobalService sharedInstance] updateInvitesBadges];
    [[GlobalService sharedInstance] saveMe:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
}

- (EventObj *)getEventById:(NSNumber *)event_id {
    EventObj *objEvent = nil;
    
    for(int nIndex = 0; nIndex < self.my_events.count; nIndex++) {
        EventObj *tmpEvent = self.my_events[nIndex];
        if(event_id.intValue == tmpEvent.event_id.intValue) {
            objEvent = tmpEvent;
            break;
        }
    }
    
    return objEvent;
}

// invitation
- (void)addInvitation:(EventObj *)objEvent {
    for(int nIndex = 0; nIndex < self.my_invitations.count; nIndex++) {
        EventObj *tmpEvent = self.my_invitations[nIndex];
        if(objEvent.event_id.intValue == tmpEvent.event_id.intValue) {
            [self.my_invitations removeObject:tmpEvent];
            break;
        }
    }
    [self.my_invitations addObject:objEvent];
    [[GlobalService sharedInstance] saveMe:self];
    [[GlobalService sharedInstance] updateInvitesBadges];
}

- (void)updateInvitations:(NSArray *)aryInvitations {
    [self.my_invitations setArray:aryInvitations];
    [[GlobalService sharedInstance] saveMe:self];
    [[GlobalService sharedInstance] updateInvitesBadges];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
}

- (void)updateUser:(UserObj *)objUser {
    self.my_user = objUser;
    [self updateDriverProfile:objUser];
}

- (void)updateDriverProfile:(UserObj *)objUser {
    for(EventObj *objEvent in self.my_events) {
        if(objEvent.event_user_id.intValue == objUser.user_id.intValue) {
            [objEvent updateCreator:objUser];
        }
        
        for(DriverObj *objDriver in objEvent.event_drivers) {
            if(objDriver.driver_user_id.intValue == objUser.user_id.intValue) {
                [objDriver updateDriver:objUser];
            }
        }
    }
    
    for(EventObj *objInvitation in self.my_invitations) {
        if(objInvitation.event_user_id.intValue == objUser.user_id.intValue) {
            [objInvitation updateCreator:objUser];
        }
        
        for(DriverObj *objDriver in objInvitation.event_drivers) {
            if(objDriver.driver_user_id.intValue == objUser.user_id.intValue) {
                [objDriver updateDriver:objUser];
            }
        }
    }
    
    [[GlobalService sharedInstance] saveMe:self];
}

// adult
- (void)addAdult:(UserObj *)objAdult {
    [self.my_adults addObject:objAdult];
    [[GlobalService sharedInstance] saveMe:self];
}

- (void)updateAdult:(UserObj *)objAdult {
    [self.my_adults replaceObjectAtIndex:0 withObject:objAdult];
    [[GlobalService sharedInstance] saveMe:self];
}

- (void)removeAdult {
    [self.my_adults removeObjectAtIndex:0];
    [[GlobalService sharedInstance] saveMe:self];
}

// passenger
- (void)addPassenger:(PassengerObj *)objPassenger {
    [self.my_passengers addObject:objPassenger];
    [[GlobalService sharedInstance] saveMe:self];
}

- (void)updatePassengerFrom:(PassengerObj *)fromPassenger To:(PassengerObj *)toPassenger {
    NSInteger nIndex = [self.my_passengers indexOfObject:fromPassenger];
    if(nIndex >= 0 && nIndex < self.my_passengers.count) {
        [self.my_passengers replaceObjectAtIndex:nIndex withObject:toPassenger];
    }
    
    for(EventObj *objEvent in self.my_events) {
        for(int nIndex = 0; nIndex < objEvent.event_block_details.count; nIndex++) {
            EventDetailObj *objEventDetail = objEvent.event_block_details[nIndex];
            NSInteger index = [objEventDetail.event_detail_passengers indexOfObject:fromPassenger.initialName];
            if(index >= 0 && index < objEventDetail.event_detail_passengers.count) {
                [objEventDetail.event_detail_passengers replaceObjectAtIndex:index withObject:toPassenger.initialName];
            }
        }
    }
    
    [[GlobalService sharedInstance] saveMe:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
}

- (void)updatePassengers:(NSArray *)aryPassengers {
    [self.my_passengers setArray:aryPassengers];
    [[GlobalService sharedInstance] saveMe:self];
}

- (void)removePassenger:(PassengerObj *)objPassenger {
    [self.my_passengers removeObject:objPassenger];
    
    for(EventObj *objEvent in self.my_events) {
        for(int nIndex = 0; nIndex < objEvent.event_block_details.count; nIndex++) {
            EventDetailObj *objEventDetail = objEvent.event_block_details[nIndex];
            [objEventDetail.event_detail_passengers removeObject:objPassenger.initialName];
        }
    }
    
    [[GlobalService sharedInstance] saveMe:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
}

@end
