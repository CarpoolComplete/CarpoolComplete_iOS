//
//  UserSettingObj.m
//  Carpool
//
//  Created by JH Lee on 5/5/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "UserSettingObj.h"

@implementation UserSettingObj

- (id)init {
    self = [super init];
    if(self) {
        self.settings_sync = YES;
        self.settings_push_invite = YES;
        self.settings_alert_days = 2;
        self.settings_alert_hours = @"9am";
        self.settings_push_accept = YES;
        self.settings_push_decline = YES;
    }
    
    return self;
}

- (UserSettingObj *)initWithDictionary:(NSDictionary *)dicSettings {
    UserSettingObj *objSetting = [[UserSettingObj alloc] init];
    
    if(dicSettings[@"settings_sync"] != nil) {
        objSetting.settings_sync = [dicSettings[@"settings_sync"] boolValue];
    }
    
    if(dicSettings[@"settings_push_invite"] != nil) {
        objSetting.settings_push_invite = [dicSettings[@"settings_push_invite"] boolValue];
    }
    
    if(dicSettings[@"settings_alert_days"] != nil) {
        objSetting.settings_alert_days = [dicSettings[@"settings_alert_days"] intValue];
    }
    
    if(dicSettings[@"settings_alert_hours"] != nil) {
        objSetting.settings_alert_hours = dicSettings[@"settings_alert_hours"];
    }
    
    if(dicSettings[@"settings_push_accept"] != nil) {
        objSetting.settings_push_accept = [dicSettings[@"settings_push_accept"] boolValue];
    }
    
    if(dicSettings[@"settings_push_decline"] != nil) {
        objSetting.settings_push_decline = [dicSettings[@"settings_push_decline"] boolValue];
    }
    
    return objSetting;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"settings_sync":          [NSNumber numberWithBool:self.settings_sync],
             @"settings_push_invite":   [NSNumber numberWithBool:self.settings_push_invite],
             @"settings_alert_days":    [NSNumber numberWithInteger:self.settings_alert_days],
             @"settings_alert_hours":   self.settings_alert_hours,
             @"settings_push_accept":   [NSNumber numberWithBool:self.settings_push_accept],
             @"settings_push_decline":  [NSNumber numberWithBool:self.settings_push_decline]
             };
}

@end
