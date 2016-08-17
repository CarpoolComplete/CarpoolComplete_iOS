
//  JHEvent.m
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "JHEvent.h"

NSInteger JHEventSortByStartTime(id ev1, id ev2, void *keyForSorting) {
    JHEvent *event1 = (JHEvent *)ev1;
    JHEvent *event2 = (JHEvent *)ev2;
    
    NSInteger v1 = [event1 minutesSinceMidnight];
    NSInteger v2 = [event2 minutesSinceMidnight];
    
    if (v1 < v2) {
        return NSOrderedAscending;
    } else if (v1 > v2) {
        return NSOrderedDescending;
    } else {
        /* Event start time is the same, compare by duration.
         */
        NSInteger d1 = [event1 durationInMinutes];
        NSInteger d2 = [event2 durationInMinutes];
        
        if (d1 < d2) {
            /*
             * Event with a shorter duration is after an event
             * with a longer duration. Looks nicer when drawing the events.
             */
            return NSOrderedDescending;
        } else if (d1 > d2) {
            return NSOrderedAscending;
        } else {
            /*
             * The last resort: compare by title.
             */
            return [event1.event_title compare:event2.event_title];
        }
    }
}

@implementation JHEvent

- (JHEvent *)createNewEvent {
    JHEvent *event = [[JHEvent alloc] init];
    
    event.event_id = @0;
    event.event_user_id = [GlobalService sharedInstance].my_user_id;
    event.event_title = @"";
    
    return event;
}

- (NSInteger)durationInMinutes {
    return [self.event_end_at minutesFromDate:self.event_start_at];
}

- (NSInteger)minutesSinceMidnight {
    return [self.event_start_at minutesFromDate:self.event_start_at.dateAtBeginningOfDay];
}

- (NSString *)eventStartTime {
    return [[GlobalService sharedInstance] stringFromDate:self.event_start_at withFormat:@"h:mm a"];
}

- (NSString *)eventEndTime {
    return [[GlobalService sharedInstance] stringFromDate:self.event_end_at withFormat:@"h:mm a"];
}

- (BOOL)compareJHEvent:(JHEvent *)event {
    if(self.event_title == event.event_title
       && [self.event_start_at compare:event.event_start_at] == NSOrderedSame
       && [self.event_end_at compare:event.event_end_at] == NSOrderedSame
       && [self.event_display_at compare:event.event_display_at] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

@end
