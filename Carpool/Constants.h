//
//  Constants.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define SERVER_URL                              @"http://52.37.247.230"
#define TERMS_URL                               @"http://terms.carpoolcomplete.com/terms-and-conditionsprivacy-policy"
#define PRIVACY_URL                             @"http://terms.carpoolcomplete.com/terms-and-conditionsprivacy-policy"

#define SERVER_RESULT_MESSAGE                   @"message"
#define APP_NAME                                @"Carpool Complete"

#define ONESIGNAL_APP_ID                        @"5b227f5b-165e-4363-b1c8-d04add345bc6"

//string constants
#define STRING_NO_INTERNET                      @"No Internet Connection!"
#define HTTP_HEADER_TOKEN_KEY                   @"AccessToken"

//NSUserDefaults Keys
#define USER_DEFAULTS_KEY_ME                    @"UserDefaultsKeyMe"
#define USER_DEFAULTS_KEY_SETTING               @"UserDefaultsKeySetting"
#define USER_DEFAULTS_KEY_FIRST_USE             @"UserDefaultsKeyFirstUse"
#define USER_DEFAULTS_KEY_FIRST_INVITE          @"UserDefaultsKeyFirstInvite"

//SVProgressHUD
#define SVPROGRESSHUD_PLEASE_WAIT               [SVProgressHUD showWithStatus:@"Please wait..."]
#define SVPROGRESSHUD_DISMISS                   [SVProgressHUD dismiss]
#define SVPROGRESSHUD_SUCCESS(status)           [SVProgressHUD showSuccessWithStatus:status]
#define SVPROGRESSHUD_ERROR(status)             [SVProgressHUD showErrorWithStatus:status]
#define SVPROGRESSHUD_PROGRESS(progress)        [SVProgressHUD showProgress:progress status:@"Uploading..."];

//Toast Messages
#define TOAST_NO_USER_FIRST_NAME                @"Please input your user first name"
#define TOAST_INVALID_EMAIL_ADDRESS             @"Invalid Email Address"
#define TOAST_INVALID_PHONE_NUMBER              @"Invalid Phone Number"
#define TOAST_SHORT_PASSWORD                    @"Password must be 6 over characters"
#define TOAST_MISMATCH_PASSWORD                 @"Mismatch your password"
#define TOAST_INVALID_CODE                      @"Your code is wrong!"
#define TOAST_NO_EVENT_TITLE                    @"Please input your event title"
#define TOAST_EXIST_SAME_CHILDREN               @"You have already same children"

//NSNotificationKeys
#define NOTIFICATION_UPDATE_EVENT               @"NotificationUpdateEvent"

#define TABBAR_HEIGHT                           60
#define SYNC_FUTURE_YEARS                       1

#define INVITES_TABBAR_INDEX                    3

#define DEFAULT_AVATAR_IMAGE                    [UIImage imageNamed:@"image_default_avatar"]

#define IN_APP_PURCHASE_UPGRADE_USER            @"CarpoolComplete2016"

typedef enum {
    EVENT_REPEAT_NONE = 0,
    EVENT_REPEAT_EVERY_DAY,
    EVENT_REPEAT_EVERY_WEEKDAY,
    EVENT_REPEAT_WEEKLY,
    EVENT_REPEAT_OTHER_WEEKLY,
    EVENT_REPEAT_EVERY_MONTH,
    EVENT_REPEAT_CUSTOM
} EVENT_REPEAT_TYPE;

typedef enum {
    CARPOOL_PUSH_SEND_INVITATION = 0,
    CARPOOL_PUSH_INVITATION_ACCEPT,
    CARPOOL_PUSH_INVITATION_REJECT,
    CARPOOL_PUSH_UPDATE_EVENT,
    CARPOOL_PUSH_UPDATE_EVENT_DRIVER,
    CARPOOL_PUSH_UPDATE_EVENT_PASSENGER,
    CARPOOL_PUSH_UPDATE_PROFILE,
    CARPOOL_PUSH_REMOVE_DRIVER,
    CARPOOL_PUSH_CREATE_PASSENGER,
    CARPOOL_PUSH_UPDATE_PASSENGER,
    CARPOOL_PUSH_REMOVE_PASSENGER,
    CARPOOL_PUSH_REMOVE_EVENT
} NOTIFICATION_TYPE;

#endif /* Constants_h */
