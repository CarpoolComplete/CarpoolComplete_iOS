//
//  GlobalService.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "GlobalService.h"

@implementation GlobalService

static GlobalService *_globalService = nil;

+ (GlobalService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalService == nil) {
            _globalService = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalService;
}

- (id)init {
    self = [super init];
    if(self) {
        self.user_device_token = @"";
        self.user_access_token = @"";
        self.is_internet_alive = YES;
    }
    
    return self;
}

- (UserMe *)loadMe {
    UserMe *objMe = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicMe = [defaults objectForKey:USER_DEFAULTS_KEY_ME];
    if(dicMe) {
        objMe = [[UserMe alloc] initWithDictionary:dicMe];
        self.my_user_id = objMe.my_user.user_id;
        self.user_access_token = objMe.my_access_token;
    }
    
    [self loadSetting];
    
    return objMe;
}

- (void)saveMe:(UserMe *)objMe {
    self.user_me = objMe;
    self.my_user_id = objMe.my_user.user_id;
    self.user_access_token = objMe.my_access_token;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user_me.currentDictionary forKey:USER_DEFAULTS_KEY_ME];
    [defaults synchronize];
}

- (void)deleteMe {
    self.user_me = nil;
    self.user_access_token = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_DEFAULTS_KEY_ME];
    [defaults synchronize];
}

- (void)loadSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicSetting = [defaults objectForKey:USER_DEFAULTS_KEY_SETTING];
    if(dicSetting) {
        self.user_setting = [[UserSettingObj alloc] initWithDictionary:dicSetting];
    } else {
        self.user_setting = [[UserSettingObj alloc] init];
    }
}

- (void)saveSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user_setting.currentDictionary forKey:USER_DEFAULTS_KEY_SETTING];
    [defaults synchronize];
}

- (void)deleteSetting {
    self.user_setting = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_DEFAULTS_KEY_SETTING];
    [defaults synchronize];
}

- (NSString *)getUserTimeZone {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger nDiffMins = [zone secondsFromGMT] / 60;
    NSInteger nMin = nDiffMins % 60;
    NSInteger nHour = nDiffMins / 60;
    
    //make user time zone => example +10:00, -8:00
    NSString *strTimeZone = [NSString stringWithFormat:@"%@%d:%d", nHour > 0 ? @"+" : @"", (int)nHour, (int)nMin];
    return strTimeZone;
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateFormat) {
        formatter.dateFormat = dateFormat;
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return [formatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateFormat) {
        formatter.dateFormat = dateFormat;
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return [formatter dateFromString:strDate];
}

- (NSString *)makeVerificationCode {
    NSString *strCode = @"";
    for(int nIndex = 0; nIndex < 4; nIndex++) {
        strCode = [NSString stringWithFormat:@"%@%d", strCode, arc4random() % 10];
    }
    
    return strCode;
}

//events

- (NSArray *)getEventsForDate:(NSDate *)date {
    NSMutableArray *aryEvents = [[NSMutableArray alloc] init];
    
    for(EventObj *objEvent in [GlobalService sharedInstance].user_me.my_events) {
        if(objEvent.event_repeat_type == EVENT_REPEAT_NONE) {
            EventDetailObj *objEventDetail = [self getEventDetailFromEvent:objEvent onDate:date];
            
            // date of custom_repeat_date + time of event_start_at
            NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
            NSString *strDate = [[GlobalService sharedInstance] stringFromDate:objEvent.event_repeat_start_at withFormat:@"yyyy-MM-dd"];
            NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strHour] withFormat:nil];
            NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];
            
            if([self containsDate:date from:startDate to:endDate]) {
                [aryEvents addObject:[self getJHEventFromEventObj:objEvent displayDate:date EventDetailObj:objEventDetail]];
            }
        } else if(objEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {
            
            for(NSString *custom_date in objEvent.event_custom_repeat_dates) {
                EventDetailObj *objEventDetail = [self getEventDetailFromEvent:objEvent
                                                                        onDate:[[GlobalService sharedInstance] dateFromString:custom_date
                                                                                                                   withFormat:@"yyyy-MM-dd"]];
                
                //if deleted date, next
                if([objEvent.event_deleted_dates containsObject:custom_date]) {
                    continue;
                }
                
                // date of custom_repeat_date + time of event_start_at
                NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
                
                NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", custom_date, strHour] withFormat:nil];
                NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];
                
                if([self containsDate:date from:startDate to:endDate]) {
                    [aryEvents addObject:[self getJHEventFromEventObj:objEvent displayDate:date EventDetailObj:objEventDetail]];
                }
            }
        } else {    // repeat
            // if past event or future event, ignore
            NSDate *start_date = objEvent.event_repeat_start_at.dateAtBeginningOfDay;
            
            if([objEvent.event_repeat_end_at compare:date] == NSOrderedAscending
               || [start_date compare:date] == NSOrderedDescending) {
                continue;
            }
            
            NSDate *tomorrow = [date dateByAddingDays:1];
            
            NSDate *nextDate = objEvent.event_repeat_start_at;
            while ([nextDate compare:tomorrow] != NSOrderedDescending) {
                EventDetailObj *objEventDetail = [self getEventDetailFromEvent:objEvent onDate:nextDate];
                
                // date of custom_repeat_date + time of event_start_at
                NSString *strHour = [[GlobalService sharedInstance] stringFromDate:objEventDetail.event_detail_start_at withFormat:@"HH:mm:ss"];
                NSString *strDate = [[GlobalService sharedInstance] stringFromDate:nextDate withFormat:@"yyyy-MM-dd"];
                NSDate *startDate = [[GlobalService sharedInstance] dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strHour] withFormat:nil];
                NSDate *endDate = [startDate dateByAddingMinutes:[objEventDetail.event_detail_end_at minutesFromDate:objEventDetail.event_detail_start_at]];
                
                NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
                if(objEvent.event_repeat_type == EVENT_REPEAT_EVERY_DAY) {
                    endDateComponents.day = 1;
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
                    endDateComponents.day = 1;
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_WEEKLY) {
                    endDateComponents.day = 7;
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_OTHER_WEEKLY) {
                    endDateComponents.day = 14;
                } else if(objEvent.event_repeat_type == EVENT_REPEAT_EVERY_MONTH) {
                    endDateComponents.month = 1;
                } else {
                    break;
                }
                
                nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:endDateComponents
                                                                         toDate:nextDate
                                                                        options:0];
                
                //make temp date to compare with deleted_dates
                NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:startDate
                                                                             withFormat:@"yyyy-MM-dd"];
                
                //if removed date, next
                if([objEvent.event_deleted_dates containsObject:strStartDate]) {
                    continue;
                }
                //if every weekly and sat or sun, continue
                if(objEvent.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
                    if(startDate.weekday == 1 || startDate.weekday == 7) {
                        continue;
                    }
                }
                
                if([self containsDate:date from:startDate to:endDate]) {
                    [aryEvents addObject:[self getJHEventFromEventObj:objEvent displayDate:date EventDetailObj:objEventDetail]];
                }
            }
            
        }
    }
    
    return [aryEvents sortedArrayUsingFunction:JHEventSortByStartTime context:NULL];
}

- (BOOL)containsDate:(NSDate *)date from:(NSDate *)fromDate to:(NSDate *)toDate {
    NSDate *nextDate = [date dateByAddingDays:1];
    
    BOOL isContained = NO;
    if([fromDate compare:date] == NSOrderedAscending) {
        if([toDate compare:date] == NSOrderedDescending) {
            isContained = YES;
        }
    } else {
        if([fromDate compare:nextDate] == NSOrderedAscending) {
            isContained = YES;
        }
    }
    
    return isContained;
}

- (JHEvent *)getJHEventFromEventObj:(EventObj *)objEvent
                        displayDate:(NSDate *)displayDate
                     EventDetailObj:(EventDetailObj *)objEventDetail {
    JHEvent *event = [[JHEvent alloc] init];
    event.event_id = objEvent.event_id;
    event.event_user_id = objEvent.event_user_id;
    event.event_start_at = objEventDetail.event_detail_start_at;
    event.event_end_at = objEventDetail.event_detail_end_at;
    event.event_display_at = displayDate;
    event.event_title = objEvent.event_title;
    NSMutableArray *event_accepted_drivers = [[NSMutableArray alloc] init];
    for(DriverObj *objDriver in objEvent.event_drivers) {
        if(objDriver.driver_status == DRIVER_STATUS_ACCEPT) {
            [event_accepted_drivers addObject:objDriver];
        }
    }
    
    //insert event creator as driver
    DriverObj *objDriver = [[DriverObj alloc] init];
    objDriver.driver_user_id = objEvent.event_user_id;
    objDriver.driver_first_name = objEvent.event_creator_first_name;
    objDriver.driver_last_name = objEvent.event_creator_last_name;
    objDriver.driver_phone = objEvent.event_creator_phone;
    [event_accepted_drivers insertObject:objDriver atIndex:0];
        
    //get event driver
    EventDriverObj *objEventToDriver = [self getEventDriverFromEvent:objEvent onDate:displayDate isTo:YES];
    EventDriverObj *objEventFromDriver = [self getEventDriverFromEvent:objEvent onDate:displayDate isTo:NO];
    
    event.event_userInfo = @{
                             @"event_passengers":       objEventDetail.event_detail_passengers,
                             @"event_from_driver_id":   objEventFromDriver.event_driver_driver_id,
                             @"event_to_driver_id":     objEventToDriver.event_driver_driver_id,
                             @"event_drivers":          event_accepted_drivers,
                             @"event_alert_time":       objEventDetail.event_detail_alert_time
                             };
    return event;
}

- (NSArray *)getJHEventsForTutorial {
    JHEvent *event = [[JHEvent alloc] init];
    event.event_start_at = [[[NSDate date] dateAtBeginningOfDay] dateByAddingHours:13];
    event.event_end_at = [[[NSDate date] dateAtBeginningOfDay] dateByAddingHours:15];
    event.event_display_at = [[NSDate date] dateAtBeginningOfDay];
    event.event_title = @"Soccer Camp";
    
    event.event_userInfo = @{
                             @"event_passengers":       @[@"Anna C.", @"Alex H.", @"Tiffany P.", @"Sonny L."],
                             @"event_from_driver_id":   @0,
                             @"event_to_driver_id":     @0,
                             @"event_drivers":          @[],
                             @"event_alert_time":       @0
                             };
    
    return @[event];
}

- (EventDriverObj *)getEventDriverFromEvent:(EventObj *)event onDate:displayDate isTo:(BOOL)isTo {
    EventDriverObj *objEventDriver = [[EventDriverObj alloc] init];
    
    for(EventDriverObj *tmpEventDriver in event.event_block_drivers) {
        if([tmpEventDriver.event_driver_date compare:displayDate] == NSOrderedDescending) {
            break;
        }
        
        if(tmpEventDriver.event_driver_to_driver != isTo) {
            continue;
        }
        
        if([tmpEventDriver.event_driver_date isSameDay:displayDate]) {
            objEventDriver = [[EventDriverObj alloc] initWithDictionary:tmpEventDriver.currentDictionary];
            break;
        }
    }
    
    return objEventDriver;
}

- (EventDetailObj *)getEventDetailFromEvent:(EventObj *)event onDate:displayDate {
    EventDetailObj *objEventDetail = [[EventDetailObj alloc] init];
    
    for(EventDetailObj *tmpEventDetail in event.event_block_details) {
        if([tmpEventDetail.event_detail_date compare:displayDate] == NSOrderedDescending) {
            break;
        }
        
        if(tmpEventDetail.event_detail_type == EVENT_DETAIL_ALL
           || tmpEventDetail.event_detail_type == EVENT_DETAIL_FUTURE) {
            objEventDetail = [[EventDetailObj alloc] initWithDictionary:tmpEventDetail.currentDictionary];
        } else if([tmpEventDetail.event_detail_date isSameDay:displayDate]) {
            objEventDetail = [[EventDetailObj alloc] initWithDictionary:tmpEventDetail.currentDictionary];
            break;
        }
    }
    
    return objEventDetail;
}

- (EventObj *)getEventObjFromJHEvent:(JHEvent *)event {
    EventObj *retEvent = nil;
    for(EventObj *objEvent in [GlobalService sharedInstance].user_me.my_events) {
        if(objEvent.event_id.intValue == event.event_id.intValue) {
            retEvent = objEvent;
            break;
        }
    }
    
    return retEvent;
}

//invites
- (DriverObj *)getMyDriverFrom:(EventObj *)objEvent {
    DriverObj *objMyInvitationDriver = nil;
    for(DriverObj *objDriver in objEvent.event_drivers) {
        if(objDriver.driver_user_id == [GlobalService sharedInstance].my_user_id) {
            objMyInvitationDriver = objDriver;
            break;
        }
    }
    
    return objMyInvitationDriver;
}

- (void)updateInvitesBadges {
    int nBadges = 0;
    for(EventObj *objEvent in self.user_me.my_invitations) {
        DriverObj *objDriver = [self getMyDriverFrom:objEvent];
        if([objEvent.event_repeat_end_at compare:[NSDate date].dateAtBeginningOfDay] != NSOrderedAscending) {
            if(objDriver && objDriver.driver_status == DRIVER_STATUS_PENDING) {
                nBadges++;
            }
        }
    }
    
    if(nBadges > 0) {
        [self.tabbar_vc.tabBar.items[INVITES_TABBAR_INDEX] setBadgeValue:[NSString stringWithFormat:@"%d", nBadges]];
    } else {
        [self.tabbar_vc.tabBar.items[INVITES_TABBAR_INDEX] setBadgeValue:nil];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = nBadges;
}

@end
