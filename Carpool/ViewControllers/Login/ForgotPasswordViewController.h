//
//  ForgotPasswordViewController.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnSubmit:(id)sender;

@end
