//
//  PhoneNumberViewController.m
//  Carpool Complete
//
//  Created by JH Lee on 8/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "VerifyPhoneViewController.h"

@interface PhoneNumberViewController ()

@end

@implementation PhoneNumberViewController

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

- (IBAction)onClickBtnEnter:(id)sender {
    [self.m_txtPhoneNumber resignFirstResponder];
    
    if ([self.m_txtPhoneNumber containsValidNumber]) {
        self.m_objUser.user_phone = [self.m_txtPhoneNumber phoneNumberWithFormat:LTPhoneNumberFormatINTERNATIONAL];
        VerifyPhoneViewController *verifyPhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneViewController"];
        verifyPhoneVC.m_objUser = self.m_objUser;
        verifyPhoneVC.m_isLogin = YES;
        [self.navigationController pushViewController:verifyPhoneVC animated:YES];
    } else {
        [self.view makeToast:TOAST_INVALID_PHONE_NUMBER duration:1.f position:CSToastPositionCenter];
    }
}

@end
