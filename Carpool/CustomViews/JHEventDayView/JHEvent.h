//
//  JHEvent.h
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NSInteger JHEventSortByStartTime(id ev1, id ev2, void *keyForSorting);

@interface JHEvent : NSObject

@property (nonatomic, copy) NSNumber        *event_id;
@property (nonatomic, copy) NSNumber        *event_user_id;
@property (nonatomic, copy) NSString        *event_title;
@property (nonatomic, copy) NSDate          *event_start_at;
@property (nonatomic, copy) NSDate          *event_end_at;
@property (nonatomic, copy) NSDate          *event_display_at;
@property (nonatomic, strong) UIColor       *event_view_background_color;
@property (nonatomic, strong) NSDictionary  *event_userInfo;

- (JHEvent *)createNewEvent;
- (NSInteger)durationInMinutes;
- (NSInteger)minutesSinceMidnight;
- (NSString *)eventStartTime;
- (NSString *)eventEndTime;
- (BOOL)compareJHEvent:(JHEvent *)event;

@end
