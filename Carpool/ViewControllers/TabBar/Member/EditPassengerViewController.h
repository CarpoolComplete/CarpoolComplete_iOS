//
//  EditPassengerViewController.h
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPassengerViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtLastName;

@property (nonatomic, retain) PassengerObj      *selected_passenger;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnEdit:(id)sender;
- (IBAction)onClickBtnRemovePassenger:(id)sender;

@end
