//
//  EditAdultViewController.h
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LTPhoneNumberField/LTPhoneNumberField.h>
#import <TOCropViewController/TOCropViewController.h>
#import <SHEmailValidator/SHEmailValidator.h>
#import "JHButton.h"

@interface EditAdultViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, TOCropViewControllerDelegate, UIAlertViewDelegate> {
    UIPopoverController             *m_popoverController;
    BOOL                            m_hasAvatar;
}

@property (weak, nonatomic) IBOutlet UIImageView        *m_imgDriverAvatar;
@property (weak, nonatomic) IBOutlet UITextField        *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField        *m_txtLastName;
@property (weak, nonatomic) IBOutlet LTPhoneNumberField *m_txtPhone;
@property (weak, nonatomic) IBOutlet UITextField        *m_txtEmailAddress;
@property (weak, nonatomic) IBOutlet JHButton           *m_btnRemoveDriver;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnEdit;

@property (nonatomic, retain) UserObj                   *selected_adult;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnEdit:(id)sender;
- (IBAction)onClickBtnRemoveDriver:(id)sender;
- (IBAction)onTapDriverAvatar:(id)sender;

@end
