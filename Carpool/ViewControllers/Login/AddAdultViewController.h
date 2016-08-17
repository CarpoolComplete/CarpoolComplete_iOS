//
//  AddAdultViewController.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAdultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;

@end
