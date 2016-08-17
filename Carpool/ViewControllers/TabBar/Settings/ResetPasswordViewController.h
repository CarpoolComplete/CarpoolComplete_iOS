//
//  ResetPasswordViewController.h
//  Carpool
//
//  Created by JH Lee on 4/29/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *m_txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_txtConfirmPassword;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnOK:(id)sender;

@end
