//
//  PhoneNumberViewController.h
//  Carpool Complete
//
//  Created by JH Lee on 8/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPhoneNumberField.h"

@interface PhoneNumberViewController : UIViewController

@property (weak, nonatomic) IBOutlet JHPhoneNumberField    *m_txtPhoneNumber;
@property (nonatomic, retain) UserObj                       *m_objUser;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnEnter:(id)sender;

@end
