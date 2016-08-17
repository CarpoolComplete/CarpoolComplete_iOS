//
//  AddChildViewController.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "AddChildViewController.h"

@interface AddChildViewController ()

@end

@implementation AddChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onClickBtnDone:(id)sender {
    [self.m_txtFirstName resignFirstResponder];
    [self.m_txtLastName resignFirstResponder];
    
    BOOL isNewChildren = YES;
    for(PassengerObj *objPassenger in [GlobalService sharedInstance].user_me.my_passengers) {
        if([objPassenger.passenger_first_name isEqualToString:self.m_txtFirstName.text]
           && [objPassenger.passenger_last_name isEqualToString:self.m_txtLastName.text]) {
            isNewChildren = NO;
            break;
        }
    }
    
    if(isNewChildren) {
        if(_m_txtFirstName.text.length == 0) {
            [self.view makeToast:TOAST_NO_USER_FIRST_NAME duration:1.f position:CSToastPositionCenter];
        } else {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] addPassengerWithUserId:[GlobalService sharedInstance].my_user_id
                                                       FamilyId:[GlobalService sharedInstance].user_me.my_user.user_family_id
                                                      FirstName:self.m_txtFirstName.text
                                                       LastName:self.m_txtLastName.text
                                                        success:^(PassengerObj *objPassenger) {
                                                            SVPROGRESSHUD_DISMISS;
                                                            [[GlobalService sharedInstance].user_me addPassenger:objPassenger];
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        }
                                                        failure:^(NSString *strError) {
                                                            SVPROGRESSHUD_ERROR(strError);
                                                        }];
        }
    } else {
        [self.view makeToast:TOAST_EXIST_SAME_CHILDREN duration:1.f position:CSToastPositionCenter];
    }
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
