//
//  EventObj.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EVENT_DETAIL_ALL = 0,
    EVENT_DETAIL_FUTURE,
    EVENT_DETAIL_THIS_ONLY
}EVENT_DETAIL_TYPE;

typedef enum {
    DRIVER_STATUS_PENDING = 0,
    DRIVER_STATUS_ACCEPT = 1,
    DRIVER_STATUS_REJECT = -1
}DRIVER_STATUS;

@interface EventDriverObj : NSObject

@property (nonatomic, retain) NSNumber                  *event_driver_id;
@property (nonatomic, retain) NSNumber                  *event_driver_driver_id;
@property (nonatomic, readwrite) BOOL                   event_driver_to_driver;
@property (nonatomic, retain) NSDate                    *event_driver_date;

- (EventDriverObj *)initWithDictionary:(NSDictionary *)dicEventDriver;
- (EventDriverObj *)initWithDriverId:(NSNumber *)event_driver_driver_id
                          IsToDriver:(BOOL)event_driver_to_driver
                          DriverDate:(NSDate *)event_driver_date;
- (NSDictionary *)currentDictionary;

@end

@interface EventDetailObj : NSObject

@property (nonatomic, retain) NSNumber                  *event_detail_id;
@property (nonatomic, retain) NSDate                    *event_detail_start_at;
@property (nonatomic, retain) NSDate                    *event_detail_end_at;
@property (nonatomic, retain) NSMutableArray            *event_detail_passengers;
@property (nonatomic, retain) NSNumber                  *event_detail_alert_time;
@property (nonatomic, readwrite) EVENT_DETAIL_TYPE      event_detail_type;
@property (nonatomic, retain) NSDate                    *event_detail_date;

- (EventDetailObj *)initWithDictionary:(NSDictionary *)dicEventPassenger;
- (EventDetailObj *)initWithEventDetailObj:(EventDetailObj *)objEventDetail;
- (BOOL)compareWithEventDetailObj:(EventDetailObj *)objEventDetail;
- (EventDetailObj *)initEventStartAt:(NSDate *)event_detail_start_at
                               EndAt:(NSDate *)event_detail_end_at
                          Passengers:(NSArray *)event_detail_passengers
                           AlertTime:(NSNumber *)event_detail_alert_time
                          DetailType:(EVENT_DETAIL_TYPE)event_detail_type
                          DetailDate:(NSDate *)event_detail_date;
- (NSDictionary *)currentDictionary;
- (NSString *)alertString;

@end

@interface DriverObj : NSObject

@property (nonatomic, retain) NSNumber          *driver_invitation_id;
@property (nonatomic, retain) NSNumber          *driver_user_id;
@property (nonatomic, retain) NSNumber          *driver_family_id;
@property (nonatomic, retain) NSString          *driver_first_name;
@property (nonatomic, retain) NSString          *driver_last_name;
@property (nonatomic, retain) NSString          *driver_email;
@property (nonatomic, retain) NSString          *driver_phone;
@property (nonatomic, retain) NSString          *driver_avatar_url;
@property (nonatomic, readwrite) DRIVER_STATUS  driver_status;

- (DriverObj *)initWithDictionary:(NSDictionary *)dicDriver;
- (NSDictionary *)currentDictionary;
- (NSString *)initialName;
- (NSString *)fullName;
- (void)updateDriver:(UserObj *)objUser;

@end

@interface EventObj : NSObject

@property (nonatomic, retain) NSNumber              *event_id;
@property (nonatomic, retain) NSString              *event_sync_id;
@property (nonatomic, retain) NSString              *event_url;
@property (nonatomic, retain) NSNumber              *event_user_id;
@property (nonatomic, retain) NSNumber              *event_family_id;
@property (nonatomic, retain) NSString              *event_creator_first_name;
@property (nonatomic, retain) NSString              *event_creator_last_name;
@property (nonatomic, retain) NSString              *event_creator_email;
@property (nonatomic, retain) NSString              *event_creator_phone;
@property (nonatomic, retain) NSString              *event_creator_avatar_url;
@property (nonatomic, retain) NSString              *event_title;
@property (nonatomic, retain) NSDate                *event_repeat_start_at;
@property (nonatomic, retain) NSDate                *event_repeat_end_at;
@property (nonatomic, readwrite) BOOL               event_repeat_no_end;
@property (nonatomic, retain) NSMutableArray        *event_block_details;
@property (nonatomic, retain) NSMutableArray        *event_block_drivers;
@property (nonatomic, retain) NSMutableArray        *event_drivers;
@property (nonatomic, readwrite) EVENT_REPEAT_TYPE  event_repeat_type;
@property (nonatomic, retain) NSMutableArray        *event_custom_repeat_dates;
@property (nonatomic, retain) NSMutableArray        *event_deleted_dates;
@property (nonatomic, retain) NSDate                *event_created_at;

- (EventObj *)initWithDictionary:(NSDictionary *)dicEvent;
- (EventObj *)initWithEventObj:(EventObj *)objEvent;
- (BOOL)compareWithEventObj:(EventObj *)objEvent;

- (NSDate *)firstEventDate;
- (NSDictionary *)currentDictionary;
- (NSDictionary *)currentDictionaryForWeb;
- (NSString *)eventRepeatTypeString;
- (NSURL *)creatorAvatarUrl;
- (NSString *)creatorInitialName;
- (NSString *)creatorFullName;
- (NSString *)eventPeriod;
- (BOOL)isValidEvent;
- (void)updateCreator:(UserObj *)objUser;

- (void)removeDriver:(NSInteger)index;

@end
