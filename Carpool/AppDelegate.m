//
//  AppDelegate.m
//  Carpool
//
//  Created by JH Lee on 4/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <OneSignal/OneSignal.h>
#import "ContactUserObj.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //SVProgressHUD config
    [SVProgressHUD setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#f0f0f0"]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //Toast config
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f0f0f0"];
    style.titleColor = [UIColor hx_colorWithHexRGBAString:@"#4F443C"];
    style.messageColor = [UIColor hx_colorWithHexRGBAString:@"#4F443C"];
    [CSToastManager setSharedStyle:style];
    
    //MKStoreKit config
    [[MKStoreKit sharedKit] startProductRequest];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      NSLog(@"%@", [[MKStoreKit sharedKit] availableProducts]);
                                                  }];
    
    [GlobalService sharedInstance].app_delegate = self;
    
    //load saved user object
    UserMe *objMe = [[GlobalService sharedInstance] loadMe];
    if(objMe) {
        [GlobalService sharedInstance].user_me = objMe;
        [self startApplication:NO];
    }
    
    OneSignal *oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
                                                              appId:ONESIGNAL_APP_ID
                                                 handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
                                                     NSLog(@"OneSignal Notification opened:\nMessage: %@", message);
                                                     [JDStatusBarNotification showWithStatus:message
                                                                                dismissAfter:5.f
                                                                                   styleName:JDStatusBarStyleSuccess];
                                                     
                                                     if (additionalData) {
                                                         [self actionWithNotification:additionalData];
                                                     }
                                                 }];
    
    [oneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
        NSLog(@"UserId:%@", userId);
        [GlobalService sharedInstance].user_device_token = userId;
    }];
    
    [self checkReachability];
    
    return YES;
}

- (void)actionWithNotification:(NSDictionary *)dicNotification {
    NOTIFICATION_TYPE noti_type = [dicNotification[@"noti_type"] intValue];
    NSNumber *noti_id = [NSNumber numberWithInt:[dicNotification[@"noti_id"] intValue]];
    
    switch (noti_type) {
        case CARPOOL_PUSH_SEND_INVITATION:
            [[WebService sharedInstance] getEventWithId:noti_id
                                                success:^(EventObj *objEvent) {
                                                    [[GlobalService sharedInstance].user_me addInvitation:objEvent];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT
                                                                                                        object:nil];
                                                }
                                                failure:^(NSString *strError) {
                                                    NSLog(@"%@", strError);
                                                }];
            
            break;
            
        case CARPOOL_PUSH_INVITATION_ACCEPT:
        case CARPOOL_PUSH_INVITATION_REJECT:
        case CARPOOL_PUSH_UPDATE_EVENT:
            [[WebService sharedInstance] getEventWithId:noti_id
                                                success:^(EventObj *objEvent) {
                                                    [[GlobalService sharedInstance].user_me updateEvent:objEvent];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_EVENT
                                                                                                        object:nil];
                                                }
                                                failure:^(NSString *strError) {
                                                    NSLog(@"%@", strError);
                                                }];
            
            break;
            
        case CARPOOL_PUSH_REMOVE_DRIVER:
        case CARPOOL_PUSH_REMOVE_EVENT:
            [[GlobalService sharedInstance].user_me removeEvent:noti_id];
            break;
            
        case CARPOOL_PUSH_UPDATE_PROFILE:
        {
            [[WebService sharedInstance] getUserWithId:noti_id
                                               success:^(UserObj *objUser) {
                                                   [[GlobalService sharedInstance].user_me updateDriverProfile:objUser];
                                               }
                                               failure:^(NSString *strError) {
                                                   NSLog(@"%@", strError);
                                               }];
            break;
        }
            
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self getAllContacts];
    //update user events and invitations
    if([GlobalService sharedInstance].user_me) {
        [[WebService sharedInstance] getUserEvents:[GlobalService sharedInstance].my_user_id
                                           success:^(NSArray *aryEvents) {
                                               NSLog(@"Update User Events");
                                               [[GlobalService sharedInstance].user_me updateEvents:aryEvents];
                                           }
                                           failure:^(NSString *strError) {
                                               NSLog(@"%@", strError);
                                           }];
        
        [[WebService sharedInstance] getUserInvitations:[GlobalService sharedInstance].my_user_id
                                                success:^(NSArray *aryInvitations) {
                                                    NSLog(@"Update User Invitations");
                                                    [[GlobalService sharedInstance].user_me updateInvitations:aryInvitations];
                                                }
                                                failure:^(NSString *strError) {
                                                    NSLog(@"%@", strError);
                                                }];
        
        [[WebService sharedInstance] getFamilyPassengers:[GlobalService sharedInstance].user_me.my_user.user_family_id
                                                 success:^(NSArray *aryPassengers) {
                                                     NSLog(@"Update Family Passengers");
                                                     [[GlobalService sharedInstance].user_me updatePassengers:aryPassengers];
                                                 }
                                                 failure:^(NSString *strError) {
                                                     NSLog(@"%@", strError);
                                                 }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if([GlobalService sharedInstance].user_me
       && [sourceApplication isEqualToString:@"com.apple.mobilecal"]) {
        NSArray *aryUrls = [url.absoluteString componentsSeparatedByString:@"/"];
        NSDate *displayDate = [[GlobalService sharedInstance] dateFromString:aryUrls[aryUrls.count - 1] withFormat:@"yyyy-MM-dd"];
        NSNumber *event_id = [NSNumber numberWithInt:[aryUrls[aryUrls.count - 2] intValue]];
        
        EventObj *objEvent = [[GlobalService sharedInstance].user_me getEventById:event_id];
        
        if(objEvent) {
            EventDetailObj *objEventDetailObj = [[GlobalService sharedInstance] getEventDetailFromEvent:objEvent onDate:displayDate];
            JHEvent *jhEvent = [[GlobalService sharedInstance] getJHEventFromEventObj:objEvent
                                                                          displayDate:displayDate
                                                                       EventDetailObj:objEventDetailObj];
            
            [GlobalService sharedInstance].tabbar_vc.m_eventDayVC.m_jhEvent = jhEvent;

            UINavigationController *calendarNC = (UINavigationController *)[GlobalService sharedInstance].tabbar_vc.viewControllers[0];
            [calendarNC popToRootViewControllerAnimated:NO];
            [GlobalService sharedInstance].tabbar_vc.selectedIndex = 0;
        }
    }
    return YES;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dmsoft.Carpool" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Carpool" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Carpool.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Custom Methods
- (void)startApplication:(BOOL)animated {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    UIViewController *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    [navController pushViewController:menuVC animated:animated];
}

- (void)checkReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [JDStatusBarNotification showWithStatus:STRING_NO_INTERNET
                                              styleName:JDStatusBarStyleError];
                [GlobalService sharedInstance].is_internet_alive = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [JDStatusBarNotification dismissAnimated:YES];
                [GlobalService sharedInstance].is_internet_alive = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [JDStatusBarNotification dismissAnimated:YES];
                [GlobalService sharedInstance].is_internet_alive = YES;
                break;
                
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) getAllContacts {
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                [self getAllContacts];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                NSLog(@"Access Denied");
            }
        });
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        if (addressBook != nil) {
            
            NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            NSMutableArray *aryContacts = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [allContacts count]; i++) {
                
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                
                NSInteger record_id = ABRecordGetRecordID(contactPerson);
                UIImage *avatar = nil;
                if(ABPersonHasImageData(contactPerson)) {
                    avatar = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail)];
                }
                
                // to set contact name
                NSString *firstName = (__bridge NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName =  (__bridge NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                
                if (lastName == nil || [lastName isEqual:[NSNull null]]) {
                    lastName = @"";
                }
                if (firstName == nil || [firstName isEqual:[NSNull null]]) {
                    firstName = @"";
                }
                
                if ([firstName isEqualToString:@""] && [lastName isEqualToString:@""]) {
                    firstName = @"No Name";
                }
                
                //get Phone Numbers
                ABMultiValueRef multiPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
                    
                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multiPhones, i);
                    NSString *phoneLabel = (__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
                    
                    NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NBPhoneNumber *number = [[NBPhoneNumberUtil sharedInstance] parse:phoneNumber
                                                                        defaultRegion:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
                                                                                error:nil];
                    if([[NBPhoneNumberUtil sharedInstance] isValidNumber:number]) {
                        phoneNumber = [[NBPhoneNumberUtil sharedInstance] format:number
                                                                    numberFormat:NBEPhoneNumberFormatINTERNATIONAL
                                                                           error:nil];
                        [aryContacts addObject:[[ContactUserObj alloc] initWithId:record_id
                                                                           Avatar:avatar
                                                                        FirstName:firstName
                                                                         LastName:lastName
                                                                       PhoneLocal:phoneLabel
                                                                      PhoneNumber:phoneNumber]];
                    }
                }
            }
            
            [GlobalService sharedInstance].user_contacts = [aryContacts copy];
        }
    } else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        
        NSLog(@"Cannot fetch Contacts :( ");
    }
    
    CFRelease(addressBook);
}

@end
