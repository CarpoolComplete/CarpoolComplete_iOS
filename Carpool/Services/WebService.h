//
//  WebService.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMe.h"

@interface WebService : NSObject

+ (WebService *) sharedInstance;

#pragma mark - User APIs
- (void)loginWithUserEmail:(NSString *)user_email
                  UserPass:(NSString *)user_pass
                   success:(void (^)(UserMe *))success
                   failure:(void (^)(NSString *))failure;

- (void)signupWithUserObj:(UserObj *)objUser
                 progress:(void (^)(CGFloat))progress
                  success:(void (^)(UserMe *))success
                  failure:(void (^)(NSInteger, NSString *))failure;

- (void)forgotPasswordWithUserEmail:(NSString *)user_email
                            success:(void (^)(NSString *))success
                            failure:(void (^)(NSString *))failure;

- (void)sendSMSToPhone:(NSString *)phone_number
      VerificationCode:(NSString *)verification_code
               success:(void (^)(NSString *))success
               failure:(void (^)(NSInteger, NSString *))failure;

- (void)updateUserWithUserId:(NSNumber *)user_id
                   FirstName:(NSString *)user_first_name
                    LastName:(NSString *)user_last_name
                 PhoneNumber:(NSString *)user_phone
                       Email:(NSString *)user_email
                   AvatarUrl:(NSString *)user_avatar_url
             UserAvatarImage:(UIImage *)user_avatar
                     success:(void (^)(UserObj *))success
                     failure:(void (^)(NSString *))failure
                    progress:(void (^)(double))progress;

- (void)changePassword:(NSNumber *)user_id
           CurrentPass:(NSString *)user_current_pass
               NewPass:(NSString *)user_new_pass
               success:(void (^)(NSString *))success
               failure:(void (^)(NSString *))failure;

- (void)logoutWithUserId:(NSNumber *)user_id
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *))failure;

- (void)getUserEvents:(NSNumber *)user_id
              success:(void (^)(NSArray *))success
              failure:(void (^)(NSString *))failure;

- (void)getUserInvitations:(NSNumber *)user_id
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSString *))failure;

- (void)getFamilyPassengers:(NSNumber *)user_family_id
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(NSString *))failure;

- (void)getUserWithId:(NSNumber *)user_id
              success:(void (^)(UserObj *))success
              failure:(void (^)(NSString *))failure;

#pragma mark - Adult APIs
- (void)addAdultWithUserId:(NSNumber *)adult_user_id
                 FirstName:(NSString *)adult_first_name
                  LastName:(NSString *)adult_last_name
                     Email:(NSString *)adult_email
                  Password:(NSString *)adult_pass
                   success:(void (^)(UserObj *))success
                   failure:(void (^)(NSString *))failure;

- (void)deleteAdultWithId:(NSNumber *)adult_id
                  success:(void (^)(NSString *))success
                  failure:(void (^)(NSString *))failure;

#pragma mark - Passenger APIs
- (void)addPassengerWithUserId:(NSNumber *)passenger_user_id
                      FamilyId:(NSNumber *)passenger_family_id
                     FirstName:(NSString *)passenger_first_name
                      LastName:(NSString *)passenger_last_name
                       success:(void (^)(PassengerObj *))success
                       failure:(void (^)(NSString *))failure;

- (void)updatePassengerWithUserId:(NSNumber *)passenger_user_id
                      PassengerId:(NSNumber *)passenger_id
                        FirstName:(NSString *)passenger_first_name
                         LastName:(NSString *)passenger_last_name
                          success:(void (^)(PassengerObj *))success
                          failure:(void (^)(NSString *))failure;

- (void)deletePassengerWithUserId:(NSNumber *)passenger_user_id
                      PassengerId:(NSNumber *)passenger_id
                          success:(void (^)(NSString *))success
                          failure:(void (^)(NSString *))failure;

#pragma mark - Event APIs
- (void)createEventWithEventObj:(EventObj *)objEvent
                        success:(void (^)(EventObj *))success
                        failure:(void (^)(NSString *))failure;

- (void)updateEventWithEventObj:(EventObj *)objEvent
                         UserId:(NSNumber *)user_id
                        success:(void (^)(NSString *))success
                        failure:(void (^)(NSString *))failure;

- (void)getEventWithId:(NSNumber *)event_id
               success:(void (^)(EventObj *))success
               failure:(void (^)(NSString *))failure;

- (void)deleteEventWithId:(NSNumber *)event_id
                   UserId:(NSNumber *)user_id
                  success:(void (^)(NSString *))success
                  failure:(void (^)(NSString *))failure;

#pragma mark - Invitation APIs
- (void)sendInvitationToDrivers:(NSArray *)aryContacts
                       ForEvent:(NSNumber *)event_id
                         succss:(void (^)(NSArray *))success
                        failure:(void (^)(NSString *))failure;

- (void)removeDriverWithInvitationId:(NSNumber *)invitation_id
                             success:(void (^)(NSString *))success
                             failure:(void (^)(NSString *))failure;

- (void)updateInvitationStatusWithId:(NSNumber *)invitation_id
                              Status:(DRIVER_STATUS)invitation_status
                             success:(void (^)(NSString *))success
                             failure:(void (^)(NSString *))failure;

#pragma mark - EventBlock APIs
- (void)addEventId:(NSNumber *)event_id
            UserId:(NSNumber *)user_id
            Driver:(EventDriverObj *)objEventDriver
           success:(void (^)(NSArray *))success
           failure:(void (^)(NSString *))failure;

- (void)addEventId:(NSNumber *)event_id
            UserId:(NSNumber *)user_id
            Detail:(EventDetailObj *)objEventDetail
           success:(void (^)(NSArray *))success
           failure:(void (^)(NSString *))failure;

@end
