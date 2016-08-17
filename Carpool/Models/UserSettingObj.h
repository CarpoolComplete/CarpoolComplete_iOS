//
//  UserSettingObj.h
//  Carpool
//
//  Created by JH Lee on 5/5/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettingObj : NSObject

@property (nonatomic, readwrite) BOOL           settings_sync;
@property (nonatomic, readwrite) BOOL           settings_push_invite;
@property (nonatomic, readwrite) NSInteger      settings_alert_days;
@property (nonatomic, retain) NSString          *settings_alert_hours;
@property (nonatomic, readwrite) BOOL           settings_push_accept;
@property (nonatomic, readwrite) BOOL           settings_push_decline;

- (UserSettingObj *)initWithDictionary:(NSDictionary *)dicSettings;
- (NSDictionary *)currentDictionary;

@end
