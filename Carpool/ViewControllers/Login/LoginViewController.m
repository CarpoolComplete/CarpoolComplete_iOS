//
//  LoginViewController.m
//  Carpool
//
//  Created by JH Lee on 4/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "LoginViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>
#import "EnterPhoneViewController.h"
#import "SignupViewController.h"
#import "PhoneNumberViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([GlobalService sharedInstance].user_inputed_email.length > 0) {
        self.m_txtEmail.text = [GlobalService sharedInstance].user_inputed_email;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickBtnForgotPassword:(id)sender {
    UIViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}

- (IBAction)onClickBtnSignIn:(id)sender {
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtPassword resignFirstResponder];
    
    if([self validateLogin]) {
        NSString *strEmail = self.m_txtEmail.text;
        NSString *strPass = [self.m_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] loginWithUserEmail:strEmail
                                               UserPass:strPass
                                                success:^(UserMe *objMe) {
                                                    [[EventService sharedInstance] updateEventsWithEventObjects:objMe.my_events
                                                                                                     completion:^(NSArray *savedEvents, NSError *error) {
                                                                                                         SVPROGRESSHUD_DISMISS;
                                                                                                         [objMe.my_events setArray:savedEvents];
                                                                                                         [[GlobalService sharedInstance] saveMe:objMe];
                                                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                             if(objMe.my_user.user_phone.length > 0) {
                                                                                                                 [[GlobalService sharedInstance].app_delegate startApplication:YES];
                                                                                                             } else {
                                                                                                                 PhoneNumberViewController *phoneNumberVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneNumberViewController"];
                                                                                                                 phoneNumberVC.m_objUser = objMe.my_user;
                                                                                                                 [self.navigationController pushViewController:phoneNumberVC animated:YES];
                                                                                                             }
                                                                                                         });
                                                                                                     }];
                                                }
                                                failure:^(NSString *strError) {
                                                    SVPROGRESSHUD_ERROR(strError);
                                                }];
    }
}

- (BOOL)validateLogin {
    NSString *strEmail = self.m_txtEmail.text;
    NSString *strPass = [self.m_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL bResult = YES;
    
    NSError *error = nil;
    if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    } else if (strPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    }
    
    return bResult;
}

- (IBAction)onClickBtnGoToSignUp:(id)sender {
    UIViewController *signupVC = nil;
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[SignupViewController class]]) {
            signupVC = vc;
            break;
        }
    }
    
    if(signupVC) {
        [self.navigationController popToViewController:signupVC animated:YES];
    } else {
        signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
        [self.navigationController pushViewController:signupVC animated:YES];
    }
}

@end
