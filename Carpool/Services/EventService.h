//
//  EventService.h
//  Carpool
//
//  Created by JH Lee on 5/5/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface EventService : NSObject

@property (nonatomic, retain) EKEventStore  *eventStore;
@property (nonatomic, readwrite) BOOL       hasAccessToEventsStore;

+ (EventService *) sharedInstance;
- (void)createEventWithEventObj:(EventObj *)objEvent
                     completion:(void (^)(NSString *eventIdentifier, NSError *error))completion;

- (NSString *)createEventWithEventObj:(EventObj *)objEvent;

- (void)updateEventWithEventObj:(EventObj *)objEvent
                     completion:(void (^)(NSString *eventIdentifier, NSError *error))completion;

- (void)updateEventsWithEventObjects:(NSArray *)aryEvents
                          completion:(void (^)(NSArray *savedEvents, NSError *error))completion;

- (void)deleteEventWithEventObj:(EventObj *)objEvent
                     completion:(void (^)(NSError *error))completion;

- (void)deleteAllEvents:(NSArray *)aryEvents
             completion:(void (^)(NSError *error))completion;

@end
