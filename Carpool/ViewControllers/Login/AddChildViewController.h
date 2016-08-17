//
//  AddChildViewController.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddChildViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtLastName;

- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;

@end
