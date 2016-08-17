//
//  EnterPhoneViewController.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EnterPhoneViewController.h"
#import "VerifyPhoneViewController.h"

@interface EnterPhoneViewController ()

@end

@implementation EnterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.m_txtPhone.leftView = leftPadding;
    self.m_txtPhone.leftViewMode = UITextFieldViewModeAlways;
    
    self.m_txtPhone.layer.masksToBounds = YES;
    self.m_txtPhone.layer.borderWidth = 1;
    self.m_txtPhone.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#5d5d5d"].CGColor;
    self.m_txtPhone.layer.cornerRadius = 5;
    
    [self.m_txtPhone becomeFirstResponder];
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

- (IBAction)onClickBtnEnter:(id)sender {
    [self.m_txtPhone resignFirstResponder];
    
    if([self.m_txtPhone containsValidNumber]) {
        self.m_objUser.user_phone = [self.m_txtPhone phoneNumberWithFormat:LTPhoneNumberFormatINTERNATIONAL];
                
        VerifyPhoneViewController *verifyPhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneViewController"];
        verifyPhoneVC.m_objUser = self.m_objUser;
        [self.navigationController pushViewController:verifyPhoneVC animated:YES];

    } else {
        [self.view makeToast:TOAST_INVALID_PHONE_NUMBER duration:1.0 position:CSToastPositionCenter];
    }
}

@end
