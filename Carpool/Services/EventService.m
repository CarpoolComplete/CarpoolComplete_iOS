//
//  EventService.m
//  Carpool
//
//  Created by JH Lee on 5/5/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventService.h"

@implementation EventService

static EventService *_globalService = nil;

+ (EventService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalService == nil) {
            _globalService = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalService;
}

- (id) init {
    self = [super init];
    if(self) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    
    return self;
}

- (void)requestAccessToEventStoreWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    if (!self.hasAccessToEventsStore) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (error) {
                NSLog(@"error adding event to calendar: %@", [error localizedDescription]);
            }
            
            self.hasAccessToEventsStore = granted;
            if (completion) {
                completion(granted, error);
            }
        }];
    } else {
        if (completion) {
            completion(YES, nil);
        }
    }
}

- (void)createEventWithEventObj:(EventObj *)objEvent
                     completion:(void (^)(NSString *eventIdentifier, NSError *error))completion {
    // get first EventDetail
    EventDetailObj *objEventDetail = objEvent.event_block_details[0];
    
    // date of custom_repeat_date + time of event_start_at
    NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
    NSString *strDate = [[GlobalService sharedInstance] stringFromDate:objEvent.event_repeat_start_at withFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strHour] withFormat:nil];
    NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];

    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = objEvent.event_title;
    event.startDate = startDate;
    event.endDate = endDate;
    event.calendar = self.eventStore.defaultCalendarForNewEvents;
    event.alarms = @[[EKAlarm alarmWithRelativeOffset:objEventDetail.event_detail_alert_time.doubleValue]];
    event.URL = [NSURL URLWithString:[NSString stringWithFormat:@"carpoolcomplete://%d/%@", objEvent.event_id.intValue, strDate]];
    
    switch (objEvent.event_repeat_type) {
        case EVENT_REPEAT_EVERY_DAY:
        case EVENT_REPEAT_EVERY_WEEKDAY:
        case EVENT_REPEAT_CUSTOM:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily
                                                                                   interval:1
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        case EVENT_REPEAT_WEEKLY:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                                                                                   interval:1
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        case EVENT_REPEAT_OTHER_WEEKLY:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                                                                                   interval:2
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        case EVENT_REPEAT_EVERY_MONTH:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly
                                                                                   interval:1
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        default:
            break;
    }
    
    NSError *eventError = nil;
    BOOL created = [self.eventStore saveEvent:event span:EKSpanThisEvent error:&eventError];
    if (created) {
        // We will only search the default calendar for our events
        NSArray *calendarArray = [NSArray arrayWithObject:self.eventStore.defaultCalendarForNewEvents];
        
        // Create the predicate
        NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:objEvent.event_repeat_start_at
                                                                          endDate:[objEvent.event_repeat_end_at dateByAddingDays:1]
                                                                        calendars:calendarArray];
        // Fetch all events that match the predicate
        NSArray *aryDeviceEvents = [self.eventStore eventsMatchingPredicate:predicate];
        
        for(EKEvent *tmpEvent in aryDeviceEvents) {
            if([event.eventIdentifier isEqualToString:tmpEvent.eventIdentifier]) {
                // check deleted dates
                NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:tmpEvent.startDate withFormat:@"yyyy-MM-dd"];
                if([objEvent.event_deleted_dates containsObject:strStartDate]) {
                    [self.eventStore removeEvent:tmpEvent span:EKSpanThisEvent error:nil];
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
                    if(tmpEvent.startDate.weekday == 1 || tmpEvent.startDate.weekday == 7) {
                        [self.eventStore removeEvent:tmpEvent span:EKSpanThisEvent error:nil];
                    }
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {    // custom
                    NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:tmpEvent.startDate withFormat:@"yyyy-MM-dd"];
                    if(![objEvent.event_custom_repeat_dates containsObject:strStartDate]) {
                        [self.eventStore removeEvent:tmpEvent span:EKSpanThisEvent error:nil];
                    }
                } else {
//                    objEventDetail = [[GlobalService sharedInstance] getEventDetailFromEvent:objEvent onDate:tmpEvent.startDate.dateAtBeginningOfDay];
//                    
//                    NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
//                    NSString *strDate = [[GlobalService sharedInstance] stringFromDate:tmpEvent.startDate withFormat:@"yyyy-MM-dd"];
//                    NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strHour] withFormat:nil];
//                    NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];
                    
//                    tmpEvent.startDate = startDate;
//                    tmpEvent.endDate = endDate;
//                    tmpEvent.alarms = @[[EKAlarm alarmWithRelativeOffset:objEventDetail.event_detail_alert_time.doubleValue]];
//                    tmpEvent.URL = [NSURL URLWithString:[NSString stringWithFormat:@"carpoolcomplete://%d/%@", objEvent.event_id.intValue, strDate]];
//                    tmpEvent.calendar = self.eventStore.defaultCalendarForNewEvents;
//                    
//                    [self.eventStore saveEvent:tmpEvent span:EKSpanThisEvent error:nil];
                }
            }
        }
        
        if (completion) {
            completion(event.eventIdentifier, nil);
        }
    } else if (eventError) {
        if (completion) {
            completion(nil, eventError);
        }
    }
}

- (NSString *)createEventWithEventObj:(EventObj *)objEvent {
    // get first EventDetail
    EventDetailObj *objEventDetail = objEvent.event_block_details[0];
    
    // date of custom_repeat_date + time of event_start_at
    NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
    NSString *strDate = [[GlobalService sharedInstance] stringFromDate:objEvent.event_repeat_start_at withFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strHour] withFormat:nil];
    NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];
    
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = objEvent.event_title;
    event.startDate = startDate;
    event.endDate = endDate;
    event.calendar = self.eventStore.defaultCalendarForNewEvents;
    event.alarms = @[[EKAlarm alarmWithRelativeOffset:objEventDetail.event_detail_alert_time.doubleValue]];
    event.URL = [NSURL URLWithString:[NSString stringWithFormat:@"carpoolcomplete://%d/%@", objEvent.event_id.intValue, strDate]];
    
    switch (objEvent.event_repeat_type) {
        case EVENT_REPEAT_EVERY_DAY:
        case EVENT_REPEAT_EVERY_WEEKDAY:
        case EVENT_REPEAT_CUSTOM:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily
                                                                                   interval:1
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        case EVENT_REPEAT_WEEKLY:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                                                                                   interval:1
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        case EVENT_REPEAT_OTHER_WEEKLY:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                                                                                   interval:2
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        case EVENT_REPEAT_EVERY_MONTH:
        {
            event.recurrenceRules = @[
                                      [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly
                                                                                   interval:1
                                                                                        end:[EKRecurrenceEnd recurrenceEndWithEndDate:[objEvent.event_repeat_end_at dateByAddingDays:1]]]
                                      ];
        }
            break;
            
        default:
            break;
    }
    
    NSError *eventError = nil;
    BOOL created = [self.eventStore saveEvent:event span:EKSpanThisEvent error:&eventError];
    if (created) {
        // We will only search the default calendar for our events
        NSArray *calendarArray = [NSArray arrayWithObject:self.eventStore.defaultCalendarForNewEvents];
        
        // Create the predicate
        NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:objEvent.event_repeat_start_at
                                                                          endDate:[objEvent.event_repeat_end_at dateByAddingDays:1]
                                                                        calendars:calendarArray];
        // Fetch all events that match the predicate
        NSArray *aryDeviceEvents = [self.eventStore eventsMatchingPredicate:predicate];
        
        for(EKEvent *tmpEvent in aryDeviceEvents) {
            if([event.eventIdentifier isEqualToString:tmpEvent.eventIdentifier]) {
                // check deleted dates
                NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:tmpEvent.startDate withFormat:@"yyyy-MM-dd"];
                if([objEvent.event_deleted_dates containsObject:strStartDate]) {
                    [self.eventStore removeEvent:tmpEvent span:EKSpanThisEvent error:nil];
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
                    if(tmpEvent.startDate.weekday == 1 || tmpEvent.startDate.weekday == 7) {
                        [self.eventStore removeEvent:tmpEvent span:EKSpanThisEvent error:nil];
                    }
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {    // custom
                    NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:tmpEvent.startDate withFormat:@"yyyy-MM-dd"];
                    if(![objEvent.event_custom_repeat_dates containsObject:strStartDate]) {
                        [self.eventStore removeEvent:tmpEvent span:EKSpanThisEvent error:nil];
                    }
                } else {
//                    objEventDetail = [[GlobalService sharedInstance] getEventDetailFromEvent:objEvent onDate:tmpEvent.startDate.dateAtBeginningOfDay];
//                    
//                    NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
//                    NSString *strDate = [[GlobalService sharedInstance] stringFromDate:tmpEvent.startDate withFormat:@"yyyy-MM-dd"];
//                    NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strHour] withFormat:nil];
//                    NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];
                    
//                    tmpEvent.startDate = startDate;
//                    tmpEvent.endDate = endDate;
//                    tmpEvent.alarms = @[[EKAlarm alarmWithRelativeOffset:objEventDetail.event_detail_alert_time.doubleValue]];
//                    tmpEvent.URL = [NSURL URLWithString:[NSString stringWithFormat:@"carpoolcomplete://%d/%@", objEvent.event_id.intValue, strDate]];
//                    tmpEvent.calendar = self.eventStore.defaultCalendarForNewEvents;
//                    [self.eventStore saveEvent:tmpEvent span:EKSpanThisEvent commit:YES error:nil];
//                    
//                    NSLog(@"%@", tmpEvent.eventIdentifier);
                }
            }
        }
        
        return event.eventIdentifier;
    } else {
        return nil;
    }
}

- (void)updateEventWithEventObj:(EventObj *)objEvent
                     completion:(void (^)(NSString *eventIdentifier, NSError *error))completion {
    [self requestAccessToEventStoreWithCompletion:^(BOOL success, NSError *anError) {
        if (success) {
            if(objEvent.event_sync_id.length > 0) {
                EKEvent *event = [self.eventStore eventWithIdentifier:objEvent.event_sync_id];
                if(event) {
                    [self.eventStore removeEvent:event span:EKSpanFutureEvents error:nil];
                }
            }
            
            [self createEventWithEventObj:objEvent completion:^(NSString *eventIdentifier, NSError *error) {
                if(completion) {
                    completion(eventIdentifier, error);
                }
            }];
        } else {    // create event
            if (completion) {
                completion(nil, anError);
            }
        }
    }];
}

- (void)updateEventsWithEventObjects:(NSArray *)aryEvents
                          completion:(void (^)(NSArray *savedEvents, NSError *error))completion {
    [self requestAccessToEventStoreWithCompletion:^(BOOL success, NSError *anError) {
        if (success) {
            for(EventObj *objEvent in aryEvents) {
                if(objEvent.event_sync_id.length > 0) {
                    EKEvent *event = [self.eventStore eventWithIdentifier:objEvent.event_sync_id];
                    if(event) {
                        [self.eventStore removeEvent:event span:EKSpanFutureEvents error:nil];
                    }
                }
                
                NSString *strEventID = [self createEventWithEventObj:objEvent];
                if(strEventID) {
                    objEvent.event_sync_id = strEventID;
                }
            }
            
            if(completion) {
                completion(aryEvents, nil);
            }
        } else {    // create event
            if (completion) {
                completion(nil, anError);
            }
        }
    }];
}

- (void)deleteEventWithEventObj:(EventObj *)objEvent
                     completion:(void (^)(NSError *error))completion {
    [self requestAccessToEventStoreWithCompletion:^(BOOL success, NSError *anError) {
        if (success) {
            if(objEvent.event_sync_id.length > 0) {
                // We will only search the default calendar for our events
                EKEvent *event = [self.eventStore eventWithIdentifier:objEvent.event_sync_id];
                if(event) {
                    [self.eventStore removeEvent:event span:EKSpanFutureEvents error:nil];
                }
            }
            if (completion) {
                completion(nil);
            }
        } else {
            if(completion) {
                completion(anError);
            }
        }
    }];
}

- (void)deleteAllEvents:(NSArray *)aryEvents
             completion:(void (^)(NSError *error))completion {
    [self requestAccessToEventStoreWithCompletion:^(BOOL success, NSError *anError) {
        if (success) {
            for(EventObj *objEvent in aryEvents) {
                if(objEvent.event_sync_id.length > 0) {
                    // We will only search the default calendar for our events
                    EKEvent *event = [self.eventStore eventWithIdentifier:objEvent.event_sync_id];
                    if(event) {
                        [self.eventStore removeEvent:event span:EKSpanFutureEvents error:nil];
                    }
                }
            }
            
            if(completion) {
                completion(nil);
            }
        } else {
            if(completion) {
                completion(anError);
            }
        }
    }];
}

@end
