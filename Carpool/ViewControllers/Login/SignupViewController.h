//
//  SignupViewController.h
//  Carpool
//
//  Created by JH Lee on 4/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ResponsiveLabel/ResponsiveLabel.h>
#import <LTPhoneNumberField/LTPhoneNumberField.h>
#import <TOCropViewController/TOCropViewController.h>

@interface SignupViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, TOCropViewControllerDelegate> {
    BOOL                            m_hasAvatar;
    UIPopoverController             *m_popoverController;
}

@property (weak, nonatomic) IBOutlet ResponsiveLabel        *m_lblSignIn;
@property (weak, nonatomic) IBOutlet UIImageView            *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UITextField            *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField            *m_txtLastName;
@property (weak, nonatomic) IBOutlet LTPhoneNumberField     *m_txtPhone;
@property (weak, nonatomic) IBOutlet UITextField            *m_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField            *m_txtPassword;
@property (weak, nonatomic) IBOutlet ResponsiveLabel        *m_lblTerms;

- (IBAction)onClickBtnCreate:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
