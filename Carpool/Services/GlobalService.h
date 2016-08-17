//
//  GlobalService.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "SideMenuViewController.h"
#import "UserMe.h"
#import "UserSettingObj.h"

@interface GlobalService : NSObject

@property (nonatomic, retain) AppDelegate                       *app_delegate;
@property (nonatomic, retain) UserMe                            *user_me;
@property (nonatomic, retain) UserSettingObj                    *user_setting;
@property (nonatomic, retain) NSNumber                          *my_user_id;
@property (nonatomic, retain) NSString                          *user_device_token;
@property (nonatomic, retain) NSString                          *user_access_token;
@property (nonatomic, readwrite) BOOL                           is_internet_alive;
@property (nonatomic, retain) NSArray                           *user_contacts;
@property (nonatomic, retain) TabBarViewController              *tabbar_vc;
@property (nonatomic, retain) SideMenuViewController            *menu_vc;
@property (nonatomic, retain) UIViewController                  *push_start_vc;
@property (nonatomic, retain) NSDate                            *active_date;
@property (nonatomic, retain) NSString                          *user_inputed_email;

+ (GlobalService *) sharedInstance;

- (UserMe *)loadMe;
- (void)saveMe:(UserMe *)objMe;
- (void)deleteMe;

- (void)loadSetting;
- (void)saveSetting;
- (void)deleteSetting;

- (NSString *)getUserTimeZone;

- (NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)dateFormat;
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;

- (NSString *)makeVerificationCode;

//event
- (JHEvent *)getJHEventFromEventObj:(EventObj *)objEvent
                        displayDate:(NSDate *)displayDate
                     EventDetailObj:(EventDetailObj *)objEventDetail;
- (NSArray *)getJHEventsForTutorial;
- (NSArray *)getEventsForDate:(NSDate *)date;
- (EventObj *)getEventObjFromJHEvent:(JHEvent *)event;
- (EventDetailObj *)getEventDetailFromEvent:(EventObj *)event onDate:displayDate;

//invitation
- (DriverObj *)getMyDriverFrom:(EventObj *)objEvent;
- (void)updateInvitesBadges;

@end
