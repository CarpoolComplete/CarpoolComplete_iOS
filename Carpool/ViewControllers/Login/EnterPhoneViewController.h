//
//  EnterPhoneViewController.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LTPhoneNumberField/LTPhoneNumberField.h>

@interface EnterPhoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet LTPhoneNumberField *m_txtPhone;
@property (nonatomic, retain) UserObj                   *m_objUser;

- (IBAction)onClickBtnEnter:(id)sender;

@end
