//
//  EditPassengerViewController.m
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EditPassengerViewController.h"

@interface EditPassengerViewController ()

@end

@implementation EditPassengerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_txtFirstName.text = self.selected_passenger.passenger_first_name;
    self.m_txtLastName.text = self.selected_passenger.passenger_last_name;
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

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnEdit:(id)sender {
    if(_m_txtFirstName.text.length == 0) {
        [self.view makeToast:TOAST_NO_USER_FIRST_NAME duration:1.f position:CSToastPositionCenter];
    } else {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] updatePassengerWithUserId:[GlobalService sharedInstance].my_user_id
                                                   PassengerId:self.selected_passenger.passenger_id
                                                     FirstName:self.m_txtFirstName.text
                                                      LastName:self.m_txtLastName.text
                                                       success:^(PassengerObj *objPassenger) {
                                                           SVPROGRESSHUD_DISMISS;
                                                           [[GlobalService sharedInstance].user_me updatePassengerFrom:self.selected_passenger To:objPassenger];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }
                                                       failure:^(NSString *strError) {
                                                           SVPROGRESSHUD_ERROR(strError);
                                                       }];
    }
}

- (IBAction)onClickBtnRemovePassenger:(id)sender {
    [[[UIAlertView alloc] initWithTitle:APP_NAME
                                message:@"Are you sure to remove this passenger?"
                               delegate:self
                      cancelButtonTitle:@"No"
                      otherButtonTitles:@"Yes", nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] deletePassengerWithUserId:[GlobalService sharedInstance].my_user_id
                                                   PassengerId:self.selected_passenger.passenger_id
                                                       success:^(NSString *strResult) {
                                                           SVPROGRESSHUD_DISMISS;
                                                           [[GlobalService sharedInstance].user_me removePassenger:self.selected_passenger];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       } failure:^(NSString *strError) {
                                                           SVPROGRESSHUD_ERROR(strError);
                                                       }];
    }
}
@end
