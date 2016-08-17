//
//  VerifyPhoneViewController.m
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "LoginViewController.h"

@interface VerifyPhoneViewController ()

@end

@implementation VerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sendSMS];
    
    [self.m_txtCode becomeFirstResponder];
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
    [self.m_txtCode resignFirstResponder];
    
    if([self.m_txtCode.text isEqualToString:m_strCode]) {
        if(!self.m_isLogin) {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] signupWithUserObj:self.m_objUser
                                                  progress:^(CGFloat progress) {
                                                      if(self.m_objUser.user_avatar_image) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              SVPROGRESSHUD_PROGRESS(progress);
                                                          });
                                                      }
                                                  }
                                                   success:^(UserMe *objMe) {
                                                       SVPROGRESSHUD_DISMISS;
                                                       [[GlobalService sharedInstance] saveMe:objMe];
                                                       [[GlobalService sharedInstance] loadSetting];
                                                       UIViewController *addFamilyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFamilyViewController"];
                                                       [self.navigationController pushViewController:addFamilyVC animated:YES];
                                                   }
                                                   failure:^(NSInteger errorCode, NSString *strError) {
                                                       SVPROGRESSHUD_ERROR(strError);
                                                       if(errorCode == 409) {   //conflict
                                                           [GlobalService sharedInstance].user_inputed_email = self.m_objUser.user_email;
                                                           [self goToSignInPage];
                                                       }
                                                   }];
        } else {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] updateUserWithUserId:self.m_objUser.user_id
                                                    FirstName:self.m_objUser.user_first_name
                                                     LastName:self.m_objUser.user_last_name
                                                  PhoneNumber:self.m_objUser.user_phone
                                                        Email:self.m_objUser.user_email
                                                    AvatarUrl:self.m_objUser.user_avatar_url
                                              UserAvatarImage:nil
                                                      success:^(UserObj *objUser) {
                                                          SVPROGRESSHUD_DISMISS;
                                                          [[GlobalService sharedInstance].user_me updateUser:objUser];
                                                          UIViewController *syncVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SyncViewController"];
                                                          [self.navigationController pushViewController:syncVC animated:YES];
                                                      }
                                                      failure:^(NSString *strError) {
                                                          SVPROGRESSHUD_ERROR(strError);
                                                      }
                                                     progress:nil];
        }
    } else {
        [self.view makeToast:TOAST_INVALID_CODE duration:1.f position:CSToastPositionCenter];
    }
}

- (void)goToSignInPage {
    UIViewController *loginVC = nil;
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[LoginViewController class]]) {
            loginVC = vc;
            break;
        }
    }
    
    if(loginVC) {
        [self.navigationController popToViewController:loginVC animated:YES];
    } else {
        loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


- (IBAction)onClickBtnResend:(id)sender {
    [self sendSMS];
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendSMS {
    m_strCode = [[GlobalService sharedInstance] makeVerificationCode];
    NSLog(@"Code:%@", m_strCode);
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] sendSMSToPhone:self.m_objUser.user_phone
                               VerificationCode:m_strCode
                                        success:^(NSString *strResult) {
                                            SVPROGRESSHUD_SUCCESS(strResult);
                                        }
                                        failure:^(NSInteger errorCode, NSString *strError) {
                                            SVPROGRESSHUD_ERROR(strError);
                                            if(errorCode == 409) {   //conflict
                                                [GlobalService sharedInstance].user_inputed_email = self.m_objUser.user_email;
                                                [self goToSignInPage];
                                            }
                                        }];
}

@end
