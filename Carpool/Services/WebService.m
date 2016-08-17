//
//  WebService.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "WebService.h"
#import <AFNetworking/AFNetworking.h>

@implementation WebService

static WebService *_webService = nil;
AFHTTPSessionManager *manager;

+ (WebService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_webService == nil) {
            _webService = [[self alloc] init]; // assignment not done here
            
            manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"image/jpeg", nil];
        }
    });
    
    return _webService;
}

- (NSString *)getErrorMessageFromNSError:(NSError *)error {
    
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if(errorData && errorData.length > 0) {
        NSDictionary *dicError = [NSJSONSerialization JSONObjectWithData:errorData
                                                                 options:0
                                                                   error:nil];
        return dicError[SERVER_RESULT_MESSAGE];
    } else {
        return error.localizedDescription;
    }
}

- (NSInteger)getErrorCodeFromNSError:(NSError *)error {
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    return response.statusCode;
}

#pragma mark - User APIs
- (void)loginWithUserEmail:(NSString *)user_email
                  UserPass:(NSString *)user_pass
                   success:(void (^)(UserMe *))success
                   failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_email":          user_email,
                                    @"user_pass":           user_pass,
                                    @"user_device_token":   [GlobalService sharedInstance].user_device_token,
                                    @"user_device_type":    @"iOS",
                                    @"user_time_zone":      [[GlobalService sharedInstance] getUserTimeZone]
                                    };
        [manager GET:@"api/v1/users/login"
          parameters:dicParams
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 UserMe *objMe = [[UserMe alloc] initWithDictionary:responseObject];
                 success(objMe);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)signupWithUserObj:(UserObj *)objUser
                 progress:(void (^)(CGFloat))progress
                  success:(void (^)(UserMe *))success
                  failure:(void (^)(NSInteger, NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:objUser.currentDictionary];
        [dicUser addEntriesFromDictionary:@{
                                            @"user_device_token":   [GlobalService sharedInstance].user_device_token,
                                            @"user_device_type":    @"iOS",
                                            @"user_time_zone":      [[GlobalService sharedInstance] getUserTimeZone]
                                            }];
        
        
        [manager POST:@"api/v1/users"
           parameters:dicUser
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if(objUser.user_avatar_image) {
        [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(objUser.user_avatar_image, 0.5f)]
                                    name:@"avatar"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpeg"];
    }
}
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 progress(uploadProgress.fractionCompleted);
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  UserMe *objMe = [[UserMe alloc] initWithDictionary:responseObject];
                  success(objMe);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorCodeFromNSError:error], [self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(400, STRING_NO_INTERNET);
    }
}

- (void)forgotPasswordWithUserEmail:(NSString *)user_email
                            success:(void (^)(NSString *))success
                            failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_email":              user_email
                                    };
        
        [manager GET:@"api/v1/users/forgot/password"
          parameters:dicParams
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                 success(strResult);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)sendSMSToPhone:(NSString *)phone_number
      VerificationCode:(NSString *)verification_code
               success:(void (^)(NSString *))success
               failure:(void (^)(NSInteger, NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"phone_number":        phone_number,
                                    @"verification_code":   verification_code
                                    };
        
        [manager POST:@"api/v1/send/code"
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                  success(strResult);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorCodeFromNSError:error], [self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(400, STRING_NO_INTERNET);
    }
}

- (void)updateUserWithUserId:(NSNumber *)user_id
                   FirstName:(NSString *)user_first_name
                    LastName:(NSString *)user_last_name
                 PhoneNumber:(NSString *)user_phone
                       Email:(NSString *)user_email
                   AvatarUrl:(NSString *)user_avatar_url
             UserAvatarImage:(UIImage *)user_avatar
                     success:(void (^)(UserObj *))success
                     failure:(void (^)(NSString *))failure
                    progress:(void (^)(double))progress {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_first_name":    user_first_name,
                                    @"user_last_name":     user_last_name,
                                    @"user_email":         user_email,
                                    @"user_phone":         user_phone,
                                    @"user_avatar_url":    user_avatar_url
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        
        [manager POST:[NSString stringWithFormat:@"api/v1/users/%d", user_id.intValue]
           parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if(user_avatar) {
        [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(user_avatar, 0.5f)]
                                    name:@"avatar"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpeg"];
    }
}
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 if(progress) {
                     progress(uploadProgress.fractionCompleted);
                 }
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  UserObj *objUser = [[UserObj alloc] initWithDictionary:responseObject];
                  success(objUser);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)changePassword:(NSNumber *)user_id
           CurrentPass:(NSString *)user_current_pass
               NewPass:(NSString *)user_new_pass
               success:(void (^)(NSString *))success
               failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_current_pass":   user_current_pass,
                                    @"user_new_pass":       user_new_pass
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager PATCH:[NSString stringWithFormat:@"api/v1/users/%d/update/password", user_id.intValue]
            parameters:dicParams
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                   success(strResult);
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(error.localizedDescription);
               }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)logoutWithUserId:(NSNumber *)user_id
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager PATCH:[NSString stringWithFormat:@"api/v1/users/%d/logout", user_id.intValue]
            parameters:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                   success(strResult);
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure([self getErrorMessageFromNSError:error]);
               }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)getUserEvents:(NSNumber *)user_id
              success:(void (^)(NSArray *))success
              failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"api/v1/users/%d/events", user_id.intValue]
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSArray *aryDicEvents = (NSArray *)responseObject;
                 NSMutableArray *aryEvents = [[NSMutableArray alloc] init];
                 for(NSDictionary *dicEvent in aryDicEvents) {
                     EventObj *objEvent = [[EventObj alloc] initWithDictionary:dicEvent];
                     [aryEvents addObject:objEvent];
                 }
                 
                 success(aryEvents);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
        
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)getUserInvitations:(NSNumber *)user_id
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"api/v1/users/%d/invitations", user_id.intValue]
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSArray *aryDicInvitations = (NSArray *)responseObject;
                 NSMutableArray *aryInvitations = [[NSMutableArray alloc] init];
                 for(NSDictionary *dicInvitation in aryDicInvitations) {
                     EventObj *objEvent = [[EventObj alloc] initWithDictionary:dicInvitation];
                     [aryInvitations addObject:objEvent];
                 }
                 
                 success(aryInvitations);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)getFamilyPassengers:(NSNumber *)user_family_id
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"api/v1/users/%d/passengers", user_family_id.intValue]
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSArray *aryDicPassengers = (NSArray *)responseObject;
                 NSMutableArray *aryPassengers = [[NSMutableArray alloc] init];
                 for(NSDictionary *dicPassenger in aryDicPassengers) {
                     PassengerObj *objPassenger = [[PassengerObj alloc] initWithDictionary:dicPassenger];
                     [aryPassengers addObject:objPassenger];
                 }
                 
                 success(aryPassengers);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)getUserWithId:(NSNumber *)user_id
              success:(void (^)(UserObj *))success
              failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"api/v1/users/%d", user_id.intValue]
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicUser = (NSDictionary *)responseObject;
                 UserObj *objUser = [[UserObj alloc] initWithDictionary:dicUser];
                 
                 success(objUser);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

#pragma mark - Adult APIs
- (void)addAdultWithUserId:(NSNumber *)adult_user_id
                 FirstName:(NSString *)adult_first_name
                  LastName:(NSString *)adult_last_name
                     Email:(NSString *)adult_email
                  Password:(NSString *)adult_pass
                   success:(void (^)(UserObj *))success
                   failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"adult_family_id":     adult_user_id,
                                    @"adult_first_name":    adult_first_name,
                                    @"adult_last_name":     adult_last_name,
                                    @"adult_email":         adult_email,
                                    @"adult_pass":          adult_pass
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager POST:@"api/v1/adults"
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  UserObj *objAdult = [[UserObj alloc] initWithDictionary:responseObject];
                  success(objAdult);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)deleteAdultWithId:(NSNumber *)adult_id
                  success:(void (^)(NSString *))success
                  failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager DELETE:[NSString stringWithFormat:@"api/v1/adults/%d", adult_id.intValue]
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                    success(strResult);
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure([self getErrorMessageFromNSError:error]);
                }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

#pragma mark - Passenger APIs
- (void)addPassengerWithUserId:(NSNumber *)passenger_user_id
                      FamilyId:(NSNumber *)passenger_family_id
                     FirstName:(NSString *)passenger_first_name
                      LastName:(NSString *)passenger_last_name
                       success:(void (^)(PassengerObj *))success
                       failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"passenger_user_id":       passenger_user_id,
                                    @"passenger_family_id":     passenger_family_id,
                                    @"passenger_first_name":    passenger_first_name,
                                    @"passenger_last_name":     passenger_last_name
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager POST:@"api/v1/passengers"
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  PassengerObj *objPassenger = [[PassengerObj alloc] initWithDictionary:responseObject];
                  success(objPassenger);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
    
}

- (void)updatePassengerWithUserId:(NSNumber *)passenger_user_id
                      PassengerId:(NSNumber *)passenger_id
                        FirstName:(NSString *)passenger_first_name
                         LastName:(NSString *)passenger_last_name
                          success:(void (^)(PassengerObj *))success
                          failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSDictionary *dicParam = @{
                                   @"passenger_user_id":    passenger_user_id,
                                   @"passenger_first_name": passenger_first_name,
                                   @"passenger_last_name":  passenger_last_name
                                   };
        
        [manager PUT:[NSString stringWithFormat:@"api/v1/passengers/%d", passenger_id.intValue]
          parameters:dicParam
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 PassengerObj *objPassenger = [[PassengerObj alloc] initWithDictionary:responseObject];
                 success(objPassenger);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)deletePassengerWithUserId:(NSNumber *)passenger_user_id
                      PassengerId:(NSNumber *)passenger_id
                          success:(void (^)(NSString *))success
                          failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSDictionary *dicParam = @{
                                   @"passenger_user_id":    passenger_user_id
                                   };
        
        [manager DELETE:[NSString stringWithFormat:@"api/v1/passengers/%d", passenger_id.intValue]
             parameters:dicParam
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                    success(strResult);
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure([self getErrorMessageFromNSError:error]);
                }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

#pragma mark - Event APIs
- (void)createEventWithEventObj:(EventObj *)objEvent
                        success:(void (^)(EventObj *))success
                        failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager POST:@"api/v1/events"
           parameters:objEvent.currentDictionaryForWeb
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  EventObj *objEvent = [[EventObj alloc] initWithDictionary:responseObject];
                  success(objEvent);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)updateEventWithEventObj:(EventObj *)objEvent
                         UserId:(NSNumber *)user_id
                        success:(void (^)(NSString *))success
                        failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:objEvent.currentDictionaryForWeb];
        dicParams[@"user_id"] = user_id;
        
        [manager PUT:[NSString stringWithFormat:@"api/v1/events/%d", objEvent.event_id.intValue]
          parameters:dicParams
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                 success(strResult);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)getEventWithId:(NSNumber *)event_id
               success:(void (^)(EventObj *))success
               failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager GET:[NSString stringWithFormat:@"api/v1/events/%d", event_id.intValue]
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 EventObj *objEvent = [[EventObj alloc] initWithDictionary:responseObject];
                 success(objEvent);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure([self getErrorMessageFromNSError:error]);
             }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)deleteEventWithId:(NSNumber *)event_id
                   UserId:(NSNumber *)user_id
                  success:(void (^)(NSString *))success
                  failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSDictionary *dicParams = @{
                                    @"user_id": user_id
                                    };
        
        [manager DELETE:[NSString stringWithFormat:@"api/v1/events/%d", event_id.intValue]
             parameters:dicParams
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                    success(strResult);
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure([self getErrorMessageFromNSError:error]);
                }];
    } else {
        failure(STRING_NO_INTERNET);
    }
    
}

#pragma mark - Invitation APIs
- (void)sendInvitationToDrivers:(NSArray *)aryContacts
                       ForEvent:(NSNumber *)event_id
                         succss:(void (^)(NSArray *))success
                        failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aryContacts
                                                           options:0
                                                             error:&error];
        
        NSString *strJSONInvitations = @"";
        
        if (!jsonData) {
            NSLog(@"JSON error: %@", error);
        } else {
            strJSONInvitations = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        }
        
        NSDictionary *dicParams = @{
                                    @"invitation_event_id": event_id,
                                    @"invitations":         strJSONInvitations
                                    };
        
        [manager POST:@"api/v1/invitations"
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSArray *aryDicDrivers = (NSArray *)responseObject;
                  NSMutableArray *aryDrivers = [[NSMutableArray alloc] init];
                  for(NSDictionary *dicDriver in aryDicDrivers) {
                      DriverObj *objDriver = [[DriverObj alloc] initWithDictionary:dicDriver];
                      [aryDrivers addObject:objDriver];
                  }
                  success(aryDrivers);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)removeDriverWithInvitationId:(NSNumber *)invitation_id
                             success:(void (^)(NSString *))success
                             failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager DELETE:[NSString stringWithFormat:@"api/v1/invitations/%d", invitation_id.intValue]
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                    success(strResult);
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure([self getErrorMessageFromNSError:error]);
                }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)updateInvitationStatusWithId:(NSNumber *)invitation_id
                              Status:(DRIVER_STATUS)invitation_status
                             success:(void (^)(NSString *))success
                             failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager PATCH:[NSString stringWithFormat:@"api/v1/invitations/%d", invitation_id.intValue]
            parameters:@{@"invitation_status": [NSNumber numberWithInt:invitation_status]}
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSString *strResult = responseObject[SERVER_RESULT_MESSAGE];
                   success(strResult);
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure([self getErrorMessageFromNSError:error]);
               }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

#pragma mark - EventBlock APIs
- (void)addEventId:(NSNumber *)event_id
            UserId:(NSNumber *)user_id
            Driver:(EventDriverObj *)objEventDriver
           success:(void (^)(NSArray *))success
           failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:objEventDriver.currentDictionary];
        dicParams[@"event_user_id"] = user_id;
        
        [manager POST:[NSString stringWithFormat:@"api/v1/events/%d/driver", event_id.intValue]
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSArray *aryDicEventDrivers = (NSArray *)responseObject;
                  NSMutableArray *aryEventDrivers = [[NSMutableArray alloc] init];
                  for(NSDictionary *dicEventDriver in aryDicEventDrivers) {
                      EventDriverObj *objEventDriver = [[EventDriverObj alloc] initWithDictionary:dicEventDriver];
                      [aryEventDrivers addObject:objEventDriver];
                  }
                  success(aryEventDrivers);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

- (void)addEventId:(NSNumber *)event_id
            UserId:(NSNumber *)user_id
            Detail:(EventDetailObj *)objEventDetail
           success:(void (^)(NSArray *))success
           failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:objEventDetail.currentDictionary];
        dicParams[@"event_user_id"] = user_id;
        
        [manager POST:[NSString stringWithFormat:@"api/v1/events/%d/details", event_id.intValue]
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSArray *aryDicEventDetails = (NSArray *)responseObject;
                  NSMutableArray *aryEventDetails = [[NSMutableArray alloc] init];
                  for(NSDictionary *dicEventDetail in aryDicEventDetails) {
                      EventDetailObj *objEventDetail = [[EventDetailObj alloc] initWithDictionary:dicEventDetail];
                      [aryEventDetails addObject:objEventDetail];
                  }
                  success(aryEventDetails);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure([self getErrorMessageFromNSError:error]);
              }];
    } else {
        failure(STRING_NO_INTERNET);
    }
}

@end
