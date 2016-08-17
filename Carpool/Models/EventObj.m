//
//  EventObj.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventObj.h"

@implementation EventDriverObj

- (id)init {
    self = [super init];
    if(self) {
        self.event_driver_id = @0;
        self.event_driver_driver_id = @0;
        self.event_driver_to_driver = NO;
        self.event_driver_date = [NSDate date].dateAtBeginningOfDay;
    }
    
    return self;
}

- (EventDriverObj *)initWithDictionary:(NSDictionary *)dicEventDriver {
    EventDriverObj *objEventDriver = [[EventDriverObj alloc] init];
    
    if(dicEventDriver[@"event_driver_id"] && ![dicEventDriver[@"event_driver_id"] isEqual:[NSNull null]]) {
        objEventDriver.event_driver_id = [NSNumber numberWithInt:[dicEventDriver[@"event_driver_id"] intValue]];
    }
    
    if(dicEventDriver[@"event_driver_driver_id"] && ![dicEventDriver[@"event_driver_driver_id"] isEqual:[NSNull null]]) {
        objEventDriver.event_driver_driver_id = [NSNumber numberWithInt:[dicEventDriver[@"event_driver_driver_id"] intValue]];
    }
    
    if(dicEventDriver[@"event_driver_driver_type"] && ![dicEventDriver[@"event_driver_driver_type"] isEqual:[NSNull null]]) {
        objEventDriver.event_driver_to_driver = [dicEventDriver[@"event_driver_driver_type"] boolValue];
    }
    
    if(dicEventDriver[@"event_driver_date"] && ![dicEventDriver[@"event_driver_date"] isEqual:[NSNull null]]) {
        objEventDriver.event_driver_date = [[GlobalService sharedInstance] dateFromString:dicEventDriver[@"event_driver_date"] withFormat:@"yyyy-MM-dd"];
    }
    
    return objEventDriver;
}

- (EventDriverObj *)initWithDriverId:(NSNumber *)event_driver_driver_id
                          IsToDriver:(BOOL)event_driver_to_driver
                          DriverDate:(NSDate *)event_driver_date {
    
    EventDriverObj *objEventDriver = [[EventDriverObj alloc] init];
    objEventDriver.event_driver_driver_id = event_driver_driver_id;
    objEventDriver.event_driver_to_driver = event_driver_to_driver;
    objEventDriver.event_driver_date = event_driver_date;
    
    return objEventDriver;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"event_driver_id":            self.event_driver_id,
             @"event_driver_driver_id":     self.event_driver_driver_id,
             @"event_driver_driver_type":   [NSNumber numberWithBool:self.event_driver_to_driver],
             @"event_driver_date":          [[GlobalService sharedInstance] stringFromDate:self.event_driver_date withFormat:@"yyyy-MM-dd"]
             };
}
@end

@implementation EventDetailObj

- (id)init {
    self = [super init];
    if(self) {
        self.event_detail_id = @0;
        NSDate *today = [NSDate date];
        if([[GlobalService sharedInstance].active_date compare:today] == NSOrderedDescending) {
            self.event_detail_start_at = [GlobalService sharedInstance].active_date;
        } else {
            self.event_detail_start_at = today;
        }

        self.event_detail_start_at = [self.event_detail_start_at dateBySettingHours:today.hour + 1];
        self.event_detail_start_at = [self.event_detail_start_at dateBySettingMinutes:0];
        self.event_detail_start_at = [self.event_detail_start_at dateBySettingSeconds:0];

        self.event_detail_end_at = [self.event_detail_start_at dateByAddingHours:1];
        self.event_detail_passengers = [[NSMutableArray alloc] init];
        self.event_detail_alert_time = @0;
        self.event_detail_type = EVENT_DETAIL_ALL;
        self.event_detail_date = [NSDate date].dateAtBeginningOfDay;
    }
    
    return self;
}

- (EventDetailObj *)initWithDictionary:(NSDictionary *)dicEventDetail {
    EventDetailObj *objDetailPassenger = [[EventDetailObj alloc] init];
    
    if(dicEventDetail[@"event_detail_id"] && ![dicEventDetail[@"event_detail_id"] isEqual:[NSNull null]]) {
        objDetailPassenger.event_detail_id = [NSNumber numberWithInt:[dicEventDetail[@"event_detail_id"] intValue]];
    }
    
    if(dicEventDetail[@"event_detail_start_at"] && ![dicEventDetail[@"event_detail_start_at"] isEqual:[NSNull null]]) {
        objDetailPassenger.event_detail_start_at = [[GlobalService sharedInstance] dateFromString:dicEventDetail[@"event_detail_start_at"] withFormat:@"HH:mm:ss"];
    }
    
    if(dicEventDetail[@"event_detail_end_at"] && ![dicEventDetail[@"event_detail_end_at"] isEqual:[NSNull null]]) {
        objDetailPassenger.event_detail_end_at = [[GlobalService sharedInstance] dateFromString:dicEventDetail[@"event_detail_end_at"] withFormat:@"HH:mm:ss"];
    }
    
    if(dicEventDetail[@"event_detail_passengers"]
       && ![dicEventDetail[@"event_detail_passengers"] isEqual:[NSNull null]]
       && [dicEventDetail[@"event_detail_passengers"] length] > 0) {
        objDetailPassenger.event_detail_passengers = [NSMutableArray arrayWithArray:[dicEventDetail[@"event_detail_passengers"] componentsSeparatedByString:@","]];
        for(int nIndex = 0; nIndex < objDetailPassenger.event_detail_passengers.count; nIndex++) {
            NSString *strPassenger = objDetailPassenger.event_detail_passengers[nIndex];
            
            if(strPassenger.length == 0) {
                [objDetailPassenger.event_detail_passengers removeObjectAtIndex:nIndex];
                nIndex--;
            }
        }
    }
    
    if(dicEventDetail[@"event_detail_alert_time"] && ![dicEventDetail[@"event_detail_alert_time"] isEqual:[NSNull null]]) {
        objDetailPassenger.event_detail_alert_time = [NSNumber numberWithInt:[dicEventDetail[@"event_detail_alert_time"] intValue]];
    }
    
    if(dicEventDetail[@"event_detail_type"] && ![dicEventDetail[@"event_detail_type"] isEqual:[NSNull null]]) {
        objDetailPassenger.event_detail_type = [dicEventDetail[@"event_detail_type"] intValue];
    }
    
    if(dicEventDetail[@"event_detail_date"] && ![dicEventDetail[@"event_detail_date"] isEqual:[NSNull null]]) {
        objDetailPassenger.event_detail_date = [[GlobalService sharedInstance] dateFromString:dicEventDetail[@"event_detail_date"] withFormat:@"yyyy-MM-dd"];
    }
    
    return objDetailPassenger;
}

- (EventDetailObj *)initWithEventDetailObj:(EventDetailObj *)objEventDetail {
    return [[EventDetailObj alloc] initWithDictionary:objEventDetail.currentDictionary];
}

- (BOOL)compareWithEventDetailObj:(EventDetailObj *)objEventDetail {
    BOOL isSame = NO;
    
    if([self.event_detail_start_at compare:objEventDetail.event_detail_start_at] == NSOrderedSame
       && [self.event_detail_end_at compare:objEventDetail.event_detail_end_at] == NSOrderedSame
       && self.event_detail_alert_time.intValue == objEventDetail.event_detail_alert_time.intValue) {
        
        isSame = YES;
        
        for(NSString *strPassenger in self.event_detail_passengers) {
            if(![objEventDetail.event_detail_passengers containsObject:strPassenger]) {
                isSame = NO;
                break;
            }
        }
    }
    
    return isSame;
}

- (EventDetailObj *)initEventStartAt:(NSDate *)event_detail_start_at
                               EndAt:(NSDate *)event_detail_end_at
                          Passengers:(NSArray *)event_detail_passengers
                           AlertTime:(NSNumber *)event_detail_alert_time
                          DetailType:(EVENT_DETAIL_TYPE)event_detail_type
                          DetailDate:(NSDate *)event_detail_date {

    EventDetailObj *objEventDetail = [[EventDetailObj alloc] init];
    objEventDetail.event_detail_start_at = event_detail_start_at;
    objEventDetail.event_detail_end_at = event_detail_end_at;
    [objEventDetail.event_detail_passengers setArray:event_detail_passengers];
    objEventDetail.event_detail_alert_time = event_detail_alert_time;
    objEventDetail.event_detail_type = event_detail_type;
    objEventDetail.event_detail_date = event_detail_date;
    
    return objEventDetail;
}

- (NSDictionary *)currentDictionary {
    NSMutableString *strPassengers = [[NSMutableString alloc] init];
    for(NSString *strPassenger in self.event_detail_passengers) {
        [strPassengers appendString:[NSString stringWithFormat:@"%@,", strPassenger]];
    }
    if(strPassengers.length > 0) {
        strPassengers = [NSMutableString stringWithString:[strPassengers substringToIndex:strPassengers.length - 1]];
    }
    
    return @{
             @"event_detail_id":                self.event_detail_id,
             @"event_detail_start_at":          [[GlobalService sharedInstance] stringFromDate:self.event_detail_start_at withFormat:@"HH:mm:ss"],
             @"event_detail_end_at":            [[GlobalService sharedInstance] stringFromDate:self.event_detail_end_at withFormat:@"HH:mm:ss"],
             @"event_detail_passengers":        strPassengers,
             @"event_detail_alert_time":        self.event_detail_alert_time,
             @"event_detail_type":              [NSNumber numberWithInt:self.event_detail_type],
             @"event_detail_date":              [[GlobalService sharedInstance] stringFromDate:self.event_detail_date withFormat:@"yyyy-MM-dd"]
             };
}

- (NSString *)alertString {
    if(self.event_detail_alert_time.intValue == 0) {
        return @"None";
    } else if(abs(self.event_detail_alert_time.intValue) / 3600 > 0) {
        return [NSString stringWithFormat:@"%d hours before", abs(self.event_detail_alert_time.intValue) / 3600];
    } else {
        return [NSString stringWithFormat:@"%d minutes before", abs(self.event_detail_alert_time.intValue) / 60];
    }
}

@end

@implementation DriverObj

- (id)init {
    self = [super init];
    if(self) {
        self.driver_invitation_id = @0;
        self.driver_user_id = @0;
        self.driver_family_id = @0;
        self.driver_first_name = @"";
        self.driver_last_name = @"";
        self.driver_email = @"";
        self.driver_phone = @"";
        self.driver_avatar_url = @"";
        self.driver_status = DRIVER_STATUS_ACCEPT;
    }
    
    return self;
}

- (DriverObj *)initWithDictionary:(NSDictionary *)dicDriver {
    DriverObj *objDriver = [[DriverObj alloc] init];
    
    if(dicDriver[@"driver_invitation_id"] && ![dicDriver[@"driver_invitation_id"] isEqual:[NSNull null]]) {
        objDriver.driver_invitation_id = [NSNumber numberWithInt:[dicDriver[@"driver_invitation_id"] intValue]];
    }
    
    if(dicDriver[@"driver_user_id"] && ![dicDriver[@"driver_user_id"] isEqual:[NSNull null]]) {
        objDriver.driver_user_id = [NSNumber numberWithInt:[dicDriver[@"driver_user_id"] intValue]];
    }
    
    if(dicDriver[@"driver_family_id"] && ![dicDriver[@"driver_family_id"] isEqual:[NSNull null]]) {
        objDriver.driver_family_id = [NSNumber numberWithInt:[dicDriver[@"driver_family_id"] intValue]];
    }
    
    if(dicDriver[@"driver_first_name"] && ![dicDriver[@"driver_first_name"] isEqual:[NSNull null]]) {
        objDriver.driver_first_name = dicDriver[@"driver_first_name"];
    }
    
    if(dicDriver[@"driver_last_name"] && ![dicDriver[@"driver_last_name"] isEqual:[NSNull null]]) {
        objDriver.driver_last_name = dicDriver[@"driver_last_name"];
    }
    
    if(dicDriver[@"driver_email"] && ![dicDriver[@"driver_email"] isEqual:[NSNull null]]) {
        objDriver.driver_email = dicDriver[@"driver_email"];
    }
    
    if(dicDriver[@"driver_phone"] && ![dicDriver[@"driver_phone"] isEqual:[NSNull null]]) {
        objDriver.driver_phone = dicDriver[@"driver_phone"];
    }
    
    if(dicDriver[@"driver_avatar_url"] && ![dicDriver[@"driver_avatar_url"] isEqual:[NSNull null]]) {
        objDriver.driver_avatar_url = dicDriver[@"driver_avatar_url"];
    }
    
    if(dicDriver[@"driver_status"] && ![dicDriver[@"driver_status"] isEqual:[NSNull null]]) {
        objDriver.driver_status = [dicDriver[@"driver_status"] intValue];
    }
    
    return objDriver;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"driver_invitation_id":   self.driver_invitation_id,
             @"driver_user_id":         self.driver_user_id,
             @"driver_first_name":      self.driver_first_name,
             @"driver_last_name":       self.driver_last_name,
             @"driver_email":           self.driver_email,
             @"driver_phone":           self.driver_phone,
             @"driver_avatar_url":      self.driver_avatar_url,
             @"driver_status":          [NSNumber numberWithInt:self.driver_status]
             };
}

- (NSString *)initialName {
    NSString *strLastName = @"";
    if(self.driver_last_name.length > 0) {
        strLastName = [[self.driver_last_name substringToIndex:1] uppercaseString];
    }
    
    return [NSString stringWithFormat:@"%@ %@.", self.driver_first_name, strLastName];
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.driver_first_name, self.driver_last_name];
}

- (void)updateDriver:(UserObj *)objUser {
    self.driver_first_name = objUser.user_first_name;
    self.driver_last_name = objUser.user_last_name;
    self.driver_email = objUser.user_email;
    self.driver_phone = objUser.user_phone;
    self.driver_avatar_url = objUser.user_avatar_url;
}

@end

@implementation EventObj

- (id)init {
    self = [super init];
    if(self) {
        self.event_id = @0;
        self.event_sync_id = @"";
        self.event_url = @"";
        self.event_user_id = @0;
        self.event_family_id = @0;
        self.event_creator_first_name = @"";
        self.event_creator_last_name = @"";
        self.event_creator_email = @"";
        self.event_creator_phone = @"";
        self.event_creator_avatar_url = @"";
        self.event_title = @"";
    
        self.event_repeat_start_at = [NSDate date];
        self.event_repeat_end_at = [NSDate date];
        self.event_repeat_no_end = NO;
        
        self.event_block_drivers = [[NSMutableArray alloc] init];
        self.event_block_details = [[NSMutableArray alloc] init];
        self.event_drivers = [[NSMutableArray alloc] init];
        self.event_repeat_type = EVENT_REPEAT_NONE;
        self.event_custom_repeat_dates = [[NSMutableArray alloc] init];
        self.event_deleted_dates = [[NSMutableArray alloc] init];
        self.event_created_at = [NSDate date];
    }
    
    return self;
}

- (EventObj *)initWithDictionary:(NSDictionary *)dicEvent {
    EventObj *objEvent = [[EventObj alloc] init];
    
    if(dicEvent[@"event_id"] && ![dicEvent[@"event_id"] isEqual:[NSNull null]]) {
        objEvent.event_id = [NSNumber numberWithInt:[dicEvent[@"event_id"] intValue]];
    }
    
    if(dicEvent[@"event_sync_id"] && ![dicEvent[@"event_sync_id"] isEqual:[NSNull null]]) {
        objEvent.event_sync_id = dicEvent[@"event_sync_id"];
    }
    
    if(dicEvent[@"event_url"] && ![dicEvent[@"event_url"] isEqual:[NSNull null]]) {
        objEvent.event_url = dicEvent[@"event_url"];
    }
    
    if(dicEvent[@"event_family_id"] && ![dicEvent[@"event_family_id"] isEqual:[NSNull null]]) {
        objEvent.event_family_id = [NSNumber numberWithInt:[dicEvent[@"event_family_id"] intValue]];
    }
    
    if(dicEvent[@"event_user_id"] && ![dicEvent[@"event_user_id"] isEqual:[NSNull null]]) {
        objEvent.event_user_id = [NSNumber numberWithInt:[dicEvent[@"event_user_id"] intValue]];
    }
    
    if(dicEvent[@"event_creator_first_name"] && ![dicEvent[@"event_creator_first_name"] isEqual:[NSNull null]]) {
        objEvent.event_creator_first_name = dicEvent[@"event_creator_first_name"];
    }
    
    if(dicEvent[@"event_creator_last_name"] && ![dicEvent[@"event_creator_last_name"] isEqual:[NSNull null]]) {
        objEvent.event_creator_last_name = dicEvent[@"event_creator_last_name"];
    }
    
    if(dicEvent[@"event_creator_email"] && ![dicEvent[@"event_creator_email"] isEqual:[NSNull null]]) {
        objEvent.event_creator_email = dicEvent[@"event_creator_email"];
    }
    
    if(dicEvent[@"event_creator_phone"] && ![dicEvent[@"event_creator_phone"] isEqual:[NSNull null]]) {
        objEvent.event_creator_phone = dicEvent[@"event_creator_phone"];
    }
    
    if(dicEvent[@"event_creator_avatar_url"] && ![dicEvent[@"event_creator_avatar_url"] isEqual:[NSNull null]]) {
        objEvent.event_creator_avatar_url = dicEvent[@"event_creator_avatar_url"];
    }
    
    if(dicEvent[@"event_title"] && ![dicEvent[@"event_title"] isEqual:[NSNull null]]) {
        objEvent.event_title = dicEvent[@"event_title"];
    }
    
    if(dicEvent[@"event_repeat_start_at"] && ![dicEvent[@"event_repeat_start_at"] isEqual:[NSNull null]]) {
        objEvent.event_repeat_start_at = [[GlobalService sharedInstance] dateFromString:dicEvent[@"event_repeat_start_at"] withFormat:@"yyyy-MM-dd"];
    }
    
    if(dicEvent[@"event_repeat_end_at"] && ![dicEvent[@"event_repeat_end_at"] isEqual:[NSNull null]]) {
        objEvent.event_repeat_end_at = [[GlobalService sharedInstance] dateFromString:dicEvent[@"event_repeat_end_at"] withFormat:@"yyyy-MM-dd"];
    }
    
    if(dicEvent[@"event_repeat_no_end"] && ![dicEvent[@"event_repeat_no_end"] isEqual:[NSNull null]]) {
        objEvent.event_repeat_no_end = [dicEvent[@"event_repeat_no_end"] boolValue];
    }
    
    if(dicEvent[@"event_block_drivers"] && ![dicEvent[@"event_block_drivers"] isEqual:[NSNull null]]) {
        for(NSDictionary *dicEventDriver in dicEvent[@"event_block_drivers"]) {
            EventDriverObj *objEventDriver = [[EventDriverObj alloc] initWithDictionary:dicEventDriver];
            [objEvent.event_block_drivers addObject:objEventDriver];
        }
    }
    
    if(dicEvent[@"event_block_details"] && ![dicEvent[@"event_block_details"] isEqual:[NSNull null]]) {
        for(NSDictionary *dicEventDetail in dicEvent[@"event_block_details"]) {
            EventDetailObj *objEventDetail = [[EventDetailObj alloc] initWithDictionary:dicEventDetail];
            [objEvent.event_block_details addObject:objEventDetail];
        }
    }
    
    if(dicEvent[@"event_drivers"] && ![dicEvent[@"event_drivers"] isEqual:[NSNull null]]) {
        NSArray *aryEventDrivers = dicEvent[@"event_drivers"];
        for(NSDictionary *dicEventDriver in aryEventDrivers) {
            DriverObj *objDriver = [[DriverObj alloc] initWithDictionary:dicEventDriver];
            [objEvent.event_drivers addObject:objDriver];
        }
    }
    
    if(dicEvent[@"event_repeat_type"] && ![dicEvent[@"event_repeat_type"] isEqual:[NSNull null]]) {
        objEvent.event_repeat_type = [dicEvent[@"event_repeat_type"] intValue];
    }
    
    if(dicEvent[@"event_custom_repeat_dates"] && ![dicEvent[@"event_custom_repeat_dates"] isEqual:[NSNull null]]) {
        NSArray *aryStringDates = [dicEvent[@"event_custom_repeat_dates"] componentsSeparatedByString:@","];
        for(NSString *strDate in aryStringDates) {
            if(strDate.length > 0) {
                [objEvent.event_custom_repeat_dates addObject:strDate];
            }
        }
    }
    
    if(dicEvent[@"event_deleted_dates"] && ![dicEvent[@"event_deleted_dates"] isEqual:[NSNull null]]) {
        NSArray *aryStringDates = [dicEvent[@"event_deleted_dates"] componentsSeparatedByString:@","];
        for(NSString *strDate in aryStringDates) {
            if(strDate.length > 0) {
                [objEvent.event_deleted_dates addObject:strDate];
            }
        }
    }
    
    if(dicEvent[@"event_created_at"] && ![dicEvent[@"event_created_at"] isEqual:[NSNull null]]) {
        objEvent.event_created_at = [[GlobalService sharedInstance] dateFromString:dicEvent[@"event_created_at"] withFormat:nil];
    }
    
    return objEvent;
}

- (NSDictionary *)currentDictionary {
    
    NSMutableArray *aryEventDrivers = [[NSMutableArray alloc] init];
    for(EventDriverObj *objEventDriver in self.event_block_drivers) {
        [aryEventDrivers addObject:objEventDriver.currentDictionary];
    }
    
    NSMutableArray *aryEventDetails = [[NSMutableArray alloc] init];
    for(EventDetailObj *objEventDetail in self.event_block_details) {
        [aryEventDetails addObject:objEventDetail.currentDictionary];
    }
    
    NSMutableArray *aryDrivers = [[NSMutableArray alloc] init];
    for(DriverObj *objDriver in self.event_drivers) {
        [aryDrivers addObject:objDriver.currentDictionary];
    }
    
    NSMutableString *strCustomRepeatDates = [[NSMutableString alloc] init];
    for(NSString *strCustomRepeatDate in self.event_custom_repeat_dates) {
        [strCustomRepeatDates appendString:[NSString stringWithFormat:@"%@,", strCustomRepeatDate]];
    }
    if(strCustomRepeatDates.length > 0) {
        strCustomRepeatDates = [NSMutableString stringWithString:[strCustomRepeatDates substringToIndex:strCustomRepeatDates.length - 1]];
    }
    
    NSMutableString *strDeletedDates = [[NSMutableString alloc] init];
    for(NSString *strDeletedDate in self.event_deleted_dates) {
        [strDeletedDates appendString:[NSString stringWithFormat:@"%@,", strDeletedDate]];
    }
    if(strDeletedDates.length > 0) {
        strDeletedDates = [NSMutableString stringWithString:[strDeletedDates substringToIndex:strDeletedDates.length - 1]];
    }
    
    return @{
             @"event_id":                   self.event_id,
             @"event_user_id":              self.event_user_id,
             @"event_sync_id":              self.event_sync_id,
             @"event_url":                  self.event_url,
             @"event_family_id":            self.event_family_id,
             @"event_creator_first_name":   self.event_creator_first_name,
             @"event_creator_last_name":    self.event_creator_last_name,
             @"event_creator_email":        self.event_creator_email,
             @"event_creator_phone":        self.event_creator_phone,
             @"event_creator_avatar_url":   self.event_creator_avatar_url,
             @"event_title":                self.event_title,
             @"event_repeat_start_at":      [[GlobalService sharedInstance] stringFromDate:self.event_repeat_start_at withFormat:@"yyyy-MM-dd"],
             @"event_repeat_end_at":        [[GlobalService sharedInstance] stringFromDate:self.event_repeat_end_at withFormat:@"yyyy-MM-dd"],
             @"event_repeat_no_end":        [NSNumber numberWithBool:self.event_repeat_no_end],
             @"event_block_drivers":        aryEventDrivers,
             @"event_block_details":        aryEventDetails,
             @"event_drivers":              aryDrivers,
             @"event_repeat_type":          [NSNumber numberWithInt:self.event_repeat_type],
             @"event_custom_repeat_dates":  strCustomRepeatDates,
             @"event_deleted_dates":        strDeletedDates,
             @"event_created_at":           [[GlobalService sharedInstance] stringFromDate:self.event_created_at withFormat:nil]
             };
}

- (NSDictionary *)currentDictionaryForWeb {
    NSMutableString *strCustomRepeatDates = [[NSMutableString alloc] init];
    for(NSString *strCustomRepeatDate in self.event_custom_repeat_dates) {
        [strCustomRepeatDates appendString:[NSString stringWithFormat:@"%@,", strCustomRepeatDate]];
    }
    if(strCustomRepeatDates.length > 0) {
        strCustomRepeatDates = [NSMutableString stringWithString:[strCustomRepeatDates substringToIndex:strCustomRepeatDates.length - 1]];
    }
    
    NSMutableString *strDeletedDates = [[NSMutableString alloc] init];
    for(NSString *strDeletedDate in self.event_deleted_dates) {
        [strDeletedDates appendString:[NSString stringWithFormat:@"%@,", strDeletedDate]];
    }
    if(strDeletedDates.length > 0) {
        strDeletedDates = [NSMutableString stringWithString:[strDeletedDates substringToIndex:strDeletedDates.length - 1]];
    }
    
    return @{
             @"event_user_id":              self.event_user_id,
             @"event_title":                self.event_title,
             @"event_repeat_start_at":      [[GlobalService sharedInstance] stringFromDate:self.event_repeat_start_at withFormat:@"yyyy-MM-dd"],
             @"event_repeat_end_at":        [[GlobalService sharedInstance] stringFromDate:self.event_repeat_end_at withFormat:@"yyyy-MM-dd"],
             @"event_repeat_no_end":        [NSNumber numberWithBool:self.event_repeat_no_end],
             @"event_repeat_type":          [NSNumber numberWithInt:self.event_repeat_type],
             @"event_custom_repeat_dates":  strCustomRepeatDates,
             @"event_deleted_dates":        strDeletedDates
             };
}

- (EventObj *)initWithEventObj:(EventObj *)objEvent {
    return [[EventObj alloc] initWithDictionary:objEvent.currentDictionary];
}

- (BOOL)compareWithEventObj:(EventObj *)objEvent {
    BOOL isSame = NO;
    
    if([self.event_title isEqualToString:objEvent.event_title]
       && self.event_repeat_type == objEvent.event_repeat_type
       && [self.event_repeat_start_at compare:objEvent.event_repeat_start_at] == NSOrderedSame
       && [self.event_repeat_end_at compare:objEvent.event_repeat_end_at] == NSOrderedSame) {
        isSame = YES;        
    }
    
    return isSame;
}

- (NSString *)eventRepeatTypeString {
    NSArray *aryRepeatEventString = @[
                                      @"Never",
                                      @"Every Day",
                                      @"Every Weekday",
                                      @"Weekly",
                                      @"Other Weekly",
                                      @"Every Month",
                                      @"Custom"
                                      ];
    
    return aryRepeatEventString[self.event_repeat_type];
}

- (NSURL *)creatorAvatarUrl {
    NSString *strAvatarUrl = [NSString stringWithFormat:@"%@/assets/avatar/%@", SERVER_URL, self.event_creator_avatar_url];
    return [NSURL URLWithString:strAvatarUrl];
}

- (NSString *)creatorInitialName {
    NSString *strLastName = @"";
    if(self.event_creator_last_name.length > 0) {
        strLastName = [[self.event_creator_last_name substringToIndex:1] uppercaseString];
    }
    
    return [NSString stringWithFormat:@"%@ %@.", self.event_creator_first_name, strLastName];
}

- (NSString *)creatorFullName {
    return [NSString stringWithFormat:@"%@ %@", self.event_creator_first_name, self.event_creator_last_name];
}

- (NSString *)eventPeriod {
    NSString *strPeriod = @"";
    
    NSString *strEventStartDate = [[GlobalService sharedInstance] stringFromDate:self.event_repeat_start_at withFormat:@"MMM dd yyyy"];
    NSArray *aryEventStartDate = [strEventStartDate componentsSeparatedByString:@" "];
    
    if(self.event_repeat_no_end) {
        strPeriod = [NSString stringWithFormat:@"%@ - Never", strEventStartDate];
    } else {
        NSString *strEventEndDate = [[GlobalService sharedInstance] stringFromDate:self.event_repeat_end_at withFormat:@"MMM dd yyyy"];
        NSArray *aryEventEndDate = [strEventEndDate componentsSeparatedByString:@" "];
        if([aryEventStartDate[2] isEqualToString:aryEventEndDate[2]]) { //equal year
            if([aryEventStartDate[0] isEqualToString:aryEventEndDate[0]]) { //equal month
                strPeriod = [NSString stringWithFormat:@"%@ %@ - %@ %@", aryEventStartDate[0], aryEventStartDate[1], aryEventEndDate[1], aryEventStartDate[2]];
            } else {
                strPeriod = [NSString stringWithFormat:@"%@ %@ - %@ %@ %@", aryEventStartDate[0], aryEventStartDate[1], aryEventEndDate[0], aryEventEndDate[1], aryEventStartDate[2]];
            }
        } else {
            strPeriod = [NSString stringWithFormat:@"%@ - %@", strEventStartDate, strEventEndDate];
        }
    }
    return strPeriod;
}

- (NSDate *)firstEventDate {
    NSDate *event_start_date = self.event_repeat_start_at.dateAtBeginningOfDay;
    
    if(self.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
        NSDate *nextDate = event_start_date;
        while([nextDate compare:self.event_repeat_end_at] != NSOrderedDescending) {
            //if every weekly and sat or sun, continue
            if(nextDate.weekday == 1 || nextDate.weekday == 7) {
                nextDate = [nextDate dateByAddingDays:1];
                continue;
            } else {
                break;
            }
        }
        
        event_start_date = nextDate;
    } if(self.event_repeat_type == EVENT_REPEAT_CUSTOM) {
        if(self.event_custom_repeat_dates.count > 0) {
            event_start_date = [[GlobalService sharedInstance] dateFromString:self.event_custom_repeat_dates[0] withFormat:@"yyyy-MM-dd"];
        }
    }
    
    return event_start_date;
}

- (BOOL)isValidEvent {
    BOOL isValid = NO;
    if(self.event_repeat_type == EVENT_REPEAT_CUSTOM) {
        for(NSString *custom_date in self.event_custom_repeat_dates) {
            //if deleted date, next
            if([self.event_deleted_dates containsObject:custom_date]) {
                continue;
            } else {
                isValid = YES;
                break;
            }
        }
    } else {    // repeat
        NSDate *nextDate = self.event_repeat_start_at;
        while ([nextDate compare:self.event_repeat_end_at] != NSOrderedDescending) {
            NSDate *startDate = nextDate;
            NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
            if(self.event_repeat_type == EVENT_REPEAT_EVERY_DAY) {
                endDateComponents.day = 1;
            } else if(self.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
                endDateComponents.day = 1;
            } else if(self.event_repeat_type == EVENT_REPEAT_WEEKLY) {
                endDateComponents.day = 7;
            } else if(self.event_repeat_type == EVENT_REPEAT_OTHER_WEEKLY) {
                endDateComponents.day = 14;
            } else if(self.event_repeat_type == EVENT_REPEAT_EVERY_MONTH) {
                endDateComponents.month = 1;
            } else {
                break;
            }
            
            nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:endDateComponents
                                                                     toDate:startDate
                                                                    options:0];
            
            //make temp date to compare with deleted_dates
            NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:startDate
                                                                         withFormat:@"yyyy-MM-dd"];
            
            //if removed date, next
            if([self.event_deleted_dates containsObject:strStartDate]) {
                continue;
            }
            //if every weekly and sat or sun, continue
            if(self.event_repeat_type == EVENT_REPEAT_EVERY_WEEKDAY) {
                if(startDate.weekday == 1 || startDate.weekday == 7) {
                    continue;
                }
            }
            
            isValid = YES;
            break;
        }
        
    }
    return isValid;
}

- (void)updateCreator:(UserObj *)objUser {
    self.event_creator_first_name = objUser.user_first_name;
    self.event_creator_last_name = objUser.user_last_name;
    self.event_creator_email = objUser.user_email;
    self.event_creator_phone = objUser.user_phone;
    self.event_creator_avatar_url = objUser.user_avatar_url;
}

- (void)removeDriver:(NSInteger)index {
    DriverObj *objDriver = self.event_drivers[index];
    [self.event_drivers removeObjectAtIndex:index];
    
    for(int nIndex = 0; nIndex < self.event_block_drivers.count; nIndex++) {
        EventDriverObj *objEventDriver = self.event_block_drivers[nIndex];
        
        if(objEventDriver.event_driver_driver_id.intValue == objDriver.driver_user_id.intValue) {
            [self.event_block_drivers removeObject:objEventDriver];
            nIndex--;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT object:nil];
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

@end
