//
//  ResetPasswordViewController.m
//  Carpool
//
//  Created by JH Lee on 4/29/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnOK:(id)sender {
    if([self validatePassword]) {
        
        NSString *strOldPass = [self.m_txtOldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *strNewPass = [self.m_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] changePassword:[GlobalService sharedInstance].my_user_id
                                        CurrentPass:strOldPass
                                            NewPass:strNewPass
                                            success:^(NSString *strResult) {
                                                SVPROGRESSHUD_SUCCESS(strResult);
                                            }
                                            failure:^(NSString *strError) {
                                                SVPROGRESSHUD_ERROR(strError);
                                            }];
    }
}

- (BOOL)validatePassword {
    NSString *strOldPass = [self.m_txtOldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strNewPass = [self.m_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strConfirmPass = [self.m_txtConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL bResult = YES;
    
    if (strOldPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    } else if(strNewPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    } else if(![strNewPass isEqualToString:strConfirmPass]) {
        [self.view makeToast:TOAST_MISMATCH_PASSWORD duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    }
    
    return bResult;
}


@end
