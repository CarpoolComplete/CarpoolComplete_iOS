//
//  LoginViewController.h
//  Carpool
//
//  Created by JH Lee on 4/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPassword;

- (IBAction)onClickBtnForgotPassword:(id)sender;
- (IBAction)onClickBtnSignIn:(id)sender;
- (IBAction)onClickBtnGoToSignUp:(id)sender;

@end
