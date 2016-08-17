
//  EventEditViewController.m
//  Carpool
//
//  Created by JH Lee on 4/23/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventEditViewController.h"
#import "ChooseAlertViewController.h"
#import "InviteDriverViewController.h"
#import "RemoveDriverViewController.h"
#import "AddPassengersViewController.h"
#import "EventAddChildViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>

@interface EventEditViewController ()

@end

@implementation EventEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempEvent = [[EventObj alloc] initWithEventObj:self.m_objEvent];
    tempEventDetail = [[EventDetailObj alloc] initWithEventDetailObj:self.m_objEventDetail];
    
    [GlobalService sharedInstance].push_start_vc = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initViews];
}

- (void)initViews {
    self.m_txtEventTitle.text = tempEvent.event_title;
    
    NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:[GlobalService sharedInstance].active_date withFormat:@"dd MMMM EEEE"];
    NSArray *aryStartDateComponents = [strStartDate componentsSeparatedByString:@" "];
    self.m_lblStartDate.text = aryStartDateComponents[0];
    self.m_lblStartWeek.text = [NSString stringWithFormat:@"%@\n%@", aryStartDateComponents[1], aryStartDateComponents[2]];
    self.m_lblStartTime.text = [[GlobalService sharedInstance] stringFromDate:tempEventDetail.event_detail_start_at withFormat:@"h:mm a"];
    
    NSString *strEndDate = [[GlobalService sharedInstance] stringFromDate:[GlobalService sharedInstance].active_date withFormat:@"dd MMMM EEEE"];
    NSArray *aryEndDateComponents = [strEndDate componentsSeparatedByString:@" "];
    self.m_lblEndDate.text = aryEndDateComponents[0];
    self.m_lblEndWeek.text = [NSString stringWithFormat:@"%@\n%@", aryEndDateComponents[1], aryEndDateComponents[2]];
    self.m_lblEndTime.text = [[GlobalService sharedInstance] stringFromDate:tempEventDetail.event_detail_end_at withFormat:@"h:mm a"];
    
    NSMutableString *strPassengers = [[NSMutableString alloc] init];
    for(NSString *strPassenger in tempEventDetail.event_detail_passengers) {
        [strPassengers appendString:[NSString stringWithFormat:@"%@,", strPassenger]];
    }
    if(strPassengers.length > 0) {
        strPassengers = [NSMutableString stringWithString:[strPassengers substringToIndex:strPassengers.length - 1]];
    }
    self.m_lblPassengers.text = strPassengers;
    
    self.m_lblRepeats.text = tempEvent.eventRepeatTypeString;
    self.m_lblAlerts.text = tempEventDetail.alertString;
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

- (void)hideKeyboards {
    [self.m_txtEventTitle resignFirstResponder];
}

- (IBAction)onClickBtnInviteDrivers:(id)sender {
    [self hideKeyboards];
    
    InviteDriverViewController *inviteDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteDriverViewController"];
    inviteDriverVC.selected_event = self.m_objEvent;
    [self.navigationController pushViewController:inviteDriverVC animated:YES];
}

- (IBAction)onClickBtnRemoveDrivers:(id)sender {
    [self hideKeyboards];
    
    RemoveDriverViewController *removeDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemoveDriverViewController"];
    removeDriverVC.selected_event = self.m_objEvent;
    [self.navigationController pushViewController:removeDriverVC animated:YES];
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnDone:(id)sender {
    [self hideKeyboards];
    
    if(self.m_txtEventTitle.text.length == 0) {
        [self.view makeToast:TOAST_NO_EVENT_TITLE duration:1.f position:CSToastPositionCenter];
        return;
    }
    
    tempEvent.event_title = self.m_txtEventTitle.text;
    
    if(![self.m_objEvent compareWithEventObj:tempEvent]
       || ![self.m_objEventDetail compareWithEventDetailObj:tempEventDetail]) {  // no changes
        BOOL existOtherDriver = NO;
        for(EventDriverObj *objEventDriver in tempEvent.event_block_drivers) {
            if(objEventDriver.event_driver_driver_id.intValue > 0
               && objEventDriver.event_driver_driver_id.intValue != [GlobalService sharedInstance].my_user_id.intValue) {
                existOtherDriver = YES;
                break;
            }
        }
        
        if(existOtherDriver) {
            [[[UIAlertView alloc] initWithTitle:APP_NAME
                                        message:@"If you choose to make this change, the previously selected driving assignments will be removed. Continue?"
                                       delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Yes", nil] show];
        } else {
            [self updateEvent];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)updateEvent {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Update Event"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if([self.m_objEvent compareWithEventObj:tempEvent]) {
        UIAlertAction *btnUpdateEvent = [UIAlertAction actionWithTitle:@"Save for this event only"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   tempEventDetail.event_detail_type = EVENT_DETAIL_THIS_ONLY;
                                                                   tempEventDetail.event_detail_date = [GlobalService sharedInstance].active_date;
                                                                   [self updateDetail:tempEventDetail];
                                                               }];
        [sheet addAction:btnUpdateEvent];
    }
    
    UIAlertAction *btnUpdateFutureEvents = [UIAlertAction actionWithTitle:@"Save for future events"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      tempEventDetail.event_detail_type = EVENT_DETAIL_FUTURE;
                                                                      tempEventDetail.event_detail_date = [GlobalService sharedInstance].active_date;
                                                                      if([self.m_objEvent compareWithEventObj:tempEvent]) {
                                                                          [self updateDetail:tempEventDetail];
                                                                      } else {
                                                                          SVPROGRESSHUD_PLEASE_WAIT;
                                                                          [[WebService sharedInstance] updateEventWithEventObj:tempEvent
                                                                                                                        UserId:[GlobalService sharedInstance].my_user_id
                                                                                                                       success:^(NSString *strResult) {
                                                                                                                           SVPROGRESSHUD_DISMISS;
                                                                                                                           self.m_objEvent = tempEvent;
                                                                                                                           [self updateDetail:tempEventDetail];
                                                                                                                       }
                                                                                                                       failure:^(NSString *strError) {
                                                                                                                           SVPROGRESSHUD_DISMISS;
                                                                                                                           [self updateDetail:tempEventDetail];
                                                                                                                       }];
                                                                      }
                                                                  }];
    
    UIAlertAction *btnUpdateAllEvents = [UIAlertAction actionWithTitle:@"Save for all events"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   tempEventDetail.event_detail_type = EVENT_DETAIL_ALL;
                                                                   tempEventDetail.event_detail_date = [GlobalService sharedInstance].active_date;
                                                                   if([self.m_objEvent compareWithEventObj:tempEvent]) {
                                                                       [self updateDetail:tempEventDetail];
                                                                   } else {
                                                                       SVPROGRESSHUD_PLEASE_WAIT;
                                                                       [[WebService sharedInstance] updateEventWithEventObj:tempEvent
                                                                                                                     UserId:[GlobalService sharedInstance].my_user_id
                                                                                                                    success:^(NSString *strResult) {
                                                                                                                        SVPROGRESSHUD_DISMISS;
                                                                                                                        self.m_objEvent = tempEvent;
                                                                                                                        [self updateDetail:tempEventDetail];
                                                                                                                    }
                                                                                                                    failure:^(NSString *strError) {
                                                                                                                        SVPROGRESSHUD_DISMISS;
                                                                                                                        [self updateDetail:tempEventDetail];
                                                                                                                    }];
                                                                   }
                                                               }];
    
    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    
    [sheet addAction:btnUpdateFutureEvents];
    [sheet addAction:btnUpdateAllEvents];
    [sheet addAction:btnCancel];
    
    UIPopoverPresentationController *popPresenter = [sheet popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
    
    [self presentViewController:sheet animated:YES completion:nil];
}

- (IBAction)onTapStartTime:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    [self hideKeyboards];
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                                  datePickerMode:UIDatePickerModeTime
                                                                    selectedDate:tempEventDetail.event_detail_start_at
                                                                       doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                                                                           tempEventDetail.event_detail_start_at = selectedDate;
                                                                           if([selectedDate compare:tempEventDetail.event_detail_end_at] != NSOrderedAscending) {
                                                                               tempEventDetail.event_detail_end_at = [selectedDate dateByAddingHours:1];
                                                                           }
                                                                           
                                                                           [self initViews];
                                                                       }
                                                                     cancelBlock:nil
                                                                          origin:tap.view];
    picker.minuteInterval = 5;
    [picker showActionSheetPicker];
}

- (IBAction)onTapEndTime:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self hideKeyboards];
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                                  datePickerMode:UIDatePickerModeTime
                                                                    selectedDate:tempEventDetail.event_detail_end_at
                                                                       doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                                           tempEventDetail.event_detail_end_at = selectedDate;
                                                                           [self initViews];
                                                                       }
                                                                     cancelBlock:nil
                                                                          origin:tap.view];
    picker.minuteInterval = 5;
    picker.minimumDate = tempEventDetail.event_detail_start_at;
    [picker showActionSheetPicker];
}

- (IBAction)onTapRepeats:(id)sender {
    [self hideKeyboards];
    
    ChooseRepeatViewController *chooseRepeatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseRepeatViewController"];
    chooseRepeatVC.selected_event = tempEvent;
    [self.navigationController pushViewController:chooseRepeatVC animated:YES];
}

- (IBAction)onTapAlerts:(id)sender {
    [self hideKeyboards];
    
    ChooseAlertViewController *chooseAlertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAlertViewController"];
    chooseAlertVC.selected_event_detail = tempEventDetail;
    [self.navigationController pushViewController:chooseAlertVC animated:YES];
}

- (IBAction)onTapPassengers:(id)sender {
    [self hideKeyboards];
    
    if([GlobalService sharedInstance].user_me.my_passengers.count == 0) {
        EventAddChildViewController *eventAddChildVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventAddChildViewController"];
        eventAddChildVC.m_aryPassengers = tempEventDetail.event_detail_passengers;
        [self.navigationController pushViewController:eventAddChildVC animated:YES];
    } else {
        AddPassengersViewController *addPassengersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPassengersViewController"];
        addPassengersVC.m_aryPassengers = tempEventDetail.event_detail_passengers;
        [self.navigationController pushViewController:addPassengersVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    tempEvent.event_title = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    tempEvent.event_title = textField.text;
}

- (void)updateDetail:(EventDetailObj *)objEventDetail {
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] addEventId:self.m_objEvent.event_id
                                     UserId:[GlobalService sharedInstance].my_user_id
                                     Detail:objEventDetail
                                    success:^(NSArray *aryEventDetails) {
                                        [[WebService sharedInstance] getEventWithId:self.m_objEvent.event_id
                                                                            success:^(EventObj *objEvent) {
                                                                                SVPROGRESSHUD_DISMISS;
                                                                                [[GlobalService sharedInstance].user_me updateEvent:objEvent];
                                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                                            }
                                                                            failure:^(NSString *strError) {
                                                                                SVPROGRESSHUD_ERROR(strError);
                                                                            }];
                                    }
                                    failure:^(NSString *strError) {
                                        SVPROGRESSHUD_ERROR(strError);
                                    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self updateEvent];
    }
}

@end
