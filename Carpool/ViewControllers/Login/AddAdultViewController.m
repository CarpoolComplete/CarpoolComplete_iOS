//
//  AddAdultViewController.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "AddAdultViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>

@interface AddAdultViewController ()

@end

@implementation AddAdultViewController

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

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnDone:(id)sender {
    [self.m_txtFirstName resignFirstResponder];
    [self.m_txtLastName resignFirstResponder];
    [self.m_txtEmail resignFirstResponder];
    
    if([self validateDriver]) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] addAdultWithUserId:[GlobalService sharedInstance].my_user_id
                                              FirstName:self.m_txtFirstName.text
                                               LastName:self.m_txtLastName.text
                                                  Email:self.m_txtEmail.text
                                               Password:[GlobalService sharedInstance].user_me.my_user.user_pass
                                                success:^(UserObj *objAdult) {
                                                    SVPROGRESSHUD_DISMISS;
                                                    [[GlobalService sharedInstance].user_me addAdult:objAdult];
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }
                                                failure:^(NSString *strError) {
                                                    SVPROGRESSHUD_ERROR(strError);
                                                }];
    }
}

- (BOOL)validateDriver {
    NSString *strFirstName = self.m_txtFirstName.text;
    NSString *strEmail = self.m_txtEmail.text;
    
    BOOL bResult = YES;
    
    NSError *error = nil;
    if(strFirstName.length == 0) {
        [self.view makeToast:TOAST_NO_USER_FIRST_NAME duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    } else if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    }
    
    return bResult;
}

@end
