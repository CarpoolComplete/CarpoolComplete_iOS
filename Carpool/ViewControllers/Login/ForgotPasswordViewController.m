//
//  ForgotPasswordViewController.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.m_txtEmail becomeFirstResponder];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSubmit:(id)sender {
    [self.m_txtEmail resignFirstResponder];
    
    NSString *strEmail = self.m_txtEmail.text;
    NSError *error = nil;
    if([[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] forgotPasswordWithUserEmail:strEmail
                                                         success:^(NSString *strResult) {
                                                             SVPROGRESSHUD_SUCCESS(strResult);
                                                         }
                                                         failure:^(NSString *strError) {
                                                             SVPROGRESSHUD_ERROR(strError);
                                                         }];
    } else {
       [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS];
    }
}

@end
