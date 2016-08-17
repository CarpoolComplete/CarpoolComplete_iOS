//
//  EventDetailViewController.m
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventEditViewController.h"
#import "PassengerTableViewCell.h"
#import "ChatViewController.h"
#import "AddPassengersViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryPassengers = self.m_jhEvent.event_userInfo[@"event_passengers"];
    m_objEvent = [[GlobalService sharedInstance] getEventObjFromJHEvent:self.m_jhEvent];
    
    m_toDriverId = self.m_jhEvent.event_userInfo[@"event_to_driver_id"];
    m_fromDriverId = self.m_jhEvent.event_userInfo[@"event_from_driver_id"];
    
    m_objEventDetail = [[EventDetailObj alloc] initEventStartAt:self.m_jhEvent.event_start_at
                                                          EndAt:self.m_jhEvent.event_end_at
                                                     Passengers:m_aryPassengers
                                                      AlertTime:self.m_jhEvent.event_userInfo[@"event_alert_time"]
                                                     DetailType:EVENT_DETAIL_ALL
                                                     DetailDate:self.m_jhEvent.event_display_at];
    
    if(self.m_jhEvent.event_user_id.intValue != [GlobalService sharedInstance].my_user_id.intValue) {   // if not my created event
        self.m_btnEdit.hidden = YES;
    }
    
    self.m_lblTitle.text = [[GlobalService sharedInstance] stringFromDate:self.m_jhEvent.event_display_at
                                                               withFormat:@"EEE MMM dd"];
    
    self.m_lblToEventName.text = [NSString stringWithFormat:@"To %@", self.m_jhEvent.event_title];
    self.m_lblEventStartTime.text = self.m_jhEvent.eventStartTime;
    self.m_lblFromEventName.text = [NSString stringWithFormat:@"From %@", self.m_jhEvent.event_title];
    self.m_lblEventEndTime.text = self.m_jhEvent.eventEndTime;
    
    if(m_toDriverId.intValue > 0) {
        if(m_toDriverId.intValue == m_objEvent.event_user_id.integerValue) {
            self.m_lblToDriverName.text = [NSString stringWithFormat:@"Driver: %@", m_objEvent.creatorFullName];
        } else {
            for(int nIndex = 0; nIndex < m_objEvent.event_drivers.count; nIndex++) {
                DriverObj *objDriver = m_objEvent.event_drivers[nIndex];
                if(objDriver.driver_user_id.intValue == m_toDriverId.intValue) {
                    self.m_lblToDriverName.text = [NSString stringWithFormat:@"Driver: %@", objDriver.fullName];
                    break;
                }
            }
        }
    } else {
        self.m_lblToDriverName.text = @"Driver Needed";
        self.m_lblToDriverName.textColor = [UIColor redColor];
    }
    
    if(m_fromDriverId.intValue > 0) {
        if(m_fromDriverId.intValue == m_objEvent.event_user_id.integerValue) {
            self.m_lblFromDriverName.text = [NSString stringWithFormat:@"Driver: %@", m_objEvent.creatorFullName];
        } else {
            for(int nIndex = 0; nIndex < m_objEvent.event_drivers.count; nIndex++) {
                DriverObj *objDriver = m_objEvent.event_drivers[nIndex];
                if(objDriver.driver_user_id.intValue == m_fromDriverId.intValue) {
                    self.m_lblFromDriverName.text = [NSString stringWithFormat:@"Driver: %@", objDriver.fullName];
                    break;
                }
            }
        }
    } else {
        self.m_lblFromDriverName.text = @"Driver Needed";
        self.m_lblFromDriverName.textColor = [UIColor redColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onClickBtnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnEdit:(id)sender {
    EventEditViewController *eventEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventEditViewController"];
    eventEditVC.m_objEvent = m_objEvent;
    eventEditVC.m_objEventDetail = m_objEventDetail;
    [self.navigationController pushViewController:eventEditVC animated:YES];
}

- (IBAction)onClickBtnAddPassengers:(id)sender {
    m_eventPassengerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventPassengerViewController"];
    m_eventPassengerVC.m_aryPassengers = m_aryPassengers;
    m_eventPassengerVC.delegate = self;
    [self addChildViewController:m_eventPassengerVC];
    [self.view addSubview:m_eventPassengerVC.view];
}

- (IBAction)onClickBtnDeleteEvent:(id)sender {
    if(m_objEvent.event_user_id.intValue == [GlobalService sharedInstance].my_user_id.intValue) {   // event owner
        if(m_objEvent.event_repeat_type == EVENT_REPEAT_NONE) {
            UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *btnDelete = [UIAlertAction actionWithTitle:@"Delete Event"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  SVPROGRESSHUD_PLEASE_WAIT;
                                                                  [[WebService sharedInstance] deleteEventWithId:m_objEvent.event_id
                                                                                                          UserId:[GlobalService sharedInstance].my_user_id
                                                                                                         success:^(NSString *strResult) {
                                                                                                             SVPROGRESSHUD_DISMISS;
                                                                                                             [[GlobalService sharedInstance].user_me removeEvent:m_objEvent.event_id];
                                                                                                             [self.navigationController popViewControllerAnimated:YES];
                                                                                                         }
                                                                                                         failure:^(NSString *strError) {
                                                                                                             SVPROGRESSHUD_ERROR(strError);
                                                                                                         }];
                                                              }];
            UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil];
            
            [sheet addAction:btnDelete];
            [sheet addAction:btnCancel];
            
            UIPopoverPresentationController *popPresenter = [sheet popoverPresentationController];
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
            
            [self presentViewController:sheet animated:YES completion:nil];
        } else {
            UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"This is a recurring event."
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *btnDeleteEvent = [UIAlertAction actionWithTitle:@"Delete This Event Only"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       if(m_objEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {
                                                                           [m_objEvent.event_custom_repeat_dates removeObject:[[GlobalService sharedInstance] stringFromDate:self.m_jhEvent.event_display_at
                                                                                                                                                                  withFormat:@"yyyy-MM-dd"]];
                                                                       } else {
                                                                           [m_objEvent.event_deleted_dates addObject:[[GlobalService sharedInstance] stringFromDate:self.m_jhEvent.event_display_at
                                                                                                                                                         withFormat:@"yyyy-MM-dd"]];
                                                                       }
                                                                       
                                                                       [self updateEvent];
                                                                   }];
            
            UIAlertAction *btnDeleteAllEvents = [UIAlertAction actionWithTitle:@"Delete All Future Events"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction *action) {
                                                                           NSDate *beforeDay = [self.m_jhEvent.event_display_at dateByAddingDays:-1];
                                                                           m_objEvent.event_repeat_end_at = beforeDay;
                                                                           
                                                                           if(m_objEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {
                                                                               NSString *strDisplayAt = [[GlobalService sharedInstance] stringFromDate:self.m_jhEvent.event_display_at
                                                                                                                                            withFormat:@"yyyy-MM-dd"];
                                                                               for(int nIndex = 0; nIndex < m_objEvent.event_custom_repeat_dates.count; nIndex++) {
                                                                                   NSString *strCustomDate = m_objEvent.event_custom_repeat_dates[nIndex];
                                                                                   if([strCustomDate compare:strDisplayAt] != NSOrderedAscending) {
                                                                                       [m_objEvent.event_custom_repeat_dates removeObject:strCustomDate];
                                                                                       nIndex--;
                                                                                   }
                                                                               }
                                                                           }
                                                                           [self updateEvent];
                                                                       }];
            
            UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil];
            
            [sheet addAction:btnDeleteEvent];
            [sheet addAction:btnDeleteAllEvents];
            [sheet addAction:btnCancel];
            
            UIPopoverPresentationController *popPresenter = [sheet popoverPresentationController];
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
            
            [self presentViewController:sheet animated:YES completion:nil];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:APP_NAME
                                    message:@"You cannot delete this event. However, if you dont want to be part of this event, you can decline it from Invite section"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
}

- (void)updateEvent {
    if(m_objEvent.isValidEvent) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] updateEventWithEventObj:m_objEvent
                                                      UserId:[GlobalService sharedInstance].my_user_id
                                                     success:^(NSString *strResult) {
                                                         SVPROGRESSHUD_DISMISS;
                                                         [[GlobalService sharedInstance].user_me updateEvent:m_objEvent];
                                                         [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                     failure:^(NSString *strError) {
                                                         SVPROGRESSHUD_ERROR(strError);
                                                     }];
    } else {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] deleteEventWithId:m_objEvent.event_id
                                                UserId:[GlobalService sharedInstance].my_user_id
                                               success:^(NSString *strResult) {
                                                   SVPROGRESSHUD_DISMISS;
                                                   [[GlobalService sharedInstance].user_me removeEvent:m_objEvent.event_id];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                               failure:^(NSString *strError) {
                                                   SVPROGRESSHUD_ERROR(strError);
                                               }];
    }
}

- (IBAction)onClickBtnChat:(id)sender {
    ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatVC.selected_event = m_objEvent;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)onTapToDriverName:(id)sender {
    if(m_toDriverId.intValue == 0) {
        self.m_lblToDriverName.text = [NSString stringWithFormat:@"Driver: %@", [GlobalService sharedInstance].user_me.my_user.fullName];
        self.m_lblToDriverName.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        m_toDriverId = [GlobalService sharedInstance].my_user_id;
        [self updateDriver:[GlobalService sharedInstance].my_user_id isTo:YES];
    } else {
        self.m_lblToDriverName.text = @"Driver Needed";
        self.m_lblToDriverName.textColor = [UIColor redColor];
        
        m_toDriverId = @0;
        [self updateDriver:@0 isTo:YES];
    }
}

- (IBAction)onTapFromDriverName:(id)sender {
    if(m_fromDriverId.intValue == 0) {
        self.m_lblFromDriverName.text = [NSString stringWithFormat:@"Driver: %@", [GlobalService sharedInstance].user_me.my_user.fullName];
        self.m_lblFromDriverName.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        m_fromDriverId = [GlobalService sharedInstance].my_user_id;
        [self updateDriver:[GlobalService sharedInstance].my_user_id isTo:NO];
    } else {
        self.m_lblFromDriverName.text = @"Driver Needed";
        self.m_lblFromDriverName.textColor = [UIColor redColor];
        
        m_fromDriverId = @0;
        [self updateDriver:@0 isTo:NO];
    }
}

- (void)updateDriver:(NSNumber *)driver_id isTo:(BOOL)isTo {    
    if(m_objEvent) {
        EventDriverObj *objEventDriver = [[EventDriverObj alloc] initWithDriverId:driver_id
                                                                       IsToDriver:isTo
                                                                       DriverDate:self.m_jhEvent.event_display_at];
        [[WebService sharedInstance] addEventId:m_objEvent.event_id
                                         UserId:[GlobalService sharedInstance].my_user_id
                                         Driver:objEventDriver
                                        success:^(NSArray *aryEventDrivers) {
                                            [m_objEvent.event_block_drivers setArray:aryEventDrivers];
                                            [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                        }
                                        failure:^(NSString *strError) {
                                            NSLog(@"%@", strError);
                                        }];
    }
}

#pragma mark - TableView DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.m_tblToPassenger) {
        return m_aryPassengers.count;
    } else {
        return m_aryPassengers.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblToPassenger) {
        PassengerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToPassengerTableViewCell"];
        cell.m_lblName.text = m_aryPassengers[indexPath.row];
        return cell;
    } else {
        PassengerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FromPassengerTableViewCell"];
        cell.m_lblName.text = m_aryPassengers[indexPath.row];
        return cell;
    }
}

#pragma mark - EventPassengerViewControllerDelegate

- (void)onClickPassengerAlertDone {
    m_objEventDetail.event_detail_passengers = m_aryPassengers;
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Update Passengers"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *btnUpdateEvent = [UIAlertAction actionWithTitle:@"For This Event Only"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               m_objEventDetail.event_detail_type = EVENT_DETAIL_THIS_ONLY;
                                                               [self updateDetail:m_objEventDetail];
                                                           }];
    
    UIAlertAction *btnUpdateFutureEvents = [UIAlertAction actionWithTitle:@"For This and Future Events"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      m_objEventDetail.event_detail_type = EVENT_DETAIL_FUTURE;
                                                                      [self updateDetail:m_objEventDetail];
                                                                  }];
    
    UIAlertAction *btnUpdateAllEvents = [UIAlertAction actionWithTitle:@"For All Events"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   m_objEventDetail.event_detail_type = EVENT_DETAIL_ALL;
                                                                   m_objEventDetail.event_detail_date = m_objEvent.event_repeat_start_at;
                                                                   [self updateDetail:m_objEventDetail];
                                                               }];
    
    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    
    [sheet addAction:btnUpdateEvent];
    [sheet addAction:btnUpdateFutureEvents];
    [sheet addAction:btnUpdateAllEvents];
    [sheet addAction:btnCancel];
    
    UIPopoverPresentationController *popPresenter = [sheet popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
    
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)updateDetail:(EventDetailObj *)objEventDetail {
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] addEventId:m_objEvent.event_id
                                     UserId:[GlobalService sharedInstance].my_user_id
                                     Detail:objEventDetail
                                    success:^(NSArray *aryEventDetails) {
                                        SVPROGRESSHUD_DISMISS;
                                        [m_objEvent.event_block_details setArray:aryEventDetails];
                                        [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                        
                                        [m_eventPassengerVC.view removeFromSuperview];
                                        [m_eventPassengerVC removeFromParentViewController];
                                        
                                        [self.m_tblToPassenger reloadData];
                                        [self.m_tblFromPassenger reloadData];
                                    }
                                    failure:^(NSString *strError) {
                                        SVPROGRESSHUD_ERROR(strError);
                                    }];
}

- (void)onClickPassengerAlertCancel {
    [m_eventPassengerVC.view removeFromSuperview];
    [m_eventPassengerVC removeFromParentViewController];
}

@end
