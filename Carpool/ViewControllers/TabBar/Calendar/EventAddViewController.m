//
//  EventAddViewController.m
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventAddViewController.h"
#import "ChooseAlertViewController.h"
#import "AddPassengersViewController.h"
#import "EventAddChildViewController.h"
#import "InviteDriverViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>

@interface EventAddViewController ()

@end

@implementation EventAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_objEvent = [[EventObj alloc] init];
    self.m_objEvent.event_user_id = [GlobalService sharedInstance].my_user_id;
    self.m_objEvent.event_repeat_start_at = self.m_objEventDetail.event_detail_start_at;
    self.m_objEvent.event_repeat_end_at = self.m_objEventDetail.event_detail_start_at;
    
    [GlobalService sharedInstance].push_start_vc = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initViews];
}

- (void)initViews {
    self.m_txtEventTitle.text = self.m_objEvent.event_title;
    
    NSString *strStartDate = [[GlobalService sharedInstance] stringFromDate:self.m_objEventDetail.event_detail_start_at withFormat:@"dd MMMM EEEE"];
    NSArray *aryStartDateComponents = [strStartDate componentsSeparatedByString:@" "];
    self.m_lblStartDate.text = aryStartDateComponents[0];
    self.m_lblStartWeek.text = [NSString stringWithFormat:@"%@\n%@", aryStartDateComponents[1], aryStartDateComponents[2]];
    self.m_lblStartTime.text = [[GlobalService sharedInstance] stringFromDate:self.m_objEventDetail.event_detail_start_at withFormat:@"h:mm a"];
    
    NSString *strEndDate = [[GlobalService sharedInstance] stringFromDate:self.m_objEventDetail.event_detail_end_at withFormat:@"dd MMMM EEEE"];
    NSArray *aryEndDateComponents = [strEndDate componentsSeparatedByString:@" "];
    self.m_lblEndDate.text = aryEndDateComponents[0];
    self.m_lblEndWeek.text = [NSString stringWithFormat:@"%@\n%@", aryEndDateComponents[1], aryEndDateComponents[2]];
    self.m_lblEndTime.text = [[GlobalService sharedInstance] stringFromDate:self.m_objEventDetail.event_detail_end_at withFormat:@"h:mm a"];
    
    NSMutableString *strPassengers = [[NSMutableString alloc] init];
    for(NSString *strPassenger in self.m_objEventDetail.event_detail_passengers) {
        [strPassengers appendString:[NSString stringWithFormat:@"%@,", strPassenger]];
    }
    if(strPassengers.length > 0) {
        strPassengers = [NSMutableString stringWithString:[strPassengers substringToIndex:strPassengers.length - 1]];
    }
    self.m_lblPassengers.text = strPassengers;
    
    self.m_lblRepeats.text = self.m_objEvent.eventRepeatTypeString;
    self.m_lblAlerts.text = self.m_objEventDetail.alertString;
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

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popToViewController:[GlobalService sharedInstance].menu_vc animated:YES];
}

- (IBAction)onClickBtnDone:(id)sender {
    [self onClickSaveAndInviteDrivers:nil];
}

- (IBAction)onTapStartTime:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    [self hideKeyboards];
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                                  datePickerMode:UIDatePickerModeDateAndTime
                                                                    selectedDate:self.m_objEventDetail.event_detail_start_at
                                                                       doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                                                                           self.m_objEventDetail.event_detail_start_at = selectedDate;
                                                                           self.m_objEvent.event_repeat_start_at = selectedDate.dateAtBeginningOfDay;
                                                                           self.m_objEvent.event_repeat_end_at = selectedDate.dateAtBeginningOfDay;
                                                                           self.m_objEventDetail.event_detail_end_at = [self.m_objEventDetail.event_detail_start_at dateByAddingHours:1];
                                                                           
                                                                           [self initViews];
                                                                       }
                                                                     cancelBlock:nil
                                                                          origin:tap.view];
    picker.minuteInterval = 5;
    picker.minimumDate = [NSDate date];
    [picker showActionSheetPicker];
}

- (IBAction)onTapEndTime:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    [self hideKeyboards];
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                                  datePickerMode:UIDatePickerModeDateAndTime
                                                                    selectedDate:self.m_objEventDetail.event_detail_end_at
                                                                       doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                                           if([selectedDate isSameDay:self.m_objEventDetail.event_detail_start_at]) {
                                                                               self.m_objEventDetail.event_detail_end_at = selectedDate;
                                                                               [self initViews];
                                                                           } else {
                                                                               [self.view makeToast:@"The system shouldn't allow for events that cross over midnight"
                                                                                           duration:3.f
                                                                                           position:CSToastPositionCenter];
                                                                           }
                                                                       }
                                                                     cancelBlock:nil
                                                                          origin:tap.view];
    picker.minuteInterval = 5;
    picker.minimumDate = self.m_objEventDetail.event_detail_start_at;
    [picker showActionSheetPicker];
}

- (IBAction)onTapRepeats:(id)sender {
    [self hideKeyboards];
    
    ChooseRepeatViewController *chooseRepeatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseRepeatViewController"];
    chooseRepeatVC.selected_event = self.m_objEvent;
    [self.navigationController pushViewController:chooseRepeatVC animated:YES];
}

- (IBAction)onTapAlerts:(id)sender {
    [self hideKeyboards];
    
    ChooseAlertViewController *chooseAlertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAlertViewController"];
    chooseAlertVC.selected_event_detail = self.m_objEventDetail;
    [self.navigationController pushViewController:chooseAlertVC animated:YES];
}

- (IBAction)onClickSaveAndInviteDrivers:(id)sender {
    [self hideKeyboards];
    
    if(self.m_txtEventTitle.text.length == 0) {
        [self.view makeToast:TOAST_NO_EVENT_TITLE duration:1.f position:CSToastPositionCenter];
        return;
    }
    
    self.m_objEvent.event_title = self.m_txtEventTitle.text;
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] createEventWithEventObj:self.m_objEvent
                                                 success:^(EventObj *objEvent) {
                                                     [[WebService sharedInstance] addEventId:objEvent.event_id
                                                                                      UserId:[GlobalService sharedInstance].my_user_id
                                                                                      Detail:self.m_objEventDetail
                                                                                     success:^(NSArray *aryEventDetails) {
                                                                                         SVPROGRESSHUD_DISMISS;
                                                                                         [objEvent.event_block_details setArray:aryEventDetails];
                                                                                         [[GlobalService sharedInstance].user_me addEvent:objEvent];
                                                                                         
                                                                                         InviteDriverViewController *inviteDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteDriverViewController"];
                                                                                         inviteDriverVC.selected_event = objEvent;
                                                                                         [self.navigationController pushViewController:inviteDriverVC animated:YES];

                                                                                     }
                                                                                     failure:^(NSString *strError) {
                                                                                         SVPROGRESSHUD_ERROR(strError);
                                                                                     }];
                                                 }
                                                 failure:^(NSString *strError) {
                                                     SVPROGRESSHUD_ERROR(strError);
                                                 }];

}

- (IBAction)onTapPassengers:(id)sender {
    [self hideKeyboards];
    
    if([GlobalService sharedInstance].user_me.my_passengers.count == 0) {
        EventAddChildViewController *eventAddChildVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventAddChildViewController"];
        eventAddChildVC.m_aryPassengers = self.m_objEventDetail.event_detail_passengers;
        [self.navigationController pushViewController:eventAddChildVC animated:YES];
    } else {
        AddPassengersViewController *addPassengersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPassengersViewController"];
        addPassengersVC.m_aryPassengers = self.m_objEventDetail.event_detail_passengers;
        [self.navigationController pushViewController:addPassengersVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.m_objEvent.event_title = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.m_objEvent.event_title = textField.text;
}

@end
